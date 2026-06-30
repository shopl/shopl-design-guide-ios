//
//  SDGFloatingButtonDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/25/26.
//

import SwiftUI

final class SDGFloatingButtonDemoState: ObservableObject {
  let specs = SDGFloatingButtonDemoSpec.allCases
  
  @Published var selectedSpecIndex = 0
  @Published var selectedState: SDGFloatingButtonDemoButtonState = .default
  
  var selectedSpec: SDGFloatingButtonDemoSpec {
    specs[safe: selectedSpecIndex] ?? .oneSize
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
