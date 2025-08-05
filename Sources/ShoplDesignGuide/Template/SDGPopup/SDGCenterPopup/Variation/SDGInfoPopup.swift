//
//  SDGInfoPopup.swift
//  DesignSystem
//
//  Created by Dino on 7/24/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

extension View {
  public func centerInfoPopup(
    isPresented: Bool,
    title: String,
    bodyText: String,
    buttonOption: SDGPopupButton.Button.Option,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.modifier(
      PopupModifier(
        isPresented: isPresented,
        tapOutsideAction: tapOutsideAction
      ) {
        SDGInfoPopup(
          title: title,
          bodyText: bodyText,
          buttonOption: buttonOption
        )
      }
    )
  }
}

private struct SDGInfoPopup: View {
  
  let title: String
  let bodyText: String
  let buttonOption: SDGPopupButton.Button.Option
  
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
      button: .init(button: .oneOption(option: buttonOption))
    )
  }
}
