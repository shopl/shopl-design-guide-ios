//
//  SDGCatalog.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/22/26.
//

import Foundation

struct SDGCatalogSection: Identifiable, Hashable {
  let id: String
  let title: String
  let description: String
  let items: [SDGCatalogItem]
}

struct SDGCatalogItem: Identifiable, Hashable {
  let id: String
  let title: String
  let description: String?
  let subDescription: String?
  let viewID: String?
  let implementationNames: [String]
  let children: [SDGCatalogItem]
  
  init(
    id: String,
    title: String,
    description: String? = nil,
    subDescription: String? = nil,
    viewID: String? = nil,
    implementationNames: [String] = [],
    children: [SDGCatalogItem] = []
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.subDescription = subDescription
    self.viewID = viewID
    self.implementationNames = implementationNames
    self.children = children
  }
  
  var allImplementationNames: [String] {
    implementationNames + children.flatMap(\.allImplementationNames)
  }
}

protocol SDGCatalogRepository {
  func catalogSections() -> [SDGCatalogSection]
  func overviewSections() -> [SDGCatalogSection]
}

extension SDGCatalogRepository {
  func catalogItem(id: String) -> SDGCatalogItem? {
    for section in catalogSections() {
      if let item = section.items.catalogItem(id: id) {
        return item
      }
    }
    
    return nil
  }
}

private extension Array where Element == SDGCatalogItem {
  func catalogItem(id: String) -> SDGCatalogItem? {
    for item in self {
      if item.id == id {
        return item
      }
      
      if let childItem = item.children.catalogItem(id: id) {
        return childItem
      }
    }
    
    return nil
  }
}

struct DefaultSDGCatalogRepository: SDGCatalogRepository {
  func catalogSections() -> [SDGCatalogSection] {
    SDGCatalogSectionKind.allCases.map(\.catalogSection)
  }
  
  func overviewSections() -> [SDGCatalogSection] {
    catalogSections()
  }
}

protocol SDGCatalogItemRepresentable: CaseIterable {
  var id: String { get }
  var title: String { get }
  var catalogDescription: String? { get }
  var catalogSubDescription: String? { get }
  var viewID: String? { get }
  var implementationNames: [String] { get }
  var children: [SDGCatalogItem] { get }
}

extension SDGCatalogItemRepresentable {
  var catalogDescription: String? { nil }
  var catalogSubDescription: String? { nil }
  var viewID: String? { nil }
  var children: [SDGCatalogItem] { [] }
  
  var catalogItem: SDGCatalogItem {
    SDGCatalogItem(
      id: id,
      title: title,
      description: catalogDescription,
      subDescription: catalogSubDescription,
      viewID: viewID,
      implementationNames: implementationNames,
      children: children
    )
  }
}

extension SDGCatalogItemRepresentable where AllCases: Collection, AllCases.Element == Self {
  static var catalogItems: [SDGCatalogItem] {
    allCases.map(\.catalogItem)
  }
}

enum SDGCatalogSectionKind: String, CaseIterable {
  case foundation
  case component
  case template
  
  var catalogSection: SDGCatalogSection {
    switch self {
    case .foundation:
      return SDGCatalogSection(
        id: rawValue,
        title: "Foundation",
        description: "일관된 레이아웃과 그에 따른 사용자 경험을 만드는 데 필수적인 시각적 요소입니다.",
        items: SDGFoundationCatalog.catalogItems
      )
    case .component:
      return SDGCatalogSection(
        id: rawValue,
        title: "Component",
        description: "각각의 기능을 구성하는 요소들의 조합입니다.",
        items: SDGComponentCatalog.catalogItems
      )
    case .template:
      return SDGCatalogSection(
        id: rawValue,
        title: "Template",
        description: "컴포넌트를 포함한 요소들의 조합입니다.",
        items: SDGTemplateCatalog.catalogItems
      )
    }
  }
}

