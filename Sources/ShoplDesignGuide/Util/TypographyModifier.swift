//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

public enum Typography {
  case naviTitle
  
  case special1_SB
  
  case point1_SB
  case point1_R
  case point2_SB
  case point2_R
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
  case body4_SB
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
  
  var weight: Font.Weight {
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
  
  public init(color: Color) {
    switch color {
    case .neutral0: self = .neutral0
    case .neutral50: self = .neutral50
    case .neutral100: self = .neutral100
    case .neutral150: self = .neutral150
    case .neutral200: self = .neutral200
    case .neutral250: self = .neutral250
    case .neutral300: self = .neutral300
    case .neutral350: self = .neutral350
    case .neutral400: self = .neutral400
    case .neutral500: self = .neutral500
    case .neutral600: self = .neutral600
    case .neutral700: self = .neutral700
    case .neutral900: self = .neutral900
    case .sdgGreen: self = .green
    case .sdgLemon: self = .lemon
    case .sdgOrange: self = .orange
    case .sdgSpecialPink: self = .pink
    case .sdgPurple: self = .purple
    case .sdgYellow: self = .yellow
    case .primary50: self = .primary50
    case .primary200: self = .primary200
    case .primary300: self = .primary300
    case .primary400: self = .primary400
    case .red50: self = .red50
    case .red300: self = .red300
    case .red350: self = .red350
    case .red400: self = .red400
    case .secondary50: self = .secondary50
    case .secondary200: self = .secondary200
    case .secondary300: self = .secondary300
    case .secondary400: self = .secondary400
    default: self = .neutral0  // fallback
    }
  }
  
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
      case .pink: Color.sdgSpecialPink
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
