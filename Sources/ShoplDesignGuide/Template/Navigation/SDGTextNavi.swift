//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

/// 화면 상단에 한 줄 타이틀과 화면 이동, 우측 실행 기능을 제공하는 내비게이션입니다.
/// 긴 타이틀은 말줄임하고 우측 액션을 우선 표시합니다. 액션 자체가 가용 폭을 넘으면 말줄임합니다.
public struct SDGTextNavi: View {
  /// 적용한 Text Navi 컴포넌트 디자인 가이드 버전입니다.
  public static let version = "2.3.53"
  
  /// 내비게이션 구성입니다. 동등 비교는 표시 값만 비교하며 콜백 변경은 비교하지 않습니다.
  /// `.search`의 AnyView는 비교할 수 없어 기존처럼 항상 비동등으로 처리합니다.
  public enum NaviType: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case (.full(let lhsLeft, let lhsTitle, let lhsRight), .full(let rhsLeft, let rhsTitle, let rhsRight)):
        return lhsLeft == rhsLeft && lhsTitle == rhsTitle && lhsRight == rhsRight
      case (.back(_, let lhsTitle, let lhsRight), .back(_, let rhsTitle, let rhsRight)):
        return lhsTitle == rhsTitle && lhsRight == rhsRight
      case (.text(let lhsTitle, let lhsRight), .text(let rhsTitle, let rhsRight)):
        return lhsTitle == rhsTitle && lhsRight == rhsRight
      default:
        return false
      }
    }
    
    public struct Left: Equatable {
      public static func == (lhs: Self, rhs: Self) -> Bool {
        let image = lhs.image == rhs.image
        let color = lhs.color == rhs.color
        
        return image && color
      }
      
      let image: Image
      let color: Color
      let action: () -> Void
      
      public init(
        image: Image,
        color: Color? = nil,
        action: @escaping () -> Void
      ) {
        self.image = image
        if let color = color {
          self.color = color
        } else {
          self.color = .neutral700
        }
        self.action = action
      }
    }
    
    /// 한 줄로 표시하는 타이틀과 색상입니다. 빈 문자열로 타이틀을 생략할 수 있습니다.
    public struct Title: Equatable {
      let text: String
      let color: Color
      
      /// - Parameters:
      ///   - text: 타이틀 문구. 영역을 넘으면 끝을 말줄임합니다.
      ///   - color: 타이틀 색상. nil이면 Neutral/900을 사용합니다.
      public init(text: String, color: Color? = nil) {
        self.text = text
        
        if let color = color {
          self.color = color
        } else {
          self.color = .neutral900
        }
      }
    }
    
    /// 선택적 아이콘과 짧은 액션 문구를 하나의 버튼으로 묶습니다.
    public struct Right: Equatable {
      public static func == (lhs: Self, rhs: Self) -> Bool {
        let image = lhs.image == rhs.image
        let color = lhs.color == rhs.color
        let title = lhs.text == rhs.text
        
        return image && color && title
      }
      
      let image: Image?
      let text: String
      let color: Color
      let action: () -> Void
      
      /// - Parameters:
      ///   - image: 문구 왼쪽의 20×20pt 아이콘. nil이면 표시하지 않습니다.
      ///   - text: 타이틀보다 우선 표시할 짧은 동사형 문구. 액션 자체가 가용 폭을 넘으면 말줄임합니다.
      ///   - color: 아이콘과 문구 색상. nil이면 Neutral/700을 사용합니다.
      ///   - action: 액션 버튼을 누를 때 실행할 콜백입니다.
      public init(
        image: Image?,
        text: String,
        color: Color? = nil,
        action: @escaping () -> Void
      ) {
        self.image = image
        self.text = text
        if let color = color {
          self.color = color
        } else {
          self.color = .neutral700
        }
        self.action = action
      }
    }
    
    case full(left: Left, title: Title, right: Right?)
    case back(back: () -> Void, title: Title, right: Right?)
    case text(title: Title, right: Right?)
    case search(back: () -> Void, view: AnyView)
  }
  
  
  private let _naviType: NaviType
  private let _backgroundColor: Color
  private var _backButtonColor: Color = .neutral700
  
  /// - Parameters:
  ///   - naviType: 좌측 요소, 타이틀, 우측 액션 구성. 버튼을 누르면 전달한 콜백을 실행합니다.
  ///   - backgroundColor: 배경색. 기본 디자인은 Neutral/100이며 투명색도 사용할 수 있습니다.
  public init(
    naviType: NaviType,
    backgroundColor: Color
  ) {
    _naviType = naviType
    _backgroundColor = backgroundColor
  }
  
  /// 기본 뒤로가기 아이콘의 색상을 지정합니다. 진한 배경에서는 Neutral/0을 사용할 수 있습니다.
  /// - Parameter color: `.back`, `.search` 타입의 아이콘 색상. 미설정 시 Neutral/700입니다.
  /// - Returns: 뒤로가기 색상을 적용한 내비게이션입니다.
  public func backButtonColor(_ color: Color) -> Self {
    var view = self
    view._backButtonColor = color
    return view
  }

  public var body: some View {
    
    HStack(spacing: 0) {
      
      switch _naviType {
        case .full(let left, let title, let right):
          
          Button {
            
            left.action()
            
          } label: {
            left.image
              .resizable()
              .frame(width: 40, height: 40)
              .foregroundColor(left.color)
          }
          .layoutPriority(2)
          .padding(.leading, 10)
          
          Text(title.text)
            .typo(.naviTitle)
            .foregroundColor(title.color)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(height: 24)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 2)
            .padding(.trailing, right == nil ? 10 : 0)
          
          if let _right = right {
            Button {
              
              _right.action()
              
            } label: {
              
              HStack(spacing: 0) {
                
                if let rightImage = _right.image {
                  rightImage
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(_right.color)
                }
                
                Text(_right.text)
                  .typo(.body1_R)
                  .foregroundColor(_right.color)
                  .lineLimit(1)
                  .truncationMode(.tail)
                  .frame(height: 20)
                
              }
              
            }
            .layoutPriority(1)
            .padding(.leading, 8)
            .padding(.trailing, 16)
          }
          
        case .back(let back, let title, let right):
          
          Button {
            
            back()
            
          } label: {
            Image(sdg: .icNaviBack)
              .frame(width: 40, height: 40)
              .foregroundColor(_backButtonColor)
          }
          .layoutPriority(2)
          .padding(.leading, 10)
          
          Text(title.text)
            .typo(.naviTitle)
            .foregroundColor(title.color)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(height: 24)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 2)
            .padding(.trailing, right == nil ? 10 : 0)
          
          if let _right = right {
            Button {
              
              _right.action()
              
            } label: {
              
              HStack(spacing: 0) {
                
                if let rightImage = _right.image {
                  rightImage
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(_right.color)
                }
                
                Text(_right.text)
                  .typo(.body1_R)
                  .foregroundColor(_right.color)
                  .lineLimit(1)
                  .truncationMode(.tail)
                  .frame(height: 20)
                
              }
              
            }
            .layoutPriority(1)
            .padding(.leading, 8)
            .padding(.trailing, 16)
            .padding(.vertical, 14)
          }
          
        case .text(let title, let right):
          
          Text(title.text)
            .typo(.naviTitle)
            .foregroundColor(title.color)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(height: 24)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
            .padding(.trailing, right == nil ? 10 : 0)
          
          if let _right = right {
            Button {
              
              _right.action()
              
            } label: {
              
              HStack(spacing: 0) {
                
                if let rightImage = _right.image {
                  rightImage
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(_right.color)
                }
                
                Text(_right.text)
                  .typo(.body1_R)
                  .foregroundColor(_right.color)
                  .lineLimit(1)
                  .truncationMode(.tail)
                  .frame(height: 20)
                
              }
              
            }
            .layoutPriority(1)
            .padding(.leading, 8)
            .padding(.trailing, 16)
          }
        
      case .search(let back, let view):
        
        Button {
          
          back()
          
        } label: {
          Image(sdg: .icNaviBack)
            .frame(width: 40, height: 40)
            .foregroundColor(_backButtonColor)
        }
        .padding(.leading, 10)
        
        view
        
      }
      
    }
    .frame(height: 48)
    .background(_backgroundColor)
  }
  
}


