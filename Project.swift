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
      sources: [
        .glob(
          "Sources/ShoplDesignGuide/**",
          excluding: [
            "Sources/ShoplDesignGuide/Generated/**"
          ]
        )
      ],
      resources: ["Sources/ShoplDesignGuide/Resources/**"],
      scripts: [
        .syncTuistGeneratedFiles
      ],
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

extension TargetScript {
  // Tuist가 자동 생성한 에셋 관련 파일들을 라이브러리 배포 범위에 포함시키기 위해 복사하는 스크립트
  // 빌드 phase 때 실행
  static let syncTuistGeneratedFiles: TargetScript = .pre(
    script: """
        mkdir -p "$SRCROOT/Sources/ShoplDesignGuide/Generated"
        
        echo "🔄 [Auto-Sync] Syncing ONLY library files..."
        
        rsync -av --delete \
            --include '*+ShoplDesignGuide.swift' \
            --exclude '*' \
            "$SRCROOT/Derived/Sources/" \
            "$SRCROOT/Sources/ShoplDesignGuide/Generated/"
            
        echo "✅ [Auto-Sync] Completed!"
        """,
    name: "Sync Tuist Generated Files",
    basedOnDependencyAnalysis: false
  )
}
