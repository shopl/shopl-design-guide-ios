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
  @ViewBuilder let content: () -> PopupContent
  let tapOutsideAction: (() -> Void)?

  public var body: some View {
    ZStack {
      TypoColor.neutral900.color.opacity(0.4)
        .ignoresSafeArea()
        .onTapGesture {
          tapOutsideAction?()
        }
      
      content()
    }
    .opacity(opacity)
  }
}
