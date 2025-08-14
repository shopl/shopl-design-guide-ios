//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/14/25.
//

import SwiftUI

public struct TopNaviTextOption {
  public let string: String
  public let tintColor: Color
  
  public init(
    string: String,
    tintColor: Color? = nil
  ) {
    self.string = string
    
    if let tintColor = tintColor {
      self.tintColor = tintColor
    } else {
      self.tintColor = .neutral700
    }
  }
}
