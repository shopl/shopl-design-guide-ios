//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

public struct SDGFixedTextForm: View {
  @Binding private var text: String
  @Binding private var isFocused: Bool
  @Binding private var isError: String?

  private let title: String

  private let icon: FormIconModel?
  private let type: FormType

  private let placeHolder: String?
  private let inputFieldColor: Color
  private let maxCharacterCount: Int?
  private let inputViewHeight: CGFloat

  private let isRequiered: Bool

  public init(
    title: String,
    icon: FormIconModel? = nil,
    type: FormType,
    text: Binding<String>,
    placeHolder: String?,
    inputField: SDGFixedTextInput.InputField = .lightGray,
    maxCharacterCount: Int? = nil,
    isFocused: Binding<Bool>,
    inputViewHeight: CGFloat = 104,
    isRequiered: Bool = false,
    isError: Binding<String?> = .constant(nil)
  ) {
    self.title = title
    self.icon = icon
    self.type = type
    self._text = text
    self.placeHolder = placeHolder
    self.inputFieldColor = inputField.color
    self.maxCharacterCount = maxCharacterCount
    self._isFocused = isFocused
    self.inputViewHeight = inputViewHeight
    self.isRequiered = isRequiered
    self._isError = isError
  }

  public init(
    title: String,
    icon: FormIconModel? = nil,
    type: FormType,
    text: Binding<String>,
    placeHolder: String?,
    backgroundColor: Color,
    maxCharacterCount: Int? = nil,
    isFocused: Binding<Bool>,
    inputViewHeight: CGFloat = 94,
    isRequiered: Bool = false,
    isError: Binding<String?> = .constant(nil)
  ) {
    self.title = title
    self.icon = icon
    self.type = type
    self._text = text
    self.placeHolder = placeHolder
    self.inputFieldColor = backgroundColor
    self.maxCharacterCount = maxCharacterCount
    self._isFocused = isFocused
    // 기존 backgroundColor API는 내부 TextEditor 높이 기준이어서 전체 필드 높이를 유지하도록 보정합니다.
    self.inputViewHeight = inputViewHeight + 10
    self.isRequiered = isRequiered
    self._isError = isError
  }

  private var fixedTextInputState: Binding<SDGFixedTextInput.State> {
    Binding(
      get: {
        if let errorMessage = isError {
          return .error(errorMessage, isFocused: isFocused)
        }

        if isFocused {
          return .focused
        }

        return text.isEmpty ? .default : .completed
      },
      set: { newState in
        switch newState {
        case .focused:
          isFocused = true
        case .error(let message, let isFocusedValue):
          isFocused = isFocusedValue
          isError = message
        case .default, .completed, .disabled:
          isFocused = false
        }
      }
    )
  }

  public var body: some View {

    VStack(spacing: 8) {
      HStack(spacing: 0) {
        Text("")
          .attributeText(
            fullText: isRequiered ? "\(title)*" : title,
            defaultFont: self.type == .empha ? .system(size: 16, weight: .semibold) : .system(size: 16),
            defaultColor: .neutral700,
            highlights: [
              .init(
                word: "*",
                font: .system(size: 16),
                color: .red300,
                underline: false
              )
            ]
          )
          .typo(self.type == .empha ? .body1_SB : .body1_R, .neutral700)
          .frame(minHeight: 28, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)

        if let icon = icon {

          Button {
            icon.onImageTap?()
          } label: {
            ZStack {
              icon.image
                .resizable()
                .foregroundStyle(icon.tintColor)
                .frame(width: 14, height: 14)
                .padding(.vertical, 3)
                .padding(.leading, 4)
                .padding(.trailing, 8)
            }
          }
          .buttonStyle(NoTapAnimationButtonStyle())
        }

        Spacer(minLength: 8)
      }

      SDGFixedTextInput(
        style: .solid,
        inputFieldColor: self.inputFieldColor,
        state: fixedTextInputState,
        text: self.$text,
        placeholder: self.placeHolder,
        maxCharacterCount: self.maxCharacterCount,
        inputViewHeight: self.inputViewHeight
      )

    }
  }
}

#Preview {
  VStack {
    SDGFixedTextForm(
      title: "타이틀",
      icon: .init(image: Image(sdg: .icClip), tintColor: .neutral500),
      type: .normal,
      text: .constant("awdawdad"),
      placeHolder: "입력",
      inputField: .lightGray,
      maxCharacterCount: 5000,
      isFocused: .constant(false),
      inputViewHeight: 104,
      isRequiered: false,
      isError: .constant(nil)
    )

    SDGFixedTextForm(
      title: "타이틀",
      icon: .init(image: Image(sdg: .icClip), tintColor: .neutral500),
      type: .normal,
      text: .constant("입력입력입력"),
      placeHolder: "입력",
      inputField: .lightGray,
      maxCharacterCount: 5000,
      isFocused: .constant(false),
      inputViewHeight: 104,
      isRequiered: true,
      isError: .constant(nil)
    )

    SDGFixedTextForm(
      title: "타이틀",
      icon: .init(image: Image(sdg: .icClip), tintColor: .neutral500),
      type: .normal,
      text: .constant(""),
      placeHolder: "입력",
      inputField: .lightGray,
      maxCharacterCount: 5000,
      isFocused: .constant(false),
      inputViewHeight: 104,
      isRequiered: true,
      isError: .constant("에러 에러에러에러에러에러에러에러에러에러에러")
    )
  }
  .padding(20)
}
