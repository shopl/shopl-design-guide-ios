//
//  SDGDropdownDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/26/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGDropdownDemoState: ObservableObject {
  static let shared = SDGDropdownDemoState()

  let statuses = SDGDropdownDemoStatus.allCases
  let backgroundOptions = SDGDropdownDemoBackground.allCases
  let options = SDGDropdownDemoOption.samples

  @Published var selectedStatusIndex = 0
  @Published var selectedBackgroundIndex = 0
  @Published var selectedOptionID = SDGDropdownDemoOption.samples[0].id
  @Published var isListPopupPresented = false

  private init() { }

  var selectedStatus: SDGDropdownDemoStatus {
    statuses[safe: selectedStatusIndex] ?? .default
  }

  var selectedBackground: SDGDropdownDemoBackground {
    backgroundOptions[safe: selectedBackgroundIndex] ?? .neutral0
  }

  var selectedOption: SDGDropdownDemoOption {
    options.first { $0.id == selectedOptionID } ?? options[0]
  }

  var dropdownModel: SDGDropdown.Model {
    SDGDropdown.Model(
      placeHolder: "placeholder",
      text: selectedStatus.shouldShowText ? selectedOption.title : "",
      status: selectedStatus.dropdownStatus,
      backgroundColor: selectedBackground.dropdownBackgroundColor
    )
  }

  var listPopupItems: [ListPopupModel] {
    options.map {
      ListPopupModel(
        id: $0.id,
        title: $0.title,
        status: $0.id == selectedOptionID ? .selected : .default
      )
    }
  }

  func selectStatus(_ status: SDGDropdownDemoStatus) {
    guard let index = statuses.firstIndex(of: status) else { return }
    selectedStatusIndex = index
  }

  func showListPopup() {
    guard selectedStatus != .disabled else { return }
    isListPopupPresented = true
  }

  func hideListPopup() {
    isListPopupPresented = false
  }

  func selectOption(id: String) {
    selectedOptionID = id
    isListPopupPresented = false

    if selectedStatus == .default {
      selectStatus(.selected)
    }
  }
}

struct SDGDropdownDemoOption: Identifiable, Equatable {
  let id: String
  let title: String

  static let samples: [SDGDropdownDemoOption] = [
    SDGDropdownDemoOption(
      id: "poem",
      title: "가슴속에 못 시인의 나의 별이 봅니다. 어머님, 멀리 별 이런 나는 추억과 남은 걱정도 쓸쓸함과 있습니다."
    ),
    SDGDropdownDemoOption(id: "default-1", title: "Default Text"),
    SDGDropdownDemoOption(id: "default-2", title: "Default Text 2"),
    SDGDropdownDemoOption(id: "default-3", title: "Default Text 3")
  ]
}

enum SDGDropdownDemoStatus: String, CaseIterable, Identifiable {
  case `default` = "Default"
  case selected = "Selected"
  case disabled = "Disabled"
  case error = "Error"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var dropdownStatus: SDGDropdown.Status {
    switch self {
    case .default:
      return .default
    case .selected:
      return .selected
    case .disabled:
      return .disabled
    case .error:
      return .error
    }
  }

  var shouldShowText: Bool {
    switch self {
    case .selected, .error:
      return true
    case .default, .disabled:
      return false
    }
  }
}

enum SDGDropdownDemoBackground: String, CaseIterable, Identifiable {
  case neutral0 = "Neutral 0"
  case neutral50 = "Neutral 50"

  var id: String {
    rawValue
  }

  var title: String {
    rawValue
  }

  var dropdownBackgroundColor: SDGDropdown.BackgroundColor {
    switch self {
    case .neutral0:
      return .neutral0
    case .neutral50:
      return .neutral50
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
