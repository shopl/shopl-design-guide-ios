//
//  SDGLinearProgressDemoView.swift
//  ShoplDesignGuide
//

import SwiftUI
import ShoplDesignGuide

struct SDGLinearProgressDemoView: View {
  @State private var progress = 0.5

  var body: some View {
    VStack(spacing: 24) {
      SDGLinearProgress(
        progress: progress,
        title: "데이터 불러오는 중...",
        titleColor: .neutral700
      )
      Slider(value: $progress, in: 0...1)
        .accessibilityLabel("진행률")
      Text(progress, format: .percent.precision(.fractionLength(0)))
      Button("초기화") { progress = 0 }
    }
    .padding(24)
  }
}
