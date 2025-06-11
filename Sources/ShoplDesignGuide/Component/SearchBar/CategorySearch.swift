//
//  CategorySearch.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct CategorySearch: View {
  
  public struct IconModel: Equatable {
    public let id: String
    public let label: String
    public let icon: Image?
    
    public init(id: String, label: String, icon: Image?) {
      self.id = id
      self.label = label
      self.icon = icon
    }
  }
  
  @Binding public var searchText: String
  @Binding public var placeholder: String
  @Binding public var isFocused: Bool
  @Binding public var iconModel: IconModel
  
  private var _searchTapped: () -> Void
  private var _showSearchCategoryPopup: () -> Void
  private var _clearAllButtonTapped: () -> Void
  
  public init(
    searchText: Binding<String>,
    placeholder: Binding<String>,
    isFocused: Binding<Bool>,
    iconModel: Binding<IconModel>,
    _searchTapped: @escaping () -> Void,
    _showSearchCategoryPopup: @escaping () -> Void,
    _clearAllButtonTapped: @escaping () -> Void
  ) {
    self._searchText = searchText
    self._placeholder = placeholder
    self._isFocused = isFocused
    self._iconModel = iconModel
    
    self._searchTapped = _searchTapped
    self._showSearchCategoryPopup = _showSearchCategoryPopup
    self._clearAllButtonTapped = _clearAllButtonTapped
  }
    
  public var body: some View {
    HStack(spacing: 0) {
      Button {
        _showSearchCategoryPopup()
      } label: {
        HStack(spacing: 0) {
          iconModel.icon
            .foregroundStyle(.neutral700)
          
          Image(.icCommonDropdown)
            .foregroundStyle(.neutral700)
        }
      }
      
      FocusableTextField(
        placeholder: $placeholder,
        text: $searchText,
        isFocused: $isFocused,
        returnAction: {
          _searchTapped()
        }
      )
      .frame(maxWidth: .infinity, maxHeight: 18)
      .padding(.vertical, 11)
      
      if !searchText.isEmpty {
        Button {
          _clearAllButtonTapped()
          
        } label: {
          Image(.icInputDelete)
            .resizable()
            .frame(width: 18, height: 18)
        }
        .padding(.leading, 12)
        .padding(.trailing, 12)
      }
    }
    .padding(.leading, 12)
    .frame(minHeight: 32)
    .background(.neutral0)
    .clipShape(Capsule())
  }
}

#Preview {
  ZStack {
    VStack {
      CategorySearch(
        searchText: .constant(""),
        placeholder: .constant("placeholder"),
        isFocused: .constant(false),
        iconModel: .constant(.init(id: "", label: "", icon: Image(.icCommonDistributor))),
        _searchTapped: { },
        _showSearchCategoryPopup: { },
        _clearAllButtonTapped: { }
      )
    }
    .padding(20)
  }
}
