//
//  SDGCheckOptionDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGCheckOptionDemoState: ObservableObject {
  static let shared = SDGCheckOptionDemoState()

  let types = SDGCheckOptionDemoType.allCases
  let specs = SDGCheckOptionDemoSpec.allCases
  let statuses = SDGCheckOptionDemoStatus.allCases

  @Published var selectedTypeIndex = 0
  @Published var selectedSpecIndex = 0
  @Published var selectedStatusIndex = 0

  private init() { }

  var selectedType: SDGCheckOptionDemoType {
    types[safe: selectedTypeIndex] ?? .solid
  }

  var selectedSpec: SDGCheckOptionDemoSpec {
    specs[safe: selectedSpecIndex] ?? .large
  }

  var selectedStatus: SDGCheckOptionDemoStatus {
    statuses[safe: selectedStatusIndex] ?? .default
  }

  var previewItems: [SDGCheckOptionDemoPreviewItem] {
    switch selectedStatus {
    case .default:
      return [
        previewItem(id: "default", status: .default)
      ]
    case .selected:
      return [
        previewItem(id: "selected-primary", status: .selected),
        previewItem(id: "selected-neutral", status: .selected, selectedColor: .neutral)
      ]
    case .disabled:
      return [
        previewItem(id: "disabled", status: .disabled)
      ]
    }
  }

  private func previewItem(
    id: String,
    status: SDGCheckOptionStatus,
    selectedColor: SDGCheckOptionDemoSelectedColor = .primary
  ) -> SDGCheckOptionDemoPreviewItem {
    SDGCheckOptionDemoPreviewItem(
      id: "\(selectedType.id)-\(selectedSpec.id)-\(id)",
      model: SDGCheckOption.Model(
        status: status,
        type: selectedType.checkOptionType,
        spec: selectedSpec.checkOptionSpec
      ),
      type: selectedType,
      spec: selectedSpec,
      selectedColor: selectedColor
    )
  }
}

struct SDGCheckOptionDemoPreviewItem: Identifiable {
  let id: String
  let model: SDGCheckOption.Model
  let type: SDGCheckOptionDemoType
  let spec: SDGCheckOptionDemoSpec
  let selectedColor: SDGCheckOptionDemoSelectedColor
}

enum SDGCheckOptionDemoType: String, CaseIterable, Identifiable {
  case solid = "Solid"
  case line = "Line"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var checkOptionType: SDGCheckOption.CheckType {
    switch self {
    case .solid:
      return .solid
    case .line:
      return .line
    }
  }
}

enum SDGCheckOptionDemoSpec: String, CaseIterable, Identifiable {
  case large = "Large"
  case medium = "Medium"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var checkOptionSpec: SDGCheckOption.Spec {
    switch self {
    case .large:
      return .large
    case .medium:
      return .medim
    }
  }

  var iconSize: CGFloat {
    switch self {
    case .large:
      return 16
    case .medium:
      return 14
    }
  }
}

enum SDGCheckOptionDemoStatus: String, CaseIterable, Identifiable {
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

enum SDGCheckOptionDemoSelectedColor: Equatable {
  case primary
  case neutral
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
