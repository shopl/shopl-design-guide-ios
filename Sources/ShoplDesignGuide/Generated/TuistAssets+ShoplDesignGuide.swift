// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

import SwiftUI
import UIKit

// 번들 위치 찾기
private class DesignSystemBundleAnchor {}
private let dsBundle = Bundle(for: DesignSystemBundleAnchor.self)

// MARK: - 🖍️ Recursive Macros

// MARK: - 🧱 SDG Namespace

public enum SDG {
    
    // MARK: - Image Resource Struct
    public struct Image: Equatable {
        public let name: String
        public let bundle: Bundle
        
        public init(name: String, bundle: Bundle) {
            self.name = name
            self.bundle = bundle
        }
    }

    // MARK: - Color Resource Struct
    public struct Color: Equatable {
        public let name: String
        public let bundle: Bundle
        
        public init(name: String, bundle: Bundle) {
            self.name = name
            self.bundle = bundle
        }
    }
    
    public struct Font: Equatable {
        private init() { }
    }
}

// MARK: - Conversion Helpers

public extension SDG.Image {
    var image: SwiftUI.Image {
        SwiftUI.Image(sdg: self)
    }
    
    var uiImage: UIKit.UIImage {
        UIKit.UIImage(sdg: self)
    }
}

public extension SDG.Color {
    var color: SwiftUI.Color {
        SwiftUI.Color(self)
    }
    
    var uiColor: UIKit.UIColor {
        UIKit.UIColor(sdg: self)
    }
}


// MARK: - 🖼️ Image Extensions

public extension SDG.Image {
    static let adminBadge = SDG.Image(name: "admin_badge", bundle: dsBundle)
    static let avatarEmpty = SDG.Image(name: "avatar_empty", bundle: dsBundle)
    static let avatarEmptyDot = SDG.Image(name: "avatar_empty_dot", bundle: dsBundle)
    static let emptyMember = SDG.Image(name: "empty_member", bundle: dsBundle)
    static let icClip = SDG.Image(name: "ic_clip", bundle: dsBundle)
    static let icCommonCheckS = SDG.Image(name: "ic_common_check_s", bundle: dsBundle)
    static let icCommonCompany = SDG.Image(name: "ic_common_company", bundle: dsBundle)
    static let icCommonDistributor = SDG.Image(name: "ic_common_distributor", bundle: dsBundle)
    static let icCommonDropdown = SDG.Image(name: "ic_common_dropdown", bundle: dsBundle)
    static let icCommonEdit = SDG.Image(name: "ic_common_edit", bundle: dsBundle)
    static let icCommonList = SDG.Image(name: "ic_common_list", bundle: dsBundle)
    static let icCommonMail = SDG.Image(name: "ic_common_mail", bundle: dsBundle)
    static let icCommonMemo = SDG.Image(name: "ic_common_memo", bundle: dsBundle)
    static let icCommonNext = SDG.Image(name: "ic_common_next", bundle: dsBundle)
    static let icCommonNextS = SDG.Image(name: "ic_common_next_s", bundle: dsBundle)
    static let icCommonPlay = SDG.Image(name: "ic_common_play", bundle: dsBundle)
    static let icCommonPrev = SDG.Image(name: "ic_common_prev", bundle: dsBundle)
    static let icCommonRefresh = SDG.Image(name: "ic_common_refresh", bundle: dsBundle)
    static let icCommonRest = SDG.Image(name: "ic_common_rest", bundle: dsBundle)
    static let icCommonSearch = SDG.Image(name: "ic_common_search", bundle: dsBundle)
    static let icCommonTime = SDG.Image(name: "ic_common_time", bundle: dsBundle)
    static let icCommonWarning = SDG.Image(name: "ic_common_warning", bundle: dsBundle)
    static let icCommonX = SDG.Image(name: "ic_common_x", bundle: dsBundle)
    static let icCrownSolid = SDG.Image(name: "ic_crown_solid", bundle: dsBundle)
    static let icFire = SDG.Image(name: "ic_fire", bundle: dsBundle)
    static let icHide = SDG.Image(name: "ic_hide", bundle: dsBundle)
    static let icInputDelete = SDG.Image(name: "ic_input_delete", bundle: dsBundle)
    static let icMenuAttendance = SDG.Image(name: "ic_menu_attendance", bundle: dsBundle)
    static let icNaviBack = SDG.Image(name: "ic_navi_back", bundle: dsBundle)
    static let icNaviChat = SDG.Image(name: "ic_navi_chat", bundle: dsBundle)
    static let icNaviClose = SDG.Image(name: "ic_navi_close", bundle: dsBundle)
    static let icNaviFilter = SDG.Image(name: "ic_navi_filter", bundle: dsBundle)
    static let icNaviSearch = SDG.Image(name: "ic_navi_search", bundle: dsBundle)
    static let icRemoveM = SDG.Image(name: "ic_remove_m", bundle: dsBundle)
    static let icToolbarBack = SDG.Image(name: "ic_toolbar_back", bundle: dsBundle)
    static let icView = SDG.Image(name: "ic_view", bundle: dsBundle)
    static let icons = SDG.Image(name: "icons", bundle: dsBundle)
    static let leaderBadge = SDG.Image(name: "leader_badge", bundle: dsBundle)
    static let popupWarning = SDG.Image(name: "popup_warning", bundle: dsBundle)
    static let profileSmall = SDG.Image(name: "profile_small", bundle: dsBundle)
}

