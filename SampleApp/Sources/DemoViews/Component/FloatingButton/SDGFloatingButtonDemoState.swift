//
//  SDGFloatingButtonDemoState.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGFloatingButtonDemoState: ObservableObject {
  static let shared = SDGFloatingButtonDemoState()
  
  let specs = SDGFloatingButtonDemoSpec.allCases
  let states = SDGFloatingButtonDemoButtonState.allCases
  
  @Published var selectedSpecIndex = 0
  @Published var selectedStateIndex = 0
  
  private init() { }
  
  var selectedSpec: SDGFloatingButtonDemoSpec {
    specs[safe: selectedSpecIndex] ?? .oneSize
  }
  
  var selectedState: SDGFloatingButtonDemoButtonState {
    states[safe: selectedStateIndex] ?? .default
  }
  
  var isPreviewDisabled: Bool {
    selectedState == .disabled
  }
}

enum SDGFloatingButtonDemoSpec: String, CaseIterable, Identifiable {
  case oneSize = "One size"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
}

enum SDGFloatingButtonDemoButtonState: String, CaseIterable, Identifiable {
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
