//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/19/25.
//

import Foundation

public enum SDGButtonSize: Equatable {
  case medium, small, xsmall
  
  var fontSize: CGFloat {
    switch self {
    case .medium: return 14
    default: return 12
    }
  }
  
  var cornerRadius: CGFloat {
    switch self {
    case .medium: return 12
    case .small: return 8
    case .xsmall: return 6
    }
  }
  
  var verticalPadding: CGFloat {
    switch self {
    case .medium: return 12
    case .small: return 8
    case .xsmall: return 2
    }
  }
  
  var horizontalPadding: CGFloat {
    switch self {
    case .medium: return 16
    case .small: return 10
    case .xsmall: return 6
    }
  }
}
