//
//  PopupPresenter.swift
//  Util
//
//  Created by Dino on 7/23/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

public struct PopupPresenter<PopupContent: View>: View {
  
  let opacity: Double
  let animation: PopupAnimation
  @ViewBuilder let content: () -> PopupContent
  let tapOutsideAction: (() -> Void)?
  
  public var body: some View {
    ZStack {
      let background = Color.neutral900.opacity(0.4)
        .ignoresSafeArea()
        .onTapGesture {
          tapOutsideAction?()
        }
      
      if animation == .slideBottomTop {
        background.opacity(opacity)
        content()
      } else {
        Group {
          background
          content()
        }
        .opacity(opacity)
      }
    }
  }
}
