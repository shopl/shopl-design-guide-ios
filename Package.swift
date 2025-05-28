// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "shopl-design-guide-ios",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "shopl-design-guide-ios",
      targets: ["shopl-design-guide-ios"]),
  ],
  targets: [
    .target(
      name: "shopl-design-guide-ios"),
    .testTarget(
      name: "shopl-design-guide-iosTests",
      dependencies: ["shopl-design-guide-ios"]
    ),
  ]
)
