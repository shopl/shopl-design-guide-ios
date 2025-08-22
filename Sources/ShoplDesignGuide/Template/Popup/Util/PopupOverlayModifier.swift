//
//  PopupOverlayModifier.swift
//  ShoplDesignGuide
//
//  Created by Dino on 8/22/25.
//

import SwiftUI

struct PopupOverlayModifier<PopupContent: View>: ViewModifier {
  
  let isPresented: Bool
  let animation: PopupAnimation
  let tapOutsideAction: (() -> Void)?
  let onDismiss: (() -> Void)
  @ViewBuilder let popupContent: () -> PopupContent
  
  @State private var showOverlay = false
  @State private var opacity: Double = 0.0
  @State private var contentOffset: CGFloat = 0
  
  init(
    isPresented: Bool,
    animation: PopupAnimation,
    tapOutsideAction: (() -> Void)?,
    onDismiss: @escaping () -> Void,
    popupContent: @escaping () -> PopupContent
  ) {
    self.isPresented = isPresented
    self.animation = animation
    self.tapOutsideAction = tapOutsideAction
    self.onDismiss = onDismiss
    self.popupContent = popupContent
  }
  
  func body(content: Content) -> some View {
    content
      .overlay {
        ZStack {
          if showOverlay {
            PopupPresenter(
              opacity: opacity,
              animation: animation,
              content: {
                popupContent()
                  .offset(y: contentOffset)
              },
              tapOutsideAction: tapOutsideAction
            )
          }
        }
      }
      .onChange(of: isPresented, perform: onPresentationChange)
  }
  
  private func onPresentationChange(presented: Bool) {
    if presented {
      present()
    } else {
      dismiss()
    }
  }
  
  private func present() {
    if animation == .fadeInOut {
      UIView.setAnimationsEnabled(false)
    }
    
    showOverlay = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + animation.presentDuration) {
      withAnimation(.easeInOut(duration: 0.1)) {
        opacity = 1.0
      }
    }
  }
  
  private func dismiss() {
    withAnimation(.easeInOut(duration: animation.dismissDuration)) {
      opacity = 0.0
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + animation.dismissDuration) {
      if animation == .slideBottomTop {
        withAnimation(.easeOut(duration: animation.dismissDuration)) {
          contentOffset = 400
        }
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + animation.dismissDuration) {
        if animation == .fadeInOut {
          UIView.setAnimationsEnabled(true)
        }
        
        showOverlay = false
        onDismiss()
      }
    }
  }
}
