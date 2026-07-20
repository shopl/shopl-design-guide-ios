//
//  SDGBottomButtonDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGBottomButtonDemoState: ObservableObject {
  static let shared = SDGBottomButtonDemoState()

  let types = SDGBottomButtonDemoType.allCases
  let specs = SDGBottomButtonDemoSpec.allCases
  let states = SDGBottomButtonDemoButtonState.allCases

  @Published var selectedTypeIndex = 0
  @Published var selectedSpecIndex = 0
  @Published var selectedStateIndex = 0
  @Published var isLongTextEnabled = false

  private init() { }

  var selectedType: SDGBottomButtonDemoType {
    types[safe: selectedTypeIndex] ?? .primary
  }

  var selectedSpec: SDGBottomButtonDemoSpec {
    specs[safe: selectedSpecIndex] ?? .full
  }

  var selectedState: SDGBottomButtonDemoButtonState {
    states[safe: selectedStateIndex] ?? .default
  }

  var previewOption: SDGBottomButton.Option {
    .init(
      type: selectedType.buttonType,
      spec: selectedSpec.buttonSpec,
      title: isLongTextEnabled ? Self.longTitle : Self.shortTitle
    )
  }

  var isPreviewDisabled: Bool {
    selectedState == .disabled
  }

  private static let shortTitle = "Label"
  private static let longTitle = "Label Label Label Label"
}

enum SDGBottomButtonDemoType: String, CaseIterable, Identifiable {
  case primary = "Primary"
  case neutral = "Neutral"
  case point = "Point"
  case normal = "Normal"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var buttonType: SDGBottomButton.Option.`Type` {
    switch self {
    case .primary:
      return .primary
    case .neutral:
      return .neutral
    case .point:
      return .point
    case .normal:
      return .normal
    }
  }
}

enum SDGBottomButtonDemoSpec: String, CaseIterable, Identifiable {
  case full = "Full"
  case adaptive = "Adaptive"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var buttonSpec: SDGBottomButton.Option.Spec {
    switch self {
    case .full:
      return .full
    case .adaptive:
      return .adaptive
    }
  }
}

enum SDGBottomButtonDemoButtonState: String, CaseIterable, Identifiable {
  case `default` = "Default"
  case disabled = "Disabled"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
