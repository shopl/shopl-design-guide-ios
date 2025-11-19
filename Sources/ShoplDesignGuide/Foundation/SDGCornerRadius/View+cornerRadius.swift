//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/3/25.
//

import SwiftUI

public extension View {
  func cornerRadius(_ radius: SDGCornerRadius) -> some View {
    self.cornerRadius(radius.rawValue)
  }
  
  func cornerRadius(_ radius: SDGCornerRadius, corners: UIRectCorner) -> some View {
    self.clipShape(RounedCorner(radius: radius.rawValue, corners: corners))
  }
  
  func clipShape(_ shape: RoundedRectangle, _ radius: SDGCornerRadius) -> some View {
    self.clipShape(RoundedRectangle(cornerRadius: radius.rawValue))
  }
}
