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
    leftButtonOption: SDGPopupButton.Button.Option,
    rightButtonOption: SDGPopupButton.Button.Option,
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
        PopupBodyTextType(_title: .init(text: bodyText))
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
