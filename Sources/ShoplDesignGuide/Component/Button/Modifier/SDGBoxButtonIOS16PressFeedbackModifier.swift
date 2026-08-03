//
//  SDGBoxButtonIOS16PressFeedbackModifier.swift
//  ShoplDesignGuide
//
//  Created by dino on 7/24/26.
//

import Foundation
import SwiftUI

extension View {
  func sdgBoxButtonIOS16PressFeedback(
    isDisabled: Bool,
    cornerRadius: CGFloat
  ) -> some View {
    modifier(
      SDGBoxButtonIOS16PressFeedbackModifier(
        isDisabled: isDisabled,
        cornerRadius: cornerRadius
      )
    )
  }
}

private struct SDGBoxButtonIOS16PressFeedbackModifier: ViewModifier {

  private enum PressState: Equatable {
    case idle
    case pressing
    case cancelled
  }

  private let isDisabled: Bool
  private let cornerRadius: CGFloat
  private let cancellationDistance: CGFloat = 10
  private let feedbackDuration: TimeInterval = 0.1

  @GestureState private var pressState: PressState = .idle
  @State private var holdsReleaseFeedback = false
  @State private var feedbackRevision = 0

  init(
    isDisabled: Bool,
    cornerRadius: CGFloat
  ) {
    self.isDisabled = isDisabled
    self.cornerRadius = cornerRadius
  }

  private var showsPressFeedback: Bool {
    !isDisabled && (pressState == .pressing || holdsReleaseFeedback)
  }

  @ViewBuilder
  func body(content: Content) -> some View {
#if os(iOS)
    if #available(iOS 17, *) {
      content
    } else {
      iOS16Body(content: content)
    }
#else
    content
#endif
  }

  private func iOS16Body(content: Content) -> some View {
    content
      .simultaneousGesture(pressGesture)
      .overlay {
        if showsPressFeedback {
          RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.neutral900.opacity(0.1))
            .allowsHitTesting(false)
        }
      }
      .animation(
        .easeInOut(duration: feedbackDuration),
        value: showsPressFeedback
      )
  }

  private var pressGesture: some Gesture {
    DragGesture(minimumDistance: 0)
      .updating($pressState) { value, state, _ in
        guard !isDisabled, state != .cancelled else {
          return
        }

        state = dragDistance(value.translation) < cancellationDistance
          ? .pressing
          : .cancelled
      }
      .onEnded { value in
        guard !isDisabled,
          pressState != .cancelled,
          dragDistance(value.translation) < cancellationDistance
        else {
          cancelReleaseFeedback()
          return
        }

        holdReleaseFeedback()
      }
  }

  private func dragDistance(_ translation: CGSize) -> CGFloat {
    hypot(translation.width, translation.height)
  }

  private func holdReleaseFeedback() {
    feedbackRevision += 1
    let revision = feedbackRevision
    holdsReleaseFeedback = true

    DispatchQueue.main.asyncAfter(deadline: .now() + feedbackDuration) {
      guard feedbackRevision == revision else {
        return
      }

      holdsReleaseFeedback = false
    }
  }

  private func cancelReleaseFeedback() {
    feedbackRevision += 1
    holdsReleaseFeedback = false
  }
}
