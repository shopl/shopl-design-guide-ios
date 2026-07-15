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

  private let state: State
  @Binding private var text: String

  @FocusState private var isTextFieldFocused: Bool
  @SwiftUI.State private var internalIsFocused = false

  private let style: Style
  private let placeholder: String
  private let inputFieldColor: Color
  private let keyboardType: UIKeyboardType
  private let maxCount: Int

  private var effectiveState: State {
    guard !state.isDisabled else { return .disabled }
    // 외부에서 에러 상태가 들어와도 실제 TextField가 포커스 중이면 편집을 유지함.
    // state 변경과 FocusState 갱신 사이의 한 프레임 차이로 키보드가 내려가는 것을 방지함.
    return internalIsFocused || isTextFieldFocused ? .focused : state
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
      return hasError ? .red300 : .neutral200
    }
  }

  private var textColor: SDG.Color {
    switch effectiveState {
    case .disabled: return .neutral300
    default: return .neutral700
    }
  }

  private var placeholderColor: SDG.Color {
    switch effectiveState {
    case .disabled: return .neutral300
    default: return .neutral350
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

  public init(
    style: Style = .solid,
    inputField: InputField = .lightGray,
    state: State = .default,
    text: Binding<String>,
    placeholder: String,
    keyboardType: UIKeyboardType = .default,
    maxCount: Int = 10000
  ) {
    self.init(
      style: style,
      inputFieldColor: inputField.color,
      state: state,
      text: text,
      placeholder: placeholder,
      keyboardType: keyboardType,
      maxCount: maxCount
    )
  }

  public init(
    style: Style = .solid,
    inputFieldColor: Color,
    state: State = .default,
    text: Binding<String>,
    placeholder: String,
    keyboardType: UIKeyboardType = .default,
    maxCount: Int = 10000
  ) {
    self.style = style
    self.inputFieldColor = inputFieldColor
    self.state = state
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
          .typo(.body1_R, placeholderColor)
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
      .placeholder(when: text.isEmpty) {
        Text(placeholder)
          .typo(.body1_R, placeholderColor)
      }
      .typo(.body1_R, textColor)
      .frame(maxWidth: .infinity, alignment: .leading)
      .lineLimit(1)
      .truncationMode(.tail)
  }

  private func activate() {
    guard !effectiveState.isDisabled else { return }

    internalIsFocused = true
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
    case .completed, .disabled:
      internalIsFocused = false
      isTextFieldFocused = false
    case .error:
      // 실시간 검증 중 에러가 주입되어도 키보드가 내려가지 않도록 현재 포커스를 유지합니다.
      break
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
          state: state,
          text: .constant(state == .default ? "" : text),
          placeholder: placeholder
        )
        .frame(width: 335)
      }
    }
  }
}
