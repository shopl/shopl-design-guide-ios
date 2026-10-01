//
//  SDGScrollTab.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/7/26.
//
import SwiftUI

/// 라벨의 너비에 따라 수평으로 스크롤하는 탭입니다.
public struct SDGScrollTab: View {
  public static let version = "2.3.48"

  public enum Style: Equatable {
    case withUnderline
    case onlyText
  }

  public enum Size: Equatable {
    case large
    case medium

    fileprivate var typography: SDG.Typography {
      switch self {
      case .large: return .title2_SB
      case .medium: return .body1_SB
      }
    }

    fileprivate var height: CGFloat {
      typography.lineHeight + SDGSpacing.spacing6.rawValue
    }

    fileprivate var spacing: CGFloat {
      switch self {
      case .large: return SDGSpacing.spacing20.rawValue
      case .medium: return SDGSpacing.spacing18.rawValue
      }
    }
  }

  public struct Item: Identifiable, Equatable, Hashable {
    public let id: String
    public let title: String

    public init(id: String, title: String) {
      self.id = id
      self.title = title
    }
  }

  @available(*, deprecated, message: "Style.withUnderline 또는 Style.onlyText를 사용하세요.")
  public enum `Type`: Equatable {
    case text
    case underline
  }

  @available(*, deprecated, renamed: "Item")
  public typealias Model = Item

  private let style: Style
  private let size: Size
  private let items: [Item]
  // 새 API는 전달받은 값만 사용하고, 이전 API는 Binding의 변경 관찰을 유지합니다.
  @Binding private var selectedIndex: Int
  private let horizontalPadding: CGFloat
  private let showsBaselineDivider: Bool
  private let onItemTapped: (Int) -> Void

  // 이전 초기화 API의 너비 제한만 호환합니다. 새 API는 라벨의 내용 너비를 유지합니다.
  private var legacyMaxWidth: CGFloat? = nil

  @Namespace private var underlineNamespace

  private let selectionAnimation = Animation.easeInOut(duration: 0.3)

  /// - Parameters:
  ///   - items: 고유한 id를 가진 항목입니다. 항목 개수에는 제한이 없습니다.
  ///   - selectedIndex: 0부터 시작하는 선택 인덱스입니다. 범위 밖이면 선택 표시를 하지 않습니다.
  ///   - horizontalPadding: 스크롤 콘텐츠의 좌우 여백입니다.
  ///   - showsBaselineDivider: 스타일과 별도로 스크롤 영역 전체 너비에
  ///     1pt·neutral200의 하단 구분선을 표시합니다. 기본값은 false입니다.
  ///   - onItemTapped: 탭한 항목의 인덱스(0부터 시작)를 전달합니다.
  ///
  /// 선택 상태는 호출부가 소유합니다. 호출부가 selectedIndex를 변경해야 선택 표시가 바뀝니다.
  /// 라벨은 내용 길이대로 한 줄에 표시합니다.
  /// Baseline Divider는 콘텐츠와 함께 스크롤하지 않으며 좌우 콘텐츠 여백까지 이어집니다.
  public init(
    style: Style = .withUnderline,
    size: Size = .large,
    items: [Item],
    selectedIndex: Int,
    horizontalPadding: CGFloat = 0,
    showsBaselineDivider: Bool = false,
    onItemTapped: @escaping (Int) -> Void
  ) {
    self.style = style
    self.size = size
    self.items = items
    self._selectedIndex = .constant(selectedIndex)
    self.horizontalPadding = horizontalPadding
    self.showsBaselineDivider = showsBaselineDivider
    self.onItemTapped = onItemTapped
  }

  /// maxWidth에 의한 라벨 너비 제한은 이전 호출부의 호환을 위해서만 유지합니다.
  @available(*, deprecated, message: "init(style:size:items:selectedIndex:horizontalPadding:showsBaselineDivider:onItemTapped:)를 사용하세요. 새 API는 라벨 너비를 제한하지 않습니다.")
  public init(
    type: `Type` = .underline,
    list: [Model],
    selectedIndex: Binding<Int>,
    horizontalPadding: CGFloat = 0,
    maxWidth: CGFloat? = nil
  ) {
    self.init(
      style: type == .underline ? .withUnderline : .onlyText,
      items: list,
      selectedIndex: selectedIndex.wrappedValue,
      horizontalPadding: horizontalPadding,
      onItemTapped: { selectedIndex.wrappedValue = $0 }
    )
    self._selectedIndex = selectedIndex
    self.legacyMaxWidth = maxWidth
  }

