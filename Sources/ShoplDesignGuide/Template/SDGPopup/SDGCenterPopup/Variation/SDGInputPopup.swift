//
//  SDGInputPopup.swift
//  DesignSystem
//
//  Created by Dino on 7/24/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

extension View {
  public func centerInputPopup(
    isPresented: Binding<Bool>,
    title: String,
    bodyText: String,
    inputTitle: String,
    placeholder: String,
    input: Binding<String>,
    maxLength: Int,
    buttonState: Binding<SDGPopupButton.Status>,
    leftButtonOption: SDGPopupButton.Button.Option,
    rightButtonOption: SDGPopupButton.Button.Option,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.modifier(
      PopupModifier(
        isPresented: isPresented,
        tapOutsideAction: tapOutsideAction
      ) {
        SDGInputPopup(
          title: title,
          bodyText: bodyText,
          inputTitle: inputTitle,
          placeholder: placeholder,
          input: input,
          maxLength: maxLength,
          buttonState: buttonState,
          leftButtonOption: leftButtonOption,
          rightButtonOption: rightButtonOption
        )
      }
    )
  }
}

private struct SDGInputPopup: View {
  
  let title: String
  let bodyText: String
  let inputTitle: String
  let placeholder: String
  let input: Binding<String>
  let maxLength: Int
  let buttonState: Binding<SDGPopupButton.Status>
  let leftButtonOption: SDGPopupButton.Button.Option
  let rightButtonOption: SDGPopupButton.Button.Option
  
  var body: some View {
    SDGCenterPopup(
      title: .init(
        title: title,
        color: .neutral700,
        alignment: .leading
      ),
      bodyContent: {
        VStack(spacing: 16) {
          PopupBodyTextType(_title: .init(text: bodyText))
          
          VStack(spacing: 8) {
            Text(inputTitle)
              .typo(.body1_R, .neutral400)
              .frame(maxWidth: .infinity, alignment: .leading)
            
            FixedInput(
              text: input,
              placeHolder: placeholder,
              backgroundColor: TypoColor.neutral50.color,
              outlineColor: nil,
              maxCharacterCount: maxLength,
              isFocused: .constant(false),
              inputViewHeight: 104,
              isError: .constant(false)
            )
          }
        }
      },
      button: .init(
        button: .twoOptions(
          option1: leftButtonOption,
          option2: rightButtonOption
        )
      )
    )
  }
}