enum SDGFoundationCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case color
  case cornerRadius
  case iconography
  case spacing
  case typography
  
  var id: String {
    switch self {
    case .color: return "foundation_color"
    case .cornerRadius: return "foundation_corner_radius"
    case .iconography: return "foundation_iconography"
    case .spacing: return "foundation_spacing"
    case .typography: return "foundation_typography"
    }
  }
  
  var title: String {
    switch self {
    case .color: return "Color"
    case .cornerRadius: return "Corner Radius"
    case .iconography: return "Iconography"
    case .spacing: return "Spacing"
    case .typography: return "Typography"
    }
  }
  
  var catalogDescription: String? {
    switch self {
    case .color:
      return "SDG의 컬러 팔레트"
    case .typography:
      return "SDG의 폰트 스타일"
    case .iconography:
      return "SDG의 아이콘 스타일"
    case .spacing:
      return "SDG의 여백 스타일"
    case .cornerRadius:
      return nil
    }
  }
  
  var catalogSubDescription: String? {
    switch self {
    case .color:
      return "샤플 앱의 모든 요소에 적용되며, 일관된/뚜렷한/계층적인 컬러 사용으로 서비스의 아이덴티티 및 브랜드 경험을 만들어 줄 수 있는 주요 요소"
    case .iconography:
      return "기호로 만든 시각 언어로 한정된 공간에서 정보를 효율적으로 전달하는 요소"
    case .typography:
      return "정의된 서체, 크기, 색상을 통해 콘텐츠 중요도 및 전체 텍스트의 균형을 조정하여 서비스와 사용자의 커뮤니케이션을 돕는 주요 요소"
    case .spacing:
      return "컴포넌트 및 템플릿, 그리고 모든 화면과 구성 요소 사이의 여백"
    case .cornerRadius:
      return nil
    }
  }
  
  var viewID: String? {
    switch self {
    case .color: return "foundation_color"
    case .iconography: return "foundation_iconography"
    case .spacing: return "foundation_spacing"
    case .typography: return "foundation_typo"
    case .cornerRadius:
      return nil
    }
  }
  
  var implementationNames: [String] {
    switch self {
    case .color: return ["SDG.Color", "Color"]
    case .cornerRadius: return ["SDGCornerRadius"]
    case .iconography: return ["SDG.Image", "Image"]
    case .spacing: return ["SDGSpacing"]
    case .typography: return ["SDG.Typography", "Typography"]
    }
  }
}

