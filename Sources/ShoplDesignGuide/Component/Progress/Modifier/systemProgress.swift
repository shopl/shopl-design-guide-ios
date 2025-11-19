//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

extension View {
  public func systmProgress(
    isLoading: Binding<Bool>,
    color: Color? = nil
  ) -> some View {
    self.modifier(
      BlurOverlay(isLoading: isLoading, color: color)
    )
  }
}

private struct BlurOverlay: ViewModifier {
  @Binding var isLoading: Bool
  var color: Color?
  
  func body(content: Content) -> some View {
    ZStack {
      content
        .blur(radius: 4)
      
      SDGSystemProgress(color: color)
    }
  }
}

#Preview {
  ZStack {
    Text("테스트 테스트 테스트")
  }
  .systmProgress(isLoading: .constant(true))
}
