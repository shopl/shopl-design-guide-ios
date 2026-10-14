import Foundation
import XCTest
@testable import SDGMetadataExtractor

/// 테스트마다 임시 폴더에 최소한의 SDG 레포 구조를 만든다.
/// 경로는 레포 루트 기준이며 `Sources/ShoplDesignGuide/...`, `SampleApp/Sources/...` 형태로 넘긴다.
struct FixtureRepository {
  let repository: Repository

  /// `throughSymlink`이 참이면 레포 폴더를 가리키는 심볼릭 링크를 루트로 넘긴다.
  init(files: [String: String], throughSymlink: Bool = false, testCase: XCTestCase) throws {
    let root = FileManager.default.temporaryDirectory
      .appending(path: "sdg-metadata-tests-\(UUID().uuidString)", directoryHint: .isDirectory)
    try FileManager.default.createDirectory(
      at: root.appending(path: "Sources/ShoplDesignGuide", directoryHint: .isDirectory),
      withIntermediateDirectories: true
    )
    for (path, contents) in files {
      let url = root.appending(path: path)
      try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
      try contents.write(to: url, atomically: true, encoding: .utf8)
    }
    testCase.addTeardownBlock { try? FileManager.default.removeItem(at: root) }

    guard throughSymlink else {
      repository = Repository(root: root)
      return
    }
    let link = root.deletingLastPathComponent()
      .appending(path: "\(root.lastPathComponent)-link", directoryHint: .isDirectory)
    try FileManager.default.createSymbolicLink(at: link, withDestinationURL: root)
    testCase.addTeardownBlock { try? FileManager.default.removeItem(at: link) }
    repository = Repository(root: link)
  }

  func api() throws -> APIFile {
    try APIExtractor(repository: repository).extract()
  }

  func examples() throws -> ExampleFile {
    try ExampleExtractor(repository: repository, api: api()).extract()
  }
}

extension APIFile {
  func card(_ name: String) -> TypeCard? {
    (views + types).first { $0.name == name }
  }
}
