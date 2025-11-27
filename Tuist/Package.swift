// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import ProjectDescription

let packageSettings = PackageSettings(
  productTypes: [
    "Kingfisher": .staticFramework,
  ]
)

#endif

let package = Package(
  name: "Externals",
  platforms: [.iOS(.v16)],
  dependencies: [
    .package(url: "https://github.com/onevcat/Kingfisher", exact: "7.10.0"),
  ]
)
