@preconcurrency import ProjectDescription

// MARK: - Settings

let settings: Settings = .settings(
  base: [
    "DEVELOPMENT_TEAM": "4Z4H456LU8",
  ]
)

// MARK: - Project

let project = Project(
  name: "ShoplDesignGuide",
  organizationName: "Shopl",
  settings: settings,
  targets: [
    .target(
      name: "ShoplDesignGuide",
      destinations: .iOS,
      product: .framework,
      bundleId: "com.shopl.designguide.framework",
      deploymentTargets: .iOS("16.0"),
      sources: ["Sources/ShoplDesignGuide/**"],
      resources: ["Sources/ShoplDesignGuide/Resources/**"],
      dependencies: [
        .external(name: "Kingfisher")
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "NO",
          "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "NO"
        ],
        configurations: [],
        defaultSettings: .recommended
      )
    ),
    .target(
      name: "SDGSampleApp",
      destinations: .iOS,
      product: .app,
      productName: "SDG",
      bundleId: "com.shopl.designguide.ios",
      deploymentTargets: .iOS("16.0"),
      infoPlist: .file(path: "SampleApp/Resources/Info.plist"),
      sources: ["SampleApp/Sources/**"],
      resources: [
        .glob(
          pattern: "SampleApp/Resources/**",
          excluding: ["SampleApp/Resources/Info.plist"]
        )
      ],
      dependencies: [
        .target(name: "ShoplDesignGuide")
      ]
    )
  ],
  resourceSynthesizers: [
    .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
    .fonts()
  ]
)

