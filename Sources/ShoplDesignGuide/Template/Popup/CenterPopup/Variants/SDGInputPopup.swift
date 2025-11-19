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
    isPresented: Bool,
    title: String,
    bodyText: String,
    inputTitle: String,
    placeholder: String,
    input: Binding<String>,
    maxLength: Int,
    leftButtonOption: SDGCenterPopupButton.Button.Option,
    rightButtonOption: SDGCenterPopupButton.Button.Option,
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
  let leftButtonOption: SDGCenterPopupButton.Button.Option
  let rightButtonOption: SDGCenterPopupButton.Button.Option
  
  var body: some View {
    SDGCenterPopup(
      title: .init(
        title: title,
        color: .neutral700,
        alignment: .leading
      ),
      bodyContent: {
        VStack(spacing: 16) {
          Text(bodyText)
            .typo(.body1_R, .neutral600)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          VStack(spacing: 8) {
            Text(inputTitle)
              .typo(.body1_R, .neutral400)
              .frame(maxWidth: .infinity, alignment: .leading)
            
            SDGFixedTextInput(
              type: .solid,
              text: input,
              placeHolder: placeholder,
              backgroundColor: TypoColor.neutral50.color,
              maxCharacterCount: maxLength,
              isFocused: .constant(false),
              inputViewHeight: 104,
              isError: .constant(nil)
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

#Preview {
  struct PreviewWrapper: View {
    @State private var showPopup = false
    @State private var input: String = ""
    
    var body: some View {
      VStack(spacing: 20) {
        Button("팝업 띄우기") {
          showPopup.toggle()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        
        Text(input)
      }
      
      .centerInputPopup(
        isPresented: showPopup,
        title: "타이틀",
        bodyText: "내용",
        inputTitle: "인풋 타이틀",
        placeholder: "플레이스홀더",
        input: $input,
        maxLength: 50,
        leftButtonOption: .init(
          title: "취소",
          action: { showPopup.toggle() }
        ),
        rightButtonOption: .init(
          title: "확인",
          action: { showPopup.toggle() }
        )
      )
    }
  }
  
  return PreviewWrapper()
}
