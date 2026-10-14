import Foundation
import SwiftSyntax

struct ExampleRecord: Encodable {
  /// `preview`: 라이브러리 `#Preview`, `sample-app`: SampleApp 데모 화면
  let source: String
  let file: String
  let code: String
  var truncated: Bool?
}

struct ExampleFile: Encodable {
  let sources: [String]
  let count: Int
  /// 키: View 이름(`SDGBoxButton`) 또는 모디파이어(`View.centerConfirmPopup`)
  let examples: [String: [ExampleRecord]]
}

/// 실제 호출부를 사용 예제로 모은다.
///
/// - 라이브러리 소스는 `#Preview` 안의 호출만 본다(본문 구현은 내부 API를 쓸 수 있으므로 제외).
/// - 프리뷰는 모듈 안에서 컴파일되므로 internal init을 쓸 수 있다. 호출과 그 안의 중첩 SDG 생성 호출
///   (`.init(...)`, `SDGButtonColor(...)`)을 공개 init 시그니처와 대조해 맞지 않으면 버린다.
/// - SampleApp은 별도 모듈이지만 같은 이름의 SwiftUI 타입(Divider 등)과 구분하기 위해 같은 검사를 거친다.
struct ExampleExtractor {
  let repository: Repository
  let api: APIFile

  static let maxPreviewExamples = 3
  static let maxSampleAppExamples = 2
  static let maxCodeLength = 1_200

  /// SwiftUI 기본 모디파이어와 이름이 같아 이름만으로는 SDG 오버로드인지 알 수 없는 것들.
  /// 사용법은 토큰 데이터의 사용 예시로 충분하므로 예제 수집에서 뺀다.
  static let ambiguousModifiers: Set<String> = ["padding", "cornerRadius", "clipShape"]

  /// 예제를 모을 대상. owner는 시그니처 안의 타입 이름(`Option`)을 찾을 스코프다.
  private struct Target {
    let owner: String
    var overloads: [[ParameterCard]]
  }

  func extract() throws -> ExampleFile {
    var targets: [String: Target] = [:]
    for view in api.views where !view.initializers.isEmpty {
      targets[view.name] = Target(owner: view.name, overloads: view.initializers.compactMap(\.parameters))
    }
    for modifier in api.modifiers where !Self.ambiguousModifiers.contains(modifier.name) {
      targets["View." + modifier.name, default: Target(owner: "", overloads: [])].overloads.append(modifier.parameters ?? [])
    }
    let validator = CallValidator(api: api)

    var candidates: [String: [ExampleRecord]] = [:]

    let libraryFiles = try repository.swiftFiles(in: repository.librarySources, excluding: [repository.generatedSources])
    for url in libraryFiles {
      let file = try ParsedFile(url: url, repository: repository)
      for preview in previewBlocks(in: file.tree) {
        collect(in: preview, file: file, source: "preview", targets: targets, validator: validator, into: &candidates)
      }
    }

    let sampleFiles = (try? repository.swiftFiles(in: repository.sampleAppSources)) ?? []
    for url in sampleFiles {
      let file = try ParsedFile(url: url, repository: repository)
      collect(in: file.tree, file: file, source: "sample-app", targets: targets, validator: validator, into: &candidates)
    }

    var examples: [String: [ExampleRecord]] = [:]
    for (key, records) in candidates {
      var seen = Set<String>()
      let unique = records.filter { seen.insert(Self.normalized($0.code)).inserted }
      let picked = Array(unique.filter { $0.source == "preview" }.prefix(Self.maxPreviewExamples))
        + Array(unique.filter { $0.source == "sample-app" }.prefix(Self.maxSampleAppExamples))
      if !picked.isEmpty { examples[key] = picked }
    }

    return ExampleFile(
      sources: [
        repository.relativePath(of: repository.librarySources) + " (#Preview)",
        repository.relativePath(of: repository.sampleAppSources)
      ],
      count: examples.values.reduce(0) { $0 + $1.count },
      examples: examples
    )
  }

  // MARK: - Collection