enum SDGComponentCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case avatar
  case attachmentElement
  case badge
  case button
  case calendar
  case checkbox
  case checkOption
  case dropdown
  case emptyIcon
  case filterChip
  case indicator
  case iconLabel
  case listHeaderLabel
  case navigation
  case numberPicker
  case progress
  case radio
  case searchBar
  case segment
  case selectInput
  case tab
  case textInput
  case thumbnails
  case timePicker
  case timeSelectInput
  case toggle
  case tooltip
  
  var id: String {
    switch self {
    case .avatar: return "component_avatar"
    case .attachmentElement: return "component_attachment_element"
    case .badge: return "component_badge"
    case .button: return "component_button"
    case .calendar: return "component_calendar"
    case .checkbox: return "component_checkbox"
    case .checkOption: return "component_check_option"
    case .dropdown: return "component_dropdown"
    case .emptyIcon: return "component_empty_icon"
    case .filterChip: return "component_filter_chip"
    case .indicator: return "component_indicator"
    case .iconLabel: return "component_icon_label"
    case .listHeaderLabel: return "component_list_header_label"
    case .navigation: return "component_navigation"
    case .numberPicker: return "component_number_picker"
    case .progress: return "component_progress"
    case .radio: return "component_radio"
    case .searchBar: return "component_search_bar"
    case .segment: return "component_segment"
    case .selectInput: return "component_select_input"
    case .tab: return "component_tab"
    case .textInput: return "component_text_input"
    case .thumbnails: return "component_thumbnails"
    case .timePicker: return "component_time_picker"
    case .timeSelectInput: return "component_time_select_input"
    case .toggle: return "component_toggle"
    case .tooltip: return "component_tooltip"
    }
  }
  
  var title: String {
    switch self {
    case .avatar: return "Avatar"
    case .attachmentElement: return "Attachment Element"
    case .badge: return "Badge"
    case .button: return "Button"
    case .calendar: return "Calendar"
    case .checkbox: return "Check Box"
    case .checkOption: return "Check Option"
    case .dropdown: return "Dropdown"
    case .emptyIcon: return "Empty Icon"
    case .filterChip: return "Filter Chip"
    case .indicator: return "Indicator"
    case .iconLabel: return "Icon Label"
    case .listHeaderLabel: return "List Header label"
    case .navigation: return "Navigation"
    case .numberPicker: return "Number Picker"
    case .progress: return "Progress"
    case .radio: return "Radio"
    case .searchBar: return "Search Bar"
    case .segment: return "Segment"
    case .selectInput: return "Select Input"
    case .tab: return "Tab"
    case .textInput: return "Text Input"
    case .thumbnails: return "Thumbnails"
    case .timePicker: return "Time Picker"
    case .timeSelectInput: return "Time Select Input"
    case .toggle: return "Toggle"
    case .tooltip: return "Tooltip"
    }
  }

  var catalogSubDescription: String? {
    switch self {
    case .avatar:
      return "직원의 얼굴 사진 또는 설정된 이미지를 보여주는 컴포넌트"
    case .attachmentElement:
      return "사진, 문서, 동영상을 표시하는 컴포넌트"
    case .checkbox:
      return "여러개의 옵션 중 다중 선택을 위한 컴포넌트"
    case .checkOption:
      return "하나의 옵션을 선택 또는 확인하는 컴포넌트"
    case .dropdown:
      return "여러 개의 리스트 옵션 중 하나의 옵션을 선택하기 위한 컴포넌트"
    case .numberPicker:
      return "어떤 특정한 값의 숫자를 스피너로 선택하는 컴포넌트"
    case .radio:
      return "여러개의 옵션 중 단일 선택을 위한 컴포넌트"
    case .toggle:
      return "항목의 활성 또는 비활성 상태를 결정하는 컴포넌트"
    default:
      return nil
    }
  }

  var viewID: String? {
    switch self {
    case .avatar, .attachmentElement, .checkbox, .checkOption, .dropdown, .numberPicker, .radio, .toggle:
      return id
    default:
      return nil
    }
  }
  
  var implementationNames: [String] {
    switch self {
    case .avatar: return ["SDGAvatar"]
    case .attachmentElement: return ["SDGAttachmentElement"]
    case .badge: return SDGBadgeCatalog.allCases.flatMap(\.implementationNames)
    case .button: return SDGButtonCatalog.allCases.flatMap(\.implementationNames)
    case .calendar: return ["SDGCalendar"]
    case .checkbox: return ["SDGCheckBox"]
    case .checkOption: return ["SDGCheckOption"]
    case .dropdown: return ["SDGDropdown"]
    case .emptyIcon: return SDGEmptyIconCatalog.allCases.flatMap(\.implementationNames)
    case .filterChip: return SDGFilterChipCatalog.allCases.flatMap(\.implementationNames)
    case .indicator: return SDGIndicatorCatalog.allCases.flatMap(\.implementationNames)
    case .iconLabel: return ["SDGIconLabel"]
    case .listHeaderLabel: return ["SDGListHeaderLabel"]
    case .navigation: return SDGNavigationCatalog.allCases.flatMap(\.implementationNames)
    case .numberPicker: return ["SDGNumberPicker"]
    case .progress: return SDGProgressCatalog.allCases.flatMap(\.implementationNames)
    case .radio: return ["SDGRadio"]
    case .searchBar: return SDGSearchBarCatalog.allCases.flatMap(\.implementationNames)
    case .segment: return ["SDGSegment"]
    case .selectInput: return ["SDGSelectInput"]
    case .tab: return SDGTabCatalog.allCases.flatMap(\.implementationNames)
    case .textInput: return SDGTextInputCatalog.allCases.flatMap(\.implementationNames)
    case .thumbnails: return ["SDGThumbnails"]
    case .timePicker: return ["SDGTimePicker"]
    case .timeSelectInput: return ["SDGTimeSelectInput"]
    case .toggle: return ["SDGToggle"]
    case .tooltip: return ["SDGTooltipSpec", "SDGTooltipDirection", "View.tooltip"]
    }
  }
  
  var children: [SDGCatalogItem] {
    switch self {
    case .badge:
      return SDGBadgeCatalog.catalogItems
    case .button:
      return SDGButtonCatalog.catalogItems
    case .emptyIcon:
      return SDGEmptyIconCatalog.catalogItems
    case .filterChip:
      return SDGFilterChipCatalog.catalogItems
    case .indicator:
      return SDGIndicatorCatalog.catalogItems
    case .navigation:
      return SDGNavigationCatalog.catalogItems
    case .progress:
      return SDGProgressCatalog.catalogItems
    case .searchBar:
      return SDGSearchBarCatalog.catalogItems
    case .tab:
      return SDGTabCatalog.catalogItems
    case .textInput:
      return SDGTextInputCatalog.catalogItems
    default:
      return []
    }
  }
}

enum SDGBadgeCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case box
  case capsule
  
  var id: String {
    switch self {
    case .box: return "component_box_badge"
    case .capsule: return "component_capsule_badge"
    }
  }
  
  var title: String {
    switch self {
    case .box: return "Box Badge"
    case .capsule: return "Capsule Badge"
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .box: return ["SDGBoxBadge"]
    case .capsule: return ["SDGCapsuleBadge"]
    }
  }
}

