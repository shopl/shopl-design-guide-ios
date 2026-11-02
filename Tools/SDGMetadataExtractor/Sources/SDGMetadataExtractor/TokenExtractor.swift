import Foundation
import SwiftSyntax

/// 디자인 토큰 한 개. 타입마다 쓰는 필드가 달라 나머지는 생략(nil)된다.
struct TokenRecord: Encodable {
  enum Kind: String, Encodable, CaseIterable {
    case color
    case typography
    case spacing
    case cornerRadius
  }

  let name: String
  let type: Kind
  let group: String?
  /// 코드에서 쓰는 형태. 예: `.neutral700`, `.body1_R`, `.spacing16`
  let swift: String
  /// 위 멤버가 속한 타입. 예: `SDG.Color`, `SDG.Typography`, `SDGSpacing`
  let swiftType: String
  let source: String
  var doc: String? = nil

  // color
  var hex: String? = nil
  /// 불투명도(%). `neutral700_10`처럼 접미사가 붙은 토큰은 기본 토큰의 투명 변형이다.
  var opacity: Int? = nil
  var baseToken: String? = nil
  var assetName: String? = nil
  var colorSpace: String? = nil

  // typography
  var size: Int? = nil
  var weight: Int? = nil
  var lineHeight: Int? = nil

  // spacing, cornerRadius
  var points: Int? = nil
}

struct TokenFile: Encodable {
  let sources: [String]
  let count: Int
  let countsByType: [String: Int]
  let tokens: [TokenRecord]
}

struct TokenExtractor {
  let repository: Repository
  let symbols: GeneratedAssetSymbols

  func extract(report: inout Report) throws -> TokenFile {
    let foundationFiles = try repository.swiftFiles(in: repository.foundationSources)
      .map { try ParsedFile(url: $0, repository: repository) }

    var tokens: [TokenRecord] = []
    tokens += try colors(report: &report)
    tokens += try typography(in: foundationFiles)
    tokens += try rawValueEnum(named: "SDGSpacing", kind: .spacing, in: foundationFiles)
    tokens += try rawValueEnum(named: "SDGCornerRadius", kind: .cornerRadius, in: foundationFiles)

    var counts: [String: Int] = [:]
    for kind in TokenRecord.Kind.allCases {
      counts[kind.rawValue] = tokens.filter { $0.type == kind }.count
    }
    let sources = Set(tokens.filter { $0.type != .color }.map(\.source))
      .union([try repository.relativePath(of: repository.colorAssets)])
      .union(symbols.sources)
      .sorted()
    return TokenFile(sources: sources, count: tokens.count, countsByType: counts, tokens: tokens)
  }

  // MARK: - Color

