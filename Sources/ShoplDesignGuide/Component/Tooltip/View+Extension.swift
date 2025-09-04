//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/4/25.
//

import SwiftUI

public extension View {
  func tooltip(
    _ text: String,
    direction: SDGTooltipDirection = .top,
    spec: SDGTooltipSpec = .medium,
    textColor: Color? = nil,
    backgroundColor: Color? = nil,
    maxWidth: CGFloat = 250,
    isPresented: Binding<Bool>
  ) -> some View {
    
    let textColor = textColor ?? .neutral0
    let backgroundColor = backgroundColor ?? .neutral900
    
    return modifier(
      TooltipModifier(
        text: text,
        direction: direction,
        spec: spec,
        textColor: textColor,
        backgroundColor: backgroundColor,
        maxWidth: maxWidth,
        isPresented: isPresented
      )
    )
  }
}
