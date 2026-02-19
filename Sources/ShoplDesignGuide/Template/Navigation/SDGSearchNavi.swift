//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

public struct SDGSearchNavi: View {
  
  public enum NaviType {
    case full(leading: TopNaviButtonOption, trailing: TopNaviButtonOption)
    case back(leading: TopNaviButtonOption)
    case close(trailing: TopNaviButtonOption)
  }
  
  private let naviType: NaviType
  private let backgroundColor: Color
  public let placeHolder: String
  public let search: (String) -> Void
  
  @State private var _searchText: String = ""
  
  @FocusState private var isTextFieldFocused: Bool
  
  public init(
    naviType: NaviType,
    backgroundColor: Color,
    placeHolder: String,
    search: @escaping (String) -> Void
  ) {
    self.naviType = naviType
    self.backgroundColor = backgroundColor
    self.placeHolder = placeHolder
    self.search = search
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: .zero) {
      switch self.naviType {
      case .full(let leading, let trailing):
        HStack(spacing: SDGSpacing.spacing2) {
          Button {
            leading.touchUpInside?()
          } label: {
            leading.image
              .foregroundStyle(leading.tintColor)
             
          }
          .frame(width: 40, height: 40)

          
          self.textField
          
          
          Button {
            trailing.touchUpInside?()
          } label: {
            trailing.image
              .foregroundStyle(trailing.tintColor)
          }
          .frame(width: 40, height: 40)
        }
      case .back(let leading):
        HStack(spacing: SDGSpacing.spacing2) {
          
          Button {
            leading.touchUpInside?()
          } label: {
            leading.image
              .foregroundStyle(leading.tintColor)
          }
          .frame(width: 40, height: 40)
          
          self.textField
        }
      case .close(let trailing):
        HStack(spacing: SDGSpacing.spacing2) {
          
          self.textField
          
          Button {
            trailing.touchUpInside?()
          } label: {
            trailing.image
              .foregroundStyle(trailing.tintColor)
              .frame(width: 40, height: 40)
          }
        }
      }
    }
    .padding(.leading, 10)
    .padding(.trailing, 10)
    .frame(height: 48)
    .background(backgroundColor)
  }
  
  @ViewBuilder
  private var textField: some View {
    HStack {
      HStack(spacing: 4) {
        Image(sdg: .icCommonSearch)
          .frame(width: 14, height: 14)
          .foregroundStyle(.neutral300)
          .padding(.leading, 12)
        
        HStack(spacing: 12) {
          TextField("", text: $_searchText)
            .placeholder(when: _searchText.isEmpty) {
              Text(placeHolder)
                .foregroundStyle(.neutral300)
            }
            .foregroundStyle(.neutral700)
            .onChange(of: _searchText) {
              self.search($0)
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
                Image(sdg: .icInputDelete)
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
  }
}

#Preview {
  
  let _ = {
    SDGString.shared.setProvider(provider: TempStringProvider())
  }()
  
  ZStack(alignment: .top) {
    VStack {
      Spacer().frame(height: 100)
      SDGSearchNavi(
        naviType: .full(
          leading: .init(
            image: SDG.Image.icNaviBack.image,
            tintColor: .black,
            touchUpInside: {}
          ),
          trailing: .init(
            image: SDG.Image.icNaviClose.image,
            tintColor: .black,
            touchUpInside: {}
          )
        ),
        backgroundColor: .neutral50,
        placeHolder: "이름/사번/휴대폰번호",
        search: { text in
          //
        }
      )
      
      SDGSearchNavi(
        naviType: .back(
          leading: .init(
            image: SDG.Image.icNaviBack.image,
            tintColor: .black,
            touchUpInside: {}
          )
        ),
        backgroundColor: .neutral50,
        placeHolder: "이름/사번/휴대폰번호",
        search: { text in
          //
        }
      )
      
      SDGSearchNavi(
        naviType: .close(
          trailing: .init(
            image: SDG.Image.icNaviClose.image,
            tintColor: .black,
            touchUpInside: {
            }
          )
        ),
        backgroundColor: .neutral50,
        placeHolder: "이름/사번/휴대폰번호",
        search: { text in
          //
        }
      )
      
      Spacer()
    }
  }
}
