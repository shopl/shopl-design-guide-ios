//
//  SDGFixedTab.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/8/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

public struct SDGFixedTab: View {
  public static let version = "2.3.48"

  private enum State {
    case unselected
    case selected
  }

  public struct Model: Equatable, Hashable {

    public let id: String
    public let title: String

    public init(id: String, title: String) {
      self.id = id
      self.title = title
    }

  }

  /// 가이드에서 제공하는 2개 또는 3개 탭 구성입니다.
  public enum Options {
    case two(Model, Model)
    case three(Model, Model, Model)

    fileprivate var models: [Model] {
      switch self {
      case let .two(first, second): [first, second]
      case let .three(first, second, third): [first, second, third]
      }
    }
  }

  private let showsBaselineDivider: Bool
  private let horizontalInset: CGFloat
  private var _list: [Model]
  private let _unSelectedUnderlineColor: Color
  @Binding private var _selectedIndex: Int
  @Namespace private var underlineNamespace

  public init(
    list: [Model],
    selectedIndex: Binding<Int>,
    unSelectedUnderlineColor: Color = .neutral200
  ) {
    self.init(
      list: list,
      selectedIndex: selectedIndex,
      unSelectedUnderlineColor: unSelectedUnderlineColor,
      showsBaselineDivider: true
    )
  }

  /// 기존 배열 API에 Divider 설정을 추가합니다. 기존 옵션 개수는 제한하지 않습니다.
  /// horizontalInset은 탭 영역의 좌우 여백이며 Divider는 이 여백까지 확장됩니다.
  public init(
    list: [Model],
    selectedIndex: Binding<Int>,
    unSelectedUnderlineColor: Color = .neutral200,
    showsBaselineDivider: Bool,
    horizontalInset: CGFloat = 0
  ) {
    self.__selectedIndex = selectedIndex
    self._list = list
    self._unSelectedUnderlineColor = unSelectedUnderlineColor
    self.showsBaselineDivider = showsBaselineDivider
    self.horizontalInset = max(0, horizontalInset)
  }

  public init(
    options: Options,
    selectedIndex: Binding<Int>,
    unSelectedUnderlineColor: Color = .neutral200,
    showsBaselineDivider: Bool = false,
    horizontalInset: CGFloat = 0
  ) {
    self.init(
      list: options.models,
      selectedIndex: selectedIndex,
      unSelectedUnderlineColor: unSelectedUnderlineColor,
      showsBaselineDivider: showsBaselineDivider,
      horizontalInset: horizontalInset
    )
  }

  public var body: some View {
    
    ZStack(alignment: .bottom) {

      if showsBaselineDivider {
        self._unSelectedUnderlineColor
          .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
          .allowsHitTesting(false)
      }
      
      HStack(spacing: 0) {

        ForEach(
          Array(zip(self._list.indices, self._list)),
          id: \.1.id
        ) { index, model in
          let state: State = index == _selectedIndex ? .selected : .unselected
          
          var selectedColor: SDG.Color {
            return state == .selected ? .neutral700 : .neutral350
          }

          var underlineColor: Color {
            return state == .selected ? .neutral700 : self._unSelectedUnderlineColor
          }
          
          Button {
            withAnimation(.easeInOut(duration: 0.3)) {
              _selectedIndex = index
            }
          } label: {
            ZStack(alignment: .bottom) {
              Text(model.title)
                .typo(.body1_SB, selectedColor)
                .lineLimit(1)
                .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                .padding(.bottom, SDGSpacing.spacing12)
                .padding(.horizontal, SDGSpacing.spacing8)
              
              if state == .selected {
                underlineColor
                  .frame(height: 2)
                  .matchedGeometryEffect(id: "underline", in: underlineNamespace)
              } else {
                // Divider가 있으면 같은 위치의 선을 재사용하여 반투명 색상이 중첩되지 않게 합니다.
                (showsBaselineDivider ? Color.clear : underlineColor)
                  .frame(height: 1)
              }
            }
            .contentShape(Rectangle())
          }
          .frame(maxWidth: .infinity)
          .buttonStyle(NoTapAnimationButtonStyle())
          
        }
        
      }
      .padding(.horizontal, horizontalInset)
    }
  }
}

#Preview("2 / 3 Option · Divider 설정") {
  SDGFixedTabPreview()
}

private struct SDGFixedTabPreview: View {
  @State private var selectedIndex = 0
  @State private var threeSelectedIndex = 0
  private let first = SDGFixedTab.Model(id: "first", title: "아주 길고 긴 첫 번째 탭 제목")
  private let second = SDGFixedTab.Model(id: "second", title: "두 번째")
  private let third = SDGFixedTab.Model(id: "third", title: "세 번째")

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        Text("2 Option · Divider 없음")
        SDGFixedTab(options: .two(first, second), selectedIndex: $selectedIndex)
        Text("3 Option · Divider 없음")
        SDGFixedTab(options: .three(first, second, third), selectedIndex: $threeSelectedIndex)
        Text("2 Option · Divider 있음 · 좌우 20")
        SDGFixedTab(
          options: .two(first, second), selectedIndex: $selectedIndex,
          showsBaselineDivider: true, horizontalInset: 20
        )
        Text("3 Option · Divider 있음 · 커스텀 색상")
        SDGFixedTab(
          options: .three(first, second, third), selectedIndex: $threeSelectedIndex,
          unSelectedUnderlineColor: .neutral350,
          showsBaselineDivider: true, horizontalInset: 20
        )
        Text("Divider 없음 · 좌우 20 · 미선택 밑줄 유지")
        SDGFixedTab(
          options: .two(first, second), selectedIndex: $selectedIndex,
          showsBaselineDivider: false, horizontalInset: 20
        )
        Text("기존 initializer")
        SDGFixedTab(list: [first, second], selectedIndex: $selectedIndex)
      }
      .padding(.vertical, 24)
    }
  }
}
