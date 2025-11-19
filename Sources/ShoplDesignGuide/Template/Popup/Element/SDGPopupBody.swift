//
//  SDGPopupBody.swift
//  DesignSystem
//
//  Created by Dino on 7/22/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

public struct SDGPopupBody<Content: View>: View {
  
  private let content: Content
  private let maxHeight: CGFloat
  @State private var contentHeight: CGFloat = 0
  
  var scrollDisabled: Bool {
    contentHeight <= maxHeight + 1
  }
  
  init(
    maxHeight: CGFloat,
    @ViewBuilder content: () -> Content
  ) {
    self.maxHeight = maxHeight
    self.content = content()
  }
  
  public var body: some View {
    ScrollView(showsIndicators: false) {
      content
        .readHeight(to: $contentHeight)
    }
    .scrollDisabled(scrollDisabled)
    .frame(maxHeight: min(maxHeight, contentHeight))
  }
}
