//
//  CapsuleBadge.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGCapsuleBadge: View {
  
  public struct Option {
    
    public enum Style: Equatable {
      case solid
      case line(color: Color)
      
      var lineColor: Color {
        switch self {
          case .line(let color):
            return color
          case .solid:
            return Color.clear
        }
      }
    }
    
    public enum Icon: Equatable {
      case left(image: Image, color: Color)
      case right(image: Image, color: Color)
    }
    
    public enum Size: Equatable {
      case small, xsmall
    }
    
    let style: Style
    let size: Size
    let icon: Icon?
    let title: String
    let titleColor: Color
    let backgroundColor: Color
    let fullSize: Bool
    
    public init(
      style: Style,
      size: Size,
      icon: Icon? = nil,
      title: String,
      titleColor: Color,
      backgroundColor: Color,
      fullSize: Bool = false
    ) {
      self.style = style
      self.size = size
      self.icon = icon
      self.title = title
      self.titleColor = titleColor
      self.backgroundColor = backgroundColor
      self.fullSize = fullSize
    }
  }
  
  private let _option: Option
  private let _action: () -> Void
  
  public init(option: Option, action: @escaping () -> Void) {
    _option = option
    _action = action
  }
  
  public var body: some View {
    
    Button {
      _action()
    } label: {
      
      HStack(spacing: 4) {
        
        switch _option.icon {
          case .left(let image, let color):
            
            image
              .resizable()
              .frame(width: 14, height: 14)
              .foregroundColor(color)
            
          default:
            EmptyView()
        }
        
        Text(_option.title)
          .applyIf(_option.size == .small, apply: {
            $0.font(.system(size: 14, weight: .regular))
          })
          .applyIf(_option.size == .xsmall, apply: {
            $0.font(.system(size: 12, weight: .regular))
          })
          .foregroundColor(_option.titleColor)
        
        switch _option.icon {
          case .right(let image, let color):
            
            image
              .resizable()
              .frame(width: 14, height: 14)
              .foregroundColor(color)
            
          default:
            EmptyView()
        }
        
      }
      .applyIf(_option.fullSize, apply: {
        $0.frame(maxWidth: .infinity)
      })
      .applyIf(_option.size == .small, apply: {
        $0
          .padding(.vertical, 6)
          .padding(.horizontal, 10)
      })
      .applyIf(_option.size == .xsmall, apply: {
        $0
          .padding(.vertical, 2)
          .padding(.horizontal, 8)
      })
      .background(_option.backgroundColor)
      .overlay(
        RoundedRectangle(cornerRadius: 100)
          .strokeBorder(_option.style.lineColor, lineWidth: 1)
      )
    }
    .clipShape(Capsule())
    .buttonStyle(DefaultButtonStyle())
    
  }
}

#Preview {
  VStack {
    SDGCapsuleBadge(
      option: .init(
        style: .solid,
        size: .small,
        //        icon: .left(image: Image(systemName: "heart.fill"), color: .red),
        title: "Hello",
        titleColor: .white,
        backgroundColor: .red,
        fullSize: false
      ),
      action: {
        
      }
    )
  }
}

