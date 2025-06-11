// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ShoplDesignGuide",
  platforms: [
    .macOS(.v12),
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "ShoplDesignGuide",
      targets: ["ShoplDesignGuide"]),
  ],
  dependencies: [
    .package(url: "https://github.com/onevcat/Kingfisher", exact: "7.10.0"),
  ],
  targets: [
    .target(
      name: "ShoplDesignGuide",
      dependencies: [
        "Kingfisher"
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "ShoplDesignGuideTests",
      dependencies: ["ShoplDesignGuide"]
    ),
  ]
)
