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
  func overviewSections() -> [SDGCatalogSection]
}

struct DefaultSDGCatalogRepository: SDGCatalogRepository {
  func overviewSections() -> [SDGCatalogSection] {
    SDGCatalogSectionKind.allCases.map(\.catalogSection)
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
    case .cornerRadius, .iconography, .spacing:
      return nil
    }
  }
  
  var catalogSubDescription: String? {
    switch self {
    case .color:
      return "일관된 브랜드 경험을 만들 수 있도록 표준 색상 차트와 사용자 가이드를 제공합니다."
    case .typography:
      return "정의된 유형, 규모, 색상을 고려하여 적용된 타이포그래피는 콘텐츠의 중요도를 분류합니다."
    case .cornerRadius, .iconography, .spacing:
      return nil
    }
  }
  
  var viewID: String? {
    switch self {
    case .color: return "foundation_color"
    case .typography: return "foundation_typo"
    case .cornerRadius, .iconography, .spacing:
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
  case attachmentList
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
    case .attachmentList: return "component_attachment_list"
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
    case .attachmentList: return "Attachment List"
    case .badge: return "Badge"
    case .button: return "Button"
    case .calendar: return "Calendar"
    case .checkbox: return "Checkbox"
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
  
  var implementationNames: [String] {
    switch self {
    case .avatar: return ["SDGAvatar"]
    case .attachmentList: return ["SDGAttachmentElement"]
    case .badge: return ["SDGBoxBadge", "SDGCapsuleBadge"]
    case .button: return SDGButtonCatalog.allCases.flatMap(\.implementationNames)
    case .calendar: return ["SDGCalendar"]
    case .checkbox: return ["SDGCheckBox"]
    case .checkOption: return ["SDGCheckOption"]
    case .dropdown: return ["SDGDropdown"]
    case .emptyIcon: return ["SDGEmptyIcon"]
    case .filterChip: return ["SDGNaviFilterChip"]
    case .indicator: return ["SDGTextIndicator", "SDGDotIndicator", "SDGNumberIndicator"]
    case .iconLabel: return ["SDGIconLabel"]
    case .listHeaderLabel: return ["SDGListHeaderLabel"]
    case .navigation: return ["SDGBasicNavi", "SDGTextNavi", "SDGSearchNavi", "SDGCategoryNavi"]
    case .numberPicker: return ["SDGNumberPicker"]
    case .progress: return ["SDGCircularProgress", "SDGDotProgress", "SDGLinearProgress", "SDGSystemProgress", "View.systemProgress"]
    case .radio: return ["SDGRadio"]
    case .searchBar: return ["SDGBoxSearch", "SDGCapsuleSearch", "SDGCategorySearch"]
    case .segment: return ["SDGSegment"]
    case .selectInput: return ["SDGSelectInput"]
    case .tab: return ["SDGBoxTab", "SDGFixedTab", "SDGIconTab", "SDGScrollTab"]
    case .textInput: return ["SDGFixedTextInput", "SDGLoginInput", "SDGSimpleInput", "SDGUnderlineInput"]
    case .thumbnails: return ["SDGThumbnails"]
    case .timePicker: return ["SDGTimePicker"]
    case .timeSelectInput: return ["SDGTimeSelectInput"]
    case .toggle: return ["SDGToggle"]
    case .tooltip: return ["SDGTooltipSpec", "SDGTooltipDirection", "View.tooltip"]
    }
  }
  
  var children: [SDGCatalogItem] {
    switch self {
    case .button:
      return SDGButtonCatalog.catalogItems
    default:
      return []
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