enum SDGButtonCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case bottom
  case box
  case capsule
  case floating
  case ghost
  
  var id: String {
    switch self {
    case .bottom: return "component_bottom_button"
    case .box: return "component_box_button"
    case .capsule: return "component_capsule_button"
    case .floating: return "component_floating_button"
    case .ghost: return "component_ghost_button"
    }
  }
  
  var title: String {
    switch self {
    case .bottom: return "Bottom Button"
    case .box: return "Box Button"
    case .capsule: return "Capsule Button"
    case .floating: return "Floating Button"
    case .ghost: return "Ghost Button"
    }
  }
  
  var catalogSubDescription: String? {
    switch self {
    case .bottom:
      return "화면 하단에 고정으로 위치한 버튼 컴포넌트"
    case .box:
      return "화면 내에 배치하여 사용하는 일반적인 사각 형태의 버튼 컴포넌트"
    case .floating:
      return "화면 우측 하단에 고정으로 위치하며, 생성&추가 등의 동작을 위한 버튼 컴포넌트"
    case .ghost:
      return "화면의 내용 영역에 배치하여 사용하는 배경이 없는 형태의 버튼 컴포넌트"
    default:
      return nil
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .bottom: return ["SDGBottomButton"]
    case .box: return ["SDGBoxButton"]
    case .capsule: return ["SDGCapsuleButton"]
    case .floating: return ["SDGFloatingButton"]
    case .ghost: return ["SDGGhostButton"]
    }
  }
}

enum SDGEmptyIconCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case basic
  case contents
  
  var id: String {
    switch self {
    case .basic: return "component_basic_empty_icon"
    case .contents: return "component_contents_empty_icon"
    }
  }
  
  var title: String {
    switch self {
    case .basic: return "Basic Empty Icon"
    case .contents: return "Contents Empty Icon"
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .basic: return ["SDGBasicEmptyIcon"]
    case .contents: return ["SDGContentsEmptyIcon"]
    }
  }
}

enum SDGFilterChipCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case body
  case navi
  
  var id: String {
    switch self {
    case .body: return "component_body_filter_chip"
    case .navi: return "component_navi_filter_chip"
    }
  }
  
  var title: String {
    switch self {
    case .body: return "Body Filter Chip"
    case .navi: return "Navi Filter Chip"
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .body: return ["SDGBodyFilterChip"]
    case .navi: return ["SDGNaviFilterChip"]
    }
  }
}

enum SDGIndicatorCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case dot
  case number
  case text
  
  var id: String {
    switch self {
    case .dot: return "component_dot_indicator"
    case .number: return "component_number_indicator"
    case .text: return "component_text_indicator"
    }
  }
  
  var title: String {
    switch self {
    case .dot: return "Dot Indicator"
    case .number: return "Number Indicator"
    case .text: return "Text Indicator"
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .dot: return ["SDGDotIndicator"]
    case .number: return ["SDGNumberIndicator"]
    case .text: return ["SDGTextIndicator"]
    }
  }
}

enum SDGNavigationCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case basic
  case category
  case text
  
  var id: String {
    switch self {
    case .basic: return "component_basic_navigation"
    case .category: return "component_category_navigation"
    case .text: return "component_text_navigation"
    }
  }
  
  var title: String {
    switch self {
    case .basic: return "Basic Navigation"
    case .category: return "Category Navigation"
    case .text: return "Text Navigation"
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .basic: return ["SDGBasicNavi"]
    case .category: return ["SDGCategoryNavi"]
    case .text: return ["SDGTextNavi"]
    }
  }
}

enum SDGProgressCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case circular
  case dot
  case linear
  case system
  
  var id: String {
    switch self {
    case .circular: return "component_circular_progress"
    case .dot: return "component_dot_progress"
    case .linear: return "component_linear_progress"
    case .system: return "component_system_progress"
    }
  }
  
  var title: String {
    switch self {
    case .circular: return "Circle Progress"
    case .dot: return "Dot Progress"
    case .linear: return "Linear Progress"
    case .system: return "System Progress"
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .circular: return ["SDGCircularProgress"]
    case .dot: return ["SDGDotProgress"]
    case .linear: return ["SDGLinearProgress"]
    case .system: return ["SDGSystemProgress", "View.systemProgress"]
    }
  }
}

enum SDGSearchBarCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case box
  case category
  case capsule
  
  var id: String {
    switch self {
    case .box: return "component_box_search"
    case .category: return "component_category_search"
    case .capsule: return "component_capsule_search"
    }
  }
  
  var title: String {
    switch self {
    case .box: return "Box Search"
    case .category: return "Category Search"
    case .capsule: return "Capsule Search"
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .box: return ["SDGBoxSearch"]
    case .category: return ["SDGCategorySearch"]
    case .capsule: return ["SDGCapsuleSearch"]
    }
  }
}

