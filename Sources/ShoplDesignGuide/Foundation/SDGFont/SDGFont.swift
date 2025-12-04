//
//  SDGFont.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/27/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

public extension Font {
  static func system(size: CGFloat, weight: Weight = .regular) -> Font {
    
    let isJapanese = UserDefaults.standard.string(forKey: "language") == "ja"
    let fontName: String
    
    if isJapanese {
      switch weight {
      case .black:      fontName = ShoplDesignGuideFontFamily.PretendardJP.black.name
      case .heavy:      fontName = ShoplDesignGuideFontFamily.PretendardJP.extraBold.name
      case .bold:       fontName = ShoplDesignGuideFontFamily.PretendardJP.bold.name
      case .semibold:   fontName = ShoplDesignGuideFontFamily.PretendardJP.semiBold.name
      case .medium:     fontName = ShoplDesignGuideFontFamily.PretendardJP.medium.name
      case .regular:    fontName = ShoplDesignGuideFontFamily.PretendardJP.regular.name
      case .light:      fontName = ShoplDesignGuideFontFamily.PretendardJP.light.name
      case .ultraLight: fontName = ShoplDesignGuideFontFamily.PretendardJP.extraLight.name
      case .thin:       fontName = ShoplDesignGuideFontFamily.PretendardJP.thin.name
      default:          fontName = ShoplDesignGuideFontFamily.PretendardJP.regular.name
      }
    } else {
      switch weight {
      case .black:      fontName = ShoplDesignGuideFontFamily.Pretendard.black.name
      case .heavy:      fontName = ShoplDesignGuideFontFamily.Pretendard.extraBold.name
      case .bold:       fontName = ShoplDesignGuideFontFamily.Pretendard.bold.name
      case .semibold:   fontName = ShoplDesignGuideFontFamily.Pretendard.semiBold.name
      case .medium:     fontName = ShoplDesignGuideFontFamily.Pretendard.medium.name
      case .regular:    fontName = ShoplDesignGuideFontFamily.Pretendard.regular.name
      case .light:      fontName = ShoplDesignGuideFontFamily.Pretendard.light.name
      case .ultraLight: fontName = ShoplDesignGuideFontFamily.Pretendard.extraLight.name
      case .thin:       fontName = ShoplDesignGuideFontFamily.Pretendard.thin.name
      default:          fontName = ShoplDesignGuideFontFamily.Pretendard.regular.name
      }
    }
    
    return .custom(fontName, size: size)
  }
}
