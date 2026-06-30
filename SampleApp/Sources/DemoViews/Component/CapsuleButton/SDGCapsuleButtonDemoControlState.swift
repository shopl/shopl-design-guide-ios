//
//  SDGCapsuleButtonDemoControlState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGCapsuleButtonDemoControlState: ObservableObject {
  static let shared = SDGCapsuleButtonDemoControlState()
  
  let types = SDGCapsuleButtonDemoType.allCases
  let specs = SDGCapsuleButtonDemoSpec.allCases
  let states = SDGCapsuleButtonDemoState.allCases
  let iconOptions = SDGCapsuleButtonDemoIconOption.allCases
  
  @Published var selectedTypeIndex = 0
  @Published var selectedSpecIndex = 0
  @Published var selectedStateIndex = 0
  @Published var selectedIconIndex = 0
  @Published var isLongTextEnabled = false
  @Published var isPreviewSelected = false
  
  private init() { }
  
  var selectedType: SDGCapsuleButtonDemoType {
    types[safe: selectedTypeIndex] ?? .solid
  }
  
  var selectedSpec: SDGCapsuleButtonDemoSpec {
    specs[safe: selectedSpecIndex] ?? .large
  }
  
  var selectedState: SDGCapsuleButtonDemoState {
    states[safe: selectedStateIndex] ?? .default
  }
  
  var selectedIconOption: SDGCapsuleButtonDemoIconOption {
    iconOptions[safe: selectedIconIndex] ?? .none
  }
  
  var previewOption: SDGCapsuleButton.Option {
    .init(
      size: selectedSpec.buttonSize,
      icon: selectedIconOption.buttonIcon(for: selectedType),
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
  private static let longTitle = "가슴속에 못 시인의 나의 별이 봅니다. 어머님, 멀리 별 이런 나는 추억과 남은 걱정도 쓸쓸함과 있습니다."
}

enum SDGCapsuleButtonDemoType: String, CaseIterable, Identifiable {
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
        lineColor: .neutral600,
        backgroundColor: .neutral600,
        textColor: .neutral0
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
        lineColor: .neutral700,
        backgroundColor: .neutral700,
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

enum SDGCapsuleButtonDemoSpec: String, CaseIterable, Identifiable {
  case large = "Large"
  case medium = "Meduim"
  case small = "Small"
  case xsmall = "Xsmall"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  var buttonSize: SDGCapsuleButtonSize {
    switch self {
    case .large:
      return .large
    case .medium:
      return .medium
    case .small:
      return .small
    case .xsmall:
      return .xsmall
    }
  }
}

enum SDGCapsuleButtonDemoState: String, CaseIterable, Identifiable {
  case `default` = "Default"
  case disabled = "Disabled"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
}

enum SDGCapsuleButtonDemoIconOption: String, CaseIterable, Identifiable {
  case none = "없음"
  case left = "왼쪽"
  case right = "오른쪽"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  func buttonIcon(for type: SDGCapsuleButtonDemoType) -> SDGButtonOptionIcon? {
    let iconColor = type == .solid ? Color.neutral0 : Color.neutral600
    
    switch self {
    case .none:
      return nil
    case .left:
      return .left(image: Image(sdg: .icons), color: iconColor)
    case .right:
      return .right(image: Image(sdg: .icons), color: iconColor)
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
