//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

public struct SDGSearchNavi: View {
  
  public enum TextFieldType {
    case capsule
    case category(icon: SDGCategorySearch.IconModel, showSearchCategoryPopup: () -> Void)
  }
  
  private let textFieldType: TextFieldType
  private let leadingButton: TopNaviButtonOption?
  private let trailingButton: TopNaviButtonOption?
  
  private let backgroundColor: Color
  public let placeHolder: String
  public let search: (String) -> Void
  
  @State private var _searchText: String = ""
  
  @FocusState private var isTextFieldFocused: Bool
  
  public init(
    leadingButton: TopNaviButtonOption?,
    textFieldType: TextFieldType,
    trailingButton: TopNaviButtonOption?,
    backgroundColor: Color,
    placeHolder: String,
    search: @escaping (String) -> Void
  ) {
    self.leadingButton = leadingButton
    self.textFieldType = textFieldType
    self.trailingButton = trailingButton
    
    self.backgroundColor = backgroundColor
    self.placeHolder = placeHolder
    self.search = search
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: .zero) {
      HStack(spacing: SDGSpacing.spacing2) {
        self.leadingIcon
        
        self.textField
        
        self.trailingIcon
      }
    }
    .padding(.leading, 10)
    .padding(.trailing, 10)
    .frame(height: 48)
    .background(backgroundColor)
  }
  
  @ViewBuilder
  private var leadingIcon: some View {
    if let leading = self.leadingButton {
      Button {
        leading.touchUpInside?()
      } label: {
        leading.image
          .foregroundStyle(leading.tintColor)
         
      }
      .frame(width: 40, height: 40)
    }
  }
  
  @ViewBuilder
  private var textField: some View {
    switch textFieldType {
    case .capsule:
      SDGCapsuleSearch(
        placeHolder: placeHolder,
        searchText: $_searchText,
        type: .soild,
        backgroundColor: SDG.Color.neutral0.color,
        clear: {
          _searchText = ""
        },
        searchButtonTapped: { text in
          search(text)
        }
      )
    
    case .category(let iconModel, let showPopup):
      SDGCategorySearch(
        searchText: $_searchText,
        placeholder: .constant(placeHolder),
        isFocused: .constant(true),
        iconModel: .constant(iconModel),
        _searchTapped: {
          search(_searchText)
        },
        _showSearchCategoryPopup: showPopup,
        _clearAllButtonTapped: {
          _searchText = ""
        }
      )
    }
  }
  
  @ViewBuilder
  private var trailingIcon: some View {
    if let trailing = self.trailingButton {
      Button {
        trailing.touchUpInside?()
      } label: {
        trailing.image
          .foregroundStyle(trailing.tintColor)
      }
      .frame(width: 40, height: 40)
    }
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
        leadingButton:  .init(
          image: SDG.Image.icNaviBack.image,
          tintColor: .black,
          touchUpInside: {}
        ),
        textFieldType: .capsule,
        trailingButton: .init(
          image: SDG.Image.icNaviClose.image,
          tintColor: .black,
          touchUpInside: {}
        ),
        backgroundColor: .neutral50,
        placeHolder: "이름/사번/휴대폰번호",
        search: { text in
          print("search: \(text)")
        }
      )
      
      SDGSearchNavi(
        leadingButton: nil,
        textFieldType: .category(icon: .init(id: "d", label: "tt", icon: SDG.Image.icAlignup.image), showSearchCategoryPopup: {
          print("7870 tap")
        }),
        trailingButton: .init(
          image: SDG.Image.icNaviClose.image,
          tintColor: .black,
          touchUpInside: {}
        ),
        backgroundColor: .neutral50,
        placeHolder: "이름/사번/휴대폰번호",
        search: { text in
          print("search: \(text)")
        }
      )
      
      SDGSearchNavi(
        leadingButton:  .init(
          image: SDG.Image.icNaviBack.image,
          tintColor: .black,
          touchUpInside: {}
        ),
        textFieldType: .capsule,
        trailingButton: nil,
        backgroundColor: .neutral50,
        placeHolder: "이름/사번/휴대폰번호",
        search: { text in
          print("search: \(text)")
        }
      )
      
      Spacer()
    }
  }
}
