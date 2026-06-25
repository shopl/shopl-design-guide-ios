//
//  SDGGhostButtonDemoControlState.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGGhostButtonDemoControlState: ObservableObject {
  static let shared = SDGGhostButtonDemoControlState()
  
  let specs = SDGGhostButtonDemoSpec.allCases
  let states = SDGGhostButtonDemoState.allCases
  
  @Published var selectedSpecIndex = 0
  @Published var selectedStateIndex = 0
  @Published var isLongTextEnabled = false
  
  private init() { }
  
  var selectedSpec: SDGGhostButtonDemoSpec {
    specs[safe: selectedSpecIndex] ?? .large
  }
  
  var selectedState: SDGGhostButtonDemoState {
    states[safe: selectedStateIndex] ?? .default
  }
  
  var title: String {
    isLongTextEnabled ? Self.longTitle : Self.shortTitle
  }
  
  var status: SDGGhostButton.Status {
    selectedState.buttonStatus
  }
  
  private static let shortTitle = "Label"
  private static let longTitle = "Label Label Label Label"
}

enum SDGGhostButtonDemoSpec: String, CaseIterable, Identifiable {
  case large = "Large"
  case medium = "Meduim"
  case small = "Small"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  var buttonSize: SDGGhostButton.Size {
    switch self {
    case .large:
      return .large
    case .medium:
      return .medium
    case .small:
      return .small
    }
  }
}

enum SDGGhostButtonDemoState: String, CaseIterable, Identifiable {
  case `default` = "Default"
  case disabled = "Disabled"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  var buttonStatus: SDGGhostButton.Status {
    switch self {
    case .default:
      return .default
    case .disabled:
      return .disabled
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
