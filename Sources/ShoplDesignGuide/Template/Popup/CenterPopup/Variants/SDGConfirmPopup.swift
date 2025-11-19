//
//  SDGConfirmPopup.swift
//  DesignSystem
//
//  Created by Dino on 7/24/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

extension View {
  public func centerConfirmPopup(
    isPresented: Bool,
    title: String,
    bodyText: String,
    leftButtonOption: SDGCenterPopupButton.Button.Option,
    rightButtonOption: SDGCenterPopupButton.Button.Option,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.modifier(
      PopupModifier(
        isPresented: isPresented,
        tapOutsideAction: tapOutsideAction
      ) {
        SDGConfirmPopup(
          title: title,
          bodyText: bodyText,
          leftButtonOption: leftButtonOption,
          rightButtonOption: rightButtonOption
        )
      }
    )
  }
}

private struct SDGConfirmPopup: View {
  
  let title: String
  let bodyText: String
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
        Text(bodyText)
          .typo(.body1_R, .neutral600)
          .frame(maxWidth: .infinity, alignment: .leading)
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
    
    var body: some View {
      Button("팝업 띄우기") {
        showPopup.toggle()
      }
      .padding()
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(8)
      .centerConfirmPopup(
        isPresented: showPopup,
        title: "타이틀",
        bodyText: "내용",
        leftButtonOption: .init(
          title: "취소",
          action: { showPopup.toggle() }),
        rightButtonOption: .init(
          title: "확인",
          action: { showPopup.toggle() }
        )
      )
    }
  }
  
  return PreviewWrapper()
}
