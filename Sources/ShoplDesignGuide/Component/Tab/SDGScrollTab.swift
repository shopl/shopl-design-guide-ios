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
  
  public enum TabType {
    case line
    case text
  }
  
  public let type: TabType
  
  private var _list: [Model]
  @Binding private var _selectedIndex: Int
  private let _leadingInset: CGFloat
  private let _trailingInset: CGFloat
  
  public init(
    type: TabType,
    list: [Model],
    leadingInset: CGFloat = 16,
    trailingInset: CGFloat = 16,
    selectedIndex: Binding<Int>,
  ) {
    self.type = type
    self.__selectedIndex = selectedIndex
    self._list = list
    self._leadingInset = leadingInset
    self._trailingInset = trailingInset
  }
  
  public var body: some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal) {
        ZStack(alignment: .bottom) {
          if type == .line {
            Color.neutral200
              .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
              .padding(.leading, _leadingInset)
              .padding(.trailing, _trailingInset)
          }
          
          HStack(spacing: 20) {
            ForEach(Array(zip(self._list.indices, self._list)), id: \.1.id) { index, model in
              var selectedColor: SDG.Color {
                index == _selectedIndex ? .neutral700 : .neutral350
              }
              
              var underlineColor: Color {
                index == _selectedIndex ? .neutral700 : .neutral200
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
                  
                  if type == .line {
                    underlineColor
                      .frame(height: index == _selectedIndex ? 2 : 0)
                  }
                }
              }
              .buttonStyle(NoTapAnimationButtonStyle())
              .animation(.easeInOut, value: _selectedIndex)
              .id(index)
            }
          }
        }
        .padding(.leading, _leadingInset)
        .padding(.trailing, _trailingInset)
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
            type: .line,
            list: [
              .init(id: UUID().uuidString, title: "첫번째 요소"),
              .init(id: UUID().uuidString, title: "두번째 요소"),
              .init(id: UUID().uuidString, title: "세번째 요소"),
              .init(id: UUID().uuidString, title: "네번째 요소")
            ],
            selectedIndex: $firstSelectedIndex
          )
          
          SDGScrollTab(
            type: .text,
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
