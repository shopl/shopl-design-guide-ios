import Foundation
import SwiftParser
import SwiftSyntax

/// 파싱된 Swift 파일. 줄 번호 계산과 원문 슬라이스에 필요한 정보를 함께 들고 있다.
struct ParsedFile {
  let url: URL
  let relativePath: String
  let source: String
  let tree: SourceFileSyntax
  let converter: SourceLocationConverter

  init(url: URL, repository: Repository) throws {
    self.url = url
    self.relativePath = try repository.relativePath(of: url)
    self.source = try String(contentsOf: url, encoding: .utf8)
    self.tree = Parser.parse(source: source)
    self.converter = SourceLocationConverter(fileName: relativePath, tree: tree)
  }

  func line(of node: some SyntaxProtocol) -> Int {
    converter.location(for: node.positionAfterSkippingLeadingTrivia).line
  }

  func location(of node: some SyntaxProtocol) -> SourceLocation {
    SourceLocation(file: relativePath, line: line(of: node))
  }
}

// MARK: - Navigation

extension SyntaxProtocol {
  func firstDescendant<T: SyntaxProtocol>(ofType type: T.Type) -> T? {
    for child in children(viewMode: .sourceAccurate) {
      if let match = child.as(T.self) { return match }
      if let nested = child.firstDescendant(ofType: type) { return nested }
    }
    return nil
  }

  func descendants<T: SyntaxProtocol>(ofType type: T.Type) -> [T] {
    var result: [T] = []
    for child in children(viewMode: .sourceAccurate) {
      if let match = child.as(T.self) { result.append(match) }
      result += child.descendants(ofType: type)
    }
    return result
  }
}

enum DeclNames {
  /// 타입·익스텐션 선언의 이름. 익스텐션은 확장 대상 타입 이름을 쓴다.
  static func name(of node: Syntax) -> String? {
    if let decl = node.as(StructDeclSyntax.self) { return decl.name.text }
    if let decl = node.as(EnumDeclSyntax.self) { return decl.name.text }
    if let decl = node.as(ClassDeclSyntax.self) { return decl.name.text }
    if let decl = node.as(ActorDeclSyntax.self) { return decl.name.text }
    if let decl = node.as(ProtocolDeclSyntax.self) { return decl.name.text }
    if let decl = node.as(TypeAliasDeclSyntax.self) { return decl.name.text }
    if let decl = node.as(ExtensionDeclSyntax.self) { return SyntaxText.compact(decl.extendedType) }
    return nil
  }

  /// 감싸는 타입·익스텐션을 따라 올라가 `SDG.Typography`, `SDGBoxButton.Option` 같은 이름을 만든다.
  static func qualifiedName(of decl: some SyntaxProtocol) -> String {
    var components: [String] = []
    var current: Syntax? = Syntax(decl)
    while let node = current {
      if let name = name(of: node) { components.append(name) }
      current = node.parent
    }
    return components.reversed().joined(separator: ".")
  }
}

// MARK: - Access level

enum Visibility {
  /// 접근 제어자가 `public`/`open`이면 공개, 다른 제어자가 있으면 비공개,
  /// 제어자가 없으면 감싼 선언의 기본값(`public extension` 안이면 공개)을 따른다.
  static func isPublic(_ modifiers: DeclModifierListSyntax, default defaultValue: Bool) -> Bool {
    for modifier in modifiers where modifier.detail == nil {
      switch modifier.name.tokenKind {
      case .keyword(.public), .keyword(.open):
        return true
      case .keyword(.private), .keyword(.fileprivate), .keyword(.internal), .keyword(.package):
        return false
      default:
        continue
      }
    }
    return defaultValue
  }

  static func isStatic(_ modifiers: DeclModifierListSyntax) -> Bool {
    modifiers.contains { modifier in
      modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
    }
  }
}

// MARK: - Comments

