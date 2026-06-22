//
//  SDGPopupModifier.swift
//  Util
//
//  Created by Dino on 7/23/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI
import UIKit

public struct PopupModifier<PopupContent: View>: ViewModifier {

  let isPresented: Bool
  let animation: PopupAnimation
  let tapOutsideAction: (() -> Void)?

  @ViewBuilder let popupContent: () -> PopupContent

  @State private var showCover = false
  @State private var opacity: Double = 0.0

  init(
    isPresented: Bool,
    animation: PopupAnimation,
    tapOutsideAction: (() -> Void)?,
    popupContent: @escaping () -> PopupContent
  ) {
    self.isPresented = isPresented
    self.animation = animation
    self.tapOutsideAction = tapOutsideAction
    self.popupContent = popupContent
  }

  @ViewBuilder public func body(content: Content) -> some View {
    switch animation {
    case .slideBottomTop:
      content
        .background(
          PopupViewControllerPresenter(
            isPresented: isPresented,
            animation: animation,
            tapOutsideAction: tapOutsideAction,
            popupContent: popupContent
          )
        )
    case .fadeInOut:
      content
        .fullScreenCover(isPresented: $showCover, onDismiss: {
          UIView.setAnimationsEnabled(true)
        }) {
          PopupPresenter(
            opacity: opacity,
            animation: animation,
            content: popupContent,
            tapOutsideAction: tapOutsideAction
          )
          .background(FullScreenCoverBackgroundRemovalView())
        }
        .onChange(of: isPresented, perform: onPresentationChange)
        .onAppear {
          if isPresented {
            onPresentationChange(presented: isPresented)
          }
        }
    }
  }

  private func onPresentationChange(presented: Bool) {
    if presented {
      present()
    } else {
      dismiss()
    }
  }

  private func present() {
    UIView.setAnimationsEnabled(false)
    var transaction = Transaction()
    transaction.disablesAnimations = true
    withTransaction(transaction) {
      showCover = true
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + animation.presentDelay + animation.deadlockAvoidanceDelay) {
      withAnimation(.easeInOut(duration: animation.presentDuration)) {
        opacity = 1.0
      }
    }
  }

  private func dismiss() {
    withAnimation(.easeInOut(duration: animation.dismissDuration)) {
      opacity = 0.0
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + animation.dismissDuration) {
      var transaction = Transaction()
      transaction.disablesAnimations = true
      withTransaction(transaction) {
        showCover = false
      }
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
