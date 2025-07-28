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
  private let topPadding: CGFloat = 4
  private let bottomPadding: CGFloat = 28
  @State private var contentHeight: CGFloat = 0
  
  var contentHeightWithPadding: CGFloat {
    contentHeight + topPadding + bottomPadding
  }
  var scrollDiabled: Bool {
    contentHeightWithPadding <= maxHeight + 1
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
    .padding(.top, topPadding)
    .padding(.bottom, bottomPadding)
    .scrollDisabled(scrollDiabled)
    .frame(maxHeight: min(maxHeight, contentHeightWithPadding))
  }
}
