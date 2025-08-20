//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

public struct SDGDotProgress: View {
  
  @State private var currentIndex = 0
  
  private var size: CGFloat
  
  public init(size: CGFloat) {
    self.size = size
  }
  
  public var body: some View {
    HStack(spacing: self.size) {
      ForEach(0..<4, id: \.self) { index in
        Circle()
          .fill(index == currentIndex ? .primary300 : .neutral300)
          .frame(width: self.size, height: self.size)
          .animation(.easeInOut(duration: 0.2), value: currentIndex)
      }
    }
    .onAppear {
      startAnimation()
    }
  }
  
  private func startAnimation() {
    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
      Task { @MainActor in
        currentIndex = (currentIndex + 1) % 4
      }
    }
  }
}

#Preview {
  VStack {
    SDGDotProgress(size: 4)
    SDGDotProgress(size: 6)
    SDGDotProgress(size: 8)
  }
}
