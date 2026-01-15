//
//  SDGBoxTab.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/8/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

public struct SDGBoxTab: View {

  public enum `Type` {
    case oneLine, twoLine
  }
  
  public struct Model: Equatable {
    public let title: String
    public let selectedItem: String?
    public let count: Int
    
    public init(title: String, selectedItem: String?, count: Int) {
      self.title = title
      self.selectedItem = selectedItem
      self.count = count
    }
  }
  
  private let type: `Type`
  private let hasOutline: Bool
  private let list: [Model]
  
  @Binding private var selectedIndex: Int
  
  public init(
    type: `Type`,
    hasOutline: Bool,
    list: [Model],
    selectedIndex: Binding<Int>
  ) {
    self.type = type
    self.hasOutline = hasOutline
    self.list = list
    self._selectedIndex = selectedIndex
  }
  
  public var body: some View {
    HStack(spacing: 8) {
      ForEach(list.indices, id: \.self) { index in
        tabButton(for: index)
        
        if index != list.count - 1 {
          divider
        }
      }
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 8)
    .background(.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay {
      if hasOutline {
        RoundedRectangle(cornerRadius: 12)
          .stroke(.neutral200, lineWidth: 1)
      }
    }
  }
  
  // MARK: - Private Views
  
  @ViewBuilder
  private func tabButton(for index: Int) -> some View {
    let model = list[index]
    let isSelected = index == selectedIndex
    
    Button {
      withAnimation {
        selectedIndex = index
      }
    } label: {
      tabContent(model: model, isSelected: isSelected)
    }
    .buttonStyle(NoTapAnimationButtonStyle())
  }
  
  @ViewBuilder
  private func tabContent(model: Model, isSelected: Bool) -> some View {
    let titleColor: SDG.Color = isSelected ? .neutral700 : .neutral300
    let subtitleColor: SDG.Color = isSelected ? .neutral500 : .neutral300
    
    VStack(spacing: 2) {
      Text(model.title)
        .typo(.body2_SB, titleColor)
        .lineLimit(nil)
        .frame(maxWidth: .infinity)
      
      if type == .twoLine, let selectedItem = model.selectedItem {
        subtitleRow(item: selectedItem, count: model.count, color: subtitleColor)
      }
    }
  }
  
  @ViewBuilder
  private func subtitleRow(item: String, count: Int, color: SDG.Color) -> some View {
    HStack(spacing: 0) {
      Text(item)
        .typo(.body3_R, color)
        .lineLimit(1)
      
      if count != 0 {
        Text("+\(count)")
          .typo(.body3_SB, color)
          .fixedSize()
      }
    }
  }
  
  private var divider: some View {
    Rectangle()
      .foregroundStyle(.neutral200)
      .frame(width: 1, height: 16)
      .padding(.horizontal, 8)
  }
}

#Preview {
  struct SDGBoxTabPreviewWrapper: View {
    @State private var firstSelectedIndex = 0
    @State private var secondSelectedIndex = 0
    @State private var thirdSelectedIndex = 0

    var body: some View {

      ZStack {
        VStack {

          Spacer()

          SDGBoxTab(
            type: .oneLine,
            hasOutline: false,
            list: [
              .init(title: "타이틀이 길어지면 줄바꿈으로 전체를 노출해줍니다 3줄이든 뭐든 다 노출", selectedItem: nil, count: 0),
              .init(title: "Label", selectedItem: nil, count: 0)
            ],
            selectedIndex: $firstSelectedIndex
          )
          
          SDGBoxTab(
            type: .oneLine,
            hasOutline: false,
            list: [
              .init(title: "Label", selectedItem: nil, count: 0),
              .init(title: "Label", selectedItem: nil, count: 0),
              .init(title: "Label", selectedItem: nil, count: 0)
            ],
            selectedIndex: $secondSelectedIndex
          )
          
          SDGBoxTab(
            type: .oneLine,
            hasOutline: true,
            list: [
              .init(title: "Label", selectedItem: nil, count: 0),
              .init(title: "Label", selectedItem: nil, count: 0),
              .init(title: "Label", selectedItem: nil, count: 0)
            ],
            selectedIndex: $thirdSelectedIndex
          )
          
          
          SDGBoxTab(
            type: .twoLine,
            hasOutline: false,
            list: [
              .init(title: "Label", selectedItem: nil, count: 0),
              .init(title: "Label", selectedItem: "아이템 이름", count: 6)
            ],
            selectedIndex: $firstSelectedIndex
          )
          
          SDGBoxTab(
            type: .twoLine,
            hasOutline: false,
            list: [
              .init(title: "Label", selectedItem: "선택된 아이템", count: 0),
              .init(title: "Label", selectedItem: nil, count: 0),
              .init(title: "Label", selectedItem: nil, count: 0)
            ],
            selectedIndex: $secondSelectedIndex
          )
          
          SDGBoxTab(
            type: .twoLine,
            hasOutline: true,
            list: [
              .init(title: "타이틀이 길어지면 줄바꿈으로 전체를 노출해줍니다", selectedItem: nil, count: 0),
              .init(title: "Label", selectedItem: "selected는 길어질 수 있는데 말줄임디 되어야 한다.", count: 512),
              .init(title: "Label", selectedItem: nil, count: 0)
            ],
            selectedIndex: $thirdSelectedIndex
          )

          Spacer()

        }
      }
    }
  }

  return SDGBoxTabPreviewWrapper()
}
