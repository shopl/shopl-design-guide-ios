//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/18/25.
//

import SwiftUI

// MARK: - FrameGetter

struct FrameGetter: ViewModifier {
  
  @Binding var frame: CGRect
  
  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { proxy -> AnyView in
          DispatchQueue.main.async {
            let rect = proxy.frame(in: .global)
            
            if rect.integral != self.frame.integral {
              self.frame = rect
            }
          }
          return AnyView(EmptyView())
        }
      )
  }
}

extension View {
  func frameGetter(_ frame: Binding<CGRect>) -> some View {
    modifier(FrameGetter(frame: frame))
  }
}
