//
//  SDGMultiTimePickerDemoState.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/2/26.
//

import SwiftUI

import ShoplDesignGuide

final class SDGMultiTimePickerDemoState: ObservableObject {
  static let shared = SDGMultiTimePickerDemoState()

  let pickerTypes = SDGMultiTimePickerDemoType.allCases
  let initialSelections = SDGMultiTimePickerDemoSelection.allCases

  @Published var selectedTypeIndex = 0
  @Published var initialSelectionIndex = 0
  @Published var showsTitle = true
  @Published var is24HourFormat = true
  @Published var isPresented = false
  @Published private(set) var selectedTime =
    SDGMultiTimePickerDemoState.makeTime(hour: 9)
  @Published private(set) var startTime =
    SDGMultiTimePickerDemoState.makeTime(hour: 9)
  @Published private(set) var endTime =
    SDGMultiTimePickerDemoState.makeTime(hour: 18)

  private init() { }

  var selectedType: SDGMultiTimePickerDemoType {
    pickerTypes[safe: selectedTypeIndex] ?? .single
  }

  var initialSelection: SDGMultiTimePickerDemoSelection {
    initialSelections[safe: initialSelectionIndex] ?? .start
  }

  var title: String? {
    showsTitle ? "Title" : nil
  }

  var pickerType: SDGMultiTimePicker.`Type` {
    switch selectedType {
    case .single:
      return .single(selectedTime: selectedTime)
    case .multi:
      return .multi(
        startTime: startTime,
        endTime: endTime,
        initialSelection: initialSelection.selection
      )
    }
  }

  var confirmedValue: String {
    switch selectedType {
    case .single:
      return selectedTime.hhmm
    case .multi:
      return "\(startTime.hhmm) ~ \(endTime.hhmm)"
    }
  }

  func present() {
    isPresented = true
  }

  func cancel() {
    isPresented = false
  }

  func confirm(_ value: SDGMultiTimePicker.Value) {
    switch value {
    case let .single(time):
      selectedTime = time
    case let .multi(startTime, endTime):
      self.startTime = startTime
      self.endTime = endTime
    }

    isPresented = false
  }

  private static func makeTime(hour: Int) -> SDGTimeValue {
    return SDGTimeValue(hour: hour, minute: 0) ?? .midnight
  }
}

enum SDGMultiTimePickerDemoType: String, CaseIterable, Identifiable {
  case single = "Single"
  case multi = "Multi"

  var id: String {
    rawValue
  }
}

enum SDGMultiTimePickerDemoSelection: String, CaseIterable, Identifiable {
  case start = "Start"
  case end = "End"

  var id: String {
    rawValue
  }

  var selection: SDGMultiTimePicker.Selection {
    switch self {
    case .start:
      return .start
    case .end:
      return .end
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
