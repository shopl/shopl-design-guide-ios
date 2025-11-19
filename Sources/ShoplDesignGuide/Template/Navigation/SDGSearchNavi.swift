//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

public struct SDGSearchNavi: View {
  
  public struct SearchButtonOption {
    
    public let searchImage: Image
    public let tintColor: Color
    public let placeholder: String
    public let search: (String) -> ()
    
    public init(
      searchImage: Image,
      tintColor: Color,
      placeholder: String,
      search: @escaping (String) -> ()
    ) {
      self.searchImage = searchImage
      self.tintColor = tintColor
      self.placeholder = placeholder
      self.search = search
    }
  }
  
  private let _naviType: TopNaviType
  private let _title: TopNaviTextOption?
  private let _backgroundColor: Color
  private let _searchButton: SearchButtonOption?
  private let _buttons: [TopNaviButtonOption]
  
  @State private var _searchState: Bool = false
  @State private var _searchText: String = ""
  
  @FocusState private var isTextFieldFocused: Bool
  
  public init(
    naviType: TopNaviType,
    title: TopNaviTextOption?,
    backgroundColor: Color,
    searchButton: SearchButtonOption,
    buttons: [TopNaviButtonOption] = []
  ) {
    _naviType = naviType
    _title = title
    _backgroundColor = backgroundColor
    _searchButton = searchButton
    _buttons = buttons
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: 0) {
      
      if case let .pop(tintColor, onDismiss) = _naviType {
        Button {
          onDismiss()
        } label: {
          Image(.icNaviBack)
            .frame(width: 40, height: 40)
            .foregroundStyle(tintColor ?? .neutral700)
        }
        .padding(.leading, -6)
        .padding(.trailing, 2)
      }
      
      if !self._searchState {
        
        if let title = _title {
          Text(title.string)
            .font(.system(size: 19, weight: .regular))
            .foregroundStyle(title.tintColor)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .truncationMode(.tail)
        } else {
          Spacer()
        }
        
        if !_buttons.isEmpty {
          HStack(spacing: 0) {
            ForEach(_buttons, id: \.id) { button in
              
              Button {
                button.touchUpInside?()
              } label: {
                switch button.isBullet {
                  case true:
                    ZStack {
                      button.image
                        .foregroundStyle(button.tintColor)
                      
                      Color.red350
                        .frame(width: 8, height: 8)
                        .cornerRadius(4)
                        .padding([.bottom, .leading], 16)
                      
                    }
                  case false:
                    button.image
                      .foregroundStyle(button.tintColor)
                }
              }
              .frame(width: 40, height: 40)
        .disabled(!button.isEnable)
            }
          }
        }
      } else {
        HStack {
          HStack(spacing: 4) {
            Image(.icCommonSearch)
              .frame(width: 14, height: 14)
              .foregroundStyle(.neutral300)
              .padding(.leading, 12)
            
            HStack(spacing: 12) {
              TextField("", text: $_searchText)
                .placeholder(when: _searchText.isEmpty) {
                  Text("\(_searchButton?.placeholder ?? "")")
                    .foregroundStyle(.neutral300)
                }
                .foregroundStyle(.neutral700)
                .onChange(of: _searchText) {
                  self._searchButton?.search($0)
                }
                .padding(.trailing, 20)
                .padding(.vertical, 11)
                .focused($isTextFieldFocused)
                .onAppear {
                  isTextFieldFocused = true
                }
              
              if !_searchText.isEmpty {
                Button {
                  _searchText = ""
                } label: {
                  ZStack {
                    Image(.icInputDelete)
                      .resizable()
                      .foregroundStyle(.neutral400)
                      .frame(width: 18, height: 18)
                  }
                  .background(.neutral150)
                  .cornerRadius(9)
                  .padding(.trailing, 12)
                }
              }
            }
          }
          
        }
        .background(.neutral0)
        .frame(maxWidth: .infinity, maxHeight: 40)
        .cornerRadius(20)
        .padding(.leading, -6)
        .padding(.trailing, 2)
      }
      
      if let searchButton = _searchButton {
        Button {
          _searchState.toggle()
          
          if !_searchState {
            _searchText = ""
            self._searchButton?.search("")
          }
          
        } label: {
          switch _searchState {
            case true:
              EmptyView()
            
            case false:
              searchButton.searchImage
                .foregroundStyle(searchButton.tintColor)
                .frame(width: 40, height: 40)
          }
        }
      }
      
      if case let .dismiss(tintColor, onDismiss) = _naviType {
        Button {
          onDismiss()
        } label: {
          Image(.icNaviClose)
            .frame(width: 40, height: 40)
            .foregroundColor(tintColor ?? .neutral700)
        }
      }
    }
    .padding(.leading, 16)
    .padding(.trailing, 10)
    .frame(height: 48)
    .background(_backgroundColor)
  }
}


#Preview {
  
  let _ = {
    SDGString.shared.setProvider(provider: TempStringProvider())
  }()
  
  ZStack(alignment: .top) {
    VStack {
      SDGSearchNavi(
        naviType: .pop(tintColor: nil, onDismiss: {
          
        }),
        title: .init(string: "타이틀"),
        backgroundColor: .neutral50,
        searchButton: .init(
          searchImage: Image(.icCommonSearch),
          tintColor: .neutral700,
          placeholder: "검색",
          search: { _ in
            
          }
        ),
        buttons: [
          .init(
            image: Image(.icNaviFilter),
            tintColor: .neutral700
          )
        ]
      )
      
      SDGSearchNavi(
        naviType: .dismiss(tintColor: nil, onDismiss: {
          
        }),
        title: .init(string: "타이틀"),
        backgroundColor: .neutral50,
        searchButton: .init(
          searchImage: Image(.icCommonSearch),
          tintColor: .neutral700,
          placeholder: "검색",
          search: { _ in
            
          }
        ),
        buttons: [
          .init(
            image: Image(.icNaviFilter),
            tintColor: .neutral700
          )
        ]
      )
      
      Spacer()
    }
  }
}
