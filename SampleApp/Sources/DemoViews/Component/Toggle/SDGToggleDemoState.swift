//
//  SDGToggleDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/26/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGToggleDemoState: ObservableObject {
  static let shared = SDGToggleDemoState()

  let specs = SDGToggleDemoSpec.allCases
  let statuses = SDGToggleDemoStatus.allCases

  @Published var selectedSpecIndex = 0
  @Published var selectedStatusIndex = 0

  private init() { }

  var selectedSpec: SDGToggleDemoSpec {
    specs[safe: selectedSpecIndex] ?? .medium
  }

  var selectedStatus: SDGToggleDemoStatus {
    statuses[safe: selectedStatusIndex] ?? .default
  }

  func select(_ status: SDGToggleDemoStatus) {
    guard let index = statuses.firstIndex(of: status) else { return }
    selectedStatusIndex = index
  }

  func setPreviewIsOn(_ isOn: Bool) {
    select(isOn ? .active : .default)
  }
}

enum SDGToggleDemoSpec: String, CaseIterable, Identifiable {
  case medium = "Medium"
  case small = "Small"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var toggleSize: SDGToggle.Size {
    switch self {
    case .medium:
      return .m
    case .small:
      return .s
    }
  }
}

enum SDGToggleDemoStatus: CaseIterable, Identifiable {
  case `default`
  case defaultDisabled
  case active
  case selectedDisabled

  var id: String {
    switch self {
    case .default: return "default"
    case .defaultDisabled: return "default_disabled"
    case .active: return "active"
    case .selectedDisabled: return "selected_disabled"
    }
  }

  var title: String {
    switch self {
    case .default, .defaultDisabled:
      return "Default"
    case .active:
      return "Active"
    case .selectedDisabled:
      return "Selected"
    }
  }

  var suffix: String? {
    switch self {
    case .default, .active:
      return nil
    case .defaultDisabled, .selectedDisabled:
      return "(Disabled)"
    }
  }

  var isEnabled: Bool {
    switch self {
    case .default, .active:
      return true
    case .defaultDisabled, .selectedDisabled:
      return false
    }
  }

  var isOn: Bool {
    switch self {
    case .default, .defaultDisabled:
      return false
    case .active, .selectedDisabled:
      return true
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
