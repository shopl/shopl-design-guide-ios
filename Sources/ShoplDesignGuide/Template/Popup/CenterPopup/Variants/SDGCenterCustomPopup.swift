//
//  SDGCenterCustomPopup.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/19/25.
//

import SwiftUI

extension View {
  public func centerCustomPopup<Content: View>(
    isPresented: Bool,
    @ViewBuilder body: @escaping () -> Content,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.modifier(
      PopupModifier(
        isPresented: isPresented,
        animation: .fadeInOut,
        tapOutsideAction: tapOutsideAction
      ) {
        body()
      }
    )
  }
}
