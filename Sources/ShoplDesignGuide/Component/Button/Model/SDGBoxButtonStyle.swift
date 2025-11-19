//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/19/25.
//

import SwiftUI

struct SDGBoxButtonStyle: ButtonStyle {
  
  @Binding private var isSelected: Bool
  
  private let cornerRadius: CGFloat
  private let defaultTextColor: Color
  private let selectedColor: SDGButtonColor
  private var isDisable: Bool
  
  init(
    isSelected: Binding<Bool>,
    cornerRadius: CGFloat,
    defaultTextColor: Color,
    selectedColor: SDGButtonColor,
    isDisable: Bool
  ) {
    self._isSelected = isSelected
    
    self.cornerRadius = cornerRadius
    self.defaultTextColor = defaultTextColor
    self.selectedColor = selectedColor
    self.isDisable = isDisable
  }
  
  func makeBody(configuration: Configuration) -> some View {
    let currentState = getCurrentState(configuration: configuration)
    
    configuration.label
      .applyIf(currentState == .pressed) {
        $0.overlay {
          Color.neutral900.opacity(0.3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .applyIf(currentState == .disabled) {
        $0.opacity(self.defaultTextColor == .neutral0 ? 1 : 0.3)
      }
      .applyIf(currentState == .selected) {
        $0
          .foregroundStyle(self.selectedColor.textColor)
          .background(self.selectedColor.backgroundColor)
          .overlay {
            RoundedRectangle(cornerRadius: self.cornerRadius)
              .strokeBorder(self.selectedColor.lineColor, lineWidth: 1)
          }
      }
      .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
  }
  
  private func getCurrentState(configuration: Configuration) -> ButtonState {
    if isDisable {
      return .disabled
    } else if configuration.isPressed {
      return .pressed
    } else if isSelected {
      return .selected
    } else {
      return .default
    }
  }
}
