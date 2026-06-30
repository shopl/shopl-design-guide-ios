//
//  SDGCheckBoxDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGCheckBoxDemoState: ObservableObject {
  let sizes = SDGCheckBoxDemoSize.allCases

  @Published var selectedSizeIndex = 0
  @Published var selectedStatus: SDGCheckBoxDemoStatus = .default

  init() { }

  var selectedSize: SDGCheckBoxDemoSize {
    sizes[safe: selectedSizeIndex] ?? .large
  }

  var previewModels: [SDGCheckBox.Model] {
    switch selectedStatus {
    case .default:
      return [
        .init(size: selectedSize.checkBoxSize, status: .default)
      ]
    case .selected:
      return [
        .init(size: selectedSize.checkBoxSize, selectedColor: .primary300, status: .selected),
        .init(size: selectedSize.checkBoxSize, selectedColor: .neutral700, status: .selected)
      ]
    case .disabled:
      return [
        .init(size: selectedSize.checkBoxSize, status: .disabled)
      ]
    }
  }
}

enum SDGCheckBoxDemoSize: String, CaseIterable, Identifiable {
  case large = "Large"
  case medium = "Medium"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var checkBoxSize: SDGCheckBox.Size {
    switch self {
    case .large:
      return .large
    case .medium:
      return .medim
    }
  }
}

enum SDGCheckBoxDemoStatus: String, CaseIterable, Identifiable {
  case `default` = "Default"
  case selected = "Selected"
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
