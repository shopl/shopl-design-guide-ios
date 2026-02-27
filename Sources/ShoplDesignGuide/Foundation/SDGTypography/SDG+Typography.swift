//
//  SDGTypography.swift
//  ShoplDesignGuide
//
//  Created by Dino on 1/15/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

extension SDG {
  public enum Typography {
    /// size 19 / weight 400
    case naviTitle
    /// size 44 / weight 600
    case special1_SB
    /// size 28 / weight 600
    case point1_SB
    /// size 28 / weight 400
    case point1_R
    /// size 24 / weight 600
    case point2_SB
    /// size 24 / weight 400
    case point2_R
    /// size 20 / weight 600
    case title1_SB
    /// size 20 / weight 400
    case title1_R
    /// size 18 / weight 600
    case title2_SB
    /// size 18 / weight 400
    case title2_R
    /// size 16 / weight 600
    case body1_SB
    /// size 16 / weight 400
    case body1_R
    /// size 14 / weight 600
    case body2_SB
    /// size 14 / weight 400
    case body2_R
    /// size 12 / weight 600
    case body3_SB
    /// size 12 / weight 400
    case body3_R
    /// size 10 / weight 600
    case body4_SB
    /// size 10 / weight 400
    case body4_R
    
    public var size: CGFloat {
      switch self {
      case .naviTitle: 19
      case .special1_SB: 44
      case .point1_SB, .point1_R: 28
      case .point2_SB, .point2_R: 24
      case .title1_SB, .title1_R: 20
      case .title2_SB, .title2_R: 18
      case .body1_SB, .body1_R: 16
      case .body2_SB, .body2_R: 14
      case .body3_SB, .body3_R: 12
      case .body4_SB, .body4_R: 10
      }
    }
    
    var weight: SwiftUI.Font.Weight {
      switch self {
      case  .special1_SB, .point1_SB, .point2_SB, .title1_SB, .title2_SB, .body1_SB, .body2_SB, .body3_SB, .body4_SB: .semibold
      case .naviTitle, .point1_R, .point2_R, .title1_R, .title2_R, .body1_R, .body2_R, .body3_R, .body4_R: .regular
      }
    }
    
    var lineHeight: CGFloat {
      switch self {
      case .naviTitle: 24
      case .special1_SB: 48
      case .point1_SB, .point1_R: 32
      case .point2_SB, .point2_R: 28
      case .title1_SB, .title1_R: 24
      case .title2_SB, .title2_R: 22
      case .body1_SB, .body1_R: 20
      case .body2_SB, .body2_R: 18
      case .body3_SB, .body3_R: 16
      case .body4_SB, .body4_R: 16
      }
    }
    
    var fontName: String {
      let fontAsset = SDG.Font.asset(weight: self.weight)
      return fontAsset.name
    }
    
    var uiFontLineHeight: CGFloat {
      return UIFont(name: fontName, size: size)?.lineHeight ?? size
    }
  }
}
