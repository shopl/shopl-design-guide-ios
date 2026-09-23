//
//  SDGCustomHistory.swift
//  shopl-design-guide-ios
//
//  Created by kai on 9/23/26.
//  Figma: https://www.figma.com/design/qWVshatQ9eqoIn4fdEZqWy/SDG?node-id=22986-3555&m=dev
//

import SwiftUI

public struct SDGCustomHistory<Header: View, Content: View>: View {
  public static var version: String { "2.3.46" }

  private let positionType: HistoryPositionType
  private let dotColor: SDG.Color
  private let headerArea: Header
  private let bodyArea: Content
  private let hasBody: Bool

  public init(
    index: Int,
    totalCount: Int,
    dotColor: SDG.Color = .neutral300,
    @ViewBuilder headerArea: () -> Header,
    @ViewBuilder bodyArea: () -> Content
  ) {
    self.init(
      positionType: Self.position(index: index, totalCount: totalCount),
      dotColor: dotColor,
      headerArea: headerArea,
      bodyArea: bodyArea
    )
  }

  public init(
    index: Int,
    totalCount: Int,
    dotColor: SDG.Color = .neutral300,
    @ViewBuilder headerArea: () -> Header
  ) where Content == EmptyView {
    self.init(
      positionType: Self.position(index: index, totalCount: totalCount),
      dotColor: dotColor,
      headerArea: headerArea
    )
  }

  private static func position(index: Int, totalCount: Int) -> HistoryPositionType {
    guard totalCount > 0, index >= 0, index < totalCount else {
      return .solo
    }
    if totalCount == 1 { return .solo }
    if index == 0 { return .first }
    if index == totalCount - 1 { return .last }
    return .middle
  }

  public init(
    positionType: HistoryPositionType,
    dotColor: SDG.Color = .neutral300,
    @ViewBuilder headerArea: () -> Header,
    @ViewBuilder bodyArea: () -> Content
  ) {
    self.positionType = positionType
    self.dotColor = dotColor
    self.headerArea = headerArea()
    self.bodyArea = bodyArea()
    self.hasBody = true
  }

  public init(
    positionType: HistoryPositionType,
    dotColor: SDG.Color = .neutral300,
    @ViewBuilder headerArea: () -> Header
  ) where Content == EmptyView {
    self.positionType = positionType
    self.dotColor = dotColor
    self.headerArea = headerArea()
    self.bodyArea = EmptyView()
    self.hasBody = false
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      headerArea
        .padding(.top, .spacing20)
        .padding(.bottom, .spacing16)
      if hasBody {
        bodyArea
          .padding(.bottom, .spacing20)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.leading, .spacing32)
    .overlay(alignment: .leading) {
      SDGCustomHistoryTimeline(positionType: positionType, dotColor: dotColor)
        .frame(width: 16)
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }
  }
}

private struct SDGCustomHistoryTimeline: View {
  let positionType: HistoryPositionType
  let dotColor: SDG.Color

  var body: some View {
    VStack(spacing: .spacing4) {
      Rectangle()
        .fill(positionType.firstFooterColor)
        .frame(width: 1, height: 21)

      Circle()
        .fill(dotColor.color)
        .frame(width: 8, height: 8)

      Rectangle()
        .fill(positionType.secondFooterColor)
        .frame(width: 1)
        .frame(maxHeight: .infinity)
    }
  }
}

#Preview("결재선 · 승인 / 반려 / 협조") {
  ScrollView {
    VStack(spacing: 0) {
      ForEach(0..<3, id: \.self) { index in
        SDGCustomHistory(
          index: index,
          totalCount: 3,
          dotColor: index == 2 ? .neutral700 : .neutral300
        ) {
          HStack(spacing: 4) {
            Text("\(index + 1)단계")
              .typo(.body1_SB, .neutral700)
            SDGBoxBadge(
              text: index == 2 ? "협조" : "승인",
              type: .solid(.init(backgroundColor: .neutral150, textColor: .neutral600))
            )
            Spacer()
            Image(sdg: .icCommonNextS)
              .resizable().frame(width: 14, height: 14)
          }
        } bodyArea: {
          VStack(alignment: .leading, spacing: 8) {
            if index != 1 {
              Text("전원 승인 필요")
                .typo(.body3_SB, .neutral600)
            }
            VStack(alignment: .leading, spacing: 8) {
              HStack(spacing: 8) {
                SDGAvatar(
                  type: .round,
                  model: .init(userId: "preview", imageURL: nil, roleType: .leader),
                  size: .xs,
                  action: { _ in }
                )
                Text("직원명 +2").typo(.body2_R, .neutral700)
                Spacer()
                if index < 2 {
                  SDGCapsuleBadge(option: .init(
                    style: .solid, size: .xsmall,
                    title: index == 0 ? "승인" : "반려",
                    titleColor: .neutral0,
                    backgroundColor: index == 0 ? .primary300 : .red300
                  ), action: {})
                } else {
                  Image(sdg: .icCommonNextS)
                    .resizable().frame(width: 14, height: 14)
                }
              }
              if index == 1 {
                Text("사유: 누락된 점검 내용을 보완해 주세요.")
                  .typo(.body3_R, .neutral500)
              }
            }
            .padding(12)
            .background(index == 0 ? Color.primary300.opacity(0.1)
              : index == 1 ? Color.red300.opacity(0.1) : Color.neutral50)
            .cornerRadius(12)
          }
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(Color.neutral0)
    .cornerRadius(20)
    .padding(16)
  }
  .background(Color.neutral100)
}
