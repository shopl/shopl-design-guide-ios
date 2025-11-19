//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/19/25.
//

import SwiftUI

public struct SDGButtonColor: Equatable {
  public let lineColor: Color
  public let backgroundColor: Color
  public let textColor: Color
  
  public init(lineColor: Color = .clear, backgroundColor: Color, textColor: Color) {
    self.lineColor = lineColor
    self.backgroundColor = backgroundColor
    self.textColor = textColor
  }
}
