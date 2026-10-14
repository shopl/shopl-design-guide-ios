import Foundation

/// 이미지 에셋 한 개. 사용자는 `Image(sdg: .<name>)`으로 접근한다.
struct IconRecord: Encodable {
  let name: String
  let assetName: String
  /// `ic_` 접두사 에셋은 icon, 나머지(빈 화면 일러스트·배지 등)는 image
  let kind: String
  /// `template`이면 `.foregroundStyle`/`templateIcon(size:color:)`로 색을 입힐 수 있다.
  let renderingMode: String?
  let formats: [String]
  let keywords: [String]
  let source: String
}

struct IconFile: Encodable {
  let sources: [String]
  let count: Int
  let countsByKind: [String: Int]
  let icons: [IconRecord]
}

struct IconExtractor {
  let repository: Repository
  let symbols: GeneratedAssetSymbols

  func extract(report: inout Report) throws -> IconFile {
    var icons: [IconRecord] = []
    var seenAssets = Set<String>()

    for imageset in try repository.directories(in: repository.imageAssets, withExtension: "imageset") {
      let assetName = imageset.deletingPathExtension().lastPathComponent
      seenAssets.insert(assetName)

      guard let symbol = symbols.images[assetName] else {
        report.warn("이미지 에셋 \(assetName)에 대응하는 Swift 심볼이 없습니다. Tuist 생성 파일이 최신인지 확인하세요.")
        continue
      }

      let contents = try ImagesetContents(contentsOf: imageset.appending(path: "Contents.json"))
      icons.append(IconRecord(
        name: symbol,
        assetName: assetName,
        kind: assetName.hasPrefix("ic_") ? "icon" : "image",
        renderingMode: contents.renderingIntent,
        formats: contents.formats,
        keywords: keywords(of: assetName),
        source: repository.relativePath(of: imageset)
      ))
    }

    for (assetName, symbol) in symbols.images where !seenAssets.contains(assetName) {
      report.warn("Swift 심볼 \(symbol)이 가리키는 이미지 에셋 \(assetName)이 없습니다.")
    }

    icons.sort { $0.name < $1.name }
    let counts = Dictionary(grouping: icons, by: \.kind).mapValues(\.count)
    return IconFile(
      sources: [repository.relativePath(of: repository.imageAssets)] + symbols.sources,
      count: icons.count,
      countsByKind: counts,
      icons: icons
    )
  }

  /// `ic_arrow_left_bold` → `["arrow", "left", "bold"]`
  private func keywords(of assetName: String) -> [String] {
    var words = assetName
      .lowercased()
      .split(whereSeparator: { $0 == "_" || $0 == "-" || $0 == " " })
      .map(String.init)
    if words.first == "ic" { words.removeFirst() }
    return words
  }
}

private struct ImagesetContents {
  let renderingIntent: String?
  let formats: [String]

  init(contentsOf url: URL) throws {
    let data = try Data(contentsOf: url)
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      throw ExtractionError.unexpectedStructure("imageset 형식을 읽지 못했습니다: \(url.path)")
    }
    let properties = json["properties"] as? [String: Any]
    renderingIntent = properties?["template-rendering-intent"] as? String

    let images = json["images"] as? [[String: Any]] ?? []
    let extensions = images.compactMap { ($0["filename"] as? String)?.split(separator: ".").last.map { $0.lowercased() } }
    formats = Array(Set(extensions)).sorted()
  }
}
