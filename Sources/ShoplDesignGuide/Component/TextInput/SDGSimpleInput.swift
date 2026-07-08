//
//  SDGSimpleInput.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGSimpleInput: View {
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
    case completed
    case disabled
    case error(String?)

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
  }

  public enum `Type`: Equatable {
    case solid
    case line(color: Color)
  }

  public enum InputState: Equatable {
    case `default`
    case active
    case completed
    case error(String?)
    case disabled

    var state: State {
      switch self {
      case .default: return .default
      case .active: return .focused
      case .completed: return .completed
      case .error(let message): return .error(message)
      case .disabled: return .disabled
      }
    }

    init(state: State) {
      switch state {
      case .default:
        self = .default
      case .focused:
        self = .active
      case .completed:
        self = .completed
      case .disabled:
        self = .disabled
      case .error(let message):
        self = .error(message)
      }
    }
  }

  @Binding private var state: State
  @Binding private var text: String

  @FocusState private var isTextFieldFocused: Bool
  @SwiftUI.State private var internalIsFocused = false

  private let style: Style
  private let placeholder: String
  private let inputFieldColor: Color
  private let outlinedStrokeColor: Color?
  private let keyboardType: UIKeyboardType
  private let maxCount: Int

  private var effectiveState: State {
    guard !state.isDisabled else { return .disabled }
    return internalIsFocused ? .focused : state
  }

  private var hasError: Bool {
    state.isError || effectiveState.isError
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
      return hasError ? .red300 : outlinedStrokeColor ?? .neutral200
    }
  }

  private var textColor: SDG.Color {
    switch effectiveState {
    case .disabled: return .neutral300
    default: return .neutral700
    }
  }

  private var errorMessage: String? {
    switch state {
    case .error(let message): return message
    default: return nil
    }
  }

  private var isEditingState: Bool {
    switch effectiveState {
    case .default, .focused: return true
    case .completed, .disabled, .error: return false
    }
  }

  private var nextRestingState: State {
    text.isEmpty ? .default : .completed
  }

  public init(
    style: Style = .solid,
    inputField: InputField = .lightGray,
    state: Binding<State>,
    text: Binding<String>,
    placeholder: String,
    keyboardType: UIKeyboardType = .default,
    maxCount: Int = 10000
  ) {
    self.init(
      style: style,
      inputFieldColor: inputField.color,
      outlinedStrokeColor: nil,
      state: state,
      text: text,
      placeholder: placeholder,
      keyboardType: keyboardType,
      maxCount: maxCount
    )
  }

  // 기존 type/state/hint API를 사용하는 호출부 호환용입니다.
  @available(*, deprecated, message: "Use init(style:inputField:state:text:placeholder:keyboardType:maxCount:) instead.")
  public init(
    type: `Type`,
    state: Binding<SDGSimpleInput.InputState>,
    text: Binding<String>,
    hint: String,
    keyboardType: UIKeyboardType = .default,
    backgroundColor: Color? = nil,
    maxCount: Int = 10000
  ) {
    switch type {
    case .solid:
      self.init(
        style: .solid,
        inputFieldColor: backgroundColor ?? .neutral50,
        outlinedStrokeColor: nil,
        state: Binding<State>(
          get: { state.wrappedValue.state },
          set: { state.wrappedValue = InputState(state: $0) }
        ),
        text: text,
        placeholder: hint,
        keyboardType: keyboardType,
        maxCount: maxCount
      )
    case .line(let color):
      self.init(
        style: .outlined,
        inputFieldColor: .neutral0,
        outlinedStrokeColor: color,
        state: Binding<State>(
          get: { state.wrappedValue.state },
          set: { state.wrappedValue = InputState(state: $0) }
        ),
        text: text,
        placeholder: hint,
        keyboardType: keyboardType,
        maxCount: maxCount
      )
    }
  }

  init(
    style: Style,
    inputFieldColor: Color,
    outlinedStrokeColor: Color?,
    state: Binding<State>,
    text: Binding<String>,
    placeholder: String,
    keyboardType: UIKeyboardType,
    maxCount: Int
  ) {
    self.style = style
    self.inputFieldColor = inputFieldColor
    self.outlinedStrokeColor = outlinedStrokeColor
    self._state = state
    self._text = text
    self.placeholder = placeholder
    self.keyboardType = keyboardType
    self.maxCount = maxCount
  }

  public var body: some View {
    VStack(spacing: 10) {
      inputField

      if let errorMessage = errorMessage {
        Text(errorMessage)
          .typo(.body3_R, .red300)
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .onChange(of: state) { newState in
      syncFocus(with: newState)
    }
  }

  private var inputField: some View {
    ZStack(alignment: .leading) {
      if isEditingState {
        textField
      } else {
        displayText
      }
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 10)
    .frame(
      maxWidth: .infinity,
      minHeight: 40,
      maxHeight: 40,
      alignment: .leading
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
    .allowsHitTesting(!effectiveState.isDisabled)
  }

  private var textField: some View {
    TextField("", text: $text)
      .placeholder(when: text.isEmpty) {
        Text(placeholder)
          .typo(.body1_R, .neutral350)
      }
      .typo(.body1_R, textColor)
      .keyboardType(keyboardType)
      .focused($isTextFieldFocused)
      .tint(.neutral700)
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: .leading)
      .onAppear {
        focusTextFieldIfNeeded()
      }
      .onChange(of: text) { newValue in
        sanitizeTextIfNeeded(newValue)
      }
      .onChange(of: isTextFieldFocused) { newValue in
        updateFocus(newValue)
      }
  }

  private var displayText: some View {
    Text(text)
      .typo(.body1_R, textColor)
      .frame(maxWidth: .infinity, alignment: .leading)
      .lineLimit(1)
      .truncationMode(.tail)
  }

  private func activate() {
    guard !effectiveState.isDisabled else { return }

    internalIsFocused = true
    state = .focused
    focusTextFieldIfNeeded()
  }

  private func focusTextFieldIfNeeded() {
    guard effectiveState == .focused, !state.isDisabled else { return }

    DispatchQueue.main.async {
      guard !state.isDisabled else { return }
      isTextFieldFocused = true
    }
  }

  private func updateFocus(_ isFocused: Bool) {
    guard !state.isDisabled else {
      internalIsFocused = false
      isTextFieldFocused = false
      return
    }

    internalIsFocused = isFocused
    state = isFocused ? .focused : nextRestingState
  }

  private func syncFocus(with newState: State) {
    switch newState {
    case .focused:
      internalIsFocused = true
      focusTextFieldIfNeeded()
    case .default:
      if text.isEmpty, !isTextFieldFocused {
        internalIsFocused = false
      }
    case .completed, .disabled, .error:
      internalIsFocused = false
      isTextFieldFocused = false
    }
  }

  // 숫자 키패드와 글자 수 제한 정책에 맞게 입력값을 보정합니다.
  private func sanitizeTextIfNeeded(_ newValue: String) {
    var sanitizedText = newValue

    if keyboardType == .numberPad {
      sanitizedText = sanitizedText.filter { "0123456789".contains($0) }
    }

    if sanitizedText.count > maxCount {
      sanitizedText = String(sanitizedText.prefix(maxCount))
    }

    guard sanitizedText != newValue else { return }
    text = sanitizedText
  }
}

#Preview("Design Resource") {
  SDGSimpleInputDesignResourcePreview()
}

private struct SDGSimpleInputDesignResourcePreview: View {

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
              .completed,
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
              .completed,
              .disabled
            ]
          )

          column(
            style: .outlined,
            inputField: .white,
            states: [
              .default,
              .focused,
              .completed,
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
    style: SDGSimpleInput.Style,
    inputField: SDGSimpleInput.InputField,
    states: [SDGSimpleInput.State]
  ) -> some View {
    VStack(spacing: 10) {
      ForEach(Array(states.enumerated()), id: \.offset) { _, state in
        SDGSimpleInput(
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
