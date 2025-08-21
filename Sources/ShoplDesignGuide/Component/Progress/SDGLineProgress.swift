//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

public struct SDGLineProgress: View {
  
  @State private var progress: CGFloat = 0.0
  @Binding private var isComplete: Bool
  
  private var title: String
  private var titleColor: Color
  
  public init(
    isComplete: Binding<Bool>,
    title: String,
    titleColor: Color? = nil
  ) {
    self._isComplete = isComplete
    self.title = title
    
    if let titleColor = titleColor {
      self.titleColor = titleColor
    } else {
      self.titleColor = .neutral0
    }
  }
  
  public var body: some View {
    VStack(spacing: 10) {
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          Rectangle()
            .fill(Color.neutral300)
          
          Rectangle()
            .fill(Color.primary300)
            .frame(width: progress * geometry.size.width)
            .animation(.easeInOut(duration: 2.0), value: progress)
        }
      }
      .frame(maxWidth: .infinity, minHeight: 4, maxHeight: 4)
      .clipShape(RoundedRectangle(cornerRadius: 2))
      
      Text(self.title)
        .typo(.body3_R, .neutral0)
    }
    .onAppear {
      if isComplete {
        progress = 1.0
      } else {
        progress = 0.33
      }
    }
    .onChange(of: isComplete) { isComplete in
      if isComplete {
        progress = 1.0
      }
    }
  }
}

#Preview {
  VStack {
    SDGLineProgress(
      isComplete: .constant(true),
      title: "업로드 중입니다."
    )
      .padding(30)
  }
  .background(.orange)
}