enum Comments {
  /// 선언 바로 앞의 `///`, `/** */` 문서 주석을 이어 붙인다.
  static func documentation(of node: some SyntaxProtocol) -> String? {
    var lines: [String] = []
    // 공백만 있는 줄도 빈 줄이므로 줄바꿈 사이의 공백은 무시하고 연속 줄바꿈 수를 센다.
    var consecutiveNewlines = 0
    for piece in node.leadingTrivia {
      switch piece {
      case .docLineComment(let text):
        lines.append(stripLinePrefix(text, prefix: "///"))
        consecutiveNewlines = 0
      case .docBlockComment(let text):
        lines.append(contentsOf: stripBlock(text))
        consecutiveNewlines = 0
      case .newlines(let count), .carriageReturns(let count), .carriageReturnLineFeeds(let count):
        // 빈 줄로 떨어진 앞쪽 문서 주석은 다른 선언의 것이므로 버린다.
        consecutiveNewlines += count
        if consecutiveNewlines > 1 { lines.removeAll() }
      case .spaces, .tabs:
        continue
      case .lineComment, .blockComment:
        lines.removeAll()
        consecutiveNewlines = 0
      default:
        consecutiveNewlines = 0
      }
    }
    let text = lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    return text.isEmpty ? nil : text
  }

  /// `// MARK: - Common` 형태의 주석에서 그룹 이름을 읽는다.
  static func markGroup(in trivia: Trivia) -> String? {
    var group: String?
    for piece in trivia {
      guard case .lineComment(let text) = piece else { continue }
      let body = text.dropFirst(2).trimmingCharacters(in: .whitespaces)
      guard body.hasPrefix("MARK:") else { continue }
      let name = body.dropFirst("MARK:".count)
        .trimmingCharacters(in: .whitespaces)
        .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        .trimmingCharacters(in: .whitespaces)
      if !name.isEmpty { group = name }
    }
    return group
  }

  private static func stripLinePrefix(_ text: String, prefix: String) -> String {
    var line = Substring(text)
    if line.hasPrefix(prefix) { line = line.dropFirst(prefix.count) }
    if line.hasPrefix(" ") { line = line.dropFirst() }
    return String(line).trimmingCharacters(in: .whitespaces)
  }

  private static func stripBlock(_ text: String) -> [String] {
    var body = Substring(text)
    if body.hasPrefix("/**") { body = body.dropFirst(3) }
    if body.hasSuffix("*/") { body = body.dropLast(2) }
    return body.split(separator: "\n", omittingEmptySubsequences: false).map { line in
      var trimmed = line.trimmingCharacters(in: .whitespaces)[...]
      if trimmed.hasPrefix("*") { trimmed = trimmed.dropFirst() }
      return trimmed.trimmingCharacters(in: .whitespaces)
    }
  }
}

// MARK: - Text

enum SyntaxText {
  /// 주석을 제거하고 공백을 한 칸으로 줄인 한 줄 표현. 시그니처·타입 표기에 쓴다.
  static func compact(_ node: some SyntaxProtocol) -> String {
    let stripped = CommentStripper(viewMode: .sourceAccurate).rewrite(Syntax(node))
    var text = stripped.trimmedDescription
    text = text.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
    for (pattern, replacement) in [("( ", "("), (" )", ")"), ("[ ", "["), (" ]", "]"), (" ,", ","), ("< ", "<"), (" >", ">")] {
      text = text.replacingOccurrences(of: pattern, with: replacement)
    }
    // 여러 줄 파라미터 목록의 마지막 쉼표(`a: Int,)`)를 정리한다.
    text = text.replacingOccurrences(of: #",\s*\)"#, with: ")", options: .regularExpression)
    return text
  }

  /// 원문을 그대로 잘라내되, 첫 줄의 들여쓰기만큼 이후 줄의 들여쓰기를 걷어낸다.
  static func snippet(of node: some SyntaxProtocol, from start: AbsolutePosition? = nil, in file: ParsedFile) -> String {
    let begin = start ?? node.positionAfterSkippingLeadingTrivia
    let end = node.endPositionBeforeTrailingTrivia
    let utf8 = Array(file.source.utf8)
    guard begin.utf8Offset >= 0, end.utf8Offset <= utf8.count, begin.utf8Offset < end.utf8Offset else {
      return node.trimmedDescription
    }
    let text = String(decoding: utf8[begin.utf8Offset..<end.utf8Offset], as: UTF8.self)
    let column = file.converter.location(for: begin).column - 1
    let lines = text.split(separator: "\n", omittingEmptySubsequences: false)
    let dedented = lines.enumerated().map { index, line -> String in
      guard index > 0 else { return String(line) }
      let leading = line.prefix { $0 == " " }.count
      return String(line.dropFirst(min(leading, column)))
    }
    return dedented.joined(separator: "\n")
  }
}

/// 토큰 trivia에서 주석만 걷어낸다.
private final class CommentStripper: SyntaxRewriter {
  override func visit(_ token: TokenSyntax) -> TokenSyntax {
    token
      .with(\.leadingTrivia, Self.withoutComments(token.leadingTrivia))
      .with(\.trailingTrivia, Self.withoutComments(token.trailingTrivia))
  }

