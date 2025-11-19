//
//  RounedCorner.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

extension View {
  public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RounedCorner(radius: radius, corners: corners))
  }
}

struct RounedCorner: Shape {
  
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}
