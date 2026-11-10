import XCTest
@testable import SDGMetadataExtractor

/// 사용 예제가 모듈 밖에서도 컴파일되는 호출만 담는지 확인한다.
final class ExampleExtractorTests: XCTestCase {
  private let path = "Sources/ShoplDesignGuide/Component/Fixture/Fixture.swift"

  func testTrailingClosureSkipsDefaultedClosureParameter() throws {
    // SE-0286: 기본값 있는 onClear 뒤에 필수 search가 남아 있으므로 후행 클로저는 search에 대응한다.
    let examples = try FixtureRepository(files: [path: """
      import SwiftUI

      public struct Search: View {
        public init(title: String, onClear: (() -> Void)? = nil, search: @escaping (String) -> Void) {}
        public var body: some View { EmptyView() }
      }

      #Preview {
        Search(title: "t") { text in print(text) }
      }
      """], testCase: self).examples()

    XCTAssertEqual(examples.examples["Search"]?.map(\.code), [#"Search(title: "t") { text in print(text) }"#])
  }

  func testNestedInitWithoutPublicInitializerIsRejected() throws {
    // 프리뷰는 모듈 안에서 컴파일되어 internal memberwise init을 쓸 수 있지만, 앱에서는 컴파일되지 않는다.
    let examples = try FixtureRepository(files: [path: """
      import SwiftUI

      public struct Part {
        let x: Int
      }

      public struct Option {
        public init(title: String) {}
      }

      public struct Host: View {
        public init(part: Part) {}
        public init(option: Option) {}
        public var body: some View { EmptyView() }
      }

      #Preview {
        Host(part: .init(x: 1))
      }

      #Preview {
        Host(option: .init(title: "ok"))
      }
      """], testCase: self).examples()

    XCTAssertEqual(examples.examples["Host"]?.map(\.code), [#"Host(option: .init(title: "ok"))"#])
  }

  func testSubclassMayInheritPublicInitializer() throws {
    // 상속한 클래스는 상위 클래스의 public init을 물려받을 수 있으므로 막지 않는다.
    let examples = try FixtureRepository(files: [path: """
      import SwiftUI

      open class Base {
        public init() {}
      }

      public final class Sub: Base {}

      public struct Host: View {
        public init(model: Sub) {}
        public var body: some View { EmptyView() }
      }

      #Preview {
        Host(model: .init())
      }
      """], testCase: self).examples()

    XCTAssertEqual(examples.examples["Host"]?.count, 1)
  }

  func testSampleAppCallsAreCollected() throws {
    let examples = try FixtureRepository(files: [
      path: """
      import SwiftUI

      public struct Badge: View {
        public init(title: String) {}
        public var body: some View { EmptyView() }
      }
      """,
      "SampleApp/Sources/Demo.swift": """
      import SwiftUI
      import ShoplDesignGuide

      struct Demo: View {
        var body: some View {
          Badge(title: "new")
        }
      }
      """
    ], testCase: self).examples()

    let badge = try XCTUnwrap(examples.examples["Badge"]?.first)
    XCTAssertEqual(badge.source, "sample-app")
    XCTAssertEqual(badge.code, #"Badge(title: "new")"#)
  }
}
