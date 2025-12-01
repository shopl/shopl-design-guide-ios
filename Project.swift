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
      ]
    ),
    .target(
      name: "ShoplDesignGuideSampleApp",
      destinations: .iOS,
      product: .app,
      bundleId: "com.shopl.designguide",
      deploymentTargets: .iOS("16.0"),
      infoPlist: .extendingDefault(with: [
        "UILaunchStoryboardName": "LaunchScreen",
      ]),
      sources: ["SampleApp/Sources/**"],
      resources: ["SampleApp/Resources/**"],
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

