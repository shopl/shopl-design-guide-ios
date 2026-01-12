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

// MARK: - 🖼️ Image Resources

public struct SDGImageResource: Sendable {
    public let name: String
    public let bundle: Bundle
    
    public init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }
}

public extension SDGImageResource {
    static let adminBadge = SDGImageResource(name: "admin_badge", bundle: dsBundle)
    static let avatarEmpty = SDGImageResource(name: "avatar_empty", bundle: dsBundle)
    static let avatarEmptyDot = SDGImageResource(name: "avatar_empty_dot", bundle: dsBundle)
    static let emptyMember = SDGImageResource(name: "empty_member", bundle: dsBundle)
    static let icClip = SDGImageResource(name: "ic_clip", bundle: dsBundle)
    static let icCommonCheckS = SDGImageResource(name: "ic_common_check_s", bundle: dsBundle)
    static let icCommonCompany = SDGImageResource(name: "ic_common_company", bundle: dsBundle)
    static let icCommonDistributor = SDGImageResource(name: "ic_common_distributor", bundle: dsBundle)
    static let icCommonDropdown = SDGImageResource(name: "ic_common_dropdown", bundle: dsBundle)
    static let icCommonEdit = SDGImageResource(name: "ic_common_edit", bundle: dsBundle)
    static let icCommonList = SDGImageResource(name: "ic_common_list", bundle: dsBundle)
    static let icCommonMail = SDGImageResource(name: "ic_common_mail", bundle: dsBundle)
    static let icCommonMemo = SDGImageResource(name: "ic_common_memo", bundle: dsBundle)
    static let icCommonNext = SDGImageResource(name: "ic_common_next", bundle: dsBundle)
    static let icCommonNextS = SDGImageResource(name: "ic_common_next_s", bundle: dsBundle)
    static let icCommonPlay = SDGImageResource(name: "ic_common_play", bundle: dsBundle)
    static let icCommonPrev = SDGImageResource(name: "ic_common_prev", bundle: dsBundle)
    static let icCommonRefresh = SDGImageResource(name: "ic_common_refresh", bundle: dsBundle)
    static let icCommonRest = SDGImageResource(name: "ic_common_rest", bundle: dsBundle)
    static let icCommonSearch = SDGImageResource(name: "ic_common_search", bundle: dsBundle)
    static let icCommonTime = SDGImageResource(name: "ic_common_time", bundle: dsBundle)
    static let icCommonWarning = SDGImageResource(name: "ic_common_warning", bundle: dsBundle)
    static let icCommonX = SDGImageResource(name: "ic_common_x", bundle: dsBundle)
    static let icHide = SDGImageResource(name: "ic_hide", bundle: dsBundle)
    static let icInputDelete = SDGImageResource(name: "ic_input_delete", bundle: dsBundle)
    static let icMenuAttendance = SDGImageResource(name: "ic_menu_attendance", bundle: dsBundle)
    static let icNaviBack = SDGImageResource(name: "ic_navi_back", bundle: dsBundle)
    static let icNaviChat = SDGImageResource(name: "ic_navi_chat", bundle: dsBundle)
    static let icNaviClose = SDGImageResource(name: "ic_navi_close", bundle: dsBundle)
    static let icNaviFilter = SDGImageResource(name: "ic_navi_filter", bundle: dsBundle)
    static let icNaviSearch = SDGImageResource(name: "ic_navi_search", bundle: dsBundle)
    static let icRemoveM = SDGImageResource(name: "ic_remove_m", bundle: dsBundle)
    static let icToolbarBack = SDGImageResource(name: "ic_toolbar_back", bundle: dsBundle)
    static let icView = SDGImageResource(name: "ic_view", bundle: dsBundle)
    static let icons = SDGImageResource(name: "icons", bundle: dsBundle)
    static let leaderBadge = SDGImageResource(name: "leader_badge", bundle: dsBundle)
    static let popupWarning = SDGImageResource(name: "popup_warning", bundle: dsBundle)
    static let profileSmall = SDGImageResource(name: "profile_small", bundle: dsBundle)
}

