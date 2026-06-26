//
//  SDGRadioDemoState.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/26/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGRadioDemoState: ObservableObject {
  static let shared = SDGRadioDemoState()

  let specs = SDGRadioDemoSpec.allCases
  let statuses = SDGRadioDemoStatus.allCases

  @Published var selectedSpecIndex = 0
  @Published var selectedStatusIndex = 0

  private init() { }

  var selectedSpec: SDGRadioDemoSpec {
    specs[safe: selectedSpecIndex] ?? .large
  }

  var selectedStatus: SDGRadioDemoStatus {
    statuses[safe: selectedStatusIndex] ?? .default
  }

  var previewItems: [SDGRadioDemoPreviewItem] {
    switch selectedStatus {
    case .default:
      return [
        previewItem(id: "default", status: .default)
      ]
    case .selected:
      return [
        previewItem(id: "selected-primary", status: .selected),
        previewItem(id: "selected-neutral", status: .selected, isPrimaryColor: false)
      ]
    case .disabled:
      return [
        previewItem(id: "disabled", status: .disabled)
      ]
    }
  }

  private func previewItem(
    id: String,
    status: SDGRadioStatus,
    isPrimaryColor: Bool = true
  ) -> SDGRadioDemoPreviewItem {
    SDGRadioDemoPreviewItem(
      id: "\(selectedSpec.id)-\(id)",
      model: SDGRadio.Model(
        status: status,
        spec: selectedSpec.radioSpec,
        isPrimaryColor: isPrimaryColor
      )
    )
  }
}

struct SDGRadioDemoPreviewItem: Identifiable {
  let id: String
  let model: SDGRadio.Model
}

enum SDGRadioDemoSpec: String, CaseIterable, Identifiable {
  case large = "Large"
  case medium = "Medium"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var radioSpec: SDGRadio.Spec {
    switch self {
    case .large:
      return .large
    case .medium:
      return .medim
    }
  }
}

enum SDGRadioDemoStatus: String, CaseIterable, Identifiable {
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
