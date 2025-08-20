//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

public struct SDGTextIndicator: View {
  
  private let maxStep: Int
  
  @Binding private var currentIndex: Int
  
  private var title: String
  private var fullSize: Bool
  
  public init(
    maxStep: Int,
    currentIndex: Binding<Int>,
    title: String,
    fullSize: Bool = false
  ) {
    self.maxStep = maxStep
    self._currentIndex = currentIndex
    self.title = title
    self.fullSize = fullSize
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      Color.neutral200
        .frame(width: 12, height: 1)
      
      ForEach(Array(0..<maxStep), id: \.self) { index in
        if index < currentIndex {
          
          ZStack {
            Color.neutral700
              .frame(width: 10, height: 10)
              .cornerRadius(5)
              .padding(4)
          }
          .background(.neutral200)
          .cornerRadius(9)
          
        } else if index == currentIndex {
          
          ZStack {
            Text(self.title)
              .typo(.body3_SB, .neutral0)
              .lineLimit(1)
              .padding(.vertical, 1)
              .padding(.horizontal, 8)
          }
          .background(.neutral700)
          .cornerRadius(9)
          
        } else {
          
          ZStack {
            Color.neutral700
              .frame(width: 10, height: 10)
              .cornerRadius(5)
              .padding(4)
          }
          .background(.neutral100)
          .cornerRadius(9)
          
        }
        
        Color.neutral200
          .frame(width: 12, height: 1)
      }
      
      if self.fullSize {
        Color.neutral200
          .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
      }
    }
  }
}

#Preview {
  VStack {
    SDGTextIndicator(
      maxStep: 5,
      currentIndex: .constant(0),
      title: "Label"
    )
    
    SDGTextIndicator(
      maxStep: 5,
      currentIndex: .constant(1),
      title: "Label"
    )
    
    SDGTextIndicator(
      maxStep: 5,
      currentIndex: .constant(2),
      title: "Label"
    )
    
    SDGTextIndicator(
      maxStep: 5,
      currentIndex: .constant(3),
      title: "Label"
    )
    
    SDGTextIndicator(
      maxStep: 5,
      currentIndex: .constant(4),
      title: "Label"
    )
    
    SDGTextIndicator(
      maxStep: 5,
      currentIndex: .constant(2),
      title: "긴 타이틀 텍스트 긴 타이틀 텍스트 긴 타이틀 텍스트 긴 타이틀 텍스트 긴 타이틀 텍스트"
    )
    
    SDGTextIndicator(
      maxStep: 5,
      currentIndex: .constant(2),
      title: "fullSize: true",
      fullSize: true
    )
  }
}