#Preview {
  VStack {
    SDGTextNavi(
      naviType: .full(
        left: .init(image: Image(sdg: .icCommonCompany), action: { }),
        title: .init(
          text: "긴 타이틀은 한 줄로 표시하고 끝을 말줄임합니다"
        ),
        right: .init(image: Image(sdg: .icCommonCompany), text: "Text더 길어지는", action: { })
      ),
      backgroundColor: .neutral100
    )
    
    SDGTextNavi(
      naviType: .back(
        back: { },
        title: .init(
          text: "긴 타이틀은 한 줄로 표시하고 끝을 말줄임합니다"
        ),
        right: .init(image: Image(sdg: .icCommonCompany), text: "Text더 길어지는", action: { })
      ),
      backgroundColor: .neutral100
    )
    
    SDGTextNavi(
      naviType: .text(
        title: .init(
          text: "긴 타이틀은 한 줄로 표시하고 끝을 말줄임합니다"
        ),
        right: .init(image: Image(sdg: .icCommonCompany), text: "Text더 길어지는", action: { })
      ),
      backgroundColor: .neutral100
    )
  }
  .frame(maxHeight: .infinity)
  .background(
    Color.neutral700
      .ignoresSafeArea()
  )
}

#Preview("액션 아이콘 없음 · 액션 없음 · 진한 배경") {
  VStack(spacing: 20) {
    SDGTextNavi(
      naviType: .back(back: {}, title: .init(text: "긴 타이틀이 있어도 우측 액션 문구를 먼저 보존합니다"),
                      right: .init(image: nil, text: "전체 저장", action: {})),
      backgroundColor: .neutral100
    )
    SDGTextNavi(
      naviType: .back(back: {}, title: .init(text: "우측 액션 없는 타이틀"), right: nil),
      backgroundColor: .neutral100
    )
    SDGTextNavi(
      naviType: .back(back: {}, title: .init(text: "진한 배경", color: .neutral0),
                      right: .init(image: nil, text: "완료", color: .neutral0, action: {})),
      backgroundColor: .neutral700
    )
    .backButtonColor(.neutral0)
  }
  .frame(width: 320)
}
