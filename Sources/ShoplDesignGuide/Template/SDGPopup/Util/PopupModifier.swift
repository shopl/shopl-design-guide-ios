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
  
  @State private var showCover = false
  @State private var opacity: Double = 0.0
  
  public func body(content: Content) -> some View {
    content
      .fullScreenCover(isPresented: $showCover) {
        PopupPresenter(
          opacity: opacity,
          content: popupContent,
          tapOutsideAction: tapOutsideAction
        )
        .background(FullScreenCoverBackgroundRemovalView())
      }
      .onChange(of: isPresented, perform: onPresentationChange)
  }
  
  private func onPresentationChange(presented: Bool) {
    if presented {
      UIView.setAnimationsEnabled(false)
      
      showCover = true
      
      DispatchQueue.main.async {
        withAnimation(.easeInOut(duration: 0.2)) {
          opacity = 1.0
        }
      }
    } else {
      withAnimation(.easeInOut(duration: 0.2)) {
        opacity = 0.0
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        showCover = false
      }
      
      UIView.setAnimationsEnabled(true)
    }
  }
}

private struct FullScreenCoverBackgroundRemovalView: UIViewRepresentable {
  
  private class BackgroundRemovalView: UIView {
    override func didMoveToWindow() {
      super.didMoveToWindow()
      superview?.superview?.backgroundColor = .clear
    }
  }
  
  func makeUIView(context: Context) -> UIView {
    return BackgroundRemovalView()
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {}
}
