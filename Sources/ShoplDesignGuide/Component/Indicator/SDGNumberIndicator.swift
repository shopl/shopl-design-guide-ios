//
//  SDGNumberIndicator.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

public struct SDGNumberIndicator: View {
  
  private let maxStep: Int
  
  @Binding private var currentIndex: Int
  
  public init(
    maxStep: Int,
    currentIndex: Binding<Int>
  ) {
    self.maxStep = maxStep
    self._currentIndex = currentIndex
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      
      ForEach(Array(0..<maxStep), id: \.self) { index in
        if index <= currentIndex {
          
          if index != 0 {
            Color.neutral700
              .frame(width: 12, height: 1)
          }
          
          ZStack {
            Text(String(index + 1))
              .typo(.body4_SB, .neutral0)
              .lineLimit(1)
              .frame(width: 12, height: 12)
              .padding(1)
          }
          .background(.neutral700)
          .cornerRadius(4)
          
        } else {
          
          if index != 0 {
            Color.neutral200
              .frame(width: 12, height: 1)
          }
          
          ZStack {
            Text(String(index + 1))
              .typo(.body4_SB, .neutral0)
              .lineLimit(1)
              .frame(width: 12, height: 12)
              .padding(1)
          }
          .background(.neutral200)
          .cornerRadius(4)
          
        }
      }
    }
  }
}

#Preview {
  VStack {
    SDGNumberIndicator(
      maxStep: 5,
      currentIndex: .constant(0)
    )
    
    SDGNumberIndicator(
      maxStep: 5,
      currentIndex: .constant(1)
    )
    
    SDGNumberIndicator(
      maxStep: 5,
      currentIndex: .constant(2)
    )
    
    SDGNumberIndicator(
      maxStep: 5,
      currentIndex: .constant(3)
    )
    
    SDGNumberIndicator(
      maxStep: 5,
      currentIndex: .constant(4)
    )
  }
}

