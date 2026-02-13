// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

private class DesignSystemBundleAnchor {}
private let dsBundle = Bundle(for: DesignSystemBundleAnchor.self)

// MARK: - Fonts

public enum ShoplDesignGuideFontFamily: Sendable {
  public enum Pretendard: Sendable {
    public static let black = ShoplDesignGuideFontConvertible(name: "Pretendard-Black", family: "Pretendard", path: "Sources/ShoplDesignGuide/Resources/Font/Pretendard-Black.otf")
    public static let bold = ShoplDesignGuideFontConvertible(name: "Pretendard-Bold", family: "Pretendard", path: "Sources/ShoplDesignGuide/Resources/Font/Pretendard-Bold.otf")
    public static let extraBold = ShoplDesignGuideFontConvertible(name: "Pretendard-ExtraBold", family: "Pretendard", path: "Sources/ShoplDesignGuide/Resources/Font/Pretendard-ExtraBold.otf")
    public static let extraLight = ShoplDesignGuideFontConvertible(name: "Pretendard-ExtraLight", family: "Pretendard", path: "Sources/ShoplDesignGuide/Resources/Font/Pretendard-ExtraLight.otf")
    public static let light = ShoplDesignGuideFontConvertible(name: "Pretendard-Light", family: "Pretendard", path: "Sources/ShoplDesignGuide/Resources/Font/Pretendard-Light.otf")
    public static let medium = ShoplDesignGuideFontConvertible(name: "Pretendard-Medium", family: "Pretendard", path: "Sources/ShoplDesignGuide/Resources/Font/Pretendard-Medium.otf")
    public static let regular = ShoplDesignGuideFontConvertible(name: "Pretendard-Regular", family: "Pretendard", path: "Sources/ShoplDesignGuide/Resources/Font/Pretendard-Regular.otf")
    public static let semiBold = ShoplDesignGuideFontConvertible(name: "Pretendard-SemiBold", family: "Pretendard", path: "Sources/ShoplDesignGuide/Resources/Font/Pretendard-SemiBold.otf")
    public static let thin = ShoplDesignGuideFontConvertible(name: "Pretendard-Thin", family: "Pretendard", path: "Sources/ShoplDesignGuide/Resources/Font/Pretendard-Thin.otf")
    public static let all: [ShoplDesignGuideFontConvertible] = [black,bold,extraBold,extraLight,light,medium,regular,semiBold,thin]
  }
  public enum PretendardJP: Sendable {
    public static let black = ShoplDesignGuideFontConvertible(name: "PretendardJP-Black", family: "Pretendard JP", path: "Sources/ShoplDesignGuide/Resources/Font/PretendardJP-Black.otf")
    public static let bold = ShoplDesignGuideFontConvertible(name: "PretendardJP-Bold", family: "Pretendard JP", path: "Sources/ShoplDesignGuide/Resources/Font/PretendardJP-Bold.otf")
    public static let extraBold = ShoplDesignGuideFontConvertible(name: "PretendardJP-ExtraBold", family: "Pretendard JP", path: "Sources/ShoplDesignGuide/Resources/Font/PretendardJP-ExtraBold.otf")
    public static let extraLight = ShoplDesignGuideFontConvertible(name: "PretendardJP-ExtraLight", family: "Pretendard JP", path: "Sources/ShoplDesignGuide/Resources/Font/PretendardJP-ExtraLight.otf")
    public static let light = ShoplDesignGuideFontConvertible(name: "PretendardJP-Light", family: "Pretendard JP", path: "Sources/ShoplDesignGuide/Resources/Font/PretendardJP-Light.otf")
    public static let medium = ShoplDesignGuideFontConvertible(name: "PretendardJP-Medium", family: "Pretendard JP", path: "Sources/ShoplDesignGuide/Resources/Font/PretendardJP-Medium.otf")
    public static let regular = ShoplDesignGuideFontConvertible(name: "PretendardJP-Regular", family: "Pretendard JP", path: "Sources/ShoplDesignGuide/Resources/Font/PretendardJP-Regular.otf")
    public static let semiBold = ShoplDesignGuideFontConvertible(name: "PretendardJP-SemiBold", family: "Pretendard JP", path: "Sources/ShoplDesignGuide/Resources/Font/PretendardJP-SemiBold.otf")
    public static let thin = ShoplDesignGuideFontConvertible(name: "PretendardJP-Thin", family: "Pretendard JP", path: "Sources/ShoplDesignGuide/Resources/Font/PretendardJP-Thin.otf")
    public static let all: [ShoplDesignGuideFontConvertible] = [black,bold,extraBold,extraLight,light,medium,regular,semiBold,thin]
  }
  public static let allCustomFonts: [ShoplDesignGuideFontConvertible] = [Pretendard.all,PretendardJP.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}

public struct ShoplDesignGuideFontConvertible: Sendable {
  public let name: String
  public let family: String
  public let path: String

  nonisolated(unsafe) private static var registeredFonts: Set<String> = []
  private static let registerLock = NSLock()

  #if os(macOS)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
  public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font {
    Self.register(font: self) // 사용 시점 자동 등록
    guard let font = Font(font: self, size: size) else {
      return Font.systemFont(ofSize: size)
    }
    return font
  }

  #if canImport(SwiftUI)
  public func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    Self.register(font: self) // 사용 시점 자동 등록
    guard let font = Font(font: self, size: size) else {
        return SwiftUI.Font.system(size: size)
    }
    return SwiftUI.Font(font)
  }
  #endif

  public func register() {
    Self.register(font: self)
  }

  private static func register(font: ShoplDesignGuideFontConvertible) {
    registerLock.lock()
    defer { registerLock.unlock() }
    
    if registeredFonts.contains(font.name) { return }
    registeredFonts.insert(font.name)
    
    guard let url = font.url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // Tuist가 생성해준 경로
    if let url = dsBundle.url(forResource: path, withExtension: nil) {
        return url
    }
    
    // Dynamic Framework는 빌드 시 리소스 폴더 구조를 없애고 루트에 파일을 모두 평탄화함
    let fileName = (path as NSString).lastPathComponent
    return dsBundle.url(forResource: fileName, withExtension: nil)
  }
}

public extension ShoplDesignGuideFontConvertible.Font {
  convenience init?(font: ShoplDesignGuideFontConvertible, size: CGFloat) {
    self.init(name: font.name, size: size)
  }
}
