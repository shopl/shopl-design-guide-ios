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

  @FocusState private var isTextEditorFocused: Bool
  @SwiftUI.State private var internalIsFocused = false

  private let style: Style
  private let placeholder: String?
  private let inputFieldColor: Color
  private let maxCharacterCount: Int?
  private let inputViewHeight: CGFloat

  private var hasError: Bool {
    state.isError
  }

  private var isFocusActive: Bool {
    internalIsFocused
      || isTextEditorFocused
      || state.isFocused
  }

  private var effectiveState: State {
    state
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

  private var visibleLineCount: Int {
    max(Int((inputViewHeight - 24) / SDG.Typography.body1_R.lineHeight), 1)
  }

  private var shouldShowPlaceholder: Bool {
    text.isEmpty && placeholder != nil
  }

  private var isEditingState: Bool {
    guard !state.isDisabled else { return false }

    if isFocusActive {
      return true
    }

    switch state {
    case .default, .focused:
      return text.isEmpty
    case .disabled, .error:
      return false
    }
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
    maxCharacterCount: Int? = nil,
    inputViewHeight: CGFloat = 104
  ) {
    self.init(
      style: style,
      inputFieldColor: inputField.color,
      state: state,
      text: text,
      placeholder: placeholder,
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
    maxCharacterCount: Int? = nil,
    inputViewHeight: CGFloat = 104
  ) {
    UITextView.appearance().backgroundColor = .clear

    self.style = style
    self.inputFieldColor = inputFieldColor
    self._state = state
    self._text = text
    self.placeholder = placeholder
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
    ZStack(alignment: .topLeading) {
      textEditor
        .opacity(isEditingState ? 1 : 0)
        .allowsHitTesting(isEditingState)
        .accessibilityHidden(!isEditingState)

      displayText
        .opacity(isEditingState ? 0 : 1)
        .allowsHitTesting(!isEditingState)
        .accessibilityHidden(isEditingState)

      Text(placeholder ?? "")
        .typo(.body1_R, .neutral350)
        .lineLimit(visibleLineCount)
        .truncationMode(.tail)
        .opacity(shouldShowPlaceholder ? 1 : 0)
        .allowsHitTesting(false)
        .accessibilityHidden(!shouldShowPlaceholder)
    }
    .padding(12)
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
    .allowsHitTesting(!effectiveState.isDisabled)
  }

  private var textEditor: some View {
    TextEditor(text: $text)
      .typo(.body1_R, textColor)
      .tint(.neutral700)
      // TextEditor의 기본 내부 여백을 상쇄해 placeholder/display text와 커서 시작점을 맞춥니다.
      .padding(.top, -8)
      .padding(.horizontal, -5)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .focused($isTextEditorFocused)
      .scrollContentBackground(.hidden)
      .background(Color.clear)
      .onAppear {
        focusTextEditorIfNeeded()
      }
      .onChange(of: isTextEditorFocused) { isFocused in
        updateFocus(isFocused)
      }
      .onChange(of: text) { newValue in
        limitTextIfNeeded(newValue)
      }
  }

  private var displayText: some View {
    Text(text)
      .typo(.body1_R, textColor)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .multilineTextAlignment(.leading)
      .lineLimit(visibleLineCount)
      .truncationMode(.tail)
  }

  private func activate() {
    guard !state.isDisabled else { return }

    setFocusActive(true)
    focusTextEditorIfNeeded()
  }

  private func focusTextEditorIfNeeded() {
    guard isFocusActive, !state.isDisabled else { return }

    DispatchQueue.main.async {
      guard !state.isDisabled else { return }
      isTextEditorFocused = true
    }
  }

  private func updateFocus(_ isFocused: Bool) {
    if isFocused {
      setFocusActive(true)
      return
    }

    deferFocusReleaseIfNeeded()
  }

  private func setFocusActive(_ isFocused: Bool) {
    guard !state.isDisabled else {
      clearFocus()
      return
    }

    internalIsFocused = isFocused

    let newState = isFocused ? nextFocusedState : nextRestingState
    if state != newState {
      state = newState
    }
  }

  private func syncFocus(with newState: State) {
    switch newState {
    case .focused, .error(_, isFocused: true):
      setFocusActive(true)
      focusTextEditorIfNeeded()
    case .disabled:
      clearFocus()
    case .default, .error:
      if !isTextEditorFocused {
        internalIsFocused = false
      }
    }
  }

  private func clearFocus() {
    internalIsFocused = false
    isTextEditorFocused = false
  }

  private func deferFocusReleaseIfNeeded() {
    DispatchQueue.main.async {
      guard !isTextEditorFocused else { return }
      setFocusActive(false)
    }
  }

  // 팝업과 폼 입력값이 설정된 글자 수 제한을 넘지 않도록 보정합니다.
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