public extension SwiftUI.Image {
    /// 사용법: Image(sdg: .iconName)
    init(sdg resource: SDG.Image) {
        self.init(resource.name, bundle: resource.bundle)
    }
}

public extension UIImage {
    /// 사용법: UIImage(sdg: .iconName)
    convenience init(sdg resource: SDG.Image) {
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
    }
}


// MARK: - 🎨 Color Extensions

public extension SDG.Color {
    static let primary200 = SDG.Color(name: "Primary200", bundle: dsBundle)
    static let primary300 = SDG.Color(name: "Primary300", bundle: dsBundle)
    static let primary400 = SDG.Color(name: "Primary400", bundle: dsBundle)
    static let primary50 = SDG.Color(name: "Primary50", bundle: dsBundle)
    static let secondary200 = SDG.Color(name: "Secondary200", bundle: dsBundle)
    static let secondary300 = SDG.Color(name: "Secondary300", bundle: dsBundle)
    static let secondary400 = SDG.Color(name: "Secondary400", bundle: dsBundle)
    static let secondary50 = SDG.Color(name: "Secondary50", bundle: dsBundle)
    static let neutral0 = SDG.Color(name: "Neutral0", bundle: dsBundle)
    static let neutral100 = SDG.Color(name: "Neutral100", bundle: dsBundle)
    static let neutral150 = SDG.Color(name: "Neutral150", bundle: dsBundle)
    static let neutral200 = SDG.Color(name: "Neutral200", bundle: dsBundle)
    static let neutral250 = SDG.Color(name: "Neutral250", bundle: dsBundle)
    static let neutral300 = SDG.Color(name: "Neutral300", bundle: dsBundle)
    static let neutral350 = SDG.Color(name: "Neutral350", bundle: dsBundle)
    static let neutral400 = SDG.Color(name: "Neutral400", bundle: dsBundle)
    static let neutral50 = SDG.Color(name: "Neutral50", bundle: dsBundle)
    static let neutral500 = SDG.Color(name: "Neutral500", bundle: dsBundle)
    static let neutral600 = SDG.Color(name: "Neutral600", bundle: dsBundle)
    static let neutral700 = SDG.Color(name: "Neutral700", bundle: dsBundle)
    static let neutral900 = SDG.Color(name: "Neutral900", bundle: dsBundle)
    static let red300 = SDG.Color(name: "Red300", bundle: dsBundle)
    static let red350 = SDG.Color(name: "Red350", bundle: dsBundle)
    static let red400 = SDG.Color(name: "Red400", bundle: dsBundle)
    static let red50 = SDG.Color(name: "Red50", bundle: dsBundle)
    static let sdgGreen = SDG.Color(name: "SDGGreen", bundle: dsBundle)
    static let sdgPurple = SDG.Color(name: "SDGPurple", bundle: dsBundle)
    static let sdgYellow = SDG.Color(name: "SDGYellow", bundle: dsBundle)
    static let sdgLemon = SDG.Color(name: "SDGLemon", bundle: dsBundle)
    static let sdgOrange = SDG.Color(name: "SDGOrange", bundle: dsBundle)
    static let sdgSpecialPink = SDG.Color(name: "SDGSpecialPink", bundle: dsBundle)
}

