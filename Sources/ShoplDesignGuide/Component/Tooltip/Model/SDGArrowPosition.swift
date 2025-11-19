//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/4/25.
//

import SwiftUI

enum SDGArrowPosition {
  case top, bottom, leading, trailing
  
  var rotation: Angle {
    switch self {
    case .top: return .degrees(0)
    case .bottom: return .degrees(180)
    case .leading: return .degrees(270)
    case .trailing: return .degrees(90)
    }
  }
}
