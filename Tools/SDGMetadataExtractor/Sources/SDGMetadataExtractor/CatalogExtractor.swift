import Foundation

struct CatalogItem: Encodable {
  let id: String
  let title: String
  var description: String?
  var subDescription: String?
  /// 카탈로그가 이 항목의 구현으로 지목한 이름들
  let implementationNames: [String]
  /// 그중 실제 공개 API로 존재하는 이름. 비어 있으면 iOS에 아직 구현되지 않은 항목이다.
  let implementedSymbols: [String]
  let implemented: Bool
  var children: [CatalogItem]?
}

struct CatalogSection: Encodable {
  let id: String
  let title: String
  let description: String
  let items: [CatalogItem]
}

struct CatalogFile: Encodable {
  let sources: [String]
  let counts: [String: Int]
  let sections: [CatalogSection]
}

/// SampleApp 디자인 가이드 카탈로그를 실행해 얻은 항목에 iOS 구현 여부를 붙인다.
///
/// 구현 여부는 SampleApp의 수동 목록(SDGImplementationManifest)이 아니라
/// 이번 추출에서 얻은 실제 공개 심볼로 계산한다.
struct CatalogExtractor {
  let repository: Repository
  let knownSymbols: Set<String>

  var catalogSource: URL { repository.sampleAppSources.appending(path: "DesignSystem/SDGCatalog.swift") }
  var dumpSource: URL { repository.root.appending(path: "Tools/SDGMetadataExtractor/CatalogDump/main.swift") }

  func extract() throws -> CatalogFile {
    let raw = try dumpCatalog()
    let sections = raw.sections.map { section in
      CatalogSection(id: section.id, title: section.title, description: section.description, items: section.items.map(item))
    }

    let leaves = sections.flatMap { $0.items.flatMap(Self.leaves) }
    return CatalogFile(
      sources: [try repository.relativePath(of: catalogSource)],
      counts: [
        "items": leaves.count,
        "implemented": leaves.filter(\.implemented).count,
        "described": leaves.filter { $0.description != nil || $0.subDescription != nil }.count
      ],
      sections: sections
    )
  }

  private func item(_ raw: RawCatalogItem) -> CatalogItem {
    let children = raw.children?.map(item)
    let implementedSymbols = raw.implementationNames.filter(knownSymbols.contains)
    let implemented = children.map { $0.contains(where: \.implemented) } ?? !implementedSymbols.isEmpty
    return CatalogItem(
      id: raw.id,
      title: raw.title,
      description: raw.description,
      subDescription: raw.subDescription,
      implementationNames: raw.implementationNames,
      implementedSymbols: implementedSymbols,
      implemented: implemented,
      children: children
    )
  }

  private static func leaves(_ item: CatalogItem) -> [CatalogItem] {
    guard let children = item.children, !children.isEmpty else { return [item] }
    return children.flatMap(leaves)
  }

  // MARK: - Dump

  private func dumpCatalog() throws -> RawCatalog {
    let workDirectory = FileManager.default.temporaryDirectory
      .appending(path: "sdg-catalog-dump-\(ProcessInfo.processInfo.processIdentifier)", directoryHint: .isDirectory)
    try FileManager.default.createDirectory(at: workDirectory, withIntermediateDirectories: true)
    defer { try? FileManager.default.removeItem(at: workDirectory) }

    let executable = workDirectory.appending(path: "dump-catalog")
    _ = try run("swiftc", [catalogSource.path, dumpSource.path, "-o", executable.path], in: workDirectory)
    let output = try run(executable.path, [], in: workDirectory)
    return try JSONDecoder().decode(RawCatalog.self, from: output)
  }

  /// 표준 출력은 파이프로, 표준 에러는 파일로 받아 두 버퍼가 서로를 막지 않게 한다.
  private func run(_ command: String, _ arguments: [String], in workDirectory: URL) throws -> Data {
    let errorLog = workDirectory.appending(path: "stderr-\(UUID().uuidString).log")
    FileManager.default.createFile(atPath: errorLog.path, contents: nil)
    let errorHandle = try FileHandle(forWritingTo: errorLog)
    defer { try? errorHandle.close() }

    let process = Process()
    process.executableURL = URL(filePath: "/usr/bin/env")
    process.arguments = [command] + arguments
    let stdout = Pipe()
    process.standardOutput = stdout
    process.standardError = errorHandle
    try process.run()
    let output = stdout.fileHandleForReading.readDataToEndOfFile()
    process.waitUntilExit()

    guard process.terminationStatus == 0 else {
      let message = (try? String(contentsOf: errorLog, encoding: .utf8)) ?? ""
      throw ExtractionError.commandFailed("카탈로그 덤프 실패 (\(command)): \(message)")
    }
    return output
  }
}

private struct RawCatalog: Decodable {
  let sections: [RawCatalogSection]
}

private struct RawCatalogSection: Decodable {
  let id: String
  let title: String
  let description: String
  let items: [RawCatalogItem]
}

private struct RawCatalogItem: Decodable {
  let id: String
  let title: String
  let description: String?
  let subDescription: String?
  let implementationNames: [String]
  let children: [RawCatalogItem]?
}
