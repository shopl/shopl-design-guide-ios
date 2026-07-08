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
    case completed
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

  @SwiftUI.State private var internalIsFocused = false
  @SwiftUI.State private var isTextEditorFocused = false

  private let style: Style
  private let placeholder: String?
  private let inputFieldColor: Color
  private let maxCharacterCount: Int?
  private let inputViewHeight: CGFloat

  private var effectiveState: State {
    guard !state.isDisabled else { return .disabled }
    return internalIsFocused || state.isFocused ? .focused : state
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

  private var errorMessage: String? {
    switch state {
    case .error(let message, _): return message
    default: return nil
    }
  }

  private var visibleLineCount: Int {
    max(Int((inputViewHeight - 24) / SDG.Typography.body1_R.lineHeight), 1)
  }

  private var shouldShowPlaceholder: Bool {
    guard text.isEmpty, placeholder != nil else { return false }
    guard !isTextEditorFocused, !internalIsFocused, !state.isFocused else { return false }
    return state == .default
  }

  private var isEditingState: Bool {
    switch effectiveState {
    case .default, .focused: return true
    case .completed, .disabled, .error: return false
    }
  }

  private var focusBinding: Binding<Bool> {
    Binding(
      get: {
        isTextEditorFocused
      },
      set: { newValue in
        guard !state.isDisabled else {
          isTextEditorFocused = false
          internalIsFocused = false
          return
        }

        isTextEditorFocused = newValue
        internalIsFocused = newValue
        state = newValue ? nextFocusedState : nextRestingState
      }
    )
  }

  private var nextRestingState: State {
    if case .error(let message, _) = state {
      return .error(message)
    }

    return text.isEmpty ? .default : .completed
  }

  private var nextFocusedState: State {
    if case .error(let message, _) = state {
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

      if let errorMessage = errorMessage {
        Text(errorMessage)
          .typo(.body3_R, .red300)
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }

  private var inputField: some View {
    ZStack(alignment: .topLeading) {
      if isEditingState {
        textEditor
      } else {
        displayText
      }

      if shouldShowPlaceholder, let placeholder {
        Text(placeholder)
          .typo(.body1_R, .neutral350)
          .lineLimit(visibleLineCount)
          .truncationMode(.tail)
          .allowsHitTesting(false)
      }
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
    SDGTextEditor(
      text: $text,
      isFocused: focusBinding
    )
    .typo(.body1_R, textColor)
    .tint(.neutral700)
    // TextEditor의 기본 내부 여백을 상쇄해 placeholder/display text와 커서 시작점을 맞춥니다.
    .padding(.top, -8)
    .padding(.horizontal, -5)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .scrollContentBackground(.hidden)
    .background(Color.clear)
    .onAppear {
      focusTextEditorIfNeeded()
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
    guard !effectiveState.isDisabled else { return }

    let canFocusImmediately = isEditingState
    internalIsFocused = true
    state = nextFocusedState
    isTextEditorFocused = canFocusImmediately
  }

  private func focusTextEditorIfNeeded() {
    guard effectiveState == .focused, !state.isDisabled else { return }

    DispatchQueue.main.async {
      guard !state.isDisabled else { return }
      isTextEditorFocused = true
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