enum SDGTabCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case box
  case fixed
  case icon
  case scroll
  
  var id: String {
    switch self {
    case .box: return "component_box_tab"
    case .fixed: return "component_fixed_tab"
    case .icon: return "component_icon_tab"
    case .scroll: return "component_scroll_tab"
    }
  }
  
  var title: String {
    switch self {
    case .box: return "Box Tab"
    case .fixed: return "Fixed Tab"
    case .icon: return "Icon Tab"
    case .scroll: return "Scroll Tab"
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .box: return ["SDGBoxTab"]
    case .fixed: return ["SDGFixedTab"]
    case .icon: return ["SDGIconTab"]
    case .scroll: return ["SDGScrollTab"]
    }
  }
}

enum SDGTextInputCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case fixed
  case login
  case simple
  case underline
  
  var id: String {
    switch self {
    case .fixed: return "component_fixed_text_input"
    case .login: return "component_login_input"
    case .simple: return "component_simple_text_input"
    case .underline: return "component_underline_input"
    }
  }
  
  var title: String {
    switch self {
    case .fixed: return "Fixed Text Input"
    case .login: return "Login Input"
    case .simple: return "Simple Text Input"
    case .underline: return "Underline Input"
    }
  }
  
  var viewID: String? {
    id
  }
  
  var implementationNames: [String] {
    switch self {
    case .fixed: return ["SDGFixedTextInput"]
    case .login: return ["SDGLoginInput"]
    case .simple: return ["SDGSimpleInput"]
    case .underline: return ["SDGUnderlineInput"]
    }
  }
}

enum SDGTemplateCatalog: CaseIterable, SDGCatalogItemRepresentable {
  case calendarAndTime
  case checkboxLabel
  case checkOptionLabel
  case emptyImg
  case form
  case foundationList
  case history
  case listHeader
  case multiCalendar
  case multiTimePicker
  case popup
  case profile
  case radioLabel
  
  var id: String {
    switch self {
    case .calendarAndTime: return "template_calendar_time"
    case .checkboxLabel: return "template_checkbox_label"
    case .checkOptionLabel: return "template_check_option_label"
    case .emptyImg: return "template_empty_img"
    case .form: return "template_form"
    case .foundationList: return "template_foundation_list"
    case .history: return "template_history"
    case .listHeader: return "template_list_header"
    case .multiCalendar: return "template_multi_calendar"
    case .multiTimePicker: return "template_multi_time_picker"
    case .popup: return "template_popup"
    case .profile: return "template_profile"
    case .radioLabel: return "template_radio_label"
    }
  }
  
  var title: String {
    switch self {
    case .calendarAndTime: return "Calendar & Time"
    case .checkboxLabel: return "Checkbox Label"
    case .checkOptionLabel: return "Check Option Label"
    case .emptyImg: return "Empty Img"
    case .form: return "Form"
    case .foundationList: return "Foundation List"
    case .history: return "History"
    case .listHeader: return "List Header"
    case .multiCalendar: return "MultiCalendar"
    case .multiTimePicker: return "Multi Time Picker"
    case .popup: return "Popup"
    case .profile: return "Profile"
    case .radioLabel: return "Radio Label"
    }
  }

  var viewID: String? {
    switch self {
    case .multiTimePicker:
      return id
    default:
      return nil
    }
  }
  
  var implementationNames: [String] {
    switch self {
    case .calendarAndTime: return ["SDGCalendarAndTime"]
    case .checkboxLabel: return ["SDGCheckBoxLabel"]
    case .checkOptionLabel: return ["CheckOptionLabel"]
    case .emptyImg: return ["SDGEmptyImg"]
    case .form: return ["SDGFixedTextForm", "SDGDropdownForm", "SDGSelectForm", "SDGSimpleTextForm", "SDGTimeSelectForm"]
    case .foundationList: return ["SDGFoundationList"]
    case .history: return ["SDGHistoryHeader"]
    case .listHeader: return ["SDGButtonHeader", "SDGIconHeader"]
    case .multiCalendar: return ["SDGMultiCalendar"]
    case .multiTimePicker: return ["SDGMultiTimePicker"]
    case .popup: return ["SDGBottomPopup", "SDGCenterPopup", "SDGIconPopup", "SDGConfirmPopup", "SDGDeletePopup", "SDGInfoPopup", "SDGInputPopup"]
    case .profile: return ["SDGMiniProfile", "SDGSecondProfile"]
    case .radioLabel: return ["SDGRadioLabel"]
    }
  }
}