  private func colors(report: inout Report) throws -> [TokenRecord] {
    var records: [TokenRecord] = []
    var seenAssets = Set<String>()
    let colorSymbols = Set(symbols.colors.values)

    for colorset in try repository.directories(in: repository.colorAssets, withExtension: "colorset") {
      let assetName = colorset.deletingPathExtension().lastPathComponent
      seenAssets.insert(assetName)

      guard let symbol = symbols.colors[assetName] else {
        report.warn("컬러 에셋 \(assetName)에 대응하는 Swift 심볼이 없습니다. Tuist 생성 파일이 최신인지 확인하세요.")
        continue
      }

      let value = try ColorsetValue(contentsOf: colorset.appending(path: "Contents.json"))
      let group = colorset.deletingLastPathComponent().standardizedFileURL == repository.colorAssets.standardizedFileURL
        ? nil
        : colorset.deletingLastPathComponent().lastPathComponent
      let opacity = Int((value.alpha * 100).rounded())
      // `neutral700_10` → `neutral700`. sdgBlack_40처럼 불투명한 기본 토큰이 없는 색은 비워 둔다.
      let baseToken = symbol.range(of: #"_\d+$"#, options: .regularExpression)
        .map { String(symbol[..<$0.lowerBound]) }
        .flatMap { colorSymbols.contains($0) ? $0 : nil }

      records.append(TokenRecord(
        name: symbol,
        type: .color,
        group: group,
        swift: "." + symbol,
        swiftType: "SDG.Color",
        source: try repository.relativePath(of: colorset),
        hex: value.hex,
        opacity: opacity,
        baseToken: baseToken,
        assetName: assetName,
        colorSpace: value.colorSpace
      ))
    }

    for (assetName, symbol) in symbols.colors where !seenAssets.contains(assetName) {
      report.warn("Swift 심볼 \(symbol)이 가리키는 컬러 에셋 \(assetName)이 없습니다.")
    }
    return records.sorted { $0.name < $1.name }
  }

  // MARK: - Typography

  /// `extension SDG { enum Typography }`의 케이스와 size/weight/lineHeight switch를 읽는다.
  private func typography(in files: [ParsedFile]) throws -> [TokenRecord] {
    guard let (file, enumDecl) = findEnum(qualifiedName: "SDG.Typography", in: files) else {
      throw ExtractionError.unexpectedStructure("SDG.Typography enum을 Foundation에서 찾지 못했습니다.")
    }

    let sizes = switchValues(of: "size", in: enumDecl)
    let weights = switchValues(of: "weight", in: enumDecl)
    let lineHeights = switchValues(of: "lineHeight", in: enumDecl)

    var records: [TokenRecord] = []
    for caseDecl in enumDecl.memberBlock.members.compactMap({ $0.decl.as(EnumCaseDeclSyntax.self) }) {
      for element in caseDecl.elements {
        let name = element.name.text
        guard let size = sizes[name].flatMap(Double.init),
              let weightName = weights[name],
              let lineHeight = lineHeights[name].flatMap(Double.init)
        else {
          throw ExtractionError.unexpectedStructure("SDG.Typography.\(name)의 size/weight/lineHeight를 읽지 못했습니다.")
        }

        records.append(TokenRecord(
          name: name,
          type: .typography,
          group: typographyGroup(of: name),
          swift: "." + name,
          swiftType: "SDG.Typography",
          source: file.relativePath,
          doc: Comments.documentation(of: caseDecl),
          size: Int(size),
          weight: Self.fontWeights[weightName.trimmingCharacters(in: CharacterSet(charactersIn: "."))],
          lineHeight: Int(lineHeight)
        ))
      }
    }
    return records
  }

  private static let fontWeights: [String: Int] = [
    "ultraLight": 100, "thin": 200, "light": 300, "regular": 400, "medium": 500,
    "semibold": 600, "bold": 700, "heavy": 800, "black": 900
  ]

  /// `body1_R` → `body`, `naviTitle` → `naviTitle`
  private func typographyGroup(of name: String) -> String {
    let prefix = name.prefix { $0.isLetter }
    return prefix.isEmpty ? name : String(prefix)
  }

  /// `var <property>: T { switch self { case .a, .b: value } }`를 케이스 이름 → 값 텍스트로 바꾼다.
  private func switchValues(of property: String, in enumDecl: EnumDeclSyntax) -> [String: String] {
    for member in enumDecl.memberBlock.members {
      guard let variable = member.decl.as(VariableDeclSyntax.self),
            variable.bindings.contains(where: { $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text == property }),
            let switchExpr = variable.firstDescendant(ofType: SwitchExprSyntax.self)
      else { continue }

      var values: [String: String] = [:]
      for element in switchExpr.cases {
        guard let switchCase = element.as(SwitchCaseSyntax.self),
              let label = switchCase.label.as(SwitchCaseLabelSyntax.self),
              let value = resultExpression(of: switchCase)
        else { continue }

        for item in label.caseItems {
          if let name = item.pattern.as(ExpressionPatternSyntax.self)?
            .expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            values[name] = SyntaxText.compact(value)
          }
        }
      }
      return values
    }
    return [:]
  }

  private func resultExpression(of switchCase: SwitchCaseSyntax) -> ExprSyntax? {
    guard let item = switchCase.statements.first?.item else { return nil }
    if let expression = Syntax(item).as(ExprSyntax.self) { return expression }
    if let returnStmt = Syntax(item).as(ReturnStmtSyntax.self) { return returnStmt.expression }
    if let expressionStmt = Syntax(item).as(ExpressionStmtSyntax.self) { return expressionStmt.expression }
    return nil
  }

