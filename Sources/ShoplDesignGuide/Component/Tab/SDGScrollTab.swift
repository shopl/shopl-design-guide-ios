//
//  File.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/7/26.
//

import SwiftUI

public struct SDGScrollTab: View {
  
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
    
    ScrollViewReader { proxy in
      
      ScrollView(.horizontal) {
        
        ZStack(alignment: .bottom) {
          
          Color.neutral200
            .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
            .padding(.trailing, 16)
          
          HStack(spacing: 20) {
            
            ForEach(
              Array(zip(self._list.indices, self._list)),
              id: \.1.id
            ) { index, model in
              
              var selectedColor: SDG.Color {
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
                    .fixedSize()
                    .frame(height: 22)
                    .padding(.bottom, 6)
                  
                  underlineColor
                    .frame(height: index == self._selectedIndex ? 2 : 0)
                }
              }
              .buttonStyle(NoTapAnimationButtonStyle())
              .animation(.easeInOut, value: _selectedIndex)
              .padding(.trailing, index == self._list.count - 1 ? 16 : 0)
              .id(index)
              
            }
            
          }
        }
        .padding(.leading, 16)
        .padding(.vertical, 10)
      }
      .scrollIndicators(.hidden)
      .onAppear {
        withAnimation {
          proxy.scrollTo(_selectedIndex)
        }
      }
    }
  }
}

#Preview {
  struct SDGScrollTabPreviewWrapper: View {
    @State private var firstSelectedIndex = 0
    @State private var secondSelectedIndex = 3
    
    var body: some View {
      
      ZStack {
        VStack {
          
          Spacer()
          
          SDGScrollTab(
            list: [
              .init(id: UUID().uuidString, title: "첫번째 요소"),
              .init(id: UUID().uuidString, title: "두번째 요소"),
              .init(id: UUID().uuidString, title: "세번째 요소"),
              .init(id: UUID().uuidString, title: "네번째 요소")
            ],
            selectedIndex: $firstSelectedIndex
          )
          
          SDGScrollTab(
            list: [
              .init(id: UUID().uuidString, title: "아주 길고 긴 첫번째 요소인데 어떻게 나오지"),
              .init(id: UUID().uuidString, title: "두번째 요소"),
              .init(id: UUID().uuidString, title: "세번째 요소"),
              .init(id: UUID().uuidString, title: "네번째 요소")
            ],
            selectedIndex: $secondSelectedIndex
          )
          
          Spacer()
          
        }
      }
    }
  }
  
  return SDGScrollTabPreviewWrapper()
}
