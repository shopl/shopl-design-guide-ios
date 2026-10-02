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

  @Environment(\.isEnabled) private var isEnabled
  @Namespace private var underlineNamespace
  @Namespace private var contentCoordinateSpace
  @Namespace private var viewportCoordinateSpace
  @State private var selectionGeometry: SelectionGeometry?
  @State private var contentFrame: CGRect = .zero
  @State private var reselectionCount = 0

  private let selectionAnimation = Animation.easeInOut(duration: 0.3)

  private enum ScrollTarget: Hashable {
    case start
    case item(String)
    case itemLeading(String)
  }

  private struct SelectionGeometry: Equatable {
    let itemID: String
    let frame: CGRect
  }

  private struct SelectionGeometryKey: PreferenceKey {
    static var defaultValue: SelectionGeometry? { nil }

    static func reduce(value: inout SelectionGeometry?, nextValue: () -> SelectionGeometry?) {
      if let nextValue = nextValue() {
        value = nextValue
      }
    }
  }

  private struct ContentFrameKey: PreferenceKey {
    static var defaultValue: CGRect? { nil }

    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
      // 측정값이 없는 형제 뷰의 기본값으로 실제 콘텐츠 프레임을 지우지 않습니다.
      if let nextValue = nextValue() {
        value = nextValue
      }
    }
  }

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
  /// 라벨·간격·좌우 여백의 전체 너비가 가용 너비를 초과할 때만 수평 스크롤을 허용합니다.
  /// 선택 라벨이 보이는 데 필요한 만큼 스크롤하며, 라벨이 스크롤 영역보다 길면 시작점을 표시합니다.
  /// 이미 선택된 라벨을 다시 탭해도 같은 스크롤 규칙을 적용합니다.
  /// 시작점을 드러낼 때 첫 항목은 horizontalPadding, 나머지는 아이템 간격만큼 앞쪽 여백을 확보합니다.
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
    GeometryReader { viewport in
      ScrollViewReader { proxy in
        ScrollView(.horizontal) {
          tabContent
            .animation(selectionAnimation, value: selectedIndex)
            .padding(.horizontal, horizontalPadding)
            .background {
              GeometryReader { content in
                Color.clear.preference(
                  key: ContentFrameKey.self,
                  value: CGRect(
                    origin: content.frame(in: .named(viewportCoordinateSpace)).origin,
                    size: content.size
                  )
                )
              }
            }
            .coordinateSpace(name: contentCoordinateSpace)
            .id(ScrollTarget.start)
        }
        .coordinateSpace(name: viewportCoordinateSpace)
        .scrollIndicators(.hidden)
        .scrollDisabled(contentFrame.width <= viewport.size.width)
        .contentShape(Rectangle())
        // 아이템 외의 영역에서 끝난 탭도 이 스크롤 영역에서 받습니다.
        .onTapGesture { }
        .onPreferenceChange(ContentFrameKey.self) { frame in
          guard let frame else { return }
          contentFrame = frame
        }
        .onPreferenceChange(SelectionGeometryKey.self) { geometry in
          selectionGeometry = geometry
          // 외부 선택 변경도 대상 라벨의 레이아웃이 반영된 뒤 스크롤합니다.
          scrollToSelection(geometry, in: viewport.size.width, using: proxy)
        }
        .onAppear {
          scrollToSelection(selectionGeometry, in: viewport.size.width, using: proxy)
        }
        .onChange(of: reselectionCount) { _ in
          scrollToSelection(selectionGeometry, in: viewport.size.width, using: proxy)
        }
        // 원점은 수동 스크롤 중에도 변하므로 너비가 바뀔 때만 다시 정렬합니다.
        .onChange(of: contentFrame.width) { _ in
          scrollToSelection(selectionGeometry, in: viewport.size.width, using: proxy)
        }
        .onChange(of: viewport.size.width) { width in
          scrollToSelection(selectionGeometry, in: width, using: proxy)
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

  private func scrollToSelection(
    _ geometry: SelectionGeometry?,
    in viewportWidth: CGFloat,
    using proxy: ScrollViewProxy
  ) {
    guard let geometry,
          viewportWidth > 0,
          items.indices.contains(selectedIndex),
          geometry.itemID == items[selectedIndex].id else { return }

    let isLeadingClipped = geometry.frame.minX + contentFrame.minX < 0
    let isWiderThanViewport = geometry.frame.width > viewportWidth
    let revealsLeading = isLeadingClipped || isWiderThanViewport
    let target: ScrollTarget
    if revealsLeading {
      target = selectedIndex == 0 ? .start : .itemLeading(geometry.itemID)
    } else {
      // 라벨 끝을 드러내는 이동에는 앞쪽 여백을 추가하지 않습니다.
      target = .item(geometry.itemID)
    }
    withAnimation(selectionAnimation) {
      proxy.scrollTo(target, anchor: revealsLeading ? .leading : nil)
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

    return Text(item.title)
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
      .contentShape(Rectangle())
      .onTapGesture {
        guard isEnabled else { return }
        onItemTapped(index)
        // 탭하기 전부터 선택된 항목만 재탭으로 처리합니다.
        if isSelected {
          reselectionCount &+= 1
        }
      }
      .background {
        if isSelected {
          GeometryReader { geometry in
            Color.clear.preference(
              key: SelectionGeometryKey.self,
              value: SelectionGeometry(
                itemID: item.id,
                frame: geometry.frame(in: .named(contentCoordinateSpace))
              )
            )
            .background(alignment: .trailing) {
              // 표시 너비와 간격은 그대로 두고, 스크롤 목표만 앞쪽 간격까지 확장합니다.
              Color.clear
                .frame(width: geometry.size.width + size.spacing, height: geometry.size.height)
                .id(ScrollTarget.itemLeading(item.id))
                .allowsHitTesting(false)
            }
          }
        }
      }
      .id(ScrollTarget.item(item.id))
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

#Preview("Style × Size") {
  VStack(alignment: .leading, spacing: 24) {
    SDGScrollTabPreviewRow(style: .withUnderline, size: .large)
    SDGScrollTabPreviewRow(style: .withUnderline, size: .medium)
    SDGScrollTabPreviewRow(style: .onlyText, size: .large)
    SDGScrollTabPreviewRow(style: .onlyText, size: .medium)
  }
  .padding(.vertical, 20)
}

#Preview("긴 라벨 / 수평 스크롤") {
  VStack(alignment: .leading, spacing: 24) {
    SDGScrollTabPreviewRow(style: .withUnderline, size: .large, longTitle: true)
    SDGScrollTabPreviewRow(style: .withUnderline, size: .medium, longTitle: true)
    SDGScrollTabPreviewRow(style: .onlyText, size: .large, longTitle: true)
    SDGScrollTabPreviewRow(style: .onlyText, size: .medium, longTitle: true)
  }
  .padding(.vertical, 20)
}

#Preview("짧은 라벨 8개 / 280pt 수평 스크롤") {
  VStack(alignment: .leading, spacing: 24) {
    SDGScrollTabOverflowPreviewRow(style: .withUnderline, size: .large)
    SDGScrollTabOverflowPreviewRow(style: .withUnderline, size: .medium)
    SDGScrollTabOverflowPreviewRow(style: .onlyText, size: .large)
    SDGScrollTabOverflowPreviewRow(style: .onlyText, size: .medium)
  }
  .frame(width: 280)
  .padding(.vertical, 20)
}

#Preview("짧은 라벨 2개 / 280pt 스크롤 비활성") {
  VStack(alignment: .leading, spacing: 24) {
    SDGScrollTabOverflowPreviewRow(style: .withUnderline, size: .large, itemCount: 2)
    SDGScrollTabOverflowPreviewRow(style: .withUnderline, size: .medium, itemCount: 2)
    SDGScrollTabOverflowPreviewRow(style: .onlyText, size: .large, itemCount: 2)
    SDGScrollTabOverflowPreviewRow(style: .onlyText, size: .medium, itemCount: 2)
  }
  .frame(width: 280)
  .padding(.vertical, 20)
}

#Preview("Baseline Divider / 여백과 남는 영역") {
  VStack(alignment: .leading, spacing: 24) {
    SDGScrollTabPreviewRow(style: .withUnderline, size: .large, showsBaselineDivider: true, itemCount: 2)
    SDGScrollTabPreviewRow(style: .withUnderline, size: .medium, showsBaselineDivider: true, itemCount: 2)
    SDGScrollTabPreviewRow(style: .onlyText, size: .large, showsBaselineDivider: true, itemCount: 2)
    SDGScrollTabPreviewRow(style: .onlyText, size: .medium, showsBaselineDivider: true, itemCount: 2)
  }
  .padding(.vertical, 20)
}

