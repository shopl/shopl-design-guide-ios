//
//  PopupAnimation.swift
//  ShoplDesignGuide
//
//  Created by Dino on 8/21/25.
//

public enum PopupAnimation {
  case fadeInOut
  case slideBottomTop
  
  var presentDuration: Double {
    switch self {
    case .fadeInOut:
      0.0
    case .slideBottomTop:
      0.4
    }
  }
  var dismissDuration: Double {
    switch self {
    case .fadeInOut:
      0.2
    case .slideBottomTop:
      0.1
    }
  }
}
