//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/2/25.
//

import SwiftUI

public struct SDGIconButton: View {
  
  public enum `Type` {
    case solid(shape: Shape)
    case line(shape: Shape, lineColor: Color)
  }
  
  public enum Shape {
    case circle(color: Color)
    case box(color: Color)
  }
  
  public enum Size {
    case small
    case xsmall
    case medium
    
    var padding: CGFloat {
      switch self {
      case .small, .xsmall: return 5
      case .medium: return 6
      }
    }
    
    var iconSize: CGFloat {
      switch self {
      case .small: return 14
      case .xsmall: return 18
      case .medium: return 20
      }
    }
    
    var boxCornerRadius: CGFloat {
      switch self {
      case .small: return 6
      case .xsmall: return 8
      case .medium: return 10
      }
    }
    
    var circleCornerRadius: CGFloat {
      switch self {
      case .small: return 12
      case .xsmall: return 14
      case .medium: return 16
      }
    }
  }
  
  private var cornerRadius: CGFloat {
    switch type {
    case .solid(let shape):
      
      switch shape {
      case .box:
        return size.boxCornerRadius
        
      case .circle:
        return size.circleCornerRadius
      }
     
    case .line(let shape, _):
      
      switch shape {
      case .box:
        return size.boxCornerRadius
        
      case .circle:
        return size.circleCornerRadius
      }
      
    }
  }
  
  private var backgroundColor: Color {
    switch type {
    case .solid(let shape):
      
      switch shape {
      case .box(let color):
        return self.isDisabled ? self.disabledColor : color
        
      case .circle(let color):
        return self.isDisabled ? self.disabledColor : color
      }
     
    case .line(let shape, _):
      
      switch shape {
      case .box(let color):
        return self.isDisabled ? .neutral0 : color
        
      case .circle(let color):
        return self.isDisabled ? .neutral0 : color
      }
      
    }
  }
  
  private var lineColor: Color {
    switch type {
    case .solid:
      return .clear
     
    case .line(_, let color):
      return color
    }
  }
  
  private var tintColor: Color {
    switch type {
    case .solid(let shape):
      
      switch shape {
      case .box(let color):
        return self.isDisabled ? .neutral0 : self.iconTintColor
        
      case .circle(let color):
        return self.isDisabled ? .neutral0 : self.iconTintColor
      }
     
    case .line(let shape, _):
      
      switch shape {
      case .box(let color):
        return self.isDisabled ? self.disabledColor : self.iconTintColor
        
      case .circle(let color):
        return self.isDisabled ? self.disabledColor : self.iconTintColor
      }
      
    }
  }
  
  
  private let type: `Type`
  private let size: Size
  private let isDisabled: Bool
  private let disabledColor: Color
  private let icon: Image
  private let iconTintColor: Color
  private let action: () -> Void
  
  public init(
    type: `Type`,
    size: Size,
    isDisabled: Bool = false,
    disabledColor: Color? = nil,
    icon: Image,
    iconTintColor: Color,
    action: @escaping () -> Void
  ) {
    self.type = type
    self.size = size
    self.isDisabled = isDisabled
    
    if let disabledColor = disabledColor {
      self.disabledColor = disabledColor
    } else {
      self.disabledColor = .neutral250
    }

    self.icon = icon
    self.iconTintColor = iconTintColor
    self.action = action
  }
  
  public var body: some View {
    Button {
      action()
    } label: {
      ZStack {
        icon
          .renderingMode(.template)
          .resizable()
          .frame(width: self.size.iconSize, height: self.size.iconSize)
          .foregroundStyle(self.tintColor)
          .padding(self.size.padding)
      }
      .background(self.backgroundColor)
      .cornerRadius(self.cornerRadius)
      .overlay {
        RoundedRectangle(cornerRadius: self.cornerRadius)
          .strokeBorder(
            self.isDisabled ? self.disabledColor : self.lineColor, lineWidth: 1
          )
      }
    }
    .disabled(self.isDisabled)
    .buttonStyle(NoTapAnimationButtonStyle())
  }
}

#Preview {
  VStack {
    
    HStack {
      SDGIconButton(
        type: .solid(shape: .circle(color: .primary300)),
        size: .small,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral0,
        action: { }
      )
      
      SDGIconButton(
        type: .line(shape: .circle(color: .neutral0), lineColor: .primary300),
        size: .small,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral700,
        action: { }
      )
    }
    
    HStack {
      SDGIconButton(
        type: .solid(shape: .box(color: .primary300)),
        size: .small,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral0,
        action: { }
      )
      
      SDGIconButton(
        type: .line(shape: .box(color: .neutral0), lineColor: .primary300),
        size: .small,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral700,
        action: { }
      )
    }
    
    HStack {
      SDGIconButton(
        type: .solid(shape: .circle(color: .primary300)),
        size: .xsmall,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral0,
        action: { }
      )
      
      SDGIconButton(
        type: .line(shape: .circle(color: .neutral0), lineColor: .primary300),
        size: .xsmall,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral700,
        action: { }
      )
    }
    
    HStack {
      SDGIconButton(
        type: .solid(shape: .box(color: .primary300)),
        size: .xsmall,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral0,
        action: { }
      )
      
      SDGIconButton(
        type: .line(shape: .box(color: .neutral0), lineColor: .primary300),
        size: .xsmall,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral700,
        action: { }
      )
    }
    
    HStack {
      SDGIconButton(
        type: .solid(shape: .circle(color: .primary300)),
        size: .medium,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral0,
        action: { }
      )
      
      SDGIconButton(
        type: .line(shape: .circle(color: .neutral0), lineColor: .primary300),
        size: .medium,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral700,
        action: { }
      )
    }
    
    HStack {
      SDGIconButton(
        type: .solid(shape: .box(color: .primary300)),
        size: .medium,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral0,
        action: { }
      )
      
      SDGIconButton(
        type: .line(shape: .box(color: .neutral0), lineColor: .primary300),
        size: .medium,
        isDisabled: false,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral700,
        action: { }
      )
    }
    
    
    HStack {
      SDGIconButton(
        type: .solid(shape: .box(color: .primary300)),
        size: .medium,
        isDisabled: true,
        disabledColor: .neutral250,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral0,
        action: { }
      )
      
      SDGIconButton(
        type: .line(shape: .box(color: .neutral0), lineColor: .primary300),
        size: .medium,
        isDisabled: true,
        disabledColor: .neutral250,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral700,
        action: { }
      )
    }
    
    HStack {
      SDGIconButton(
        type: .solid(shape: .box(color: .primary300)),
        size: .medium,
        isDisabled: true,
        disabledColor: .neutral300,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral0,
        action: { }
      )
      
      SDGIconButton(
        type: .line(shape: .box(color: .neutral0), lineColor: .primary300),
        size: .medium,
        isDisabled: true,
        disabledColor: .neutral300,
        icon: Image(sdg: .icClip),
        iconTintColor: .neutral700,
        action: { }
      )
    }
    
  }
}
