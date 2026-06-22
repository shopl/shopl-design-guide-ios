//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/19/25.
//

import Foundation

public enum SDGButtonSize: Equatable {
  case medium, small, ssmall, xsmall
  
  var font: SDG.Typography {
    switch self {
    case .medium, .small: return .body2_R
    case .ssmall, .xsmall: return .body3_R
    }
  }
  
  var cornerRadius: CGFloat {
    switch self {
    case .medium: return 12
    case .small: return 10
    case .ssmall: return 10
    case .xsmall: return 6
    }
  }
  
  var iconSpacing: CGFloat {
    switch self {
    case .medium: return 4
    case .small: return 3
    case .ssmall: return 2
    case .xsmall: return 2
    }
  }
  
  var verticalPadding: CGFloat {
    switch self {
    case .medium: return 12
    case .small: return 7
    case .ssmall: return 6
    case .xsmall: return 2
    }
  }
  
  var horizontalPadding: CGFloat {
    switch self {
    case .medium: return 16
    case .small: return 10
    case .ssmall: return 8
    case .xsmall: return 6
    }
  }
}