public extension Image {
    /// 사용법: Image(.icNaviBack)
    init(_ resource: SDGImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

    /// 사용법: Image.icNaviBack
    static let adminBadge = Image(.adminBadge)
    static let avatarEmpty = Image(.avatarEmpty)
    static let avatarEmptyDot = Image(.avatarEmptyDot)
    static let emptyMember = Image(.emptyMember)
    static let icClip = Image(.icClip)
    static let icCommonCheckS = Image(.icCommonCheckS)
    static let icCommonCompany = Image(.icCommonCompany)
    static let icCommonDistributor = Image(.icCommonDistributor)
    static let icCommonDropdown = Image(.icCommonDropdown)
    static let icCommonEdit = Image(.icCommonEdit)
    static let icCommonList = Image(.icCommonList)
    static let icCommonMail = Image(.icCommonMail)
    static let icCommonMemo = Image(.icCommonMemo)
    static let icCommonNext = Image(.icCommonNext)
    static let icCommonNextS = Image(.icCommonNextS)
    static let icCommonPlay = Image(.icCommonPlay)
    static let icCommonPrev = Image(.icCommonPrev)
    static let icCommonRefresh = Image(.icCommonRefresh)
    static let icCommonRest = Image(.icCommonRest)
    static let icCommonSearch = Image(.icCommonSearch)
    static let icCommonTime = Image(.icCommonTime)
    static let icCommonWarning = Image(.icCommonWarning)
    static let icCommonX = Image(.icCommonX)
    static let icHide = Image(.icHide)
    static let icInputDelete = Image(.icInputDelete)
    static let icMenuAttendance = Image(.icMenuAttendance)
    static let icNaviBack = Image(.icNaviBack)
    static let icNaviChat = Image(.icNaviChat)
    static let icNaviClose = Image(.icNaviClose)
    static let icNaviFilter = Image(.icNaviFilter)
    static let icNaviSearch = Image(.icNaviSearch)
    static let icRemoveM = Image(.icRemoveM)
    static let icToolbarBack = Image(.icToolbarBack)
    static let icView = Image(.icView)
    static let icons = Image(.icons)
    static let leaderBadge = Image(.leaderBadge)
    static let popupWarning = Image(.popupWarning)
    static let profileSmall = Image(.profileSmall)
}

public extension UIImage {
    /// 사용법: UIImage(resource: .icNaviBack)
    convenience init?(resource: SDGImageResource) {
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)
    }

    /// 사용법: UIImage.icNaviBack (Return Type: UIImage?)
    static let adminBadge = UIImage(resource: .adminBadge)
    static let avatarEmpty = UIImage(resource: .avatarEmpty)
    static let avatarEmptyDot = UIImage(resource: .avatarEmptyDot)
    static let emptyMember = UIImage(resource: .emptyMember)
    static let icClip = UIImage(resource: .icClip)
    static let icCommonCheckS = UIImage(resource: .icCommonCheckS)
    static let icCommonCompany = UIImage(resource: .icCommonCompany)
    static let icCommonDistributor = UIImage(resource: .icCommonDistributor)
    static let icCommonDropdown = UIImage(resource: .icCommonDropdown)
    static let icCommonEdit = UIImage(resource: .icCommonEdit)
    static let icCommonList = UIImage(resource: .icCommonList)
    static let icCommonMail = UIImage(resource: .icCommonMail)
    static let icCommonMemo = UIImage(resource: .icCommonMemo)
    static let icCommonNext = UIImage(resource: .icCommonNext)
    static let icCommonNextS = UIImage(resource: .icCommonNextS)
    static let icCommonPlay = UIImage(resource: .icCommonPlay)
    static let icCommonPrev = UIImage(resource: .icCommonPrev)
    static let icCommonRefresh = UIImage(resource: .icCommonRefresh)
    static let icCommonRest = UIImage(resource: .icCommonRest)
    static let icCommonSearch = UIImage(resource: .icCommonSearch)
    static let icCommonTime = UIImage(resource: .icCommonTime)
    static let icCommonWarning = UIImage(resource: .icCommonWarning)
    static let icCommonX = UIImage(resource: .icCommonX)
    static let icHide = UIImage(resource: .icHide)
    static let icInputDelete = UIImage(resource: .icInputDelete)
    static let icMenuAttendance = UIImage(resource: .icMenuAttendance)
    static let icNaviBack = UIImage(resource: .icNaviBack)
    static let icNaviChat = UIImage(resource: .icNaviChat)
    static let icNaviClose = UIImage(resource: .icNaviClose)
    static let icNaviFilter = UIImage(resource: .icNaviFilter)
    static let icNaviSearch = UIImage(resource: .icNaviSearch)
    static let icRemoveM = UIImage(resource: .icRemoveM)
    static let icToolbarBack = UIImage(resource: .icToolbarBack)
    static let icView = UIImage(resource: .icView)
    static let icons = UIImage(resource: .icons)
    static let leaderBadge = UIImage(resource: .leaderBadge)
    static let popupWarning = UIImage(resource: .popupWarning)
    static let profileSmall = UIImage(resource: .profileSmall)
}