  /// `#Preview` 블록과, 프리뷰가 위임하는 비공개 헬퍼 타입(`private struct XxxPreview: View`).
  private func previewBlocks(in tree: SourceFileSyntax) -> [Syntax] {
    let declarations = tree.descendants(ofType: MacroExpansionDeclSyntax.self)
      .filter { $0.macroName.text == "Preview" }
      .map { Syntax($0) }
    let expressions = tree.descendants(ofType: MacroExpansionExprSyntax.self)
      .filter { $0.macroName.text == "Preview" }
      .map { Syntax($0) }
    let helpers = tree.descendants(ofType: StructDeclSyntax.self)
      .filter { $0.name.text.contains("Preview") && !Visibility.isPublic($0.modifiers, default: false) }
      .map { Syntax($0) }
    return declarations + expressions + helpers
  }

  private func collect(
    in root: some SyntaxProtocol,
    file: ParsedFile,
    source: String,
    targets: [String: Target],
    validator: CallValidator,
    into candidates: inout [String: [ExampleRecord]]
  ) {
    for call in root.descendants(ofType: FunctionCallExprSyntax.self) {
      guard let (key, start) = targetKey(of: call, targets: targets),
            let target = targets[key],
            validator.isValid(call, overloads: target.overloads, owner: target.owner)
      else { continue }

      var code = SyntaxText.snippet(of: call, from: start, in: file)
      var truncated: Bool?
      if code.count > Self.maxCodeLength {
        code = String(code.prefix(Self.maxCodeLength)) + "\n…"
        truncated = true
      }
      candidates[key, default: []].append(ExampleRecord(source: source, file: file.relativePath, code: code, truncated: truncated))
    }
  }

  /// 호출이 가리키는 예제 키와 스니펫 시작 위치. 모디파이어는 `.name(` 부터 잘라 앞의 뷰 체인을 뺀다.
  private func targetKey(of call: FunctionCallExprSyntax, targets: [String: Target]) -> (String, AbsolutePosition)? {
    if let reference = call.calledExpression.as(DeclReferenceExprSyntax.self),
       targets[reference.baseName.text] != nil {
      return (reference.baseName.text, call.positionAfterSkippingLeadingTrivia)
    }
    if let member = call.calledExpression.as(MemberAccessExprSyntax.self),
       member.base != nil,
       targets["View." + member.declName.baseName.text] != nil {
      return ("View." + member.declName.baseName.text, member.period.positionAfterSkippingLeadingTrivia)
    }
    return nil
  }

  private static func normalized(_ code: String) -> String {
    code.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
  }
}

// MARK: - Public API validation

/// 호출과 인자 안의 중첩 SDG 생성 호출이 공개 init만 쓰는지 검사한다.
/// SDG 타입이 아닌 값(SwiftUI·Foundation 타입, 변수, enum case 등)은 검사하지 않는다.
private struct CallValidator {
  private let cards: [String: TypeCard]

  init(api: APIFile) {
    cards = Dictionary((api.views + api.types).map { ($0.name, $0) }, uniquingKeysWith: { first, _ in first })
  }

  func isValid(_ call: FunctionCallExprSyntax, overloads: [[ParameterCard]], owner: String, depth: Int = 0) -> Bool {
    guard depth < 8 else { return true }
    let shape = CallShape(call)
    return overloads.contains { parameters in
      guard let bound = shape.bind(parameters) else { return false }
      return zip(call.arguments, bound).allSatisfy { argument, parameterIndex in
        isValidArgument(argument.expression, type: parameters[parameterIndex].type, owner: owner, depth: depth)
      }
    }
  }

  private func isValidArgument(_ expression: ExprSyntax, type: String, owner: String, depth: Int) -> Bool {
    let type = Self.bareType(type)
    if let array = expression.as(ArrayExprSyntax.self) {
      guard let element = Self.arrayElement(of: type) else { return true }
      return array.elements.allSatisfy { isValidArgument($0.expression, type: element, owner: owner, depth: depth) }
    }

    guard let call = expression.as(FunctionCallExprSyntax.self),
          let constructed = constructedTypeName(of: call, contextualType: type),
          let card = resolve(constructed, owner: owner)
    else { return true }

    let initializers = card.initializers.compactMap(\.parameters)
    guard !initializers.isEmpty else {
      // public init이 없는 struct·class는 모듈 밖에서 만들 수 없다(내부 memberwise init만 있는 경우 등).
      return card.kind != "struct" && card.kind != "class"
    }
    return isValid(call, overloads: initializers, owner: card.name, depth: depth + 1)
  }