  private static func withoutComments(_ trivia: Trivia) -> Trivia {
    Trivia(pieces: trivia.map { piece in piece.isComment ? .spaces(1) : piece })
  }
}

// MARK: - Attributes

struct Availability {
  /// deprecated 안내 문구. `message:`와 `renamed:`를 합친다. deprecated가 아니면 nil.
  var deprecated: String?
  /// `unavailable`·`obsoleted` — 사용할 수 없는 선언이므로 추출 결과에서 뺀다.
  var isUnavailable = false
}

enum Attributes {
  /// `@available(*, deprecated, message: "...", renamed: "...")`, `@available(*, unavailable)`를 읽는다.
  ///
  /// 토큰 단위로 읽어 메시지 문자열 안의 단어("unavailable" 등)를 키워드로 오인하지 않고,
  /// macOS 등 다른 플랫폼 전용 표시는 iOS 앱에 해당하지 않으므로 무시한다.
  static func availability(in attributes: AttributeListSyntax) -> Availability {
    var result = Availability()
    for element in attributes {
      guard case .attribute(let attribute) = element,
            attribute.attributeName.trimmedDescription == "available",
            let arguments = attribute.arguments
      else { continue }

      let tokens = Array(arguments.tokens(viewMode: .sourceAccurate))
      guard let platform = tokens.first?.text, platform == "*" || platform == "iOS" else { continue }
      let keywords = Set(tokens.filter { !isStringSegment($0) }.map(\.text))

      if keywords.contains("unavailable") || keywords.contains("obsoleted") {
        result.isUnavailable = true
      }
      guard keywords.contains("deprecated") else { continue }

      let message = labeledString("message", in: tokens)
      let renamed = labeledString("renamed", in: tokens)
      switch (message, renamed) {
      case let (message?, renamed?): result.deprecated = "\(message) (renamed: \(renamed))"
      case let (message?, nil): result.deprecated = message
      case let (nil, renamed?): result.deprecated = "renamed: \(renamed)"
      case (nil, nil): result.deprecated = "deprecated"
      }
    }
    return result
  }

  /// `label: "value"` — 라벨 토큰 뒤 문자열 리터럴의 조각을 이어 붙인다.
  private static func labeledString(_ label: String, in tokens: [TokenSyntax]) -> String? {
    guard let index = tokens.firstIndex(where: { $0.text == label && !isStringSegment($0) }),
          index + 1 < tokens.count,
          tokens[index + 1].tokenKind == .colon
    else { return nil }

    var value = ""
    var isInsideLiteral = false
    for token in tokens[(index + 2)...] {
      switch token.tokenKind {
      case .stringQuote:
        if isInsideLiteral { return value }
        isInsideLiteral = true
      case .stringSegment(let text):
        value += text
      default:
        if !isInsideLiteral { return nil }
      }
    }
    return nil
  }

  private static func isStringSegment(_ token: TokenSyntax) -> Bool {
    if case .stringSegment = token.tokenKind { return true }
    return false
  }
}

// MARK: - Literals

enum Literals {
  /// 보간이 없는 문자열 리터럴의 값.
  static func string(_ expression: ExprSyntax?) -> String? {
    guard let literal = expression?.as(StringLiteralExprSyntax.self) else { return nil }
    var value = ""
    for segment in literal.segments {
      guard let text = segment.as(StringSegmentSyntax.self) else { return nil }
      value += text.content.text
    }
    return value
  }

  /// 정수 또는 실수 리터럴을 숫자로 읽는다. `2.0` 같은 값도 허용한다.
  static func number(_ expression: ExprSyntax?) -> Double? {
    guard let expression else { return nil }
    if let integer = expression.as(IntegerLiteralExprSyntax.self) {
      return Double(integer.literal.text.replacingOccurrences(of: "_", with: ""))
    }
    if let float = expression.as(FloatLiteralExprSyntax.self) {
      return Double(float.literal.text.replacingOccurrences(of: "_", with: ""))
    }
    return nil
  }
}
