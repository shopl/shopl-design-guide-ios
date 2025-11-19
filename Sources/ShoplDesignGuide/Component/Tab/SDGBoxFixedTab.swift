//
//  SDGBoxFixedTab.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGBoxFixedTab: View {
  
  public struct Item: Equatable, Identifiable, Hashable {
    
    public var id: String
    let title: String
    var subtitle: String = ""
    let isInitial: Bool
    
    public init(id: String, title: String, subtitle: String = "", isInitial: Bool = false) {
      self.id = id
      self.title = title
      self.subtitle = subtitle
      self.isInitial = isInitial
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.id == rhs.id
    }
  }
  
  @Binding public var items: [Item]
  @Binding var selectedItem: Item
  
  private var _hasOutline: Bool
  
  private var _didSelected: (Item) -> Void
  
  public init(
    items: Binding<[Item]>,
    selectedItem: Binding<Item>,
    hasOutline: Bool = false,
    didSelected: @escaping (Item) -> Void
  ) {
    self._items = items
    self._selectedItem = selectedItem
    
    self._hasOutline = hasOutline
    
    self._didSelected = didSelected
  }
      
  public var body: some View {
    HStack(spacing: 0) {
      ForEach(items) { item in
        Button {
          _didSelected(item)
        } label: {
          SDGBoxFixedTabItemView(
            title: item.title,
            subtitle: item.subtitle,
            isSelected: selectedItem.id == item.id
          )
          
          if items.last != item {
            divider
          }
        }
        
      }
    }
    .background(.neutral0)
    .cornerRadius(12)
    .applyIf(_hasOutline, apply: {
      $0.overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(.neutral200, lineWidth: 1)
      )
    })
  }
  
  // MARK: - Subviews
  private var divider: some View {
    Rectangle()
      .foregroundStyle(.neutral200)
      .frame(width: 1, height: 16)
      .padding(.horizontal, 8)
  }
}

// MARK: - Item View

struct SDGBoxFixedTabItemView: View {
  
  private let title: String
  private var subtitle: String = ""
  private let isSelected: Bool
  
  public init(title: String, subtitle: String, isSelected: Bool) {
    self.title = title
    self.subtitle = subtitle
    self.isSelected = isSelected
  }
  
  var body: some View {
    HStack(spacing: 0) {
      Spacer()
      VStack(spacing: 2) {
        Text(title)
          .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
          .foregroundColor(isSelected ? .neutral700 : .neutral300)
        
        if !subtitle.isEmpty {
          Text(subtitle)
            .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
            .foregroundColor(isSelected ? .neutral500 : .neutral300)
        }
      }
      .padding(.vertical, 12)
      
      Spacer()
    }
  }
}

#Preview {
  ZStack {
    VStack {
      SDGBoxFixedTab(
        items: .constant([
          .init(id: UUID().uuidString, title: "1"),
          .init(id: UUID().uuidString, title: "2"),
          .init(id: UUID().uuidString, title: "3"),
          .init(id: UUID().uuidString, title: "4"),
          .init(id: UUID().uuidString, title: "5")
        ]),
        selectedItem: .constant(.init(id: UUID().uuidString, title: "1")),
        hasOutline: false,
        didSelected: { _ in }
      )

      SDGBoxFixedTab(
        items: .constant([
          .init(id: UUID().uuidString, title: "1"),
          .init(id: UUID().uuidString, title: "2"),
          .init(id: UUID().uuidString, title: "3"),
          .init(id: UUID().uuidString, title: "4"),
          .init(id: UUID().uuidString, title: "5")
        ]),
        selectedItem: .constant(.init(id: UUID().uuidString, title: "1")),
        hasOutline: true,
        didSelected: { _ in }
      )
    }
    .padding(20)
  }
}
