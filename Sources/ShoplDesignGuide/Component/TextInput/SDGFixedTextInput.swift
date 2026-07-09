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
  private let state: State

  @FocusState private var isTextFieldFocused: Bool

  private let style: Style
  private let placeholder: String?
  private let inputFieldColor: Color
  private let keyboardType: UIKeyboardType
  private let inputViewHeight: CGFloat

  private var visualState: State {
    switch state {
    case .disabled:
      return .disabled
    case .error(let message, let isFocused):
      return .error(message, isFocused: isFocused || isTextFieldFocused)
    case .focused:
      return .focused
    case .default:
      return isTextFieldFocused ? .focused : .default
    }
  }

  private var isEditable: Bool {
    !visualState.isDisabled
  }

  private var hasError: Bool {
    visualState.isError
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

  public init(
    style: Style = .solid,
    inputField: InputField = .lightGray,
    state: State = .default,
    text: Binding<String>,
    placeholder: String?,
    keyboardType: UIKeyboardType = .default,
    inputViewHeight: CGFloat = 104
  ) {
    self.init(
      style: style,
      inputFieldColor: inputField.color,
      state: state,
      text: text,
      placeholder: placeholder,
      keyboardType: keyboardType,
      inputViewHeight: inputViewHeight
    )
  }

  init(
    style: Style = .solid,
    inputFieldColor: Color,
    state: State = .default,
    text: Binding<String>,
    placeholder: String?,
    keyboardType: UIKeyboardType = .default,
    inputViewHeight: CGFloat = 104
  ) {
    self.style = style
    self.inputFieldColor = inputFieldColor
    self.state = state
    self._text = text
    self.placeholder = placeholder
    self.keyboardType = keyboardType
    self.inputViewHeight = inputViewHeight
  }

  public var body: some View {
    VStack(spacing: 10) {
      inputField
    }
    .onChange(of: state) { newState in
      if newState.isDisabled {
        isTextFieldFocused = false
      }
    }
  }

  private var inputField: some View {
    textEditor
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

  private var textEditor: some View {
    ZStack(alignment: .topLeading) {
      TextEditor(text: $text)
        .scrollIndicators(.visible, axes: .vertical)
        .scrollContentBackground(.hidden)
        .typo(.body1_R, textColor)
        .tint(.neutral700)
        .keyboardType(keyboardType)
        .focused($isTextFieldFocused)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .disabled(!isEditable)

      if text.isEmpty, let placeholderText {
        placeholderText
          .accessibilityHidden(true)
          .allowsHitTesting(false)
          .padding(.top, 8)
          .padding(.leading, 5)
      }
    }
  }

  private func activate() {
    guard isEditable else { return }

    isTextFieldFocused = true
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
          state: state,
          text: .constant(state == .default ? "" : text),
          placeholder: placeholder
        )
        .frame(width: 335)
      }
    }
  }
}
