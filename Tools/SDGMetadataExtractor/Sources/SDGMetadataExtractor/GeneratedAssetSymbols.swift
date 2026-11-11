import Foundation
import SwiftSyntax

/// Tuist가 생성한 `Generated/*.swift`에서 에셋 이름 ↔ Swift 심볼 매핑을 읽는다.
///
/// ```swift
/// public extension SDG.Color {
///   static let neutral0 = SDG.Color(name: "Neutral0", bundle: dsBundle)
/// }
/// ```
/// 라이브러리 사용자는 에셋 이름이 아니라 이 심볼(`.neutral0`, `.icAddPlus`)로 접근하므로
/// 심볼이 없는 에셋은 사용할 수 없는 것으로 본다.
struct GeneratedAssetSymbols {
  /// 에셋 이름 → Swift 심볼 이름
  private(set) var colors: [String: String] = [:]
  private(set) var images: [String: String] = [:]
  private(set) var sources: [String] = []

  static func load(from repository: Repository) throws -> GeneratedAssetSymbols {
    var symbols = GeneratedAssetSymbols()
    for url in try repository.swiftFiles(in: repository.generatedSources) {
      let file = try ParsedFile(url: url, repository: repository)
      let before = symbols.colors.count + symbols.images.count
      for statement in file.tree.statements {
        if let extensionDecl = Syntax(statement.item).as(ExtensionDeclSyntax.self) {
          symbols.collect(from: extensionDecl)
        }
      }
      if symbols.colors.count + symbols.images.count > before {
        symbols.sources.append(file.relativePath)
      }
    }
    return symbols
  }

  private mutating func collect(from extensionDecl: ExtensionDeclSyntax) {
    let extendedType = SyntaxText.compact(extensionDecl.extendedType)
    guard extendedType == "SDG.Color" || extendedType == "SDG.Image" else { return }

    for member in extensionDecl.memberBlock.members {
      guard let variable = member.decl.as(VariableDeclSyntax.self) else { continue }
      for binding in variable.bindings {
        guard let symbol = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              let call = binding.initializer?.value.as(FunctionCallExprSyntax.self),
              SyntaxText.compact(call.calledExpression) == extendedType,
              let nameArgument = call.arguments.first(where: { $0.label?.text == "name" }),
              let assetName = Literals.string(nameArgument.expression)
        else { continue }

        if extendedType == "SDG.Color" {
          colors[assetName] = symbol
        } else {
          images[assetName] = symbol
        }
      }
    }
  }
}
