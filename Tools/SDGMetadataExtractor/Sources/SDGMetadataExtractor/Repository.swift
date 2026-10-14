import Foundation

/// 레포 루트를 기준으로 SDG 소스·에셋 위치를 찾고 상대 경로를 계산한다.
struct Repository {
  let root: URL

  init(root: URL) {
    self.root = root.standardizedFileURL
  }

  var librarySources: URL { root.appending(path: "Sources/ShoplDesignGuide") }
  var generatedSources: URL { librarySources.appending(path: "Generated") }
  var foundationSources: URL { librarySources.appending(path: "Foundation") }
  var colorAssets: URL { librarySources.appending(path: "Resources/Assets/Colors.xcassets") }
  var imageAssets: URL { librarySources.appending(path: "Resources/Assets/Images.xcassets") }
  var sampleAppSources: URL { root.appending(path: "SampleApp/Sources") }
  var packageManifest: URL { root.appending(path: "Package.swift") }

  /// 레포 루트 기준 상대 경로. 생성 데이터에 절대 경로가 남지 않도록 항상 이 값을 쓴다.
  func relativePath(of url: URL) -> String {
    let path = url.standardizedFileURL.path
    let rootPath = root.path.hasSuffix("/") ? root.path : root.path + "/"
    return path.hasPrefix(rootPath) ? String(path.dropFirst(rootPath.count)) : path
  }

  /// 디렉터리 아래의 `.swift` 파일을 상대 경로 순으로 반환한다. 숨김 폴더는 건너뛴다.
  func swiftFiles(in directory: URL, excluding excluded: [URL] = []) throws -> [URL] {
    let excludedPaths = excluded.map { $0.standardizedFileURL.path + "/" }
    return try files(in: directory, matching: { $0.pathExtension == "swift" })
      .filter { file in !excludedPaths.contains { file.path.hasPrefix($0) } }
  }

  /// 디렉터리 아래에서 이름이 `.<pathExtension>`으로 끝나는 폴더(에셋 카탈로그의 colorset 등)를 찾는다.
  func directories(in directory: URL, withExtension pathExtension: String) throws -> [URL] {
    try files(in: directory, includeDirectories: true, matching: { url in
      url.pathExtension == pathExtension && url.hasDirectoryPath
    })
  }

  private func files(
    in directory: URL,
    includeDirectories: Bool = false,
    matching predicate: (URL) -> Bool
  ) throws -> [URL] {
    guard let enumerator = FileManager.default.enumerator(
      at: directory,
      includingPropertiesForKeys: [.isDirectoryKey],
      options: [.skipsHiddenFiles]
    ) else {
      throw ExtractionError.missingPath(relativePath(of: directory))
    }

    var result: [URL] = []
    for case let url as URL in enumerator {
      let isDirectory = (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
      let candidate = isDirectory ? url.appending(path: "", directoryHint: .isDirectory) : url
      if isDirectory && !includeDirectories { continue }
      if predicate(candidate) { result.append(candidate.standardizedFileURL) }
    }
    return result.sorted { relativePath(of: $0) < relativePath(of: $1) }
  }
}

/// `Sources/ShoplDesignGuide/<Layer>/<Group>/...` 경로에서 레이어와 그룹을 읽는다.
///
/// 줄 번호는 정렬에만 쓰고 출력하지 않는다. 코드가 몇 줄 밀릴 때마다 생성 데이터 diff가 생기는 것을 막기 위해서다.
struct SourceLocation: Encodable, Equatable {
  let file: String
  let line: Int
  let layer: String
  let group: String

  private enum CodingKeys: String, CodingKey {
    case file, layer, group
  }

  init(file: String, line: Int) {
    self.file = file
    self.line = line

    let components = file.split(separator: "/").map(String.init)
    if components.count >= 4, components[0] == "Sources", components[1] == "ShoplDesignGuide" {
      layer = components[2]
      group = components.count > 4 ? components[3] : components[2]
    } else {
      layer = components.first ?? file
      group = components.dropLast().last ?? layer
    }
  }
}

enum ExtractionError: Error, CustomStringConvertible {
  case missingPath(String)
  case invalidArguments(String)
  case unexpectedStructure(String)
  case commandFailed(String)

  var description: String {
    switch self {
    case .missingPath(let path): "경로를 찾을 수 없습니다: \(path)"
    case .invalidArguments(let message): message
    case .unexpectedStructure(let message): "소스 구조가 추출기의 가정과 다릅니다: \(message)"
    case .commandFailed(let message): message
    }
  }
}
