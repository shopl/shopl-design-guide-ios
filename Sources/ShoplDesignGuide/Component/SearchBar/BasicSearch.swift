//
//  BasicSearch.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct BasicSearch: View {
  @Binding public var searchTerm: String
  
  private let _placeholder: String
  private let _type: `Type`
  private let _style: Style
  
  private let _searchButtonTapped: (String) -> Void
  private let _searchTermChanged: (String) -> Void
  
  public enum Style {
    case basic(backgroundColor: Color)
    case line(borderColor: Color)
    
    var borderColor: Color {
      switch self {
        case .line(let color):
        return color
        case .basic:
          return Color.clear
      }
    }
    
    var backgroundColor: Color {
      switch self {
        case .line:
        return Color.clear
      case .basic(let color):
        return color
      }
    }
  }
  
  public enum `Type` {
    case round
    case box
  }
  
  public init(
    searchTerm: Binding<String>,
    placeholder: String,
    type: `Type`,
    style: Style,
    searchButtonTapped: @escaping (String) -> Void,
    searchTermChanged: @escaping (String) -> Void
  ) {
    self._searchTerm = searchTerm
    
    self._placeholder = placeholder
    self._type = type
    self._style = style
    
    self._searchButtonTapped = searchButtonTapped
    self._searchTermChanged = searchTermChanged
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: 4) {
      Image(.icCommonSearch)
        .foregroundStyle(.neutral300)
      
      TextField(
        "",
        text: $searchTerm,
        prompt: Text(_placeholder)
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.neutral300)
      )
      .font(.system(size: 14, weight: .regular))
      .foregroundStyle(.neutral700)
      .submitLabel(.search)
      .frame(maxWidth: .infinity)
      .onSubmit {
        self._searchButtonTapped($searchTerm.wrappedValue)
      }
      .onChange(of: $searchTerm.wrappedValue) {
        self._searchTermChanged($0)
      }
      
      Spacer()
        .frame(width: 12)
      
      Image(.icInputDelete)
        .onTapGesture {
          searchTerm.removeAll()
        }
        .isHidden(searchTerm.isEmpty)
    }
    .padding(.horizontal, 12)
    .frame(height: 40)
    .background(
      RoundedRectangle(cornerRadius: _type == .round ? 20 : 10)
        .foregroundStyle(_style.backgroundColor)
    )
    .overlay(
      RoundedRectangle(cornerRadius: _type == .round ? 20 : 10)
        .stroke(_style.borderColor, lineWidth: 1)
    )
  }
}

#Preview {
  ZStack {
    VStack {
      BasicSearch(
        searchTerm: .constant(""),
        placeholder: "placeHolder",
        type: .box,
        style: .basic(backgroundColor: .neutral100),
        searchButtonTapped: { _ in },
        searchTermChanged: { _ in }
      )
      
      BasicSearch(
        searchTerm: .constant(""),
        placeholder: "placeHolder",
        type: .box,
        style: .line(borderColor: .neutral100),
        searchButtonTapped: { _ in },
        searchTermChanged: { _ in }
      )
      
      BasicSearch(
        searchTerm: .constant(""),
        placeholder: "placeHolder",
        type: .round,
        style: .basic(backgroundColor: .neutral100),
        searchButtonTapped: { _ in },
        searchTermChanged: { _ in }
      )
      
      BasicSearch(
        searchTerm: .constant(""),
        placeholder: "placeHolder",
        type: .round,
        style: .basic(backgroundColor: .neutral100),
        searchButtonTapped: { _ in },
        searchTermChanged: { _ in }
      )
    }
    .padding(20)
  }
}

