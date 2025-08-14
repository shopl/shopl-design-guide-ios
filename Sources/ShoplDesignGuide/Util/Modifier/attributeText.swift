//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

struct TextHighlight {
  let word: String
  let font: Font?
  let color: Color?
  let underline: Bool
}

struct AttributeTextModifier: ViewModifier {
  let fullText: String
  let defaultFont: Font?
  let defaultColor: Color?
  let highlights: [TextHighlight]
  
  func body(content: Content) -> some View {
    var attr = AttributedString(fullText)
    
    if let f = defaultFont {
      attr.font = f
    }
    if let c = defaultColor {
      attr.foregroundColor = c
    }
    
    for hi in highlights {
      if let range = attr.range(of: hi.word) {
        if let f = hi.font {
          attr[range].font = f
        }
        if let c = hi.color {
          attr[range].foregroundColor = c
        }
        if hi.underline {
          attr[range].underlineStyle = .single
        }
      }
    }
    
    return Text(attr)
  }
}

extension View {
  func attributeText(
    fullText: String,
    defaultFont: Font? = nil,
    defaultColor: Color? = nil,
    highlights: [TextHighlight]
  ) -> some View {
    self.modifier(
      AttributeTextModifier(
        fullText: fullText,
        defaultFont: defaultFont,
        defaultColor: defaultColor,
        highlights: highlights
      )
    )
  }
}
