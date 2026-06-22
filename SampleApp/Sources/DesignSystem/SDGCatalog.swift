//
//  SDGCatalog.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/22/26.
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
    [
      foundationSection,
      componentSection,
      templateSection
    ]
  }
}

private extension DefaultSDGCatalogRepository {
  var foundationSection: SDGCatalogSection {
    SDGCatalogSection(
      id: "foundation",
      title: "Foundation",
      description: "일관된 레이아웃과 그에 따른 사용자 경험을 만드는 데 필수적인 시각적 요소입니다.",
      items: [
        .init(
          id: "foundation_color",
          title: "Color",
          description: "SDG의 컬러 팔레트",
          subDescription: "일관된 브랜드 경험을 만들 수 있도록 표준 색상 차트와 사용자 가이드를 제공합니다.",
          viewID: "foundation_color",
          implementationNames: ["SDG.Color", "Color"]
        ),
        .init(
          id: "foundation_corner_radius",
          title: "Corner Radius",
          implementationNames: ["SDGCornerRadius"]
        ),
        .init(
          id: "foundation_iconography",
          title: "Iconography",
          implementationNames: ["SDG.Image", "Image"]
        ),
        .init(
          id: "foundation_spacing",
          title: "Spacing",
          implementationNames: ["SDGSpacing"]
        ),
        .init(
          id: "foundation_typography",
          title: "Typography",
          description: "SDG의 폰트 스타일",
          subDescription: "정의된 유형, 규모, 색상을 고려하여 적용된 타이포그래피는 콘텐츠의 중요도를 분류합니다.",
          viewID: "foundation_typo",
          implementationNames: ["SDG.Typography", "Typography"]
        )
      ]
    )
  }
  
  var componentSection: SDGCatalogSection {
    SDGCatalogSection(
      id: "component",
      title: "Component",
      description: "각각의 기능을 구성하는 요소들의 조합입니다.",
      items: [
        .init(id: "component_avatar", title: "Avatar", implementationNames: ["SDGAvatar"]),
        .init(id: "component_attachment_list", title: "Attachment List", implementationNames: ["SDGAttachmentElement"]),
        .init(id: "component_badge", title: "Badge", implementationNames: ["SDGBoxBadge", "SDGCapsuleBadge"]),
        .init(
          id: "component_button",
          title: "Button",
          implementationNames: [
            "SDGBottomButton",
            "SDGBoxButton",
            "SDGCapsuleButton",
            "SDGFloatingButton",
            "SDGGhostButton"
          ],
          children: [
            .init(id: "component_bottom_button", title: "Bottom Button", viewID: "component_bottom_button", implementationNames: ["SDGBottomButton"]),
            .init(id: "component_box_button", title: "Box Button", viewID: "component_box_button", implementationNames: ["SDGBoxButton"]),
            .init(id: "component_capsule_button", title: "Capsule Button", viewID: "component_capsule_button", implementationNames: ["SDGCapsuleButton"]),
            .init(id: "component_floating_button", title: "Floating Button", viewID: "component_floating_button", implementationNames: ["SDGFloatingButton"]),
            .init(id: "component_ghost_button", title: "Ghost Button", viewID: "component_ghost_button", implementationNames: ["SDGGhostButton"])
          ]
        ),
        .init(id: "component_calendar", title: "Calendar", implementationNames: ["SDGCalendar"]),
        .init(id: "component_checkbox", title: "Checkbox", implementationNames: ["SDGCheckBox"]),
        .init(id: "component_check_option", title: "Check Option", implementationNames: ["SDGCheckOption"]),
        .init(id: "component_dropdown", title: "Dropdown", implementationNames: ["SDGDropdown"]),
        .init(id: "component_empty_icon", title: "Empty Icon", implementationNames: ["SDGEmptyIcon"]),
        .init(id: "component_filter_chip", title: "Filter Chip", implementationNames: ["SDGNaviFilterChip"]),
        .init(id: "component_indicator", title: "Indicator", implementationNames: ["SDGTextIndicator", "SDGDotIndicator", "SDGNumberIndicator"]),
        .init(id: "component_icon_label", title: "Icon Label", implementationNames: ["SDGIconLabel"]),
        .init(id: "component_list_header_label", title: "List Header label", implementationNames: ["SDGListHeaderLabel"]),
        .init(id: "component_navigation", title: "Navigation", implementationNames: ["SDGBasicNavi", "SDGTextNavi", "SDGSearchNavi", "SDGCategoryNavi"]),
        .init(id: "component_number_picker", title: "Number Picker", implementationNames: ["SDGNumberPicker"]),
        .init(id: "component_progress", title: "Progress", implementationNames: ["SDGCircularProgress", "SDGDotProgress", "SDGLinearProgress", "SDGSystemProgress", "View.systemProgress"]),
        .init(id: "component_radio", title: "Radio", implementationNames: ["SDGRadio"]),
        .init(id: "component_search_bar", title: "Search Bar", implementationNames: ["SDGBoxSearch", "SDGCapsuleSearch", "SDGCategorySearch"]),
        .init(id: "component_segment", title: "Segment", implementationNames: ["SDGSegment"]),
        .init(id: "component_select_input", title: "Select Input", implementationNames: ["SDGSelectInput"]),
        .init(id: "component_tab", title: "Tab", implementationNames: ["SDGBoxTab", "SDGFixedTab", "SDGIconTab", "SDGScrollTab"]),
        .init(id: "component_text_input", title: "Text Input", implementationNames: ["SDGFixedTextInput", "SDGLoginInput", "SDGSimpleInput", "SDGUnderlineInput"]),
        .init(id: "component_thumbnails", title: "Thumbnails", implementationNames: ["SDGThumbnails"]),
        .init(id: "component_time_picker", title: "Time Picker", implementationNames: ["SDGTimePicker"]),
        .init(id: "component_time_select_input", title: "Time Select Input", implementationNames: ["SDGTimeSelectInput"]),
        .init(id: "component_toggle", title: "Toggle", implementationNames: ["SDGToggle"]),
        .init(id: "component_tooltip", title: "Tooltip", implementationNames: ["SDGTooltipSpec", "SDGTooltipDirection", "View.tooltip"])
      ]
    )
  }
  
