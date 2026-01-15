//
//  SDGNaviFilterChip.swift
//  SDGSampleApp
//
//  Created by jerry on 1/12/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

public struct SDGNaviFilterChip: View {
  
  public struct Filter: Equatable, Identifiable {
    public let id: String
    public let title: String
    public let count: Int
    
    fileprivate var text: String {
      if count < 2 {
        return title
      }
      
      return "\(title)+\(count)"
    }
    
    public init(id: String, title: String, count: Int) {
      self.id = id
      self.title = title
      self.count = count
    }
  }
  
  public let filters: [Filter]
  public var backgroundColor: Color
  
  public var refresh: () -> Void
  public var remove: (String) -> Void
  
  private var filterBackgroundColor: Color {
    return backgroundColor == .neutral0 ? .neutral50 : .neutral0
  }
  
  public init(
    filters: [Filter],
    backgroundColor: Color? = nil,
    refresh: @escaping () -> Void,
    remove: @escaping (String) -> Void
  ) {
    self.filters = filters
    
    if let backgroundColor = backgroundColor {
      self.backgroundColor = backgroundColor
    } else {
      self.backgroundColor = .neutral50
    }
    
    self.refresh = refresh
    self.remove = remove
  }
  
  public var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 10) {
        
        refreshButton()
        
        filterList()
        
      }
      .padding(.leading, 16)
      
    }
    .background(backgroundColor)
    .scrollIndicators(.hidden)
  }
  
  //MARK: - Private Views
  
  @ViewBuilder
  private func refreshButton() -> some View {
    Button {
      refresh()
    } label: {
      ZStack {
        Image(sdg: .icCommonRefresh)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(.neutral400)
          .frame(width: 20, height: 20)
          .padding(2)
      }
      .background(.neutral0)
      .cornerRadius(8)
    }
  }
  
  
  @ViewBuilder
  private func filterList() -> some View {
    ForEach(filters, id: \.id) { filter in
      
      ZStack {
        HStack(spacing: 4) {
          
          Text(filter.text)
            .typo(.body2_R, .neutral500)
          
          Button {
            
            remove(filter.id)
            
          } label: {
            ZStack {
              Image(sdg: .icCommonX)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.neutral300)
                .frame(width: 14, height: 14)
                .padding(4)
            }
          }
          
        }
      }
      .background(filterBackgroundColor)
      .cornerRadius(8)
      .applyIf(filter.id == filters.last?.id) {
        $0.padding(.trailing, 16)
      }
      
    }
  }
}

#Preview {
  VStack {
    VStack {
      
      Spacer()
      
      SDGNaviFilterChip(
        filters: [
          .init(id: UUID().uuidString, title: "필터명", count: 3),
          .init(id: UUID().uuidString, title: "필터명", count: 1),
          .init(id: UUID().uuidString, title: "필터명", count: 1)
        ],
        refresh: { },
        remove: { _ in }
      )
      
      SDGNaviFilterChip(
        filters: [
          .init(id: UUID().uuidString, title: "필터명이 길어져도 모두 노출", count: 3),
          .init(id: UUID().uuidString, title: "필터명", count: 1),
          .init(id: UUID().uuidString, title: "필터명", count: 1),
          .init(id: UUID().uuidString, title: "필터명", count: 9999)
        ],
        refresh: { },
        remove: { _ in }
      )
      
      Spacer()
    }
    .background(.neutral100)
    
    VStack {
      
      Spacer()
      
      SDGNaviFilterChip(
        filters: [
          .init(id: UUID().uuidString, title: "필터명", count: 3),
          .init(id: UUID().uuidString, title: "필터명", count: 1),
          .init(id: UUID().uuidString, title: "필터명", count: 1)
        ],
        backgroundColor: .neutral0,
        refresh: { },
        remove: { _ in }
      )
      
      SDGNaviFilterChip(
        filters: [
          .init(id: UUID().uuidString, title: "필터명이 길어져도 모두 노출", count: 3),
          .init(id: UUID().uuidString, title: "필터명", count: 1),
          .init(id: UUID().uuidString, title: "필터명", count: 1),
          .init(id: UUID().uuidString, title: "필터명", count: 9999)
        ],
        backgroundColor: .neutral0,
        refresh: { },
        remove: { _ in }
      )
      
      Spacer()
    }
    .background(.neutral0)
    
  }
}
