//
//  SDGIconTab.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/7/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

/// 선택한 항목은 제목, 나머지 항목은 아이콘으로 표시하는 탭입니다.
public struct SDGIconTab: View {
  public static let version = "2.3.47"

  /// 디자인 가이드에서 지원하는 3·4·5개 항목만 구성할 수 있습니다.
  public enum Option: Equatable {
    case three(Item, Item, Item)
    case four(Item, Item, Item, Item)
    case five(Item, Item, Item, Item, Item)

    fileprivate var items: [Item] {
      switch self {
      case let .three(first, second, third):
        return [first, second, third]
      case let .four(first, second, third, fourth):
        return [first, second, third, fourth]
      case let .five(first, second, third, fourth, fifth):
        return [first, second, third, fourth, fifth]
      }
    }
  }

  /// 20×20pt 영역 중앙에 배치할 아이콘의 크기입니다.
  public enum IconSize: CGFloat {
    case large = 20
    case medium = 16
    case small = 14
  }

  public struct Item: Identifiable, Equatable {
    public let id: String
    public let icon: Image
    public let tintColor: Color
    public let title: String
    public let count: Int
    public let showCount: Bool
    public let iconSize: IconSize

    /// - Parameters:
    ///   - id: 같은 Option 안에서 고유한 식별자입니다.
    ///   - count: 0 이상의 건수입니다. 가용 너비를 넘으면 최대 수치 표기로 표시합니다.
    ///   - showCount: 선택 여부와 관계없이 수치를 표시할지 결정합니다.
    public init(
      id: String,
      icon: Image,
      tintColor: Color,
      title: String,
      count: Int,
      showCount: Bool = true,
      iconSize: IconSize = .large
    ) {
      self.id = id
      self.icon = icon
      self.tintColor = tintColor
      self.title = title
      self.count = count
      self.showCount = showCount
      self.iconSize = iconSize
    }
  }

  private let items: [Item]
  private let selectedIndex: Int
  private let onTabClick: (Int) -> Void

  /// - Parameters:
  ///   - option: 고유한 id를 가진 3·4·5개의 항목입니다.
  ///   - selectedIndex: 0부터 시작하는 선택 인덱스입니다. 항목 수보다 작아야 합니다.
  ///   - onTabClick: 클릭한 항목의 인덱스(0부터 시작)를 전달합니다.
  ///
  /// 선택 상태는 호출부가 소유합니다. 호출부가 selectedIndex를 변경해야 선택 표시가 바뀝니다.
  /// 외부 여백은 호출부의 padding으로 설정합니다.
  /// 최소 가용 너비는 3개 158pt, 4개 212pt, 5개 266pt입니다.
  public init(
    option: Option,
    selectedIndex: Int,
    onTabClick: @escaping (Int) -> Void
  ) {
    self.items = option.items
    self.selectedIndex = selectedIndex
    self.onTabClick = onTabClick
  }

  public var body: some View {
    HStack(spacing: SDGSpacing.spacing4.rawValue) {
      ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
        tabButton(item: item, index: index)
      }
    }
    .frame(height: 76)
  }

  private func tabButton(item: Item, index: Int) -> some View {
    let isSelected = index == selectedIndex
    let shape = RoundedRectangle(cornerRadius: SDGCornerRadius.radius12.rawValue)

    return Button {
      onTabClick(index)
    } label: {
      tabContent(item: item, isSelected: isSelected)
        .padding(.horizontal, SDGSpacing.spacing4.rawValue)
        .frame(minWidth: 50, maxWidth: isSelected ? .infinity : 50)
        .frame(height: 76)
        .background(isSelected ? Color.neutral600 : Color.neutral0)
        .clipShape(shape)
        .overlay {
          shape.strokeBorder(isSelected ? Color.neutral600 : Color.neutral200, lineWidth: 1)
        }
        .contentShape(shape)
    }
    .buttonStyle(NoTapAnimationButtonStyle())
  }

  private func tabContent(item: Item, isSelected: Bool) -> some View {
    VStack(spacing: SDGSpacing.spacing8.rawValue) {
      if isSelected {
        Text(item.title)
          .typo(.body2_R, .neutral0)
          .lineLimit(2)
          .truncationMode(.tail)
          .multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
      } else {
        item.icon
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .foregroundStyle(item.tintColor)
          .frame(width: item.iconSize.rawValue, height: item.iconSize.rawValue)
          .frame(width: 20, height: 20)
      }

      if item.showCount {
        SDGIconTabCount(count: item.count, color: isSelected ? .neutral0 : .neutral500)
      }
    }
  }
}

private struct SDGIconTabCount: View {
  let count: Int
  let color: SDG.Color

  private let typography: SDG.Typography = .body2_SB

  var body: some View {
    GeometryReader { geometry in
      Text(displayText(in: geometry.size.width))
        .typo(typography, color)
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: false)
        .frame(width: geometry.size.width, height: typography.lineHeight)
    }
    .frame(height: typography.lineHeight)
  }

  private func displayText(in availableWidth: CGFloat) -> String {
    let original = String(count)
    let font = SDG.Font.asset(weight: typography.weight).font(size: typography.size)

    func fits(_ text: String) -> Bool {
      (text as NSString).size(withAttributes: [.font: font]).width <= availableWidth
    }

    guard count >= 10, !fits(original) else { return original }

    // 원본보다 자릿수가 적은 최대값만 후보로 사용합니다.
    // 문자열로 생성하므로 Int.max에서도 정수 연산 오버플로가 없습니다.
    for digitCount in stride(from: original.count - 1, through: 1, by: -1) {
      let candidate = String(repeating: "9", count: digitCount) + "+"
      if fits(candidate) {
        return candidate
      }
    }

    // 최소 탭 너비 50pt(내부 42pt)에서는 가장 작은 최대값 표기가 들어갑니다.
    return "9+"
  }
}

#Preview("3 / 4 / 5 Option") {
  SDGIconTabPreview()
}

#Preview("Count 숨김") {
  SDGIconTabPreview(showCount: false)
}

private struct SDGIconTabPreview: View {
  var showCount = true

  @State private var threeSelectedIndex = 0
  @State private var fourSelectedIndex = 0
  @State private var fiveSelectedIndex = 0

  var body: some View {
    VStack(spacing: 20) {
      SDGIconTab(
        option: .three(item(0), item(1), item(2)),
        selectedIndex: threeSelectedIndex,
        onTabClick: { threeSelectedIndex = $0 }
      )
      SDGIconTab(
        option: .four(item(0), item(1), item(2), item(3)),
        selectedIndex: fourSelectedIndex,
        onTabClick: { fourSelectedIndex = $0 }
      )
      SDGIconTab(
        option: .five(item(0), item(1), item(2), item(3), item(4)),
        selectedIndex: fiveSelectedIndex,
        onTabClick: { fiveSelectedIndex = $0 }
      )
    }
    .frame(width: 335)
    .padding(20)
  }

  private func item(_ index: Int) -> SDGIconTab.Item {
    let counts = [0, 999, 1_000, 123_456, Int.max]
    let sizes: [SDGIconTab.IconSize] = [.large, .medium, .small]

    return .init(
      id: String(index),
      icon: Image(sdg: .icClip),
      tintColor: .neutral500,
      title: index == 1 ? "긴 제목은 최대 두 줄까지 표시하고 나머지는 말줄임으로 처리합니다" : "Label \(index + 1)",
      count: counts[index],
      showCount: showCount,
      iconSize: sizes[index % sizes.count]
    )
  }
}
