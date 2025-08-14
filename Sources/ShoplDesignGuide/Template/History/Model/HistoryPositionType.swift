//
//  HistoryPositionType.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/14/25.
//

import SwiftUI

public enum HistoryPositionType: Equatable, Decodable, Sendable {
  case first, middle, last, solo
  
  var firstFooterColor: Color {
    switch self {
      case .first, .solo: return .clear
      case .middle, .last: return .neutral200
    }
  }
  
  var secondFooterColor: Color {
    switch self {
      case .last, .solo: return .clear
      case .middle, .first: return .neutral200
    }
  }
}

