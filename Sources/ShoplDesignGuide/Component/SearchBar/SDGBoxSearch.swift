//
//  SDGBoxSearch.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/18/25.
//

import SwiftUI

public struct SDGBoxSearch: View {
  
  public enum `Type` {
    case soild
    case line(Color)
  }
  
  private let placeHolder: String
  @Binding private var searchText: String
  
  private let type: `Type`
  private let backgroundColor: Color
  
  private let clear: () -> Void
  private let searchButtonTapped: ((String) -> Void)?
  private let searchTextChanged: ((String) -> Void)?
  
  var lineColor: Color {
    switch type {
    case let .line(color): return color
    default: return .clear
    }
  }
  
  public init(
    placeHolder: String,
    searchText: Binding<String>,
    type: `Type`,
    backgroundColor: Color,
    clear: @escaping () -> Void,
    searchButtonTapped: ((String) -> Void)? = nil,
    searchTextChanged: ((String) -> Void)? = nil
  ) {
    self.placeHolder = placeHolder
    self._searchText = searchText
    self.type = type
    self.backgroundColor = backgroundColor
    self.clear = clear
    self.searchButtonTapped = searchButtonTapped
    self.searchTextChanged = searchTextChanged
  }
  
  public var body: some View {
    ZStack {
      HStack(alignment: .center, spacing: 0) {
        Image(sdg: .icCommonSearch)
          .resizable()
          .foregroundStyle(.neutral300)
          .frame(width: 14, height: 14)
          .padding(.trailing, 4)
        
        TextField(
          "",
          text: $searchText,
          prompt: Text(placeHolder)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.neutral300)
        )
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(.neutral700)
        .submitLabel(.search)
        .frame(maxWidth: .infinity)
        .onSubmit {
          searchButtonTapped?(searchText)
        }
        .onChange(of: searchText) { search in
          searchTextChanged?(search)
        }
        
        Spacer()
          .frame(width: 12)
        
        Image(sdg: .icInputDelete)
          .onTapGesture {
            searchText.removeAll()
          }
          .isHidden(searchText.isEmpty)
      }
      .padding(.vertical, 11)
      .padding(.horizontal, 12)
    }
    .background(self.backgroundColor)
    .cornerRadius(10)
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(lineColor, lineWidth: 1)
    )
  }
}

#Preview {
  
  VStack {
    
    Spacer()
    
    SDGBoxSearch(
      placeHolder: "입력",
      searchText: .constant(""),
      type: .soild,
      backgroundColor: .neutral0,
      clear: {
        
      }
    )
    
    SDGBoxSearch(
      placeHolder: "입력",
      searchText: .constant(""),
      type: .line(.neutral100),
      backgroundColor: .neutral0,
      clear: {
        
      }
    )
    
    SDGBoxSearch(
      placeHolder: "입력",
      searchText: .constant(""),
      type: .soild,
      backgroundColor: .neutral100,
      clear: {
        
      }
    )
    
    SDGBoxSearch(
      placeHolder: "입력",
      searchText: .constant(""),
      type: .line(.neutral0),
      backgroundColor: .neutral100,
      clear: {
        
      }
    )
    
    Spacer()
  }
  .padding(20)
  .background(.black)
}

