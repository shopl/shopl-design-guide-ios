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
/// - SampleApp은 별도 모듈이라 공개 API만 쓰지만, 같은 이름의 SwiftUI 타입(Divider 등)과 구분하기 위해
///   모든 호출을 공개 시그니처의 인자 라벨과 대조하고 맞지 않으면 버린다.
struct ExampleExtractor {
  let repository: Repository
  let api: APIFile

  static let maxPreviewExamples = 3
  static let maxSampleAppExamples = 2
  static let maxCodeLength = 1_200

  /// SwiftUI 기본 모디파이어와 이름이 같아 이름만으로는 SDG 오버로드인지 알 수 없는 것들.
  /// 사용법은 토큰 데이터의 사용 예시로 충분하므로 예제 수집에서 뺀다.
  static let ambiguousModifiers: Set<String> = ["padding", "cornerRadius", "clipShape"]

  func extract() throws -> ExampleFile {
    var shapes: [String: [[ParameterCard]]] = [:]
    for view in api.views where !view.initializers.isEmpty {
      shapes[view.name] = view.initializers.compactMap(\.parameters)
    }
    for modifier in api.modifiers where !Self.ambiguousModifiers.contains(modifier.name) {
      shapes["View." + modifier.name, default: []].append(modifier.parameters ?? [])
    }

    var candidates: [String: [ExampleRecord]] = [:]

    let libraryFiles = try repository.swiftFiles(in: repository.librarySources, excluding: [repository.generatedSources])
    for url in libraryFiles {
      let file = try ParsedFile(url: url, repository: repository)
      for preview in previewBlocks(in: file.tree) {
        collect(in: preview, file: file, source: "preview", shapes: shapes, into: &candidates)
      }
    }

    let sampleFiles = (try? repository.swiftFiles(in: repository.sampleAppSources)) ?? []
    for url in sampleFiles {
      let file = try ParsedFile(url: url, repository: repository)
      collect(in: file.tree, file: file, source: "sample-app", shapes: shapes, into: &candidates)
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
    shapes: [String: [[ParameterCard]]],
    into candidates: inout [String: [ExampleRecord]]
  ) {
    for call in root.descendants(ofType: FunctionCallExprSyntax.self) {
      guard let (key, start) = target(of: call, shapes: shapes),
            let overloads = shapes[key],
            overloads.contains(where: { CallShape(call).matches($0) })
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
  private func target(of call: FunctionCallExprSyntax, shapes: [String: [[ParameterCard]]]) -> (String, AbsolutePosition)? {
    if let reference = call.calledExpression.as(DeclReferenceExprSyntax.self),
       shapes[reference.baseName.text] != nil {
      return (reference.baseName.text, call.positionAfterSkippingLeadingTrivia)
    }
    if let member = call.calledExpression.as(MemberAccessExprSyntax.self),
       member.base != nil,
       shapes["View." + member.declName.baseName.text] != nil {
      return ("View." + member.declName.baseName.text, member.period.positionAfterSkippingLeadingTrivia)
    }
    return nil
  }

  private static func normalized(_ code: String) -> String {
    code.replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
  }
}

// MARK: - Argument label matching

/// 호출의 인자 라벨·후행 클로저 구성이 파라미터 목록과 맞는지 판단한다.
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

  func matches(_ parameters: [ParameterCard]) -> Bool {
    var index = 0

    func advance(toLabel label: String?) -> Bool {
      while index < parameters.count, parameters[index].label != label, parameters[index].defaultValue != nil {
        index += 1
      }
      guard index < parameters.count, parameters[index].label == label else { return false }
      index += 1
      return true
    }

    for label in labels {
      guard advance(toLabel: label) else { return false }
    }

    if hasTrailingClosure {
      while index < parameters.count, !Self.isClosure(parameters[index]), parameters[index].defaultValue != nil {
        index += 1
      }
      guard index < parameters.count, Self.isClosure(parameters[index]) else { return false }
      index += 1
    }

    for label in additionalTrailingLabels {
      guard advance(toLabel: label) else { return false }
    }

    return parameters[index...].allSatisfy { $0.defaultValue != nil }
  }

  private static func isClosure(_ parameter: ParameterCard) -> Bool {
    parameter.type.contains("->")
  }
}
