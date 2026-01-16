//
//  SDGPopupTitle.swift
//  DesignSystem
//
//  Created by Dino on 7/22/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

public struct SDGPopupTitle: View {
  
  let title: String
  let color: SDG.Color
  let alignment: Alignment
  
  public init(title: String, color: SDG.Color, alignment: Alignment) {
    self.title = title
    self.color = color
    self.alignment = alignment
  }
  
  public var body: some View {
    Text(title)
      .typo(.title2_SB, color)
      .frame(maxWidth: .infinity, alignment: alignment)
  }
}