#Preview("외부 선택 / 8개 탭 / 빈 목록") {
  SDGScrollTabSelectionPreview()
}

#Preview("초기 선택이 화면 밖인 경우") {
  SDGScrollTabSelectionPreview(initialSelectedIndex: 3)
}

#Preview("긴 라벨 재탭 / 선택값 유지") {
  VStack(alignment: .leading, spacing: 8) {
    Text("선택된 네 번째 라벨의 앞부분을 스크롤로 가린 뒤 같은 라벨을 다시 탭하세요.")
      .typo(.body2_R, .neutral500)
      .padding(.horizontal, 16)

    SDGScrollTabSelectionPreview(initialSelectedIndex: 3)
  }
}

#Preview("앞부분 여백 / Large 20pt") {
  SDGScrollTabSelectionPreview(initialSelectedIndex: 7, initialLongLabel: false)
}

#Preview("앞부분 여백 / Medium 18pt") {
  SDGScrollTabSelectionPreview(size: .medium, initialSelectedIndex: 7, initialLongLabel: false)
}

private struct SDGScrollTabPreviewRow: View {
  let style: SDGScrollTab.Style
  let size: SDGScrollTab.Size
  var longTitle = false
  var showsBaselineDivider = false
  var itemCount = 5

  @State private var selectedIndex = 0

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("\(style == .withUnderline ? "With Underline" : "Only Text") / \(size == .large ? "Large" : "Medium")")
        .typo(.body3_SB, .neutral500)
        .padding(.horizontal, 16)