  // MARK: - Spacing / CornerRadius

  /// `enum X: CGFloat { //MARK: - Common \n case spacing2 = 2.0 }` 형태의 토큰 enum을 읽는다.
  private func rawValueEnum(named name: String, kind: TokenRecord.Kind, in files: [ParsedFile]) throws -> [TokenRecord] {
    guard let (file, enumDecl) = findEnum(qualifiedName: name, in: files) else {
      throw ExtractionError.unexpectedStructure("\(name) enum을 Foundation에서 찾지 못했습니다.")
    }

    var records: [TokenRecord] = []
    var group: String?
    for member in enumDecl.memberBlock.members {
      guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { continue }
      group = Comments.markGroup(in: caseDecl.leadingTrivia) ?? group

      for element in caseDecl.elements {
        guard let value = Literals.number(element.rawValue?.value) else {
          throw ExtractionError.unexpectedStructure("\(name).\(element.name.text)의 raw value가 숫자가 아닙니다.")
        }
        records.append(TokenRecord(
          name: element.name.text,
          type: kind,
          group: group,
          swift: "." + element.name.text,
          swiftType: name,
          source: file.relativePath,
          doc: Comments.documentation(of: caseDecl),
          points: Int(value)
        ))
      }
    }
    return records.sorted { ($0.points ?? 0, $0.name) < ($1.points ?? 0, $1.name) }
  }

  private func findEnum(qualifiedName: String, in files: [ParsedFile]) -> (ParsedFile, EnumDeclSyntax)? {
    for file in files {
      for enumDecl in file.tree.descendants(ofType: EnumDeclSyntax.self)
      where DeclNames.qualifiedName(of: enumDecl) == qualifiedName {
        return (file, enumDecl)
      }
    }
    return nil
  }
}

// MARK: - Colorset

/// `*.colorset/Contents.json`의 universal(라이트) 색상 값.
private struct ColorsetValue {
  let red: Int
  let green: Int
  let blue: Int
  let alpha: Double
  let colorSpace: String?

  var hex: String {
    String(format: "#%02X%02X%02X", red, green, blue)
  }

  init(contentsOf url: URL) throws {
    let data = try Data(contentsOf: url)
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let colors = json["colors"] as? [[String: Any]],
          let entry = colors.first(where: { $0["appearances"] == nil }) ?? colors.first,
          let color = entry["color"] as? [String: Any],
          let components = color["components"] as? [String: String]
    else {
      throw ExtractionError.unexpectedStructure("colorset 형식을 읽지 못했습니다: \(url.path)")
    }

    func channel(_ key: String) -> Int? {
      guard let raw = components[key] else { return nil }
      return Self.channelValue(raw)
    }

    if let white = channel("white") {
      red = white
      green = white
      blue = white
    } else if let r = channel("red"), let g = channel("green"), let b = channel("blue") {
      red = r
      green = g
      blue = b
    } else {
      throw ExtractionError.unexpectedStructure("colorset 색상 채널을 읽지 못했습니다: \(url.path)")
    }

    alpha = components["alpha"].flatMap(Self.alphaValue) ?? 1
    colorSpace = color["color-space"] as? String
  }

  /// Xcode는 채널 값을 `0xFF`(16진수), `1.000`(0~1 실수), `255`(8비트 정수) 중 하나로 저장한다.
  private static func channelValue(_ raw: String) -> Int? {
    let text = raw.trimmingCharacters(in: .whitespaces)
    if text.lowercased().hasPrefix("0x") {
      return Int(text.dropFirst(2), radix: 16)
    }
    if text.contains("."), let value = Double(text) {
      return Int((value * 255).rounded())
    }
    return Int(text)
  }

  private static func alphaValue(_ raw: String) -> Double? {
    let text = raw.trimmingCharacters(in: .whitespaces)
    if text.lowercased().hasPrefix("0x"), let value = Int(text.dropFirst(2), radix: 16) {
      return Double(value) / 255
    }
    return Double(text)
  }
}