// MARK: - 🎨 Color Resources

public struct SDGColorResource: Sendable {
    public let name: String
    public let bundle: Bundle
    
    public init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }
}

public extension SDGColorResource {
    static let primary200 = SDGColorResource(name: "Primary200", bundle: dsBundle)
    static let primary300 = SDGColorResource(name: "Primary300", bundle: dsBundle)
    static let primary400 = SDGColorResource(name: "Primary400", bundle: dsBundle)
    static let primary50 = SDGColorResource(name: "Primary50", bundle: dsBundle)
    static let secondary200 = SDGColorResource(name: "Secondary200", bundle: dsBundle)
    static let secondary300 = SDGColorResource(name: "Secondary300", bundle: dsBundle)
    static let secondary400 = SDGColorResource(name: "Secondary400", bundle: dsBundle)
    static let secondary50 = SDGColorResource(name: "Secondary50", bundle: dsBundle)
    static let neutral0 = SDGColorResource(name: "Neutral0", bundle: dsBundle)
    static let neutral100 = SDGColorResource(name: "Neutral100", bundle: dsBundle)
    static let neutral150 = SDGColorResource(name: "Neutral150", bundle: dsBundle)
    static let neutral200 = SDGColorResource(name: "Neutral200", bundle: dsBundle)
    static let neutral250 = SDGColorResource(name: "Neutral250", bundle: dsBundle)
    static let neutral300 = SDGColorResource(name: "Neutral300", bundle: dsBundle)
    static let neutral350 = SDGColorResource(name: "Neutral350", bundle: dsBundle)
    static let neutral400 = SDGColorResource(name: "Neutral400", bundle: dsBundle)
    static let neutral50 = SDGColorResource(name: "Neutral50", bundle: dsBundle)
    static let neutral500 = SDGColorResource(name: "Neutral500", bundle: dsBundle)
    static let neutral600 = SDGColorResource(name: "Neutral600", bundle: dsBundle)
    static let neutral700 = SDGColorResource(name: "Neutral700", bundle: dsBundle)
    static let neutral900 = SDGColorResource(name: "Neutral900", bundle: dsBundle)
    static let red300 = SDGColorResource(name: "Red300", bundle: dsBundle)
    static let red350 = SDGColorResource(name: "Red350", bundle: dsBundle)
    static let red400 = SDGColorResource(name: "Red400", bundle: dsBundle)
    static let red50 = SDGColorResource(name: "Red50", bundle: dsBundle)
    static let sdgGreen = SDGColorResource(name: "SDGGreen", bundle: dsBundle)
    static let sdgPurple = SDGColorResource(name: "SDGPurple", bundle: dsBundle)
    static let sdgYellow = SDGColorResource(name: "SDGYellow", bundle: dsBundle)
    static let sdgLemon = SDGColorResource(name: "SDGLemon", bundle: dsBundle)
    static let sdgOrange = SDGColorResource(name: "SDGOrange", bundle: dsBundle)
    static let sdgSpecialPink = SDGColorResource(name: "SDGSpecialPink", bundle: dsBundle)
}

public extension Color {
    /// 사용법: Color(.brandBlue)
    init(_ resource: SDGColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

    /// 사용법: Color.brandBlue
    static let primary200 = Color(.primary200)
    static let primary300 = Color(.primary300)
    static let primary400 = Color(.primary400)
    static let primary50 = Color(.primary50)
    static let secondary200 = Color(.secondary200)
    static let secondary300 = Color(.secondary300)
    static let secondary400 = Color(.secondary400)
    static let secondary50 = Color(.secondary50)
    static let neutral0 = Color(.neutral0)
    static let neutral100 = Color(.neutral100)
    static let neutral150 = Color(.neutral150)
    static let neutral200 = Color(.neutral200)
    static let neutral250 = Color(.neutral250)
    static let neutral300 = Color(.neutral300)
    static let neutral350 = Color(.neutral350)
    static let neutral400 = Color(.neutral400)
    static let neutral50 = Color(.neutral50)
    static let neutral500 = Color(.neutral500)
    static let neutral600 = Color(.neutral600)
    static let neutral700 = Color(.neutral700)
    static let neutral900 = Color(.neutral900)
    static let red300 = Color(.red300)
    static let red350 = Color(.red350)
    static let red400 = Color(.red400)
    static let red50 = Color(.red50)
    static let sdgGreen = Color(.sdgGreen)
    static let sdgPurple = Color(.sdgPurple)
    static let sdgYellow = Color(.sdgYellow)
    static let sdgLemon = Color(.sdgLemon)
    static let sdgOrange = Color(.sdgOrange)
    static let sdgSpecialPink = Color(.sdgSpecialPink)
}

public extension UIColor {
    /// 사용법: UIColor(resource: .brandBlue)
    convenience init?(resource: SDGColorResource) {
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)
    }

