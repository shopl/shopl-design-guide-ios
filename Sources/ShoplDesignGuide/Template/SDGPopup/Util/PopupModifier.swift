//
//  SDGPopupModifier.swift
//  Util
//
//  Created by Dino on 7/23/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

public struct PopupModifier<PopupContent: View>: ViewModifier {
  let isPresented: Bool
  let tapOutsideAction: (() -> Void)?
  @ViewBuilder let popupContent: () -> PopupContent
  
  public init(
    isPresented: Bool,
    tapOutsideAction: (() -> Void)? = nil,
    @ViewBuilder popupContent: @escaping () -> PopupContent
  ) {
    self.isPresented = isPresented
    self.tapOutsideAction = tapOutsideAction
    self.popupContent = popupContent
  }
  
  public func body(content: Content) -> some View {
    ZStack {
      content
      
      PopupPresenter(
        isPresented: isPresented,
        content: popupContent,
        tapOutsideAction: tapOutsideAction
      )
    }
  }
}
