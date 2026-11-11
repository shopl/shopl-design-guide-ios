//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

/// 검색창과 좌우 버튼으로 구성된 검색 내비게이션입니다.
public struct SDGSearchNavi: View {
  
  public enum TextFieldType {
    case capsule
    case category(icon: SDGCategorySearch.IconModel, showSearchCategoryPopup: () -> Void)
  }
  
  private let textFieldType: TextFieldType
  private let leadingButton: TopNaviButtonOption?
  private let trailingButton: TopNaviButtonOption?
  
  private let backgroundColor: Color
  private let text: Binding<String>
  private let onClear: (() -> Void)?
  private let autoFocus: Bool
  public let placeHolder: String
  public let search: (String) -> Void
  
  /// - Parameter autoFocus: 캡슐형 검색창 진입 시 입력 포커스를 요청합니다. 기본값은 `false`입니다.
  public init(
    leadingButton: TopNaviButtonOption?,
    textFieldType: TextFieldType,
    trailingButton: TopNaviButtonOption?,
    backgroundColor: Color,
    placeHolder: String,
    text: Binding<String>,
    autoFocus: Bool = false,
    onClear: (() -> Void)? = nil,
    search: @escaping (String) -> Void
  ) {
    self.leadingButton = leadingButton
    self.textFieldType = textFieldType
    self.trailingButton = trailingButton
    
    self.backgroundColor = backgroundColor
    self.placeHolder = placeHolder
    self.text = text
    self.onClear = onClear
    self.autoFocus = autoFocus
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
        searchText: text,
        type: .soild,
        backgroundColor: SDG.Color.neutral0.color,
        autoFocus: autoFocus,
        clearAllButtonTapped: {
          text.wrappedValue = ""
          onClear?()
        },
        searchButtonTapped: { text in
          search(text)
        }
      )
    
    case .category(let iconModel, let showPopup):
      SDGCategorySearch(
        searchText: text,
        placeholder: .constant(placeHolder),
        isFocused: .constant(true),
        iconModel: .constant(iconModel),
        _searchTapped: {
          search(text.wrappedValue)
        },
        _showSearchCategoryPopup: showPopup,
        _clearAllButtonTapped: {
          text.wrappedValue = ""
          onClear?()
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
        text: .constant(""),
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
        text: .constant(""),
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
        text: .constant(""),
        search: { text in
          print("search: \(text)")
        }
      )
      
      Spacer()
    }
  }
}
