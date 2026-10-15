//
//  SDGLinearProgress.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

/// 실제 작업 진행률을 표시하는 고정 너비의 프로그레스입니다.
public struct SDGLinearProgress: View {
  public static let version = "2.0.0"

  private let progress: Double
  private let legacyCompletion: Binding<Bool>?
  private let title: String
  private let titleColor: Color

  /// - Parameters:
  ///   - progress: 0~1 사이의 실제 진행률. 범위를 벗어나면 보정하며 NaN은 0으로 처리합니다.
  ///   - title: 한 줄로 표시할 짧은 안내 문구입니다.
  ///   - titleColor: 기본값은 neutral0. 밝은 배경에서는 neutral700을 사용합니다.
  public init(progress: Double, title: String, titleColor: Color? = nil) {
    self.progress = progress
    self.legacyCompletion = nil
    self.title = title
    self.titleColor = titleColor ?? .neutral0
  }

  /// 기존 호출부 호환용입니다. 완료 전에는 0%, 완료 후에는 100%를 표시합니다.
  @available(*, deprecated, message: "Use init(progress:title:titleColor:) to display actual progress.")
  public init(isComplete: Binding<Bool>, title: String, titleColor: Color? = nil) {
    self.progress = 0
    self.legacyCompletion = isComplete
    self.title = title
    self.titleColor = titleColor ?? .neutral0
  }

  private var normalizedProgress: Double {
    if let legacyCompletion {
      return legacyCompletion.wrappedValue ? 1 : 0
    }
    return progress.isNaN ? 0 : min(max(progress, 0), 1)
  }

  public var body: some View {
    VStack(spacing: 10) {
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          Rectangle()
            .fill(Color.neutral300)
          Rectangle()
            .fill(Color.primary300)
            .frame(width: CGFloat(normalizedProgress) * geometry.size.width)
        }
      }
      .frame(width: 160, height: 4)
      .clipShape(RoundedRectangle(cornerRadius: 2))

      Text(title)
        .typo(.body3_R)
        .foregroundStyle(titleColor)
        .lineLimit(1)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(Text(title))
    .accessibilityValue(Text(normalizedProgress, format: .percent.precision(.fractionLength(0))))
  }
}

#Preview {
  SDGLinearProgress(progress: 0.65, title: "업로드 중입니다", titleColor: .neutral700)
    .padding(30)
}
