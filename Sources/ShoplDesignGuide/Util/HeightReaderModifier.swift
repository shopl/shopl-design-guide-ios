//
//  HeightReaderModifier.swift
//  DesignSystem
//
//  Created by Dino on 7/28/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

extension View {
  func readHeight(to height: Binding<CGFloat>) -> some View {
    self.modifier(HeightReaderModifier(height: height))
  }
}

private struct HeightReaderModifier: ViewModifier {
  @Binding var height: CGFloat
  
  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { geometry in
          Color.clear
            .preference(
              key: HeightPreferenceKey.self,
              value: geometry.size.height
            )
        }
      )
      .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
        DispatchQueue.main.async {
          self.height = newHeight
        }
      }
  }
}

private struct HeightPreferenceKey: PreferenceKey {
  static let defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
}
