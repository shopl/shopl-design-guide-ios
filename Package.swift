// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ShoplDesignGuide",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "ShoplDesignGuide",
      targets: ["ShoplDesignGuide"]),
  ],
  targets: [
    .target(
      name: "ShoplDesignGuide",
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
