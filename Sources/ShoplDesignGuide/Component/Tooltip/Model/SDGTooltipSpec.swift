//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/4/25.
//

import Foundation

public enum SDGTooltipSpec {
  case medium
  case small
  
  var fontSize: CGFloat {
    switch self {
    case .medium: return 14
    case .small: return 12
    }
  }
  
  var horizontalPadding: CGFloat {
    switch self {
    case .medium: return 10
    case .small: return 4
    }
  }
  
  var verticalPadding: CGFloat {
    switch self {
    case .medium: return 6
    case .small: return 2
    }
  }
}
