// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import ProjectDescription

let packageSettings = PackageSettings(
  productTypes: [
    "Kingfisher": .framework,
  ],
  targetSettings: [
    // Match the app's minimum iOS version; newer Xcode SDKs no longer support iOS 12.
    "Kingfisher": .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "16.0"]),
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
