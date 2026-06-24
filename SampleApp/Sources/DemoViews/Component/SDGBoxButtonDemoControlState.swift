//
//  SDGBoxButtonDemoControlState.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGBoxButtonDemoControlState: ObservableObject {
  static let shared = SDGBoxButtonDemoControlState()
  
  @Published var isPreviewEnabled = true
  @Published var isSizeControlEnabled = true
  @Published var isStyleControlEnabled = true
  @Published var isStateControlEnabled = true
  
  @Published var selectedSizeIndex = 0
  @Published var selectedStyleIndex = 0
  @Published var selectedStateIndex = 0
  
  private init() { }
  
  var previewSize: SDGButtonSize {
    guard isSizeControlEnabled else { return .medium }
    
    switch selectedSizeIndex {
    case 1:
      return .small
    case 2:
      return .xsmall
    default:
      return .medium
    }
  }
  
  var previewIcon: SDGButtonOptionIcon? {
    guard isStyleControlEnabled, selectedStyleIndex == 1 else {
      return nil
    }
    
    return .left(image: Image(sdg: .icons), color: .neutral300)
  }
  
  var isPreviewSelected: Bool {
    isStateControlEnabled && selectedStateIndex == 1
  }
  
  var isPreviewDisabled: Bool {
    isStateControlEnabled && selectedStateIndex == 2
  }
  
  var previewOption: SDGBoxButton.Option {
    .init(
      size: previewSize,
      icon: previewIcon,
      title: "Label",
      color: .init(
        backgroundColor: .neutral200,
        textColor: .neutral600
      ),
      selectedColor: .init(
        backgroundColor: .neutral600,
        textColor: .neutral0
      )
    )
  }
}
