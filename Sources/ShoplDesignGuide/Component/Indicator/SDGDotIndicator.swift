//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

public struct SDGDotIndicator: View {
  
  private let maxStep: Int
  
  @Binding private var currentIndex: Int
  
  private let size: CGFloat
  
  public init(
    maxStep: Int,
    currentIndex: Binding<Int>,
    size: CGFloat = 6
  ) {
    self.maxStep = maxStep
    self._currentIndex = currentIndex
    self.size = size
  }
  
  public var body: some View {
    HStack(spacing: 10) {
      ForEach(Array(0..<maxStep), id: \.self) { index in
        if currentIndex == index {
          
          Color.neutral700
            .frame(width: size, height: size)
            .cornerRadius(size/2)
          
        } else {
          
          Color.neutral200
            .frame(width: size, height: size)
            .cornerRadius(size/2)
          
        }
      }
    }
  }
}

#Preview {
  VStack {
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(0)
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(1)
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(2)
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(3)
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(4)
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(0),
      size: 8
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(1),
      size: 8
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(2),
      size: 8
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(3),
      size: 8
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(4),
      size: 8
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(0),
      size: 10
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(1),
      size: 10
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(2),
      size: 10
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(3),
      size: 10
    )
    
    SDGDotIndicator(
      maxStep: 5,
      currentIndex: .constant(4),
      size: 10
    )
  }
}


