//
//  PopupOverlayModifier.swift
//  ShoplDesignGuide
//
//  Created by Dino on 8/22/25.
//

import SwiftUI
import UIKit

struct PopupOverlayModifier<PopupContent: View>: ViewModifier {

  let isPresented: Bool
  let animation: PopupAnimation
  let tapOutsideAction: (() -> Void)?
  let onDismiss: (() -> Void)
  @ViewBuilder let popupContent: () -> PopupContent

  @State private var showOverlay = false
  @State private var opacity: Double = 0.0
  @State private var contentOffset: CGFloat = 0
  @State private var containerHeight: CGFloat = 0
  @State private var transitionID = 0

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
        GeometryReader { geometry in
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
          .onAppear {
            containerHeight = geometry.size.height
          }
          .onChange(of: geometry.size.height) { height in
            containerHeight = height
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
    transitionID += 1
    let currentTransitionID = transitionID

    if animation == .fadeInOut {
      UIView.setAnimationsEnabled(false)
    }

    if animation == .slideBottomTop {
      opacity = 0.0
      contentOffset = hiddenContentOffset
    }

    showOverlay = true

    DispatchQueue.main.asyncAfter(deadline: .now() + animation.presentDelay + animation.deadlockAvoidanceDelay) {
      guard currentTransitionID == transitionID else {
        return
      }

      withAnimation(.easeInOut(duration: animation.presentDuration)) {
        opacity = 1.0
      }

      if animation == .slideBottomTop {
        withAnimation(.easeOut(duration: animation.presentDuration)) {
          contentOffset = 0
        }
      }
    }
  }

  private func dismiss() {
    transitionID += 1
    let currentTransitionID = transitionID

    withAnimation(.easeInOut(duration: animation.dismissDuration)) {
      opacity = 0.0
    }

    if animation == .slideBottomTop {
      withAnimation(.easeIn(duration: animation.dismissDuration)) {
        contentOffset = hiddenContentOffset
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + dismissCompletionDelay) {
      guard currentTransitionID == transitionID else {
        return
      }

      if animation == .fadeInOut {
        UIView.setAnimationsEnabled(true)
      }

      showOverlay = false
      onDismiss()
    }
  }

  private var hiddenContentOffset: CGFloat {
    containerHeight > 0 ? containerHeight : 2000
  }

  private var dismissCompletionDelay: Double {
    animation.dismissDuration
  }
}
