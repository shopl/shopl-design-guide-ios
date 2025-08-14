//
//  SDGBodySearch.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGBodySearch: View {
  
  private let _placeHolder: String
  private let _isDisabled: Bool
  @Binding private var _searchText: String
  
  private let _clear: () -> ()
  private let _onSubmit: ((String) -> Void)?
  
  public init(
    placeHolder: String,
    isDisabled: Bool,
    searchText: Binding<String>,
    clear: @escaping () -> (),
    onSubmit: ((String) -> Void)? = nil
  ) {
    _placeHolder = placeHolder
    _isDisabled = isDisabled
    __searchText = searchText
    _clear = clear
    _onSubmit = onSubmit
  }
  
  init(placeHolder: String, isDisabled: Bool) {
    _placeHolder = placeHolder
    _isDisabled = isDisabled
    __searchText = Binding<String>.constant("")
    _onSubmit = nil
    _clear = { }
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      
      Image(.icCommonSearch)
        .frame(width: 14, height: 14)
        .foregroundColor(.neutral300)
        .padding(.leading, 12)
      
      TextField(_placeHolder, text: $_searchText) {
        _onSubmit?(_searchText)
      }
        .font(.system(size: 14, weight: .regular))
        .foregroundColor(.neutral700)
        .padding(.leading, 4)
        .padding(.vertical, 6)
        .disabled(_isDisabled)
      
      if _searchText != "" {
        Button {
          _clear()
        } label: {
          Image(.icInputDelete)
            .resizable()
            .frame(width: 18, height: 18)
        }
        .padding(.leading, 12)
        .padding(.trailing, 12)
      
      }
 
    }
    .frame(minHeight: 32)
    .background(.neutral0)
    .clipShape(Capsule())
  }
  
}

struct BodyRoundSearch_Preview: PreviewProvider {
  
  @Binding var searchText: String
  
  static var previews: some View {
    ZStack {
      VStack {
        SDGBodySearch(placeHolder: "힌트문구", isDisabled: true)
      }
      .padding(20)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      Color.sdgGreen
        .ignoresSafeArea(.all, edges: .all)
    )
  }
}
