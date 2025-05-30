//
//  Font.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

extension Font {
  public static func system(size: CGFloat, weight: Weight = .regular) -> Font {
    if UserDefaults.standard.string(forKey: "language") == "ja" {
      switch weight {
        case .black: return .custom("PretendardJP-Black", fixedSize: size)
        case .heavy: return .custom("PretendardJP-ExtraBold", fixedSize: size)
        case .bold: return .custom("PretendardJP-Bold", fixedSize: size)
        case .semibold: return .custom("PretendardJP-SemiBold", fixedSize: size)
        case .medium: return .custom("PretendardJP-Medium", fixedSize: size)
        case .regular: return .custom("PretendardJP-Regular", fixedSize: size)
        case .light: return .custom("PretendardJP-Light", fixedSize: size)
        case .ultraLight: return .custom("PretendardJP-ExtraLight", fixedSize: size)
        case .thin: return .custom("PretendardJP-Thin", fixedSize: size)
        default: return .system(size: size, weight: weight)
      }
    } else {
      switch weight {
        case .black: return .custom("Pretendard-Black", fixedSize: size)
        case .heavy: return .custom("Pretendard-ExtraBold", fixedSize: size)
        case .bold: return .custom("Pretendard-Bold", fixedSize: size)
        case .semibold: return .custom("Pretendard-SemiBold", fixedSize: size)
        case .medium: return .custom("Pretendard-Medium", fixedSize: size)
        case .regular: return .custom("Pretendard-Regular", fixedSize: size)
        case .light: return .custom("Pretendard-Light", fixedSize: size)
        case .ultraLight: return .custom("Pretendard-ExtraLight", fixedSize: size)
        case .thin: return .custom("Pretendard-Thin", fixedSize: size)
        default: return .system(size: size, weight: weight)
      }
    }
  }
}
