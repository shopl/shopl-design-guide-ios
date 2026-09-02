//
//  SDGMultiTimePicker.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/2/26.
//

import Foundation
import SwiftUI

extension View {
  public func multiTimePicker(
    isPresented: Bool,
    title: String? = nil,
    type: SDGMultiTimePicker.`Type`,
    is24HourFormat: Bool,
    cancelTitle: String,
    confirmTitle: String,
    cancelAction: @escaping () -> Void,
    confirmAction: @escaping (SDGMultiTimePicker.Value) -> Void,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    modifier(
      PopupModifier(
        isPresented: isPresented,
        animation: .slideBottomTop,
        tapOutsideAction: tapOutsideAction
      ) {
        SDGMultiTimePicker(
          title: title,
          type: type,
          is24HourFormat: is24HourFormat,
          cancelTitle: cancelTitle,
          confirmTitle: confirmTitle,
          cancelAction: cancelAction,
          confirmAction: confirmAction
        )
      }
    )
  }
}

public struct SDGMultiTimePicker: View {
  public static let version = "2.0.0"

  public enum `Type`: Equatable {
    case single(selectedTime: SDGTimeValue)
    case multi(
      startTime: SDGTimeValue,
      endTime: SDGTimeValue,
      initialSelection: Selection
    )
  }

  public enum Selection: Equatable {
    case start
    case end
  }

  public enum Value: Equatable {
    case single(SDGTimeValue)
    case multi(
      startTime: SDGTimeValue,
      endTime: SDGTimeValue
    )
  }

  private enum Mode {
    case single
    case multi
  }

  private struct Draft {
    let mode: Mode
    var selectedTime: SDGTimeValue
    var startTime: SDGTimeValue
    var endTime: SDGTimeValue
    var selection: Selection

    init(type: Type) {
      switch type {
      case let .single(selectedTime):
        self.mode = .single
        self.selectedTime = selectedTime
        self.startTime = selectedTime
        self.endTime = selectedTime
        self.selection = .start

      case let .multi(startTime, endTime, initialSelection):
        self.mode = .multi
        self.selectedTime = startTime
        self.startTime = startTime
        self.endTime = endTime
        self.selection = initialSelection
      }
    }

    var value: Value {
      switch mode {
      case .single:
        return .single(selectedTime)
      case .multi:
        return .multi(startTime: startTime, endTime: endTime)
      }
    }
  }

  private let title: String?
  private let is24HourFormat: Bool
  private let cancelTitle: String
  private let confirmTitle: String
  private let cancelAction: () -> Void
  private let confirmAction: (Value) -> Void

  @State private var draft: Draft

  public init(
    title: String? = nil,
    type: Type,
    is24HourFormat: Bool,
    cancelTitle: String,
    confirmTitle: String,
    cancelAction: @escaping () -> Void,
    confirmAction: @escaping (Value) -> Void
  ) {
    self.title = title
    self.is24HourFormat = is24HourFormat
    self.cancelTitle = cancelTitle
    self.confirmTitle = confirmTitle
    self.cancelAction = cancelAction
    self.confirmAction = confirmAction
    self._draft = State(initialValue: Draft(type: type))
  }

  public var body: some View {
    SDGBottomPopup(
      title: popupTitle,
      bodyContent: {
        pickerContent
      },
      button: SDGBottomPopupButton(
        button: .twoOptions(
          option1: .init(
            title: cancelTitle,
            action: cancelAction
          ),
          option2: .init(
            title: confirmTitle,
            action: {
              confirmAction(draft.value)
            }
          )
        )
      )
    )
  }

  private var popupTitle: SDGPopupTitle? {
    title.map {
      SDGPopupTitle(
        title: $0,
        color: .neutral700,
        alignment: .leading
      )
    }
  }

  @ViewBuilder
  private var pickerContent: some View {
    switch draft.mode {
    case .single:
      SDGTimePicker(
        selectedDate: selectedDateBinding,
        is24HourFormat: is24HourFormat
      )
      .environment(\.timeZone, SDGTimeValueDateBridge.timeZone)
      .environment(\.calendar, SDGTimeValueDateBridge.calendar)

    case .multi:
      VStack(spacing: 24) {
        multiTimeBoxes

        SDGTimePicker(
          selectedDate: selectedMultiDateBinding,
          is24HourFormat: is24HourFormat
        )
        .environment(\.timeZone, SDGTimeValueDateBridge.timeZone)
        .environment(\.calendar, SDGTimeValueDateBridge.calendar)
      }
    }
  }

  private var multiTimeBoxes: some View {
    HStack(spacing: 4) {
      timeBox(
        time: draft.startTime,
        selection: .start
      )

      Text(sdg: "~")
        .typo(.body1_R, .neutral700)

      timeBox(
        time: draft.endTime,
        selection: .end
      )
    }
  }

  private func timeBox(
    time: SDGTimeValue,
    selection: Selection
  ) -> some View {
    Button {
      draft.selection = selection
    } label: {
      Text(sdg: time.hhmm)
        .typo(.body1_R, draft.selection == selection ? .primary300 : .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .frame(height: 40)
        .background(Color.neutral50)
        .clipShape(
          RoundedRectangle(
            cornerRadius: SDGCornerRadius.radius12.rawValue,
            style: .continuous
          )
        )
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .frame(maxWidth: .infinity)
  }

  private var selectedDateBinding: Binding<Date> {
    Binding(
      get: {
        SDGTimeValueDateBridge.date(from: draft.selectedTime)
      },
      set: { selectedDate in
        draft.selectedTime = SDGTimeValueDateBridge.time(from: selectedDate)
      }
    )
  }

  private var selectedMultiDateBinding: Binding<Date> {
    Binding(
      get: {
        switch draft.selection {
        case .start:
          return SDGTimeValueDateBridge.date(from: draft.startTime)
        case .end:
          return SDGTimeValueDateBridge.date(from: draft.endTime)
        }
      },
      set: { selectedDate in
        let selectedTime = SDGTimeValueDateBridge.time(from: selectedDate)

        switch draft.selection {
        case .start:
          draft.startTime = selectedTime
        case .end:
          draft.endTime = selectedTime
        }
      }
    )
  }
}
