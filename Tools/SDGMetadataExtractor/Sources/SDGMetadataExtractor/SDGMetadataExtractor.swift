import Foundation

/// SDG 소스에서 MCP 서버용 메타데이터(JSON)를 생성한다.
///
/// ```
/// swift run --package-path Tools/SDGMetadataExtractor sdg-metadata \
///   --repo-root . --output plugins/sdg-ios/server/data
/// ```
/// 출력은 결정적(정렬·상대 경로·타임스탬프 없음)이어야 한다. CI가 재생성 결과와 커밋된 파일을 비교한다.
@main
struct SDGMetadataExtractor {
  static func main() {
    do {
      let options = try Options(arguments: Array(CommandLine.arguments.dropFirst()))
      let repository = Repository(root: options.repoRoot)
      let writer = OutputWriter(directory: options.output)
      var report = Report()

      let symbols = try GeneratedAssetSymbols.load(from: repository)

      let tokens = try TokenExtractor(repository: repository, symbols: symbols).extract(report: &report)
      try writer.write(tokens, to: "tokens.generated.json")
      report.summary("tokens", tokens.count, details: tokens.countsByType)

      let icons = try IconExtractor(repository: repository, symbols: symbols).extract(report: &report)
      try writer.write(icons, to: "icons.generated.json")
      report.summary("icons", icons.count, details: icons.countsByKind)

      let api = try APIExtractor(repository: repository).extract()
      try writer.write(api, to: "api.generated.json")
      report.summary("api", api.views.count + api.types.count + api.modifiers.count + api.extensions.count, details: api.counts)

      report.printAll()
      if report.hasEmptyResult {
        FileHandle.standardError.write(Data("✗ 비어 있는 결과가 있습니다. 추출기의 소스 구조 가정이 깨졌을 수 있습니다.\n".utf8))
        exit(1)
      }
    } catch {
      FileHandle.standardError.write(Data("✗ \(error)\n".utf8))
      exit(1)
    }
  }
}

struct Options {
  var repoRoot: URL
  var output: URL

  init(arguments: [String]) throws {
    let cwd = URL(filePath: FileManager.default.currentDirectoryPath, directoryHint: .isDirectory)
    var repoRoot = cwd
    var output: URL?

    var iterator = arguments.makeIterator()
    while let argument = iterator.next() {
      switch argument {
      case "--repo-root":
        guard let value = iterator.next() else { throw ExtractionError.invalidArguments("--repo-root 값이 필요합니다.") }
        repoRoot = URL(filePath: value, directoryHint: .isDirectory, relativeTo: cwd).standardizedFileURL
      case "--output":
        guard let value = iterator.next() else { throw ExtractionError.invalidArguments("--output 값이 필요합니다.") }
        output = URL(filePath: value, directoryHint: .isDirectory, relativeTo: cwd).standardizedFileURL
      case "--help", "-h":
        print("usage: sdg-metadata [--repo-root <path>] [--output <dir>]")
        exit(0)
      default:
        throw ExtractionError.invalidArguments("알 수 없는 인자: \(argument)")
      }
    }

    self.repoRoot = repoRoot
    self.output = output ?? repoRoot.appending(path: "plugins/sdg-ios/server/data", directoryHint: .isDirectory)
  }
}

struct OutputWriter {
  let directory: URL

  func write(_ value: some Encodable, to fileName: String) throws {
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    var data = try encoder.encode(value)
    data.append(contentsOf: Array("\n".utf8))
    try data.write(to: directory.appending(path: fileName), options: .atomic)
  }
}

struct Report {
  private var lines: [String] = []
  private var warnings: [String] = []
  private(set) var hasEmptyResult = false

  mutating func warn(_ message: String) {
    warnings.append(message)
  }

  mutating func summary(_ name: String, _ count: Int, details: [String: Int] = [:]) {
    if count == 0 { hasEmptyResult = true }
    let detailText = details.sorted { $0.key < $1.key }.map { "\($0.key) \($0.value)" }.joined(separator: " · ")
    lines.append("✓ \(name): \(count)" + (detailText.isEmpty ? "" : " (\(detailText))"))
  }

  func printAll() {
    lines.forEach { print($0) }
    for warning in warnings {
      FileHandle.standardError.write(Data("⚠️  \(warning)\n".utf8))
    }
  }
}
