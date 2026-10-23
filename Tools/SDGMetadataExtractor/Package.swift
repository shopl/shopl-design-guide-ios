// swift-tools-version: 6.0
// SDG MCP 서버가 제공할 메타데이터를 라이브러리 소스에서 추출하는 개발용 도구.
// swift-syntax 의존성을 SDG 라이브러리(루트 Package.swift)와 분리하기 위해 별도 패키지로 둔다.

import PackageDescription

let package = Package(
  name: "SDGMetadataExtractor",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .executable(name: "sdg-metadata", targets: ["SDGMetadataExtractor"])
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax.git", "600.0.0"..<"700.0.0")
  ],
  targets: [
    .executableTarget(
      name: "SDGMetadataExtractor",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax")
      ]
    ),
    .testTarget(
      name: "SDGMetadataExtractorTests",
      dependencies: ["SDGMetadataExtractor"]
    )
  ]
)
