//
//  SDGFixedTab.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/8/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

public struct SDGFixedTab: View {

  public struct Model: Equatable, Hashable {

    public let id: String
    public let title: String

    public init(id: String, title: String) {
      self.id = id
      self.title = title
    }

  }

  private var _list: [Model]
  private let _unSelectedUnderlineColor: Color
  @Binding private var _selectedIndex: Int
  @Namespace private var underlineNamespace

  public init(
    list: [Model],
    selectedIndex: Binding<Int>,
    unSelectedUnderlineColor: Color = .neutral200
  ) {
    self.__selectedIndex = selectedIndex

    self._list = list
    self._unSelectedUnderlineColor = unSelectedUnderlineColor
  }

  public var body: some View {
    
    ZStack(alignment: .bottom) {

      Color.neutral200
        .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
      
      HStack(spacing: 0) {

        ForEach(
          Array(zip(self._list.indices, self._list)),
          id: \.1.id
        ) { index, model in
          
          var selectedColor: SDG.Color {
            return index == _selectedIndex ? .neutral700 : .neutral350
          }

          var underlineColor: Color {
            return index == _selectedIndex ? .neutral700 : self._unSelectedUnderlineColor
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
                .frame(maxWidth: .infinity, minHeight: 22, maxHeight: 22)
                .padding(.bottom, SDGSpacing.spacing12)
                .padding(.horizontal, SDGSpacing.spacing8)
              
              if index == self._selectedIndex {
                underlineColor
                  .frame(height: 2)
                  .matchedGeometryEffect(id: "underline", in: underlineNamespace)
              } else {
                Color.clear
                  .frame(height: 0)
              }
            }
          }
          .buttonStyle(NoTapAnimationButtonStyle())
          
        }
        
      }
    }
  }
}

#Preview {
  struct SDGFixedTabPreviewWrapper: View {
    @State private var firstSelectedIndex = 0
    @State private var secondSelectedIndex = 1
    
    var body: some View {
      
      ZStack {
        VStack(spacing: 20) {
          
          Spacer()
          
          SDGFixedTab(
            list: [
              .init(id: UUID().uuidString, title: "첫번째 요소"),
              .init(id: UUID().uuidString, title: "두번째 요소")
            ],
            selectedIndex: $firstSelectedIndex
          )
          
          SDGFixedTab(
            list: [
              .init(id: UUID().uuidString, title: "아주 길고 긴 첫번째 요소인데 어떻게 나오지"),
              .init(id: UUID().uuidString, title: "두번째 요소"),
              .init(id: UUID().uuidString, title: "세번째 요소")
            ],
            selectedIndex: $secondSelectedIndex
          )
          
          Spacer()
          
        }
      }
    }
  }
  
  return SDGFixedTabPreviewWrapper()
}
