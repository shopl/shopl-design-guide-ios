//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/14/25.
//

import SwiftUI

public enum TopNaviType: Equatable {
  public static func == (lhs: TopNaviType, rhs: TopNaviType) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
      return true
    case (.dismiss, .dismiss):
      return true
    case (.pop, .pop):
      return true
    default:
      return false
    }
  }
  
  case none
  case dismiss(tintColor: Color? = nil, onDismiss: () -> Void)
  case pop(tintColor: Color? = nil, onDismiss: () -> Void)
}
