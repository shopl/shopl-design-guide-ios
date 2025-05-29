//
//  SDGColor.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/29/25.
//

import SwiftUI

public struct SDGColor: Sendable {
  public let value: UIColor
}

extension SDGColor {
  static var clear: SDGColor {
    SDGColor(value: .clear)
  }
  
  func withAlphaComponent(_ alpha: CGFloat) -> SDGColor {
    SDGColor(value: value.withAlphaComponent(alpha))
  }
}

public extension Color {
  init(_ color: SDGColor) {
    self.init(color.value)
  }
}

public extension View {
  func background(_ color: SDGColor, alignment: Alignment = .center) -> some View {
    background(Color(color.value), alignment: alignment)
  }
  
  func foregroundColor(_ color: SDGColor) -> some View {
    foregroundColor(Color(color.value))
  }
}
