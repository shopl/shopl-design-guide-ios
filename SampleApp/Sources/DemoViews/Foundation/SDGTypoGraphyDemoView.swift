//
//  SDGTypoGraphyDemoView.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/28/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

import ShoplDesignGuide

struct SDGTypographyDemoView: View {
  @State private var selectedGroup: SDGTypographySpecGroup?
  @State private var isPreviewPopupPresented = false
  @State private var selectedTabIndex = 0

  private let popupDismissDelay = 0.2
  private let tabModels = [
    SDGScrollTab.Model(id: "common", title: "Common")
  ]

  var body: some View {
    VStack(alignment: .leading, spacing: .spacing16) {
      SDGTypographyTypeSection()

      VStack(alignment: .leading, spacing: .spacing12) {
        VStack(alignment: .leading, spacing: .spacing8) {
          Text(sdg: "Spec")
            .typo(.body3_SB, .neutral350)
            .frame(maxWidth: .infinity, alignment: .leading)

          SDGScrollTab(
            type: .text,
            list: tabModels,
            selectedIndex: $selectedTabIndex
          )
        }

        SDGTypographySpecCard { group in
          selectedGroup = group
          isPreviewPopupPresented = true
        }
      }
      .padding(.horizontal, .spacing16)

      SDGTypographyUsageGuidelinesSection()
    }
    .padding(.top, .spacing16)
    .padding(.bottom, .spacing40)
    .frame(maxWidth: .infinity, alignment: .leading)
    .centerPopup(
      isPresented: isPreviewPopupPresented,
      title: nil,
      body: {
        if let selectedGroup {
          SDGTypographyPreviewPopupBody(group: selectedGroup)
        }
      },
      button: .init(
        button: .oneOption(
          option: .init(
            title: "닫기",
            action: {
              dismissPreviewPopup()
            }
          )
        )
      ),
      tapOutsideAction: {
        dismissPreviewPopup()
      }
    )
  }

  private func dismissPreviewPopup() {
    isPreviewPopupPresented = false

    DispatchQueue.main.asyncAfter(deadline: .now() + popupDismissDelay) {
      guard !isPreviewPopupPresented else { return }
      selectedGroup = nil
    }
  }
}

private enum SDGTypographySpecGroup: String, CaseIterable, Identifiable {
  case naviTitle
  case title
  case body
  case point
  case special

  var id: String {
    rawValue
  }

  var items: [SDGTypographySpecItem] {
    previewSections.flatMap { $0 }
  }

  var previewSections: [[SDGTypographySpecItem]] {
    switch self {
    case .naviTitle:
      return [
        [
          .init(style: .naviTitle, name: "Navi Title", weight: "Regular")
        ]
      ]
    case .title:
      return [
        [
          .init(style: .title1_SB, name: "Title 1 - SB", weight: "Semi Bold"),
          .init(style: .title1_R, name: "Title 1 - R", weight: "Regular")
        ],
        [
          .init(style: .title2_SB, name: "Title 2 - SB", weight: "Semi Bold"),
          .init(style: .title2_R, name: "Title 2 - R", weight: "Regular")
        ]
      ]
    case .body:
      return [
        [
          .init(style: .body1_SB, name: "Body 1 - SB", weight: "Semi Bold"),
          .init(style: .body1_R, name: "Body 1 - R", weight: "Regular")
        ],
        [
          .init(style: .body2_SB, name: "Body 2 - SB", weight: "Semi Bold"),
          .init(style: .body2_R, name: "Body 2 - R", weight: "Regular")
        ],
        [
          .init(style: .body3_SB, name: "Body 3 - SB", weight: "Semi Bold"),
          .init(style: .body3_R, name: "Body 3 - R", weight: "Regular")
        ],
        [
          .init(style: .body4_SB, name: "Body 4 - SB", weight: "Semi Bold"),
          .init(style: .body4_R, name: "Body 4 - R", weight: "Regular")
        ]
      ]
    case .point:
      return [
        [
          .init(style: .point1_SB, name: "Point 1 - SB", weight: "Semi Bold"),
          .init(style: .point1_R, name: "Point 1 - R", weight: "Regular")
        ],
        [
          .init(style: .point2_SB, name: "Point 2 - SB", weight: "Semi Bold"),
          .init(style: .point2_R, name: "Point 2 - R", weight: "Regular")
        ]
      ]
    case .special:
      return [
        [
          .init(style: .special1_SB, name: "Special 1 - SB", weight: "Semi Bold")
        ]
      ]
    }
  }
}

private struct SDGTypographySpecItem: Identifiable {
  let style: SDG.Typography
  let name: String
  let weight: String

  var id: String {
    name
  }

