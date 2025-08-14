//
//  SDGLineFixedTab.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGLineFixedTab: View {
  
  public struct Item: Equatable, Identifiable, Hashable {
    
    public var id: String
    let text: String
    let isInitial: Bool
    
    public init(id: String, text: String, isInitial: Bool) {
      self.id = id
      self.text = text
      self.isInitial = isInitial
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.id == rhs.id
    }
  }
  
  @Binding public var items: [Item]
  @State var selectedItem: Item
  
  private var _didSelected: (Item) -> Void
  
  public init(
    items: Binding<[Item]>,
    didSelected: @escaping (Item) -> Void
  ) {
    self._items = items
    self._selectedItem = State(initialValue: items.wrappedValue.first ?? .init(id: "", text: "", isInitial: true))
    
    self._didSelected = didSelected
  }
  
  public var body: some View {
    
    HStack(spacing: 0) {
      
      ForEach(items) { item in
        Button {
          selectedItem = item
          _didSelected(item)
        } label: {
          SDGLineFixedTabItemView(
            text: item.text,
            isSelected: selectedItem.id == item.id
          )
        }
      }
    }
  }
}

struct SDGLineFixedTabItemView: View {
  
  private let _text: String
  private let _isSelected: Bool
  
  init(text: String, isSelected: Bool) {
    _text = text
    _isSelected = isSelected
  }
  
  var body: some View {
    
    VStack(spacing: 9) {
      
      Text(_text)
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(
          _isSelected
          ? .neutral700
          : .neutral350
        )
        .frame(maxWidth: .infinity, alignment: .center)
      
      ZStack {
        VStack(spacing: 0) {
          Color.clear
            .frame(height: 1.5)
          
          Color.neutral100
            .frame(height: 1.5)
        }
        
        if _isSelected {
          Color.neutral700
            .frame(height: 3)
        } else {
          Color.clear.frame(height: 3)
        }
      }
    }
    .padding(.vertical, 4)
  }
}

struct LineFixedTab_Preview: PreviewProvider {
  
  @State static var items: [SDGLineFixedTab.Item] = [
    .init(id: UUID().uuidString, text: "1", isInitial: true),
    .init(id: UUID().uuidString, text: "1", isInitial: true),
    .init(id: UUID().uuidString, text: "1", isInitial: true),
    .init(id: UUID().uuidString, text: "1", isInitial: true),
    .init(id: UUID().uuidString, text: "1", isInitial: true),
    .init(id: UUID().uuidString, text: "1", isInitial: true)
  ]
  
  static var previews: some View {
    ZStack {
      VStack {
        SDGLineFixedTab(
          items: $items,
          didSelected: { _ in }
        )
      }
      .padding()
    }
  }
}
