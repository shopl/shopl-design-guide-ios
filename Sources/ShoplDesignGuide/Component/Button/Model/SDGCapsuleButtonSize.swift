//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/1/25.
//

import Foundation

public enum SDGCapsuleButtonSize: Equatable {
  case large, medium, small, xsmall
  
  var fontSize: CGFloat {
    switch self {
    case .large: return 16
    case .medium: return 14
    default: return 12
    }
  }
  
  var cornerRadius: CGFloat {
    switch self {
    case .large: return 25
    case .medium: return 18
    case .small: return 14
    case .xsmall: return 10
    }
  }
  
  var height: CGFloat {
    switch self {
    case .large: return 50
    case .medium: return 36
    case .small: return 28
    case .xsmall: return 20
    }
  }
  
  var iconSpacing: CGFloat {
    switch self {
    case .large: return 8
    case .medium: return 4
    case .small, .xsmall: return 2
    }
  }
  
  var iconSize: CGFloat {
    switch self {
    case .large: return 18
    case .medium: return 16
    case .small, .xsmall: return 14
    }
  }
  
  var verticalPadding: CGFloat {
    switch self {
    case .large: return 15
    case .medium: return 9
    case .small: return 6
    case .xsmall: return 2
    }
  }
  
  var horizontalPadding: CGFloat {
    switch self {
    case .large: return 20
    case .medium: return 12
    case .small: return 8
    case .xsmall: return 6
    }
  }
}
