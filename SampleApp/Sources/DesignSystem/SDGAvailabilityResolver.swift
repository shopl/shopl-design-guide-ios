//
//  SDGAvailabilityResolver.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/22/26.
//

import Foundation

struct SDGAvailability: Hashable {
  let isImplemented: Bool
  let matchedImplementationNames: [String]
}

protocol SDGAvailabilityResolving {
  func availability(for item: SDGCatalogItem) -> SDGAvailability
}

struct SDGAvailabilityResolver: SDGAvailabilityResolving {
  private let implementedNames: Set<String>
  
  init(implementedNames: Set<String> = SDGImplementationManifest.implementedNames) {
    self.implementedNames = implementedNames
  }
  
  func availability(for item: SDGCatalogItem) -> SDGAvailability {
    let matchedNames = item.allImplementationNames.filter { implementedNames.contains($0) }
    
    return SDGAvailability(
      isImplemented: !matchedNames.isEmpty,
      matchedImplementationNames: matchedNames
    )
  }
}

enum SDGImplementationManifest {
  static let implementedNames: Set<String> = [
    "SDG.Color",
    "SDG.Image",
    "SDG.Typography",
    "SDGAttachmentElement",
    "SDGAvatar",
    "SDGBasicNavi",
    "SDGBottomButton",
    "SDGBottomPopup",
    "SDGBoxBadge",
    "SDGBoxButton",
    "SDGBoxSearch",
    "SDGBoxTab",
    "SDGButtonHeader",
    "SDGCapsuleBadge",
    "SDGCapsuleButton",
    "SDGCapsuleSearch",
    "SDGCategoryNavi",
    "SDGCategorySearch",
    "SDGCenterPopup",
    "SDGCheckBox",
    "SDGCheckBoxLabel",
    "SDGCheckOption",
    "SDGCircularProgress",
    "SDGConfirmPopup",
    "SDGCornerRadius",
    "SDGDeletePopup",
    "SDGDotIndicator",
    "SDGDotProgress",
    "SDGDropdown",
    "SDGDropdownForm",
    "SDGFixedTab",
    "SDGFixedTextForm",
    "SDGFixedTextInput",
    "SDGFloatingButton",
    "SDGGhostButton",
    "SDGHistoryHeader",
    "SDGIconHeader",
    "SDGIconLabel",
    "SDGIconPopup",
    "SDGIconTab",
    "SDGInfoPopup",
    "SDGInputPopup",
    "SDGLinearProgress",
    "SDGListHeaderLabel",
    "SDGLoginInput",
    "SDGMiniProfile",
    "SDGMultiTimePicker",
    "SDGNaviFilterChip",
    "SDGNumberIndicator",
    "SDGNumberPicker",
    "SDGProgressView",
    "SDGRadio",
    "SDGRadioLabel",
    "SDGScrollTab",
    "SDGSearchNavi",
    "SDGSecondProfile",
    "SDGSegment",
    "SDGSelectForm",
    "SDGSimpleInput",
    "SDGSimpleTextForm",
    "SDGSpacing",
    "SDGSystemProgress",
    "SDGTextIndicator",
    "SDGTextNavi",
    "SDGThumbnails",
    "SDGTimePicker",
    "SDGTimeSelectForm",
    "SDGTimeSelectInput",
    "SDGToggle",
    "SDGTooltipDirection",
    "SDGTooltipSpec",
    "SDGUnderlineInput",
    "View.systemProgress",
    "View.tooltip"
  ]
}
