//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/25/25.
//

import SwiftUI

public struct SDGFixedTextInput: View {
  public static var version: String { "2.3.36" }

  public enum Style: Equatable {
    case solid
    case outlined
  }

  public enum InputField: Equatable {
    case lightGray
    case white

    var color: Color {
      switch self {
      case .lightGray: return .neutral50
      case .white: return .neutral0
      }
    }
  }

  public enum State: Equatable {
    case `default`
    case focused
    case disabled
    case error(String?, isFocused: Bool = false)

    var isDisabled: Bool {
      switch self {
      case .disabled: return true
      default: return false
      }
    }

    var isError: Bool {
      switch self {
      case .error: return true
      default: return false
      }
    }

    var isFocused: Bool {
      switch self {
      case .focused, .error(_, isFocused: true): return true
      default: return false
      }
    }
  }

  @Binding private var text: String
  @Binding private var state: State

  @FocusState private var isTextFieldFocused: Bool

  private let style: Style
  private let placeholder: String?
  private let inputFieldColor: Color
  private let keyboardType: UIKeyboardType
  private let maxCharacterCount: Int?
  private let inputViewHeight: CGFloat

  private var isEditable: Bool {
    !state.isDisabled
  }

  private var hasError: Bool {
    state.isError
  }

  private var backgroundColor: Color {
    switch style {
    case .solid:
      return hasError ? .red300_10 : inputFieldColor
    case .outlined:
      return .neutral0
    }
  }

  private var strokeColor: Color {
    switch style {
    case .solid:
      return .clear
    case .outlined:
      return hasError ? .red300 : .neutral200
    }
  }

  private var textColor: SDG.Color {
    isEditable ? .neutral700 : .neutral300
  }

  private var placeholderText: Text? {
    guard let placeholder else {
      return nil
    }

    return Text(placeholder)
      .foregroundColor(.neutral350)
  }

  private var nextRestingState: State {
    if case let .error(message, _) = state {
      return .error(message)
    }

    return .default
  }

  private var nextFocusedState: State {
    if case let .error(message, _) = state {
      return .error(message, isFocused: true)
    }

    return .focused
  }

  public init(
    style: Style = .solid,
    inputField: InputField = .lightGray,
    state: Binding<State>,
    text: Binding<String>,
    placeholder: String?,
    keyboardType: UIKeyboardType = .default,
    maxCharacterCount: Int? = nil,
    inputViewHeight: CGFloat = 104
  ) {
    self.init(
      style: style,
      inputFieldColor: inputField.color,
      state: state,
      text: text,
      placeholder: placeholder,
      keyboardType: keyboardType,
      maxCharacterCount: maxCharacterCount,
      inputViewHeight: inputViewHeight
    )
  }

  init(
    style: Style = .solid,
    inputFieldColor: Color,
    state: Binding<State>,
    text: Binding<String>,
    placeholder: String?,
    keyboardType: UIKeyboardType = .default,
    maxCharacterCount: Int? = nil,
    inputViewHeight: CGFloat = 104
  ) {
    self.style = style
    self.inputFieldColor = inputFieldColor
    self._state = state
    self._text = text
    self.placeholder = placeholder
    self.keyboardType = keyboardType
    self.maxCharacterCount = maxCharacterCount
    self.inputViewHeight = inputViewHeight
  }

  public var body: some View {
    VStack(spacing: 10) {
      inputField
    }
    .onChange(of: state) { newState in
      syncFocus(with: newState)
    }
  }

  private var inputField: some View {
    textField
      .padding(.spacing12)
      .frame(
        maxWidth: .infinity,
        minHeight: inputViewHeight,
        maxHeight: inputViewHeight,
        alignment: .topLeading
      )
      .background(backgroundColor)
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(strokeColor, lineWidth: 1)
      )
      .contentShape(RoundedRectangle(cornerRadius: 12))
      .onTapGesture {
        activate()
      }
      .allowsHitTesting(isEditable)
  }

  private var textField: some View {
    TextField(
      "",
      text: $text,
      prompt: placeholderText,
      axis: .vertical
    )
      .typo(.body1_R, textColor)
      .tint(.neutral700)
      .keyboardType(keyboardType)
      .focused($isTextFieldFocused)
      .textFieldStyle(.plain)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .disabled(!isEditable)
      .onChange(of: text) { newValue in
        limitTextIfNeeded(newValue)
      }
      .onChange(of: isTextFieldFocused) { isFocused in
        updateFocus(isFocused)
      }
  }

  private func activate() {
    guard isEditable else { return }

    isTextFieldFocused = true
  }

  private func updateFocus(_ isFocused: Bool) {
    guard isEditable else {
      isTextFieldFocused = false
      return
    }

    let newState = isFocused ? nextFocusedState : nextRestingState
    if state != newState {
      state = newState
    }
  }

  private func syncFocus(with newState: State) {
    switch newState {
    case .focused, .error(_, isFocused: true):
      guard isEditable else { return }
      DispatchQueue.main.async {
        guard isEditable else { return }
        isTextFieldFocused = true
      }
    case .disabled:
      isTextFieldFocused = false
    case .default, .error:
      break
    }
  }

  private func limitTextIfNeeded(_ newValue: String) {
    guard let maxCharacterCount, newValue.count > maxCharacterCount else { return }
    text = String(newValue.prefix(maxCharacterCount))
  }
}

#Preview("Design Resource") {
  SDGFixedTextInputDesignResourcePreview()
}

private struct SDGFixedTextInputDesignResourcePreview: View {

  private let placeholder = "Placeholder"
  private let text = "Text"

  var body: some View {
    ScrollView([.horizontal, .vertical]) {
      VStack(alignment: .leading, spacing: 52) {
        VStack(alignment: .leading, spacing: 20) {
          Text("Design Resource")
            .typo(.special1_SB, .neutral600)

          Rectangle()
            .fill(.neutral600)
            .frame(width: 860, height: 4)
        }

        HStack(alignment: .top, spacing: 40) {
          column(
            style: .solid,
            inputField: .white,
            states: [
              .default,
              .focused,
              .disabled,
              .error(nil)
            ]
          )

          column(
            style: .solid,
            inputField: .lightGray,
            states: [
              .default,
              .focused,
              .disabled
            ]
          )

          column(
            style: .outlined,
            inputField: .white,
            states: [
              .default,
              .focused,
              .disabled,
              .error(nil)
            ]
          )
        }
        .padding(12)
        .overlay(
          Rectangle()
            .stroke(
              .purple.opacity(0.5),
              style: StrokeStyle(lineWidth: 1, dash: [6, 4])
            )
        )
      }
      .padding(80)
    }
    .background(.neutral0)
  }

  private func column(
    style: SDGFixedTextInput.Style,
    inputField: SDGFixedTextInput.InputField,
    states: [SDGFixedTextInput.State]
  ) -> some View {
    VStack(spacing: 10) {
      ForEach(Array(states.enumerated()), id: \.offset) { _, state in
        SDGFixedTextInput(
          style: style,
          inputField: inputField,
          state: .constant(state),
          text: .constant(state == .default ? "" : text),
          placeholder: placeholder
        )
        .frame(width: 335)
      }
    }
  }
}
