//
//  ExpandTouchAreaModifier.swift
//  DesignSystem
//
//  Created by Dino on 8/5/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

extension View {
  public func expandTouchArea(isDisabled: Bool, action: @escaping () -> Void) -> some View {
    self.modifier(ExpandTouchAreaModifier(isDisabled: isDisabled, action: action))
  }
}

private struct ExpandTouchAreaModifier: ViewModifier {
  let action: () -> Void
  let isDisabled: Bool
  
  init(
    isDisabled: Bool,
    action: @escaping () -> Void
  ) {
    self.isDisabled = isDisabled
    self.action = action
  }
  
  func body(content: Content) -> some View {
    ZStack {
      Color.clear
        .contentShape(Rectangle())
        .onTapGesture {
          guard !isDisabled else { return }
          action()
        }
      
      content
    }
  }
}
