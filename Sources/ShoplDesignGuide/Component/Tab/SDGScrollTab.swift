//
//  SDGScrollTab.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/7/26.
//
import SwiftUI

public struct SDGScrollTab: View {
  
  public enum `Type`: Equatable {
    case text
    case underline
  }
  
  public struct Model: Equatable, Hashable {
    public let id: String
    public let title: String
    
    public init(id: String, title: String) {
      self.id = id
      self.title = title
    }
  }
  
  private let type: `Type`
  private let list: [Model]
  private let maxWidth: CGFloat?
  
  @Binding private var selectedIndex: Int
  
  public init(
    type: `Type` = .underline,
    list: [Model],
    selectedIndex: Binding<Int>,
    maxWidth: CGFloat? = nil
  ) {
    self.type = type
    self.list = list
    self._selectedIndex = selectedIndex
    self.maxWidth = maxWidth
  }
  
  public var body: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal) {
        
        switch type {
        case .text:
          textBody
        case .underline:
          underlineBody
        }
        
      }
      .scrollIndicators(.hidden)
      .onAppear {
        withAnimation {
          proxy.scrollTo(selectedIndex)
        }
      }
      .onChange(of: selectedIndex) { newValue in
        withAnimation {
          proxy.scrollTo(newValue)
        }
      }
    }
  }
  
  // MARK: - Private Views
  
  private var textBody: some View {
    TabHStackLayout(spacing: SDGSpacing.spacing20.rawValue, maxTotalWidth: maxWidth) {
      
      ForEach(
        Array(zip(list.indices, list)),
        id: \.1.id
      ) { index, model in
        
        tabButton(for: index, model: model)
        
      }
      
    }
  }
  
  private var underlineBody: some View {
    ZStack(alignment: .bottom) {
      
      Color.neutral200
        .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
      
      TabHStackLayout(spacing: SDGSpacing.spacing20.rawValue, maxTotalWidth: maxWidth) {
        
        ForEach(
          Array(zip(list.indices, list)),
          id: \.1.id
        ) { index, model in
          
          tabButton(for: index, model: model)
          
        }
        
      }
    }
  }
  
  @ViewBuilder
  private func tabButton(for index: Int, model: Model) -> some View {
    let isSelected = index == selectedIndex
    let textColor: SDG.Color = isSelected ? .neutral700 : .neutral350
    
    Button {
      selectedIndex = index
    } label: {
      
      switch type {
      case .text:
        Text(model.title)
          .typo(.title2_SB, textColor)
          .lineLimit(1)
          .frame(height: 22)
          .padding(.bottom, SDGSpacing.spacing6)
        
      case .underline:
        ZStack(alignment: .bottom) {
          Text(model.title)
            .typo(.title2_SB, textColor)
            .lineLimit(1)
            .frame(height: 22)
            .padding(.bottom, SDGSpacing.spacing6)
          
          Color.neutral700
            .frame(height: isSelected ? 2 : 0)
        }
      }
      
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .animation(.easeInOut, value: selectedIndex)
    .id(index)
  }
}

// MARK: - Tab Layout

private struct TabHStackLayout: Layout {
  
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
