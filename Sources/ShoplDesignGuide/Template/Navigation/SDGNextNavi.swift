//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

public struct SDGTextNavi: View {
  
  public enum NaviType: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
        case (.full, .full):
        return true
      case (.back(_, let lhsTitle, let lhsRight), .back(_, let rhsTitle, let rhsRight)):
        return lhsTitle == rhsTitle && lhsRight == rhsRight
      case (.text, .text):
        return true
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
    
    public struct Title: Equatable {
      let text: String
      let color: Color
      
      public init(text: String, color: Color? = nil) {
        self.text = text
        
        if let color = color {
          self.color = color
        } else {
          self.color = .neutral700
        }
      }
    }
    
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
  
  public init(
    naviType: NaviType,
    backgroundColor: Color
  ) {
    _naviType = naviType
    _backgroundColor = backgroundColor
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
          .padding(.leading, 10)
          
          Text(title.text)
            .font(.system(size: 19, weight: .regular))
            .foregroundColor(title.color)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 2)
          
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
                  .font(.system(size: 16, weight: .regular))
                  .foregroundColor(_right.color)
                  .lineLimit(1)
                
              }
              
            }
            .padding(.trailing, 16)
          }
          
        case .back(let back, let title, let right):
          
          Button {
            
            back()
            
          } label: {
            Image(.icNaviBack)
              .frame(width: 40, height: 40)
              .foregroundColor(.neutral700)
          }
          .padding(.leading, 10)
          
          Text(title.text)
            .font(.system(size: 19, weight: .regular))
            .foregroundColor(title.color)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 2)
          
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
                  .font(.system(size: 16, weight: .regular))
                  .foregroundColor(_right.color)
                  .lineLimit(1)
                
              }
              
            }
            .padding(.trailing, 16)
            .padding(.vertical, 14)
          }
          
        case .text(let title, let right):
          
          Text(title.text)
            .font(.system(size: 19, weight: .regular))
            .foregroundColor(title.color)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
          
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
                  .font(.system(size: 16, weight: .regular))
                  .foregroundColor(_right.color)
                  .lineLimit(1)
                
              }
              
            }
            .padding(.trailing, 16)
          }
        
      case .search(let back, let view):
        
        Button {
          
          back()
          
        } label: {
          Image(.icNaviBack)
            .frame(width: 40, height: 40)
            .foregroundColor(.neutral700)
        }
        .padding(.leading, 10)
        
        view
        
      }
      
    }
    .background(_backgroundColor)
    .frame(height: 48)
  }
  
}


#Preview {
  VStack {
    SDGTextNavi(
      naviType: .full(
        left: .init(image: Image(.icCommonCompany), action: { }),
        title: .init(
          text: "Title이 꽤 기다란 Title인데 이게 두줄 이상은 또 안보여야 돼",
          color: .neutral700
        ),
        right: .init(image: Image(.icCommonCompany), text: "Text더 길어지는", action: { })
      ),
      backgroundColor: .neutral100
    )
    
    SDGTextNavi(
      naviType: .back(
        back: { },
        title: .init(
          text: "Title이 꽤 기다란 Title인데 이게 두줄 이상은 또 안보여야 돼",
          color: .neutral700
        ),
        right: .init(image: Image(.icCommonCompany), text: "Text더 길어지는", action: { })
      ),
      backgroundColor: .neutral100
    )
    
    SDGTextNavi(
      naviType: .text(
        title: .init(
          text: "Title이 꽤 기다란 Title인데 이게 두줄 이상은 또 안보여야 돼",
          color: .neutral700
        ),
        right: .init(image: Image(.icCommonCompany), text: "Text더 길어지는", action: { })
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