  public var body: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal) {
        tabContent
          .animation(selectionAnimation, value: selectedIndex)
          .padding(.horizontal, horizontalPadding)
      }
      .scrollIndicators(.hidden)
      .onAppear {
        withAnimation(selectionAnimation) {
          proxy.scrollTo(selectedIndex)
        }
      }
      .onChange(of: selectedIndex) { index in
        withAnimation(selectionAnimation) {
          proxy.scrollTo(index)
        }
      }
    }
    .frame(height: size.height)
    .background(alignment: .bottom) {
      if showsBaselineDivider {
        Color.neutral200
          .frame(height: 1)
      }
    }
  }

  private var tabContent: some View {
    tabLayout
      .background(alignment: .bottom) {
        if style == .withUnderline {
          // 미선택 밑줄과 아이템 사이 구분선을 이어서 그립니다.
          Color.neutral200
            .frame(height: 1)
        }
      }
  }

  @ViewBuilder
  private var tabLayout: some View {
    if let legacyMaxWidth {
      LegacyConstrainedTabLayout(spacing: size.spacing, maxTotalWidth: legacyMaxWidth) {
        tabButtons
      }
    } else {
      HStack(spacing: size.spacing) {
        tabButtons
      }
    }
  }

  private var tabButtons: some View {
    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
      tabButton(item: item, index: index)
    }
  }

  private func tabButton(item: Item, index: Int) -> some View {
    let isSelected = index == selectedIndex
    let textColor: SDG.Color = isSelected ? .neutral700 : .neutral350

    return Button {
      onItemTapped(index)
    } label: {
      Text(item.title)
        .typo(size.typography, textColor)
        .lineLimit(1)
        .truncationMode(.tail)
        .fixedSize(horizontal: legacyMaxWidth == nil, vertical: false)
        .frame(height: size.typography.lineHeight)
        .padding(.bottom, SDGSpacing.spacing6)
        .overlay(alignment: .bottom) {
          if style == .withUnderline, isSelected {
            Color.neutral700
              .frame(height: 2)
              .matchedGeometryEffect(id: "underline", in: underlineNamespace)
          }
        }
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .id(index)
  }
}

// MARK: - Legacy Width Compatibility

private struct LegacyConstrainedTabLayout: Layout {
  
  let spacing: CGFloat
  let maxTotalWidth: CGFloat?
  
  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    guard !subviews.isEmpty else { return .zero }
    
    let totalSpacing = spacing * CGFloat(subviews.count - 1)
    let idealWidths = subviews.map { $0.sizeThatFits(.unspecified).width }
    let totalIdealWidth = idealWidths.reduce(0, +) + totalSpacing
    let maxHeight = subviews.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
    
    let width: CGFloat
    if let maxTotalWidth, totalIdealWidth > maxTotalWidth {
      width = maxTotalWidth
    } else {
      width = totalIdealWidth
    }
    
