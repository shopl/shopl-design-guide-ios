//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

public struct SDGTopCategoryNavi: View {
  
  private let _naviType: TopNaviType
  private let _title: TopNaviTextOption?
  private let _backgroundColor: Color
  private let _buttons: [TopNaviButtonOption]
  
  private let _category: () -> Void
  
  public init(
    naviType: TopNaviType,
    title: TopNaviTextOption?,
    backgroundColor: Color,
    buttons: [TopNaviButtonOption] = [],
    category: @escaping () -> Void
  ) {
    _naviType = naviType
    _title = title
    _backgroundColor = backgroundColor
    _buttons = buttons
    _category = category
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
      
      if let title = _title {
        Button {
          _category()
        } label: {
          HStack(spacing: 0) {
            Text(title.string)
              .font(.system(size: 19, weight: .regular))
              .foregroundStyle(title.tintColor)
              .lineLimit(1)
              .truncationMode(.tail)
            
            Image(.icCommonDropdown)
              .resizable()
              .foregroundStyle(.neutral700)
              .frame(width: 20, height: 20)
            
            Spacer()
          }
        }
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
      SDGTopCategoryNavi(
        naviType: .pop(tintColor: nil, onDismiss: {
          
        }),
        title: .init(string: "타이틀"),
        backgroundColor: .neutral50,
        buttons: [
          .init(
            image: Image(.icNaviFilter),
            tintColor: .neutral700
          )
        ],
        category: {
          
        }
      )
      
      SDGTopCategoryNavi(
        naviType: .dismiss(tintColor: nil, onDismiss: {
          
        }),
        title: .init(string: "타이틀"),
        backgroundColor: .neutral50,
        buttons: [
          .init(
            image: Image(.icNaviFilter),
            tintColor: .neutral700
          )
        ],
        category: {
          
        }
      )
      
      Spacer()
    }
  }
}
