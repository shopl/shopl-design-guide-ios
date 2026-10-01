//
//  SDGCheckOptionDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGCheckOptionDemoState: ObservableObject {
  let styles = SDGCheckOptionDemoStyle.allCases
  let specs = SDGCheckOptionDemoSpec.allCases

  @Published var selectedStyleIndex = 0
  @Published var selectedSpecIndex = 0
  @Published var selectedState: SDGCheckOptionDemoStateOption = .default

  init() { }

  var selectedStyle: SDGCheckOptionDemoStyle {
    styles[safe: selectedStyleIndex] ?? .solid
  }

  var selectedSpec: SDGCheckOptionDemoSpec {
    specs[safe: selectedSpecIndex] ?? .large
  }

  var previewItems: [SDGCheckOptionDemoPreviewItem] {
    switch selectedState {
    case .default:
      return [
        previewItem(id: "default", state: .default)
      ]
    case .selected:
      return [
        previewItem(id: "selected-normal", state: .selected),
        previewItem(id: "selected-neutral", state: .selected, selectColor: .neutral)
      ]
    case .disabled:
      return [
        previewItem(id: "disabled", state: .disabled)
      ]
    }
  }

  private func previewItem(
    id: String,
    state: SDGCheckOptionState,
    selectColor: SDGCheckOptionDemoSelectColor = .normal
  ) -> SDGCheckOptionDemoPreviewItem {
    SDGCheckOptionDemoPreviewItem(
      id: "\(selectedStyle.id)-\(selectedSpec.id)-\(id)",
      model: SDGCheckOption.Model(
        state: state,
        style: selectedStyle.checkOptionStyle,
        spec: selectedSpec.checkOptionSpec,
        selectColor: selectColor.checkOptionSelectColor
      )
    )
  }
}

struct SDGCheckOptionDemoPreviewItem: Identifiable {
  let id: String
  let model: SDGCheckOption.Model
}

enum SDGCheckOptionDemoStyle: String, CaseIterable, Identifiable {
  case solid = "Solid"
  case line = "Line"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var checkOptionStyle: SDGCheckOption.Style {
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
}

enum SDGCheckOptionDemoStateOption: String, CaseIterable, Identifiable {
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

enum SDGCheckOptionDemoSelectColor: Equatable {
  case normal
  case neutral

  var checkOptionSelectColor: SDGCheckOption.SelectColor {
    switch self {
    case .normal:
      return .normal
    case .neutral:
      return .neutral
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
