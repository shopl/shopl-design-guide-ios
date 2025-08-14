//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 7/8/25.
//

import SwiftUI

public struct GhostButton: View {
  
  public enum Size {
    case l
    case m
    case s
    
    var height: CGFloat {
      switch self {
      case .l:
        return 52
      case .m:
        return 36
      case .s:
        return 28
      }
    }
    
    var fontSize: CGFloat {
      switch self {
      case .l:
        return 16
      case .m:
        return 14
      case .s:
        return 12
      }
    }
    var imageSize: CGFloat {
      switch self {
      case .l:
        return 16
      case .m:
        return 14
      case .s:
        return 14
      }
    }
    var horizontalPadding: CGFloat {
      switch self {
      case .l:
        return 16
      case .m:
        return 10
      case .s:
        return 6
      }
    }
    
    var gap: CGFloat {
      switch self {
      case .l:
        return 6
      case .m:
        return 4
      case .s:
        return 2
      }
    }
  }
  
  public struct ImageOption {
    public enum Position {
      case left, right
    }
    
    let image: Image
    let color: Color
    let position: Position
    
    public init(image: Image, color: Color, position: Position) {
      self.image = image
      self.color = color
      self.position = position
    }
  }
  
  public enum `Type` {
    case normal, empha
  }
  
  private let _image: ImageOption?
  private let _title: String
  private let _size: Size
  private let _titleColor: Color
  private let _type: `Type`
  private let _fullSize: Bool
  private let _action: () -> ()
  
  @Binding private var _isDisabled: Bool

  public init(
    image: ImageOption?,
    title: String,
    size: Size,
    titleColor: Color,
    type: `Type` = .normal,
    fullSize: Bool = false,
    isDisabled: Binding<Bool> = .constant(false),
    action: @escaping () -> Void
  ) {
    _image = image
    _title = title
    _size = size
    _titleColor = titleColor
    _type = type
    _fullSize = fullSize
    __isDisabled = isDisabled
    _action = action
  }
  
  public var body: some View {
    
    Button(action: {
      
      _action()
      
    }, label: {
      
      if let image = _image {
        
        switch image.position {
          case .right:
            
          HStack(spacing: _size.gap) {
              
              Text(_title)
                .applyIf(_type == .normal, apply: {
                  $0.font(
                    .system(size: _size.fontSize, weight: .regular)
                  )
                  .foregroundColor(_titleColor)
                })
                .applyIf(_type == .empha, apply: {
                  $0.font(
                    .system(size: _size.fontSize, weight: .semibold)
                  )
                  .foregroundColor(_titleColor)
                })
                .frame(height: _size.height)
                .padding(.vertical, 4)
                .padding(.leading, _size.horizontalPadding)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                 
              image.image
                .resizable()
                .renderingMode(.template)
                .foregroundColor(image.color)
                .frame(width: _size.imageSize, height: _size.imageSize)
                .padding(.trailing, _size.horizontalPadding)
              
            }
            .applyIf(_fullSize, apply: {
              $0.frame(maxWidth: .infinity)
            })
          
          case .left:
            HStack(spacing: _size.gap) {
              
              image.image
                .resizable()
                .renderingMode(.template)
                .foregroundColor(image.color)
                .frame(width: _size.imageSize, height: _size.imageSize)
                .padding(.leading, _size.horizontalPadding)
              
              Text(_title)
                .applyIf(_type == .normal, apply: {
                  $0.font(
                    .system(size: _size.fontSize, weight: .regular)
                  )
                  .foregroundColor(_titleColor)
                })
                .applyIf(_type == .empha, apply: {
                  $0.font(
                    .system(size: _size.fontSize, weight: .semibold)
                  )
                  .foregroundColor(_titleColor)
                })
                .frame(height: _size.height)
                .padding(.vertical, 4)
                .padding(.trailing, _size.horizontalPadding)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
            }
            .applyIf(_fullSize, apply: {
              $0.frame(maxWidth: .infinity)
            })
        }
        
      } else {
        Text(_title)
          .applyIf(_type == .normal, apply: {
            $0.font(
              .system(size: _size.fontSize, weight: .regular)
            )
              .foregroundColor(_titleColor)
          })
          .applyIf(_type == .empha, apply: {
            $0.font(
              .system(size: _size.fontSize, weight: .semibold)
            )
            .foregroundColor(_titleColor)
          })
          .frame(height: _size.height)
          .padding(.vertical, 4)
          .padding(.horizontal, _size.horizontalPadding)
          .lineLimit(nil)
          .multilineTextAlignment(.center)
          .applyIf(_fullSize, apply: {
            $0.frame(maxWidth: .infinity)
          })
      }
      
    })
    .disabled(_isDisabled)
    .applyIf(_isDisabled) {
      $0.overlay(
        .neutral0.opacity(0.7)
      )
    }
  }
}


struct GhostButton_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        
        Text("Default")
        HStack {
          
          GhostButton(
            image: .init(
              image: Image(.icClip),
              color: .neutral350,
              position: .right
            ),
            title: "버튼명",
            size: .m,
            titleColor: .neutral350,
            action: {
              
            }
          )
          .background(.sdgGreen)
          
          GhostButton(
            image: .init(
              image: Image(.icClip),
              color: .neutral350,
              position: .left
            ),
            title: "버튼명",
            size: .m,
            titleColor: .neutral350,
            action: {
              
            }
          )
          .background(.sdgGreen)
          
          GhostButton(
            image: nil,
            title: "버튼명",
            size: .m,
            titleColor: .neutral350,
            action: {
              
            }
          )
          .background(.sdgGreen)
        }
      }
    }
}

