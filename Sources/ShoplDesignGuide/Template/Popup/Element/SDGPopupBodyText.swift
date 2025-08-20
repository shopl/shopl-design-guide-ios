//
//  SDGPopupBodyText.swift
//  DesignSystem
//
//  Created by Dino on 7/28/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

public struct SDGPopupBodyText: View {
  
  let bodyText: String
  let color: TypoColor
  let alignment: Alignment
  let labelWeight: LabelWeight
  
  public enum LabelWeight {
    case R
    case SB
    
    var typo: Typography {
      switch self {
      case .R:
        return .body1_R
      case .SB:
        return .body1_SB
      }
    }
  }
  
  public init(bodyText: String, labelWeight: LabelWeight, color: TypoColor, alignment: Alignment) {
    self.bodyText = bodyText
    self.labelWeight = labelWeight
    self.color = color
    self.alignment = alignment
  }
  
  public var body: some View {
    Text(bodyText)
      .typo(labelWeight.typo, color)
      .frame(maxWidth: .infinity, alignment: alignment)
  }
}
