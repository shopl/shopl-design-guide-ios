//
//  SDGLinearProgress.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

/// 실제 진행률 또는 완료 시간을 알 수 없는 작업을 표시하는 160pt 너비의 프로그레스입니다.
public struct SDGLinearProgress: View {
  public static let version = "2.3.52"

  public enum ProgressType: Equatable {
    /// 0~1 사이의 진행률. 범위를 벗어나면 보정하며 NaN은 0으로 처리합니다.
    case determinate(Double)
    /// 일정 길이의 인디케이터가 트랙 안에서 좌우로 반복 이동합니다.
    case indeterminate
  }

  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  private let type: ProgressType
  private let legacyCompletion: Binding<Bool>?
  private let label: String?
  private let labelColor: Color

  /// - Parameters:
  ///   - type: 실제 진행률 표시 또는 진행률을 알 수 없는 반복 로딩입니다.
  ///   - label: 생략하거나 빈 문자열이면 바만 표시합니다. 긴 문구는 160pt 안에서 중앙 정렬로 줄바꿈합니다.
  ///   - labelColor: 라벨 색상. 기본값은 neutral700이며 SDG 색상을 사용할 수 있습니다.
  public init(type: ProgressType, label: String? = nil, labelColor: Color = .neutral700) {
    self.type = type
    self.legacyCompletion = nil
    self.label = label
    self.labelColor = labelColor
  }

  /// 실제 진행률을 표시합니다. 라벨을 생략하면 바만 표시합니다.
  public init(progress: Double, label: String? = nil, labelColor: Color = .neutral700) {
    self.init(type: .determinate(progress), label: label, labelColor: labelColor)
  }

  @available(*, deprecated, message: "Use init(progress:label:labelColor:) instead.")
  public init(progress: Double, title: String, titleColor: Color? = nil) {
    self.init(progress: progress, label: title, labelColor: titleColor ?? .neutral0)
  }

  /// 기존 호출부 호환용입니다. 완료 전에는 0%, 완료 후에는 100%를 표시합니다.
  @available(*, deprecated, message: "Use init(progress:label:labelColor:) to display actual progress.")
  public init(isComplete: Binding<Bool>, title: String, titleColor: Color? = nil) {
    self.type = .determinate(0)
    self.legacyCompletion = isComplete
    self.label = title
    self.labelColor = titleColor ?? .neutral0
  }

  private var effectiveType: ProgressType {
    if let legacyCompletion {
      return .determinate(legacyCompletion.wrappedValue ? 1 : 0)
    }
    return type
  }

  private var visibleLabel: String? {
    guard let label, !label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
    return label
  }

  public var body: some View {
    VStack(spacing: 10) {
      ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: SDGCornerRadius.radius2.rawValue)
          .fill(Color.neutral300)

        switch effectiveType {
        case .determinate(let value):
          let progress = value.isNaN ? 0 : min(max(value, 0), 1)
          RoundedRectangle(cornerRadius: SDGCornerRadius.radius2.rawValue)
            .fill(Color.primary300)
            .frame(width: 160 * CGFloat(progress))
            .animation(reduceMotion ? nil : .linear(duration: 0.2), value: progress)
        case .indeterminate:
          SDGLinearProgressIndeterminateBar()
        }
      }
      .frame(width: 160, height: 4)
      .clipped()

      if let visibleLabel {
        Text(visibleLabel)
          .typo(.body3_R)
          .foregroundStyle(labelColor)
          .multilineTextAlignment(.center)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
          .frame(width: 160)
      }
    }
    .frame(width: 160)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(Text(visibleLabel ?? "진행 상태"))
    .accessibilityValue(accessibilityProgress)
  }

  private var accessibilityProgress: Text {
    switch effectiveType {
    case .determinate(let value):
      let progress = value.isNaN ? 0 : min(max(value, 0), 1)
      return Text(progress, format: .percent.precision(.fractionLength(0)))
    case .indeterminate:
      return Text("진행 중")
    }
  }
}

/// 화면에서 제거되면 TimelineView도 함께 종료됩니다. 별도의 반복 타이머를 유지하지 않습니다.
private struct SDGLinearProgressIndeterminateBar: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @State private var startDate = Date()

  var body: some View {
    TimelineView(.animation(minimumInterval: 1.0 / 30, paused: reduceMotion)) { context in
      let elapsed = max(0, context.date.timeIntervalSince(startDate))
      // 편도 1.2초, 왕복 2.4초. 양 끝에서 부드럽게 방향을 바꿉니다.
      let position = reduceMotion ? 0.5 : (1 - cos(elapsed * .pi / 1.2)) / 2
      RoundedRectangle(cornerRadius: SDGCornerRadius.radius2.rawValue)
        .fill(Color.primary300)
        .frame(width: 160 / 3, height: 4)
        .offset(x: (160 - 160 / 3) * position)
    }
    .onAppear { startDate = Date() }
  }
}

#Preview {
  VStack(spacing: 32) {
    SDGLinearProgress(progress: 0.65, label: "업로드 중입니다")
    SDGLinearProgress(type: .indeterminate, label: "데이터를 불러오고 있습니다. 잠시만 기다려 주세요.")
    SDGLinearProgress(progress: 0.3)
  }
  .padding(30)
}
