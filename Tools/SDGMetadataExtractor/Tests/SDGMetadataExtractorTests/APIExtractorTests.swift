import XCTest
@testable import SDGMetadataExtractor

/// 공개 API 추출 규칙의 회귀 테스트. 현재 SDG 소스에는 없는 형태도 포함해, 소스가 바뀌어도 규칙이 유지되는지 확인한다.
final class APIExtractorTests: XCTestCase {
  private let path = "Sources/ShoplDesignGuide/Component/Fixture/Fixture.swift"

  func testViewConformanceDeclaredInExtension() throws {
    let api = try FixtureRepository(files: [path: """
      import SwiftUI

      public struct ConformLater {
        public init() {}
        public var body: some View { Text("x") }
      }
      extension ConformLater: View {}
      """], testCase: self).api()

    let card = try XCTUnwrap(api.card("ConformLater"))
    XCTAssertTrue(card.isView)
    XCTAssertFalse(card.properties.contains { $0.name == "body" })
  }

  func testNestedTypeDeclaredInExtensionIsLinkedToParent() throws {
    let api = try FixtureRepository(files: [path: """
      public struct Holder {
        public init() {}
      }
      extension Holder {
        public enum Mode { case a, b }
      }
      """], testCase: self).api()

    XCTAssertEqual(api.card("Holder")?.nestedTypes, ["Holder.Mode"])
  }

  func testDeclarationsInsideNonPublicTypesAreExcluded() throws {
    let api = try FixtureRepository(files: [path: """
      struct InternalType {
        public struct InlineNested {}
      }
      extension InternalType {
        public func leaked() {}
        public struct ExtensionNested {}
      }
      """], testCase: self).api()

    let names = (api.views + api.types).map(\.name)
    XCTAssertFalse(names.contains { $0.hasPrefix("InternalType") }, "\(names)")
    XCTAssertFalse((api.modifiers + api.extensions).contains { $0.name == "leaked" })
  }

  func testMultipleBindingsShareTypeAnnotation() throws {
    let api = try FixtureRepository(files: [path: """
      public struct Multi {
        public let a, b: Int
        public let c = 1, d: String = "x"
      }
      """], testCase: self).api()

    XCTAssertEqual(api.card("Multi")?.properties.map(\.signature), ["let a: Int", "let b: Int", "let c = 1", "let d: String"])
  }

  func testAvailabilityAttributes() throws {
    let api = try FixtureRepository(files: [path: """
      public struct Availability {
        @available(*, deprecated, renamed: "init(value:)")
        public init(old: Int) {}

        @available(*, deprecated, message: "Use init(value:) instead.")
        public init(legacy: Int) {}

        @available(*, deprecated, message: "This is unavailable on watchOS.")
        public init(note: Int) {}

        @available(iOS, deprecated: 16, message: "Use init(value:).")
        public init(platform: Int) {}

        @available(*, unavailable)
        public init(removed: Int) {}

        @available(macOS, unavailable)
        public init(iOSOnly: Int) {}

        public init(value: Int) {}
      }
      """], testCase: self).api()

    let initializers = try XCTUnwrap(api.card("Availability")).initializers
    let deprecations = Dictionary(uniqueKeysWithValues: initializers.map { ($0.signature, $0.deprecated ?? "") })
    XCTAssertEqual(deprecations["init(old: Int)"], "renamed: init(value:)")
    XCTAssertEqual(deprecations["init(legacy: Int)"], "Use init(value:) instead.")
    // 메시지 안의 "unavailable"은 키워드가 아니다.
    XCTAssertEqual(deprecations["init(note: Int)"], "This is unavailable on watchOS.")
    XCTAssertEqual(deprecations["init(platform: Int)"], "Use init(value:).")
    // 모든 플랫폼에서 unavailable이면 제외, macOS 전용 unavailable은 iOS에서 쓸 수 있으므로 유지.
    XCTAssertNil(deprecations["init(removed: Int)"])
    XCTAssertEqual(deprecations["init(iOSOnly: Int)"], "")
    XCTAssertEqual(deprecations["init(value: Int)"], "")
  }

  func testDebugOnlyDeclarationsAreExcluded() throws {
    let api = try FixtureRepository(files: [path: """
      #if DEBUG
      public struct DebugOnly {}
      #endif

      #if DEBUG && targetEnvironment(simulator)
      public struct DebugSimulatorOnly {}
      #endif

      #if !DEBUG
      public struct ReleaseOnly {}
      #else
      public struct DebugElse {}
      #endif
      """], testCase: self).api()

    let names = Set((api.views + api.types).map(\.name))
    XCTAssertFalse(names.contains("DebugOnly"))
    XCTAssertFalse(names.contains("DebugSimulatorOnly"))
    XCTAssertTrue(names.contains("ReleaseOnly"))
    XCTAssertTrue(names.contains("DebugElse"), "#else 절의 조건은 알 수 없으므로 유지한다")
  }

  func testSymlinkedRepositoryRootKeepsRelativePathsAndExclusions() throws {
    let fixture = try FixtureRepository(files: [
      path: """
        public struct Linked {
          public init() {}
        }
        """,
      "Sources/ShoplDesignGuide/Generated/Assets.swift": """
        public struct GeneratedOnly {}
        """,
    ], throughSymlink: true, testCase: self)
    let api = try fixture.api()

    let names = (api.views + api.types).map(\.name)
    XCTAssertEqual(names, ["Linked"], "Generated 폴더는 심볼릭 링크 루트에서도 제외되어야 한다")
    XCTAssertEqual(api.card("Linked")?.location.file, path)
    XCTAssertEqual(api.sources, ["Sources/ShoplDesignGuide"])
    // 루트 밖 경로는 절대 경로로 남기지 않고 실패한다.
    XCTAssertThrowsError(try fixture.repository.relativePath(of: URL(filePath: "/usr/bin")))
  }

  func testDocCommentSeparatedByWhitespaceOnlyLineIsDropped() throws {
    let api = try FixtureRepository(files: [path: "public struct Doc {\n  /// detached\n  \n  public init() {}\n  /// attached\n  public init(y: Int) {}\n}\n"], testCase: self).api()

    let docs = Dictionary(uniqueKeysWithValues: try XCTUnwrap(api.card("Doc")).initializers.map { ($0.signature, $0.doc ?? "") })
    XCTAssertEqual(docs["init()"], "")
    XCTAssertEqual(docs["init(y: Int)"], "attached")
  }
}
