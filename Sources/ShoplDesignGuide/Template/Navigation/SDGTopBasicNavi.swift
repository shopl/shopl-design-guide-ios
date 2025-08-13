//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

public struct SDGTopBasicNavi: View {
  
  public enum NaviType: Equatable {
    public static func == (lhs: NaviType, rhs: NaviType) -> Bool {
      switch (lhs, rhs) {
      case (.none, .none):
        return true
      case (.dismiss, .dismiss):
        return true
      case (.pop, .pop):
        return true
      default:
        return false
      }
    }
    
    case none
    case dismiss(tintColor: Color? = nil, onDismiss: () -> Void)
    case pop(tintColor: Color? = nil, onDismiss: () -> Void)
  }
  
  public struct ButtonOption: Identifiable {
    
    public let id: String
    public let image: Image
    public let tintColor: Color
    public let isBullet: Bool
    public let isEnable: Bool
    public let touchUpInside: (() -> ())?
    
    public init(
      image: Image,
      tintColor: Color,
      isBullet: Bool = false,
      isEnable: Bool = true,
      touchUpInside: (() -> ())? = nil
    ) {
      self.id = UUID().uuidString
      self.image = image
      self.tintColor = tintColor
      self.isBullet = isBullet
      self.isEnable = isEnable
      self.touchUpInside = touchUpInside
    }
  }
  
  public struct TextOption {
    public let string: String
    public let tintColor: Color
    
    public init(
      string: String,
      tintColor: Color? = nil
    ) {
      self.string = string
      
      if let tintColor = tintColor {
        self.tintColor = tintColor
      } else {
        self.tintColor = .neutral700
      }
    }
  }
  
  private let _naviType: NaviType
  private let _title: TextOption?
  private let _backgroundColor: Color
  private let _buttons: [ButtonOption]
  
  public init(
    naviType: NaviType,
    title: TextOption?,
    backgroundColor: Color,
    buttons: [ButtonOption] = []
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
            .foregroundColor(tintColor)
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
      SDGTopBasicNavi(
        naviType:
            .pop(tintColor: nil, onDismiss: {
              
            }),
        title: .init(
          string: "뭔가엄청긴NavigationTitle입니다.말줄임도포함이고요.", tintColor: nil
        ),
        backgroundColor: .neutral0
      )
      
      SDGTopBasicNavi(
        naviType:
            .dismiss(onDismiss: {
              
            }),
        title: .init(
          string: "뭔가 엄청 긴 Navigation Title 입니다. 말줄임도 포함이고요."
        ),
        backgroundColor: .neutral0
      )
      
      SDGTopBasicNavi(
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
      
      SDGTopBasicNavi(
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
      
      SDGTopBasicNavi(
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
      
      SDGTopBasicNavi(naviType: .pop(onDismiss: {
        
      }), title: .init(string: "some"),
                   backgroundColor: .neutral0)
      
      SDGTopBasicNavi(naviType: .pop(tintColor: .neutral0, onDismiss: {
        
      }), title: .init(string: "some"), backgroundColor: .neutral0)
    }
  }
}
