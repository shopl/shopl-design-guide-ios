//
//  PopupAnimation.swift
//  ShoplDesignGuide
//
//  Created by Dino on 8/21/25.
//

public enum PopupAnimation {
  case fadeInOut
  case slideBottomTop
  
  var presentDelay: Double {
    switch self {
    case .fadeInOut:
      return 0
    case .slideBottomTop:
      return 0.4
    }
  }
  var deadlockAvoidanceDelay: Double {
    switch self {
    case .fadeInOut:
      if #available(iOS 17, *) {
        return 0
      } else {
        return 0.1 // iOS 16 이하에서만 발생하는 데드락 회피 위한 지연
      }
    case .slideBottomTop:
      return 0
    }
  }
  var presentDuration: Double {
    switch self {
    case .fadeInOut:
      return 0.1
    case .slideBottomTop:
      return 0.4
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
