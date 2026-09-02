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
  @Published private(set) var selectedDate = SDGMultiTimePickerDemoState.makeDate(hour: 9)
  @Published private(set) var startDate = SDGMultiTimePickerDemoState.makeDate(hour: 9)
  @Published private(set) var endDate = SDGMultiTimePickerDemoState.makeDate(hour: 18)

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
      return .single(selectedDate: selectedDate)
    case .multi:
      return .multi(
        startDate: startDate,
        endDate: endDate,
        initialSelection: initialSelection.selection
      )
    }
  }

  var confirmedValue: String {
    switch selectedType {
    case .single:
      return formattedTime(selectedDate)
    case .multi:
      return "\(formattedTime(startDate)) ~ \(formattedTime(endDate))"
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
    case let .single(date):
      selectedDate = date
    case let .multi(startDate, endDate):
      self.startDate = startDate
      self.endDate = endDate
    }

    isPresented = false
  }

  private func formattedTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }

  private static func makeDate(hour: Int) -> Date {
    Calendar.current.date(
      bySettingHour: hour,
      minute: 0,
      second: 0,
      of: Date()
    ) ?? Date()
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
