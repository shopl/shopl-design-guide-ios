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
    case single(selectedDate: Date)
    case multi(startDate: Date, endDate: Date, initialSelection: Selection)
  }

  public enum Selection: Equatable {
    case start
    case end
  }

  public enum Value: Equatable {
    case single(Date)
    case multi(startDate: Date, endDate: Date)
  }

  private enum Mode {
    case single
    case multi
  }

  private struct Draft {
    let mode: Mode
    var selectedDate: Date
    var startDate: Date
    var endDate: Date
    var selection: Selection

    init(type: Type) {
      switch type {
      case let .single(selectedDate):
        self.mode = .single
        self.selectedDate = selectedDate
        self.startDate = selectedDate
        self.endDate = selectedDate
        self.selection = .start

      case let .multi(startDate, endDate, initialSelection):
        self.mode = .multi
        self.selectedDate = startDate
        self.startDate = startDate
        self.endDate = endDate
        self.selection = initialSelection
      }
    }

    var value: Value {
      switch mode {
      case .single:
        return .single(selectedDate)
      case .multi:
        return .multi(startDate: startDate, endDate: endDate)
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

    case .multi:
      VStack(spacing: 24) {
        multiTimeBoxes

        SDGTimePicker(
          selectedDate: selectedMultiDateBinding,
          is24HourFormat: is24HourFormat
        )
      }
    }
  }

  private var multiTimeBoxes: some View {
    HStack(spacing: 4) {
      timeBox(
        date: draft.startDate,
        selection: .start
      )

      Text(sdg: "~")
        .typo(.body1_R, .neutral700)

      timeBox(
        date: draft.endDate,
        selection: .end
      )
    }
  }

  private func timeBox(
    date: Date,
    selection: Selection
  ) -> some View {
    Button {
      draft.selection = selection
    } label: {
      Text(sdg: formattedTime(date))
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
        draft.selectedDate
      },
      set: {
        draft.selectedDate = $0
      }
    )
  }

  private var selectedMultiDateBinding: Binding<Date> {
    Binding(
      get: {
        switch draft.selection {
        case .start:
          return draft.startDate
        case .end:
          return draft.endDate
        }
      },
      set: { selectedDate in
        switch draft.selection {
        case .start:
          draft.startDate = selectedDate
        case .end:
          draft.endDate = selectedDate
        }
      }
    )
  }

  private func formattedTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}