  var templateSection: SDGCatalogSection {
    SDGCatalogSection(
      id: "template",
      title: "Template",
      description: "컴포넌트를 포함한 요소들의 조합입니다.",
      items: [
        .init(id: "template_calendar_time", title: "Calendar & Time", implementationNames: ["SDGCalendarAndTime"]),
        .init(id: "template_checkbox_label", title: "Checkbox Label", implementationNames: ["SDGCheckBoxLabel"]),
        .init(id: "template_check_option_label", title: "Check Option Label", implementationNames: ["CheckOptionLabel"]),
        .init(id: "template_empty_img", title: "Empty Img", implementationNames: ["SDGEmptyImg"]),
        .init(id: "template_form", title: "Form", implementationNames: ["SDGFixedTextForm", "SDGDropdownForm", "SDGSelectForm", "SDGSimpleTextForm", "SDGTimeSelectForm"]),
        .init(id: "template_foundation_list", title: "Foundation List", implementationNames: ["SDGFoundationList"]),
        .init(id: "template_history", title: "History", implementationNames: ["SDGHistoryHeader"]),
        .init(id: "template_list_header", title: "List Header", implementationNames: ["SDGButtonHeader", "SDGIconHeader"]),
        .init(id: "template_multi_calendar", title: "MultiCalendar", implementationNames: ["SDGMultiCalendar"]),
        .init(id: "template_multi_time_picker", title: "Multi Time Picker", implementationNames: ["SDGMultiTimePicker"]),
        .init(id: "template_popup", title: "Popup", implementationNames: ["SDGBottomPopup", "SDGCenterPopup", "SDGIconPopup", "SDGConfirmPopup", "SDGDeletePopup", "SDGInfoPopup", "SDGInputPopup"]),
        .init(id: "template_profile", title: "Profile", implementationNames: ["SDGMiniProfile", "SDGSecondProfile"]),
        .init(id: "template_radio_label", title: "Radio Label", implementationNames: ["SDGRadioLabel"])
      ]
    )
  }
}
