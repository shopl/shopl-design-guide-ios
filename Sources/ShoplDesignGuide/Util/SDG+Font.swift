//
//  SDG+Font.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/27/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

typealias SDGFonts = ShoplDesignGuideFontFamily

extension SDG.Font {
  static func asset(weight: SwiftUI.Font.Weight) -> ShoplDesignGuideFontConvertible {
    
    let isJapanese = UserDefaults.standard.string(forKey: "language") == "ja"
    
    let targetFont: ShoplDesignGuideFontConvertible
    
    if isJapanese {
      switch weight {
      case .black:      targetFont = SDGFonts.PretendardJP.black
      case .heavy:      targetFont = SDGFonts.PretendardJP.extraBold
      case .bold:       targetFont = SDGFonts.PretendardJP.bold
      case .semibold:   targetFont = SDGFonts.PretendardJP.semiBold
      case .medium:     targetFont = SDGFonts.PretendardJP.medium
      case .regular:    targetFont = SDGFonts.PretendardJP.regular
      case .light:      targetFont = SDGFonts.PretendardJP.light
      case .ultraLight: targetFont = SDGFonts.PretendardJP.extraLight
      case .thin:       targetFont = SDGFonts.PretendardJP.thin
      default:          targetFont = SDGFonts.PretendardJP.regular
      }
    } else {
      switch weight {
      case .black:      targetFont = SDGFonts.Pretendard.black
      case .heavy:      targetFont = SDGFonts.Pretendard.extraBold
      case .bold:       targetFont = SDGFonts.Pretendard.bold
      case .semibold:   targetFont = SDGFonts.Pretendard.semiBold
      case .medium:     targetFont = SDGFonts.Pretendard.medium
      case .regular:    targetFont = SDGFonts.Pretendard.regular
      case .light:      targetFont = SDGFonts.Pretendard.light
      case .ultraLight: targetFont = SDGFonts.Pretendard.extraLight
      case .thin:       targetFont = SDGFonts.Pretendard.thin
      default:          targetFont = SDGFonts.Pretendard.regular
      }
    }
    
    return targetFont
  }
}

public extension Font {
  static func system(size: CGFloat, weight: Weight = .regular) -> Font {
    return SDG.Font.asset(weight: weight).swiftUIFont(size: size)
  }
}