  /// `.init(...)`이면 파라미터 타입, `Type(...)`·`Type.init(...)`이면 그 타입 이름.
  private func constructedTypeName(of call: FunctionCallExprSyntax, contextualType: String) -> String? {
    if let member = call.calledExpression.as(MemberAccessExprSyntax.self), member.declName.baseName.text == "init" {
      return member.base.map(SyntaxText.compact) ?? contextualType
    }
    if let reference = call.calledExpression.as(DeclReferenceExprSyntax.self) {
      return reference.baseName.text
    }
    return nil
  }

  /// 안쪽 스코프부터 바깥으로 타입을 찾고, typealias는 대상 타입까지 따라간다.
  private func resolve(_ name: String, owner: String, hops: Int = 0) -> TypeCard? {
    var scopes = owner.split(separator: ".").map(String.init)
    while true {
      if let card = cards[(scopes + [name]).joined(separator: ".")] {
        if card.kind == "typealias", let target = card.aliasOf, hops < 4 {
          let parent = card.name.split(separator: ".").dropLast().joined(separator: ".")
          return resolve(target, owner: parent, hops: hops + 1)
        }
        return card
      }
      if scopes.isEmpty { return nil }
      scopes.removeLast()
    }
  }

  /// `@escaping`·`@ViewBuilder`·`inout`·옵셔널 표기를 걷어낸 타입 이름.
  static func bareType(_ type: String) -> String {
    var text = type.replacingOccurrences(of: #"@\w+\s*"#, with: "", options: .regularExpression)
    text = text.replacingOccurrences(of: "inout ", with: "").trimmingCharacters(in: .whitespaces)
    while text.hasSuffix("?") || text.hasSuffix("!") { text.removeLast() }
    if text.hasPrefix("Optional<"), text.hasSuffix(">") { text = String(text.dropFirst("Optional<".count).dropLast()) }
    return text
  }

  static func arrayElement(of type: String) -> String? {
    if type.hasPrefix("["), type.hasSuffix("]"), !type.contains(":") {
      return bareType(String(type.dropFirst().dropLast()))
    }
    if type.hasPrefix("Array<"), type.hasSuffix(">") {
      return bareType(String(type.dropFirst("Array<".count).dropLast()))
    }
    return nil
  }
}

// MARK: - Argument label matching

/// 호출의 인자 라벨·후행 클로저 구성을 파라미터 목록에 대응시킨다.
/// Swift의 오버로드 해석을 단순화한 것으로, 기본값이 있는 파라미터는 생략될 수 있다고 본다.
private struct CallShape {
  let labels: [String?]
  let hasTrailingClosure: Bool
  let additionalTrailingLabels: [String]

  init(_ call: FunctionCallExprSyntax) {
    labels = call.arguments.map { $0.label?.text }
    hasTrailingClosure = call.trailingClosure != nil
    additionalTrailingLabels = call.additionalTrailingClosures.map(\.label.text)
  }

  /// 괄호 안 인자마다 대응하는 파라미터 인덱스. 맞지 않으면 nil.
  func bind(_ parameters: [ParameterCard]) -> [Int]? {
    var index = 0
    var bound: [Int] = []

    func advance(toLabel label: String?) -> Int? {
      while index < parameters.count, parameters[index].label != label, parameters[index].defaultValue != nil {
        index += 1
      }
      guard index < parameters.count, parameters[index].label == label else { return nil }
      defer { index += 1 }
      return index
    }

    for label in labels {
      guard let position = advance(toLabel: label) else { return nil }
      bound.append(position)
    }

    if hasTrailingClosure {
      // SE-0286 정방향 스캔: 기본값이 있는 클로저 파라미터는, 그 뒤에 반드시 채워야 하는
      // 파라미터(라벨 붙은 후행 클로저로 채워지지 않는 것)가 남아 있으면 건너뛴다.
      var matched = false
      while index < parameters.count {
        let parameter = parameters[index]
        let laterRequired = parameters[(index + 1)...].contains { later in
          later.defaultValue == nil && !additionalTrailingLabels.contains(later.label ?? "")
        }
        if Self.isClosure(parameter) && !(parameter.defaultValue != nil && laterRequired) {
          index += 1
          matched = true
          break
        }
        guard parameter.defaultValue != nil else { return nil }
        index += 1
      }
      guard matched else { return nil }
    }

    for label in additionalTrailingLabels {
      guard advance(toLabel: label) != nil else { return nil }
    }

    return parameters[index...].allSatisfy { $0.defaultValue != nil } ? bound : nil
  }

  private static func isClosure(_ parameter: ParameterCard) -> Bool {
    parameter.type.contains("->")
  }
}