public extension SwiftUI.Color {
    /// 내부 전용 생성자
    internal init(_ resource: SDG.Color) {
        self.init(resource.name, bundle: resource.bundle)
    }

    /// 사용법: Color.neutral100
    static let primary200 = SwiftUI.Color(SDG.Color.primary200)
    static let primary300 = SwiftUI.Color(SDG.Color.primary300)
    static let primary400 = SwiftUI.Color(SDG.Color.primary400)
    static let primary50 = SwiftUI.Color(SDG.Color.primary50)
    static let secondary200 = SwiftUI.Color(SDG.Color.secondary200)
    static let secondary300 = SwiftUI.Color(SDG.Color.secondary300)
    static let secondary400 = SwiftUI.Color(SDG.Color.secondary400)
    static let secondary50 = SwiftUI.Color(SDG.Color.secondary50)
    static let neutral0 = SwiftUI.Color(SDG.Color.neutral0)
    static let neutral100 = SwiftUI.Color(SDG.Color.neutral100)
    static let neutral150 = SwiftUI.Color(SDG.Color.neutral150)
    static let neutral200 = SwiftUI.Color(SDG.Color.neutral200)
    static let neutral250 = SwiftUI.Color(SDG.Color.neutral250)
    static let neutral300 = SwiftUI.Color(SDG.Color.neutral300)
    static let neutral350 = SwiftUI.Color(SDG.Color.neutral350)
    static let neutral400 = SwiftUI.Color(SDG.Color.neutral400)
    static let neutral50 = SwiftUI.Color(SDG.Color.neutral50)
    static let neutral500 = SwiftUI.Color(SDG.Color.neutral500)
    static let neutral600 = SwiftUI.Color(SDG.Color.neutral600)
    static let neutral700 = SwiftUI.Color(SDG.Color.neutral700)
    static let neutral900 = SwiftUI.Color(SDG.Color.neutral900)
    static let red300 = SwiftUI.Color(SDG.Color.red300)
    static let red350 = SwiftUI.Color(SDG.Color.red350)
    static let red400 = SwiftUI.Color(SDG.Color.red400)
    static let red50 = SwiftUI.Color(SDG.Color.red50)
    static let sdgGreen = SwiftUI.Color(SDG.Color.sdgGreen)
    static let sdgPurple = SwiftUI.Color(SDG.Color.sdgPurple)
    static let sdgYellow = SwiftUI.Color(SDG.Color.sdgYellow)
    static let sdgLemon = SwiftUI.Color(SDG.Color.sdgLemon)
    static let sdgOrange = SwiftUI.Color(SDG.Color.sdgOrange)
    static let sdgSpecialPink = SwiftUI.Color(SDG.Color.sdgSpecialPink)
}

public extension UIColor {
    /// 내부 전용 생성자
    internal convenience init(sdg resource: SDG.Color) {
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
    }

