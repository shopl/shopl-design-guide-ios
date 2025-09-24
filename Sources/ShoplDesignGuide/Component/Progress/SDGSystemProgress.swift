//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

public struct SDGSystemProgress: View {
  
  private var color: Color
  
  public init(color: Color? = nil) {
    if let color = color {
      self.color = color
    } else {
      self.color = .primary300
    }
  }
  
  public var body: some View {
    ProgressView()
      .frame(width: 30, height: 30)
      .tint(self.color)
  }
}

#Preview {
  VStack {
    SDGSystemProgress()
    
    SDGSystemProgress(color: .neutral700)
  }
}
