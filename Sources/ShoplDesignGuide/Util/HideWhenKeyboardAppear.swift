//
//  HideWhenKeyboardAppear.swift
//  ShoplDesignGuide
//
//  Created by Dino on 9/11/25.
//

import SwiftUI

extension View {
  public func hideWhenKeyboardAppear() -> some View {
    self.modifier(HideWhenKeyboardAppearModifier())
  }
}

struct HideWhenKeyboardAppearModifier: ViewModifier {
  
  @State private var isKeyboardAppeared: Bool = false
  
  func body(content: Content) -> some View {
    content
      .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification),
                 perform: { _ in
        self.isKeyboardAppeared = true
      }).onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
                   perform: { _ in
        self.isKeyboardAppeared = false
      })
      .isHidden(isKeyboardAppeared)
  }
}