      SDGScrollTab(
        style: style,
        size: size,
        items: (0..<itemCount).map { index in
          .init(
            id: String(index),
            title: longTitle && index == 0
              ? "긴 라벨도 한 줄에 전체 표시하고 수평 스크롤로 탐색합니다"
              : "Label"
          )
        },
        selectedIndex: selectedIndex,
        horizontalPadding: 16,
        showsBaselineDivider: showsBaselineDivider,
        onItemTapped: { selectedIndex = $0 }
      )
    }
  }
}

private struct SDGScrollTabOverflowPreviewRow: View {
  let style: SDGScrollTab.Style
  let size: SDGScrollTab.Size
  var itemCount = 8

  @State private var selectedIndex = 0

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("\(style == .withUnderline ? "With Underline" : "Only Text") / \(size == .large ? "Large" : "Medium")")
        .typo(.body3_SB, .neutral500)
        .padding(.horizontal, 16)

      SDGScrollTab(
        style: style,
        size: size,
        items: (0..<itemCount).map { .init(id: String($0), title: "Label \($0 + 1)") },
        selectedIndex: selectedIndex,
        horizontalPadding: 16,
        onItemTapped: { selectedIndex = $0 }
      )

      Text("선택: Label \(selectedIndex + 1)")
        .typo(.body3_SB, .neutral500)
        .padding(.horizontal, 16)
    }
  }
}

private struct SDGScrollTabSelectionPreview: View {
  let size: SDGScrollTab.Size

  @State private var selectedIndex: Int
  @State private var lastClickedIndex: Int?
  @State private var acceptsSelection = true
  @State private var isEmpty = false
  @State private var usesFewItems = false
  @State private var showsBaselineDivider = false
  @State private var usesLongLabel: Bool

  init(
    size: SDGScrollTab.Size = .large,
    initialSelectedIndex: Int = 0,
    initialLongLabel: Bool = true
  ) {
    self.size = size
    self._selectedIndex = State(initialValue: initialSelectedIndex)
    self._usesLongLabel = State(initialValue: initialLongLabel)
  }

  private var items: [SDGScrollTab.Item] {
    isEmpty ? [] : (0..<(usesFewItems ? 2 : 8)).map { index in
      .init(
        id: String(index),
        title: usesLongLabel && index == 3
          ? "스크롤 영역보다 긴 라벨은 선택하면 이 문장의 시작부터 표시합니다"
          : "Label \(index + 1)"
      )
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      SDGScrollTab(
        size: size,
        items: items,
        selectedIndex: selectedIndex,
        horizontalPadding: 16,
        showsBaselineDivider: showsBaselineDivider,
        onItemTapped: { index in
          lastClickedIndex = index
          if acceptsSelection {
            selectedIndex = index
          }
        }
      )
      .frame(width: 280)

      VStack(alignment: .leading, spacing: 16) {
        Text("선택 인덱스: \(selectedIndex)")
        Text("마지막 클릭: \(lastClickedIndex.map { String($0) } ?? "없음")")
        Toggle("클릭 시 선택 변경", isOn: $acceptsSelection)
        Toggle("네 번째에 긴 라벨 사용", isOn: $usesLongLabel)
        Toggle("짧은 라벨 2개만 표시", isOn: $usesFewItems)
        Toggle("빈 목록", isOn: $isEmpty)
        Toggle("Baseline Divider", isOn: $showsBaselineDivider)
        Button("외부에서 첫 번째 선택") { selectedIndex = 0 }
        Button("외부에서 네 번째 선택") { selectedIndex = 3 }
        Button("외부에서 다섯 번째 선택") { selectedIndex = 4 }
        Button("외부에서 여덟 번째 선택") { selectedIndex = 7 }
        Button("유효하지 않은 인덱스 전달") { selectedIndex = 99 }
      }
      .padding(.horizontal, 16)
    }
    .padding(.vertical, 20)
  }
}
