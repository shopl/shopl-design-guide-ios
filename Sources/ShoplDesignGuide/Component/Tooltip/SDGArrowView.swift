//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/4/25.
//

import SwiftUI

struct SDGArrowView: View {
  let config: SDGArrowConfig
  let color: Color
  
  var body: some View {
    SDGArrow()
      .fill(color)
      .frame(width: config.size.width, height: config.size.height)
      .rotationEffect(config.position.rotation)
      .offset(x: config.offset)
  }
}

struct SDGArrow: Shape {
  func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: CGPoint(x: rect.midX, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.closeSubpath()
    }
  }
}
