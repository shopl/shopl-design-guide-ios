//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

public struct SDGCircularProgress: View {
  
  @State private var isLoading = false
  
  private let size: CGFloat
  private let lineWidth: CGFloat
  
  public init(
    size: CGFloat,
    lineWidth: CGFloat
  ) {
    self.size = size
    self.lineWidth = lineWidth
  }
  
  public var body: some View {
    
    ZStack {
      Circle()
        .stroke(.neutral150, lineWidth: self.lineWidth)
        .frame(width: self.size, height: self.size)
      
      Circle()
        .trim(from: 0, to: 0.75)
        .stroke(.primary300, lineWidth: self.lineWidth)
        .frame(width: self.size, height: self.size)
        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
        .animation(
          Animation.linear(duration: 1).repeatForever(autoreverses: false),
          value: isLoading
        )
        .onAppear() {
          self.isLoading = true
        }
      
    }
  }
}

#Preview {
  VStack {
    SDGCircularProgress(size: 44, lineWidth: 4)
    SDGCircularProgress(size: 36, lineWidth: 3)
    SDGCircularProgress(size: 28, lineWidth: 2.5)
    SDGCircularProgress(size: 20, lineWidth: 2)
  }
}