    /// 사용법: UIColor.neutral100
    static let primary200 = UIColor(sdg: SDG.Color.primary200)
    static let primary300 = UIColor(sdg: SDG.Color.primary300)
    static let primary400 = UIColor(sdg: SDG.Color.primary400)
    static let primary50 = UIColor(sdg: SDG.Color.primary50)
    static let secondary200 = UIColor(sdg: SDG.Color.secondary200)
    static let secondary300 = UIColor(sdg: SDG.Color.secondary300)
    static let secondary400 = UIColor(sdg: SDG.Color.secondary400)
    static let secondary50 = UIColor(sdg: SDG.Color.secondary50)
    static let neutral0 = UIColor(sdg: SDG.Color.neutral0)
    static let neutral100 = UIColor(sdg: SDG.Color.neutral100)
    static let neutral150 = UIColor(sdg: SDG.Color.neutral150)
    static let neutral200 = UIColor(sdg: SDG.Color.neutral200)
    static let neutral250 = UIColor(sdg: SDG.Color.neutral250)
    static let neutral300 = UIColor(sdg: SDG.Color.neutral300)
    static let neutral350 = UIColor(sdg: SDG.Color.neutral350)
    static let neutral400 = UIColor(sdg: SDG.Color.neutral400)
    static let neutral50 = UIColor(sdg: SDG.Color.neutral50)
    static let neutral500 = UIColor(sdg: SDG.Color.neutral500)
    static let neutral600 = UIColor(sdg: SDG.Color.neutral600)
    static let neutral700 = UIColor(sdg: SDG.Color.neutral700)
    static let neutral900 = UIColor(sdg: SDG.Color.neutral900)
    static let red300 = UIColor(sdg: SDG.Color.red300)
    static let red350 = UIColor(sdg: SDG.Color.red350)
    static let red400 = UIColor(sdg: SDG.Color.red400)
    static let red50 = UIColor(sdg: SDG.Color.red50)
    static let sdgGreen = UIColor(sdg: SDG.Color.sdgGreen)
    static let sdgPurple = UIColor(sdg: SDG.Color.sdgPurple)
    static let sdgYellow = UIColor(sdg: SDG.Color.sdgYellow)
    static let sdgLemon = UIColor(sdg: SDG.Color.sdgLemon)
    static let sdgOrange = UIColor(sdg: SDG.Color.sdgOrange)
    static let sdgSpecialPink = UIColor(sdg: SDG.Color.sdgSpecialPink)
}

// MARK: - ShapeStyle Extensions

public extension ShapeStyle where Self == SwiftUI.Color {
    /// 사용법: .background(.neutral100)
    static var primary200: SwiftUI.Color { SwiftUI.Color(SDG.Color.primary200) }
    static var primary300: SwiftUI.Color { SwiftUI.Color(SDG.Color.primary300) }
    static var primary400: SwiftUI.Color { SwiftUI.Color(SDG.Color.primary400) }
    static var primary50: SwiftUI.Color { SwiftUI.Color(SDG.Color.primary50) }
    static var secondary200: SwiftUI.Color { SwiftUI.Color(SDG.Color.secondary200) }
    static var secondary300: SwiftUI.Color { SwiftUI.Color(SDG.Color.secondary300) }
    static var secondary400: SwiftUI.Color { SwiftUI.Color(SDG.Color.secondary400) }
    static var secondary50: SwiftUI.Color { SwiftUI.Color(SDG.Color.secondary50) }
    static var neutral0: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral0) }
    static var neutral100: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral100) }
    static var neutral150: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral150) }
    static var neutral200: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral200) }
    static var neutral250: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral250) }
    static var neutral300: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral300) }
    static var neutral350: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral350) }
    static var neutral400: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral400) }
    static var neutral50: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral50) }
    static var neutral500: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral500) }
    static var neutral600: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral600) }
    static var neutral700: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral700) }
    static var neutral900: SwiftUI.Color { SwiftUI.Color(SDG.Color.neutral900) }
    static var red300: SwiftUI.Color { SwiftUI.Color(SDG.Color.red300) }
    static var red350: SwiftUI.Color { SwiftUI.Color(SDG.Color.red350) }
    static var red400: SwiftUI.Color { SwiftUI.Color(SDG.Color.red400) }
    static var red50: SwiftUI.Color { SwiftUI.Color(SDG.Color.red50) }
    static var sdgGreen: SwiftUI.Color { SwiftUI.Color(SDG.Color.sdgGreen) }
    static var sdgPurple: SwiftUI.Color { SwiftUI.Color(SDG.Color.sdgPurple) }
    static var sdgYellow: SwiftUI.Color { SwiftUI.Color(SDG.Color.sdgYellow) }
    static var sdgLemon: SwiftUI.Color { SwiftUI.Color(SDG.Color.sdgLemon) }
    static var sdgOrange: SwiftUI.Color { SwiftUI.Color(SDG.Color.sdgOrange) }
    static var sdgSpecialPink: SwiftUI.Color { SwiftUI.Color(SDG.Color.sdgSpecialPink) }
}

