//
//  SDGCapsuleSearch.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/18/25.
//

import SwiftUI

/// 텍스트 검색과 지우기 기능을 제공하는 캡슐형 검색창입니다.
public struct SDGCapsuleSearch: View {
  
  public enum `Type` {
    case soild
    case line(Color)
  }
  
  private let placeHolder: String
  @Binding private var searchText: String
  
  private let type: `Type`
  private let backgroundColor: Color
  private let autoFocus: Bool
  @FocusState private var isTextFieldFocused: Bool
  
  private var clearAllButtonTapped: () -> Void
  private let searchButtonTapped: ((String) -> Void)?
  private let searchTextChanged: ((String) -> Void)?
  
  var lineColor: Color {
    switch type {
    case let .line(color): return color
    default: return .clear
    }
  }
  
  /// - Parameter autoFocus: 화면에 나타날 때 입력 포커스를 요청합니다. 기본값은 `false`입니다.
  public init(
    placeHolder: String,
    searchText: Binding<String>,
    type: `Type`,
    backgroundColor: Color,
    autoFocus: Bool = false,
    clearAllButtonTapped: @escaping () -> Void,
    searchButtonTapped: ((String) -> Void)? = nil,
    searchTextChanged: ((String) -> Void)? = nil
  ) {
    self.placeHolder = placeHolder
    self._searchText = searchText
    self.type = type
    self.backgroundColor = backgroundColor
    self.autoFocus = autoFocus
    self.clearAllButtonTapped = clearAllButtonTapped
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
        .focused($isTextFieldFocused)
        .task {
          if autoFocus {
            isTextFieldFocused = true
          }
        }
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
            clearAllButtonTapped()
          }
          .isHidden(searchText.isEmpty)
      }
      .padding(.vertical, 11)
      .padding(.horizontal, 12)
    }
    .frame(height: 40)
    .background(self.backgroundColor)
    .cornerRadius(20)
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(lineColor, lineWidth: 1)
    )
  }
}

#Preview {
  
  VStack {
    
    Spacer()
    
    SDGCapsuleSearch(
      placeHolder: "입력",
      searchText: .constant(""),
      type: .soild,
      backgroundColor: .neutral0,
      clearAllButtonTapped: {
        
      }
    )
    
    SDGCapsuleSearch(
      placeHolder: "입력",
      searchText: .constant(""),
      type: .line(.neutral100),
      backgroundColor: .neutral0,
      clearAllButtonTapped: {
        
      }
    )
    
    SDGCapsuleSearch(
      placeHolder: "입력",
      searchText: .constant(""),
      type: .soild,
      backgroundColor: .neutral100,
      clearAllButtonTapped: {
        
      }
    )
    
    SDGCapsuleSearch(
      placeHolder: "입력",
      searchText: .constant(""),
      type: .line(.neutral0),
      backgroundColor: .neutral100,
      clearAllButtonTapped: {
        
      }
    )
    
    Spacer()
  }
  .padding(20)
  .background(.black)
}
