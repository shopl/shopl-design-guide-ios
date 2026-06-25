//
//  SDGBoxButtonDemoControlState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGBoxButtonDemoControlState: ObservableObject {
  static let shared = SDGBoxButtonDemoControlState()
  
  let types = SDGBoxButtonDemoType.allCases
  let specs = SDGBoxButtonDemoSpec.allCases
  let states = SDGBoxButtonDemoState.allCases
  let iconOptions = SDGBoxButtonDemoIconOption.allCases
  
  @Published var selectedTypeIndex = 0
  @Published var selectedSpecIndex = 0
  @Published var selectedStateIndex = 0
  @Published var selectedIconIndex = 0
  @Published var isLongTextEnabled = false
  @Published var isPreviewSelected = false
  
  private init() { }
  
  var selectedType: SDGBoxButtonDemoType {
    types[safe: selectedTypeIndex] ?? .solid
  }
  
  var selectedSpec: SDGBoxButtonDemoSpec {
    specs[safe: selectedSpecIndex] ?? .medium
  }
  
  var selectedState: SDGBoxButtonDemoState {
    states[safe: selectedStateIndex] ?? .default
  }
  
  var selectedIconOption: SDGBoxButtonDemoIconOption {
    iconOptions[safe: selectedIconIndex] ?? .none
  }
  
  var previewOption: SDGBoxButton.Option {
    .init(
      size: selectedSpec.buttonSize,
      icon: selectedIconOption.buttonIcon,
      title: isLongTextEnabled ? Self.longTitle : Self.shortTitle,
      color: selectedType.defaultColor,
      selectedColor: selectedType.selectedColor
    )
  }
  
  var isPreviewDisabled: Bool {
    selectedState == .disabled
  }
  
  func togglePreviewSelected() {
    guard !isPreviewDisabled else { return }
    isPreviewSelected.toggle()
  }
  
  private static let shortTitle = "Label"
  private static let longTitle = "Label Label Label Label"
}

enum SDGBoxButtonDemoType: String, CaseIterable, Identifiable {
  case solid = "Solid"
  case line = "Line"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  var defaultColor: SDGButtonColor {
    switch self {
    case .solid:
      return .init(
        lineColor: .neutral200,
        backgroundColor: .neutral200,
        textColor: .neutral600
      )
    case .line:
      return .init(
        lineColor: .neutral250,
        backgroundColor: .neutral0,
        textColor: .neutral600
      )
    }
  }
  
  var selectedColor: SDGButtonColor {
    switch self {
    case .solid:
      return .init(
        backgroundColor: .neutral600,
        textColor: .neutral0
      )
    case .line:
      return .init(
        lineColor: .neutral600,
        backgroundColor: .neutral0,
        textColor: .neutral600
      )
    }
  }
}

enum SDGBoxButtonDemoSpec: String, CaseIterable, Identifiable {
  case medium = "Medium"
  case small = "Small"
  case xsmall = "Xsmall"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  var buttonSize: SDGButtonSize {
    switch self {
    case .medium:
      return .medium
    case .small:
      return .small
    case .xsmall:
      return .xsmall
    }
  }
}

enum SDGBoxButtonDemoState: String, CaseIterable, Identifiable {
  case `default` = "Default"
  case disabled = "Disabled"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
}

enum SDGBoxButtonDemoIconOption: String, CaseIterable, Identifiable {
  case none = "없음"
  case left = "왼쪽"
  case right = "오른쪽"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  var buttonIcon: SDGButtonOptionIcon? {
    switch self {
    case .none:
      return nil
    case .left:
      return .left(image: Image(sdg: .icons), color: .neutral300)
    case .right:
      return .right(image: Image(sdg: .icons), color: .neutral300)
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
