//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

public enum Typography {
  case naviTitle
  
  case title1_SB // semi bold
  case title1_R // regular
  case title2_SB
  case title2_R
  case body1_SB
  case body1_R
  case body2_SB
  case body2_R
  case body3_SB
  case body3_R
  
  var size: CGFloat {
    switch self {
    case .naviTitle: 19
    case .title1_SB, .title1_R: 20
    case .title2_SB, .title2_R: 18
    case .body1_SB, .body1_R: 16
    case .body2_SB, .body2_R: 14
    case .body3_SB, .body3_R: 12
    }
  }
  
  var weight: Font.Weight {
    switch self {
    case .title1_SB, .title2_SB, .body1_SB, .body2_SB, .body3_SB: .semibold
    case .naviTitle, .title1_R, .title2_R, .body1_R, .body2_R, .body3_R: .regular
    }
  }
  
  var lineHeight: CGFloat {
    switch self {
    case .naviTitle: 24
    case .title1_SB, .title1_R: 24
    case .title2_SB, .title2_R: 22
    case .body1_SB, .body1_R: 20
    case .body2_SB, .body2_R: 18
    case .body3_SB, .body3_R: 16
    }
  }
  
  var uiFontLineHeight: CGFloat {
    var uiFontName: String
    if UserDefaults.standard.string(forKey: "language") == "ja"  {
      if self.weight == .semibold {
        uiFontName = "PretendardJP-SemiBold"
      } else {
        uiFontName = "PretendardJP-Regular"
      }
    } else {
      if self.weight == .semibold {
        uiFontName = "Pretendard-SemiBold"
      } else {
        uiFontName = "Pretendard-Regular"
      }
    }
    return UIFont(name: uiFontName, size: self.size)?.lineHeight ?? self.size
  }
}

struct TypographyModifier: ViewModifier {
  let type: Typography
  let color: Color
  
  public init(type: Typography, color: Color) {
    self.type = type
    self.color = color
  }
  
  func body(content: Content) -> some View {
    content
      .font(.system(size: type.size, weight: type.weight))
      .foregroundStyle(color)
      .lineSpacing(type.lineHeight - type.uiFontLineHeight)
  }
}

extension View {
  public func typo(_ type: Typography, _ color: TypoColor) -> some View {
    modifier(TypographyModifier(type: type, color: color.color))
  }
}

// MARK: - Typogrphy Color
public enum TypoColor {
  case green
  case lemon
  case neutral0
  case neutral50
  case neutral100
  case neutral150
  case neutral200
  case neutral250
  case neutral300
  case neutral350
  case neutral400
  case neutral500
  case neutral600
  case neutral700
  case neutral900
  case orange
  case pink
  case primary50
  case primary200
  case primary300
  case primary400
  case purple
  case red50
  case red300
  case red350
  case red400
  case secondary50
  case secondary200
  case secondary300
  case secondary400
  case yellow
  
  var color: Color {
    switch self {
      case .green: Color.sdgGreen
      case .lemon: Color.sdgLemon
      case .neutral0: Color.neutral0
      case .neutral50: Color.neutral50
      case .neutral100: Color.neutral100
      case .neutral150: Color.neutral150
      case .neutral200: Color.neutral200
      case .neutral250: Color.neutral250
      case .neutral300: Color.neutral300
      case .neutral350: Color.neutral350
      case .neutral400: Color.neutral400
      case .neutral500: Color.neutral500
      case .neutral600: Color.neutral600
      case .neutral700: Color.neutral700
      case .neutral900: Color.neutral900
      case .orange: Color.sdgOrange
      case .pink: Color.sdgPink
      case .primary50: Color.primary50
      case .primary200: Color.primary200
      case .primary300: Color.primary300
      case .primary400: Color.primary400
      case .purple: Color.sdgPurple
      case .red50:  Color.red50
      case .red300: Color.red300
      case .red350: Color.red350
      case .red400: Color.red400
      case .secondary50: Color.secondary50
      case .secondary200: Color.secondary200
      case .secondary300: Color.secondary300
      case .secondary400: Color.secondary400
      case .yellow: Color.sdgYellow
    }
  }
}
