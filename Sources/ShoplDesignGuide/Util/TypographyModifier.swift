//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

extension View {
  public func typo(_ type: SDG.Typography, _ color: SDG.Color) -> some View {
    modifier(TypographyModifier(type: type, color: color.color))
  }
  
  public func typo(_ type: SDG.Typography) -> some View {
    modifier(TypographyModifier(type: type, color: nil))
  }
}

struct TypographyModifier: ViewModifier {
  let type: SDG.Typography
  let color: Color?
  
  public init(type: SDG.Typography, color: Color?) {
    self.type = type
    self.color = color
  }
  
  func body(content: Content) -> some View {
    let fontAsset = SDG.Font.asset(weight: type.weight)
    
    content
      .font(fontAsset.swiftUIFont(size: type.size))
      .lineSpacing(type.lineHeight - type.uiFontLineHeight)
    
    if let color = color {
      content.foregroundStyle(color)
    } else {
      content
    }
  }
}