    /// 사용법: UIColor.brandBlue
    static let primary200 = UIColor(Color.primary200)
    static let primary300 = UIColor(Color.primary300)
    static let primary400 = UIColor(Color.primary400)
    static let primary50 = UIColor(Color.primary50)
    static let secondary200 = UIColor(Color.secondary200)
    static let secondary300 = UIColor(Color.secondary300)
    static let secondary400 = UIColor(Color.secondary400)
    static let secondary50 = UIColor(Color.secondary50)
    static let neutral0 = UIColor(Color.neutral0)
    static let neutral100 = UIColor(Color.neutral100)
    static let neutral150 = UIColor(Color.neutral150)
    static let neutral200 = UIColor(Color.neutral200)
    static let neutral250 = UIColor(Color.neutral250)
    static let neutral300 = UIColor(Color.neutral300)
    static let neutral350 = UIColor(Color.neutral350)
    static let neutral400 = UIColor(Color.neutral400)
    static let neutral50 = UIColor(Color.neutral50)
    static let neutral500 = UIColor(Color.neutral500)
    static let neutral600 = UIColor(Color.neutral600)
    static let neutral700 = UIColor(Color.neutral700)
    static let neutral900 = UIColor(Color.neutral900)
    static let red300 = UIColor(Color.red300)
    static let red350 = UIColor(Color.red350)
    static let red400 = UIColor(Color.red400)
    static let red50 = UIColor(Color.red50)
    static let sdgGreen = UIColor(Color.sdgGreen)
    static let sdgPurple = UIColor(Color.sdgPurple)
    static let sdgYellow = UIColor(Color.sdgYellow)
    static let sdgLemon = UIColor(Color.sdgLemon)
    static let sdgOrange = UIColor(Color.sdgOrange)
    static let sdgSpecialPink = UIColor(Color.sdgSpecialPink)
}

// MARK: - ShapeStyle Extensions

public extension ShapeStyle where Self == Color {
    /// 사용법: .background(.brandBlue)
    static var primary200: Color { Color(.primary200) }
    static var primary300: Color { Color(.primary300) }
    static var primary400: Color { Color(.primary400) }
    static var primary50: Color { Color(.primary50) }
    static var secondary200: Color { Color(.secondary200) }
    static var secondary300: Color { Color(.secondary300) }
    static var secondary400: Color { Color(.secondary400) }
    static var secondary50: Color { Color(.secondary50) }
    static var neutral0: Color { Color(.neutral0) }
    static var neutral100: Color { Color(.neutral100) }
    static var neutral150: Color { Color(.neutral150) }
    static var neutral200: Color { Color(.neutral200) }
    static var neutral250: Color { Color(.neutral250) }
    static var neutral300: Color { Color(.neutral300) }
    static var neutral350: Color { Color(.neutral350) }
    static var neutral400: Color { Color(.neutral400) }
    static var neutral50: Color { Color(.neutral50) }
    static var neutral500: Color { Color(.neutral500) }
    static var neutral600: Color { Color(.neutral600) }
    static var neutral700: Color { Color(.neutral700) }
    static var neutral900: Color { Color(.neutral900) }
    static var red300: Color { Color(.red300) }
    static var red350: Color { Color(.red350) }
    static var red400: Color { Color(.red400) }
    static var red50: Color { Color(.red50) }
    static var sdgGreen: Color { Color(.sdgGreen) }
    static var sdgPurple: Color { Color(.sdgPurple) }
    static var sdgYellow: Color { Color(.sdgYellow) }
    static var sdgLemon: Color { Color(.sdgLemon) }
    static var sdgOrange: Color { Color(.sdgOrange) }
    static var sdgSpecialPink: Color { Color(.sdgSpecialPink) }
}