  var size: String {
    "\(Int(style.size))"
  }
}

private struct SDGTypographyTypeSection: View {
  var body: some View {
    VStack(alignment: .leading, spacing: .spacing12) {
      VStack(alignment: .leading, spacing: .spacing8) {
        Text(sdg: "Type")
          .typo(.body3_SB, .neutral350)
          .frame(maxWidth: .infinity, alignment: .leading)

        Text(sdg: "Pretendard")
          .typo(.title2_SB, .neutral700)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, .spacing16)

      Divider(color: .neutral200, option: .init(direction: .horizental, thickness: 1))
    }
  }
}

private struct SDGTypographySpecCard: View {
  let onSelect: (SDGTypographySpecGroup) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading, spacing: .spacing16) {
        SDGTypographyHeaderRow()

        Divider(color: .neutral200, option: .init(direction: .horizental, thickness: 1))
      }
      .padding(.top, .spacing16)

      VStack(alignment: .leading, spacing: .spacing16) {
        ForEach(Array(SDGTypographySpecGroup.allCases.enumerated()), id: \.element.id) { index, group in
          SDGTypographyGroupRow(group: group) {
            onSelect(group)
          }

          if index < SDGTypographySpecGroup.allCases.count - 1 {
            Divider(color: .neutral200, option: .init(direction: .horizental, thickness: 1))
          }
        }
      }
      .padding(.vertical, .spacing16)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }
}

private struct SDGTypographyHeaderRow: View {
  var body: some View {
    HStack(spacing: .spacing12) {
      Text(sdg: "Style")
        .frame(width: 100, alignment: .leading)

      Text(sdg: "Size")
        .frame(width: 40, alignment: .leading)

      Text(sdg: "Weight")
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .typo(.body3_R, .neutral700)
    .padding(.horizontal, .spacing16)
  }
}

private struct SDGTypographyGroupRow: View {
  let group: SDGTypographySpecGroup
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      HStack(spacing: .spacing8) {
        VStack(alignment: .leading, spacing: .spacing12) {
          ForEach(group.items) { item in
            SDGTypographySpecItemRow(item: item)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        Image(sdg: .icCommonNext)
          .renderingMode(.template)
          .resizable()
          .foregroundStyle(Color.neutral700)
          .frame(width: 24, height: 24)
      }
      .padding(.leading, .spacing16)
      .padding(.trailing, .spacing8)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

private struct SDGTypographySpecItemRow: View {
  let item: SDGTypographySpecItem

  var body: some View {
    HStack(alignment: .top, spacing: .spacing12) {
      Text(sdg: item.name)
        .frame(width: 100, alignment: .leading)

      Text(sdg: item.size)
        .frame(width: 40, alignment: .leading)

      Text(sdg: item.weight)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .typo(.body1_R, .neutral700)
  }
}

private struct SDGTypographyUsageGuidelinesSection: View {
  var body: some View {
    VStack(alignment: .leading, spacing: .spacing20) {
      Divider(color: .neutral200, option: .init(direction: .horizental, thickness: 1))

      VStack(alignment: .leading, spacing: .spacing8) {
        Text(sdg: "Usage Guidelines")
          .typo(.body3_SB, .neutral350)
          .frame(maxWidth: .infinity, alignment: .leading)

        Text(sdg: "# 지원되지 않는 언어는 각 OS 시스템폰트로 적용합니다.")
          .typo(.body2_SB, .neutral500)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, .spacing16)
    }
  }
}

private struct SDGTypographyPreviewPopupBody: View {
  let group: SDGTypographySpecGroup

  var body: some View {
    VStack(alignment: .leading, spacing: .spacing20) {
      Text(sdg: "미리보기")
        .typo(.body2_SB, .neutral350)
        .frame(maxWidth: .infinity, alignment: .leading)

      ForEach(Array(group.previewSections.enumerated()), id: \.offset) { index, items in
        if index > 0 {
          Divider(color: .neutral200, option: .init(direction: .horizental, thickness: 1))
        }

        VStack(alignment: .leading, spacing: .spacing20) {
          ForEach(items) { item in
            SDGTypographyPreviewSample(item: item)
          }
        }
      }
    }
  }
}

private struct SDGTypographyPreviewSample: View {
  let item: SDGTypographySpecItem

  var body: some View {
    VStack(alignment: .leading, spacing: .spacing4) {
      Text(sdg: item.name)
        .typo(item.style, .neutral700)

      Text(sdg: "가나라다마바사")
        .typo(item.style, .neutral700)

      Text(sdg: "1234567890 !@#$%^&*()")
        .typo(item.style, .neutral700)
    }
    .fixedSize(horizontal: false, vertical: true)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGTypographyDemoView()
}
