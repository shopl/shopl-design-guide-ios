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
  @Binding private var _selectedIndex: Int

  public init(
    list: [Model],
    selectedIndex: Binding<Int>
  ) {
    self.__selectedIndex = selectedIndex

    self._list = list
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
          
          var selectedColor: TypoColor {
            return index == _selectedIndex ? .neutral700 : .neutral350
          }
          
          var underlineColor: Color {
            return index == _selectedIndex ? .neutral700 : .neutral200
          }
          
          Button {
            
            _selectedIndex = index
            
          } label: {
            ZStack(alignment: .bottom) {
              Text(model.title)
                .typo(.title2_SB, selectedColor)
                .lineLimit(1)
                .frame(maxWidth: .infinity, minHeight: 22, maxHeight: 22)
                .padding(.bottom, SDGSpacing.spacing10)
                .padding(.horizontal, SDGSpacing.spacing8)
              
              underlineColor
                .frame(height: index == self._selectedIndex ? 2 : 0)
            }
          }
          .buttonStyle(NoTapAnimationButtonStyle())
          .animation(.easeInOut, value: _selectedIndex)
          
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
