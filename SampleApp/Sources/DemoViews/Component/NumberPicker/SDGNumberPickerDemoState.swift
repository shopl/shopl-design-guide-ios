//
//  SDGNumberPickerDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/26/26.
//

import SwiftUI

final class SDGNumberPickerDemoState: ObservableObject {
  static let shared = SDGNumberPickerDemoState()

  let types = SDGNumberPickerDemoType.allCases
  let oneOptionValues = Array(0...20)
  let firstOptionValues = Array(0...20)
  let secondOptionValues = Array(stride(from: 0, to: 60, by: 5))

  @Published var selectedTypeIndex = 0
  @Published var selectedValue = 9
  @Published var selectedFirstValue = 9
  @Published var selectedSecondValue = 30

  private init() { }

  var selectedType: SDGNumberPickerDemoType {
    types[safe: selectedTypeIndex] ?? .oneOption
  }
}

enum SDGNumberPickerDemoType: String, CaseIterable, Identifiable {
  case oneOption = "1 Option"
  case twoOption = "2 Option"

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
