//
//  Image+extension.swift
//  ShoplDesignGuide
//
//  Created by Dino on 8/20/25.
//

import SwiftUI

extension Image {
  public func templateIcon(
    size: CGFloat,
    color: Color
  ) -> some View {
    self
      .resizable()
      .renderingMode(.template)
      .frame(width: size, height: size)
      .foregroundStyle(color)
  }
}