    return CGSize(width: width, height: maxHeight)
  }
  
  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    guard !subviews.isEmpty else { return }
    
    let widths = computeWidths(subviews: subviews, totalWidth: bounds.width)
    
    var x = bounds.minX
    for (index, subview) in subviews.enumerated() {
      let width = widths[index]
      let childProposal = ProposedViewSize(width: width, height: bounds.height)
      
      subview.place(
        at: CGPoint(x: x, y: bounds.midY),
        anchor: .leading,
        proposal: childProposal
      )
      
      x += width + (index < subviews.count - 1 ? spacing : 0)
    }
  }
  
  private func computeWidths(subviews: Subviews, totalWidth: CGFloat) -> [CGFloat] {
    let idealWidths = subviews.map { $0.sizeThatFits(.unspecified).width }
    let totalSpacing = spacing * CGFloat(max(subviews.count - 1, 0))
    let contentWidth = totalWidth - totalSpacing
    let totalIdeal = idealWidths.reduce(0, +)
    
    guard maxTotalWidth != nil, totalIdeal > contentWidth, contentWidth > 0 else {
      return idealWidths
    }
    
    return waterFill(naturalWidths: idealWidths, availableWidth: contentWidth)
  }
  
  private func waterFill(naturalWidths: [CGFloat], availableWidth: CGFloat) -> [CGFloat] {
    let sorted = naturalWidths.sorted()
    var remaining = availableWidth
    var capWidth = remaining / CGFloat(sorted.count)
    
    for i in 0..<sorted.count {
      let equalShare = remaining / CGFloat(sorted.count - i)
      if sorted[i] <= equalShare {
        remaining -= sorted[i]
      } else {
        capWidth = equalShare
        break
      }
    }
    
    return naturalWidths.map { min($0, capWidth) }
  }
}

#Preview {
  struct SDGScrollTabPreviewWrapper: View {
    @State private var textSelectedIndex = 0
    @State private var underlineSelectedIndex = 0
    @State private var longTextSelectedIndex = 2
    @State private var maxWidthSelectedIndex = 0
    @State private var maxWidthTextSelectedIndex = 0
    
    var body: some View {
      
      VStack(spacing: 20) {
        
        Spacer()
        
        SDGScrollTab(
          type: .text,
          list: [
            .init(id: "0", title: "첫번째"),
            .init(id: "1", title: "두번째"),
            .init(id: "2", title: "세번째"),
            .init(id: "3", title: "네번째")
          ],
          selectedIndex: $textSelectedIndex
        )
        .padding(.horizontal, 16)
        
        SDGScrollTab(
          type: .underline,
          list: [
            .init(id: "0", title: "첫번째 요소"),
            .init(id: "1", title: "두번째 요소"),
            .init(id: "2", title: "세번째 요소"),
            .init(id: "3", title: "네번째 요소")
          ],
          selectedIndex: $underlineSelectedIndex
        )
        .padding(.horizontal, 16)
        
        SDGScrollTab(
          type: .underline,
          list: [
            .init(id: "0", title: "아주 길고 긴 첫번째 요소인데 어떻게 나오지"),
            .init(id: "1", title: "두번째 요소"),
            .init(id: "2", title: "세번째 요소"),
            .init(id: "3", title: "네번째 요소")
          ],
          selectedIndex: $longTextSelectedIndex
        )
        .padding(.horizontal, 16)
        
        SDGScrollTab(
          type: .underline,
          list: [
            .init(id: "0", title: "Label이 길어지면 한줄로 줄임말 처리합니다."),
            .init(id: "1", title: "Label"),
            .init(id: "2", title: "Label"),
            .init(id: "3", title: "Label")
          ],
          selectedIndex: $maxWidthSelectedIndex,
          maxWidth: 370
        )
        .padding(.horizontal, 16)
        
        SDGScrollTab(
          type: .underline,
          list: [
            .init(id: "0", title: "아주 길고 긴 첫번째 요소인데 어떻게 나오지"),
            .init(id: "1", title: "두번째 요소"),
            .init(id: "2", title: "세번째 요소"),
            .init(id: "3", title: "네번째 요소")
          ],
          selectedIndex: $maxWidthSelectedIndex,
          maxWidth: 300
        )
        .padding(.horizontal, 16)
        
        SDGScrollTab(
          type: .text,
          list: [
            .init(id: "0", title: "Label이 길어지면 한줄로 줄임말 처리합니다."),
            .init(id: "1", title: "Label"),
            .init(id: "2", title: "Label"),
            .init(id: "3", title: "Label")
          ],
          selectedIndex: $maxWidthTextSelectedIndex,
          maxWidth: 280
        )
        .padding(.horizontal, 16)
        
        Spacer()
        
      }
    }
  }
  
  return SDGScrollTabPreviewWrapper()
}
