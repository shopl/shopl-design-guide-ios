//
//  PopupPresenter.swift
//  Util
//
//  Created by Dino on 7/23/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

public struct PopupPresenter<PopupContent: View>: View {
  
  let isPresented: Bool
  @ViewBuilder let content: () -> PopupContent
  let tapOutsideAction: (() -> Void)?
  
  public init(isPresented: Bool, content: @escaping () -> PopupContent, tapOutsideAction: (() -> Void)?) {
    self.isPresented = isPresented
    self.content = content
    self.tapOutsideAction = tapOutsideAction
  }
  
  public var body: some View {
    if isPresented {
      ZStack {
        TypoColor.neutral900.color.opacity(0.4)
          .ignoresSafeArea()
          .onTapGesture {
            tapOutsideAction?()
          }
        
        content()
      }
      .transition(.opacity.animation(.easeInOut(duration: 0.2)))
    }
  }
}
