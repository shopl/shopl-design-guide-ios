import Foundation
import SwiftSyntax

struct PlatformRequirement: Encodable {
  let name: String
  let version: String
}

struct PackageDependency: Encodable {
  let url: String
  /// 예: `exact: 7.10.0`, `from: 1.0.0`
  let requirement: String?
}

struct SetupFile: Encodable {
  let sources: [String]
  let swiftToolsVersion: String?
  /// `import`에 쓰는 모듈 이름이자 SPM 제품 이름
  let products: [String]
  let platforms: [PlatformRequirement]
  let dependencies: [PackageDependency]
  /// 다국어 키(SDGLocalizationKey)를 직접 쓰는 파일에 선언된 공개 심볼.
  /// 이 심볼을 쓰는 앱은 시작 시 `SDGString.shared.setProvider(provider:)`를 호출해야 한다.
  let localizedSymbols: [String]
}

/// Package.swift와 소스에서 셋업 가이드에 필요한 사실을 뽑는다.
/// 설치 절차·주의사항 문구는 사람이 관리하는 `setup.curated.json`이 담당한다.
struct SetupExtractor {
  let repository: Repository
  let api: APIFile

  func extract() throws -> SetupFile {
    let manifest = try ParsedFile(url: repository.packageManifest, repository: repository)
    let localized = try localizedSymbols()

    return SetupFile(
      sources: [manifest.relativePath] + localized.files,
      swiftToolsVersion: toolsVersion(in: manifest.source),
      products: products(in: manifest.tree),
      platforms: platforms(in: manifest.tree),
      dependencies: dependencies(in: manifest.tree),
      localizedSymbols: localized.symbols
    )
  }

  private func toolsVersion(in source: String) -> String? {
    guard let firstLine = source.split(separator: "\n", maxSplits: 1).first,
          let range = firstLine.range(of: #"swift-tools-version:\s*([0-9.]+)"#, options: .regularExpression)
    else { return nil }
    return firstLine[range].split(separator: ":").last.map { $0.trimmingCharacters(in: .whitespaces) }
  }

  /// `.library(name: "ShoplDesignGuide", ...)`
  private func products(in tree: SourceFileSyntax) -> [String] {
    calls(named: "library", in: tree).compactMap { call in
      Literals.string(call.arguments.first { $0.label?.text == "name" }?.expression)
    }
  }

  /// `.iOS(.v16)` → iOS 16.0, `.macOS(.v13_4)` → macOS 13.4
  private func platforms(in tree: SourceFileSyntax) -> [PlatformRequirement] {
    ["iOS", "macOS", "tvOS", "watchOS", "visionOS", "macCatalyst"].flatMap { platform in
      calls(named: platform, in: tree).compactMap { call -> PlatformRequirement? in
        guard let argument = call.arguments.first?.expression else { return nil }
        if let member = argument.as(MemberAccessExprSyntax.self) {
          let parts = member.declName.baseName.text.dropFirst().split(separator: "_").map(String.init)
          guard let major = parts.first else { return nil }
          return PlatformRequirement(name: platform, version: parts.count > 1 ? parts.joined(separator: ".") : major + ".0")
        }
        return Literals.string(argument).map { PlatformRequirement(name: platform, version: $0) }
      }
    }
  }

  /// `.package(url: "...", exact: "7.10.0")`
  private func dependencies(in tree: SourceFileSyntax) -> [PackageDependency] {
    calls(named: "package", in: tree).compactMap { call in
      guard let url = Literals.string(call.arguments.first { $0.label?.text == "url" }?.expression) else { return nil }
      let requirement = call.arguments.dropFirst().first.map { argument in
        let value = Literals.string(argument.expression) ?? SyntaxText.compact(argument.expression)
        return (argument.label.map { $0.text + ": " } ?? "") + value
      }
      return PackageDependency(url: url, requirement: requirement)
    }
  }

  private func calls(named name: String, in tree: SourceFileSyntax) -> [FunctionCallExprSyntax] {
    tree.descendants(ofType: FunctionCallExprSyntax.self).filter { call in
      call.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text == name
    }
  }

  /// 다국어 문자열(SDGLocalizationKey, SDGString.getSDGString)을 직접 쓰는 라이브러리 파일
  /// (다국어 모듈 자체는 제외)에 선언된 공개 View·모디파이어.
  private func localizedSymbols() throws -> (symbols: [String], files: [String]) {
    let localizationDirectory = repository.foundationSources.appending(path: "SDGLocalization")
    let files = try repository.swiftFiles(
      in: repository.librarySources,
      excluding: [repository.generatedSources, localizationDirectory]
    )

    var localizedFiles: [String] = []
    for url in files {
      let source = try String(contentsOf: url, encoding: .utf8)
      if source.contains("SDGLocalizationKey") || source.contains("getSDGString") {
        localizedFiles.append(repository.relativePath(of: url))
      }
    }

    let fileSet = Set(localizedFiles)
    let views = api.views.filter { fileSet.contains($0.location.file) }.map(\.name)
    let modifiers = api.modifiers.filter { fileSet.contains($0.location.file) }.map { "View." + $0.name }
    return (Array(Set(views + modifiers)).sorted(), localizedFiles)
  }
}
