//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

public struct SDGBasicNavi: View {
  
  private let _naviType: TopNaviType
  private let _title: TopNaviTextOption?
  private let _backgroundColor: Color
  private let _buttons: [TopNaviButtonOption]
  
  public init(
    naviType: TopNaviType,
    title: TopNaviTextOption?,
    backgroundColor: Color,
    buttons: [TopNaviButtonOption] = []
  ) {
    _naviType = naviType
    _title = title
    _backgroundColor = backgroundColor
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

struct TopBasicNavi_Preview: PreviewProvider {
  static var previews: some View {
    
    VStack {
      SDGBasicNavi(
        naviType:
            .pop(tintColor: nil, onDismiss: {
              
            }),
        title: .init(
          string: "뭔가엄청긴NavigationTitle입니다.말줄임도포함이고요.", tintColor: nil
        ),
        backgroundColor: .neutral0
      )
      
      SDGBasicNavi(
        naviType:
            .dismiss(onDismiss: {
              
            }),
        title: .init(
          string: "뭔가 엄청 긴 Navigation Title 입니다. 말줄임도 포함이고요."
        ),
        backgroundColor: .neutral0
      )
      
      SDGBasicNavi(
        naviType:
            .dismiss(onDismiss: {
              
            }),
        title: .init(
          string: "dismiss 테스트 네비게이션"
        ),
        backgroundColor: .neutral0,
        buttons: [
          .init(
            image: Image(.icNaviSearch),
            tintColor: .neutral700,
            touchUpInside: {
              
            }
          )]
      )
      
      SDGBasicNavi(
        naviType:
            .pop(onDismiss: {
              
            }),
        title: .init(
          string: "pop 테스트 네비게이션"
        ),
        backgroundColor: .neutral0
        ,
        buttons: [
          .init(
            image: Image(.icNaviSearch),
            tintColor: .neutral700,
            touchUpInside: {
              
            }
          )]
      )
      
      SDGBasicNavi(
        naviType:.none,
        title: .init(
          string: "pop 테스트 네비게이션"
        ),
        backgroundColor: .neutral0,
        buttons: [
          .init(
            image: Image(.icNaviChat),
            tintColor: .neutral700,
            touchUpInside: {
              
            }
          )]
      )
      
      SDGBasicNavi(naviType: .pop(onDismiss: {
        
      }), title: .init(string: "some"),
                   backgroundColor: .neutral0)
      
      SDGBasicNavi(naviType: .pop(tintColor: .neutral0, onDismiss: {
        
      }), title: .init(string: "some"), backgroundColor: .neutral0)
    }
  }
}
