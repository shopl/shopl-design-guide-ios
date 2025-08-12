//
//  SDGGhostButton.swift
//  DesignSystem
//
//  Created by Dino on 7/30/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

public struct SDGGhostButton: View {
  
  private let title: String
  private let titleColor: TypoColor
  private let size: Size
  private let labelWeight: LabelWeight
  private let status: Status
  private let iconOption: IconOption?
  private let action: () -> Void
  
  public enum LabelWeight {
    case R, SB
  }
  
  public enum Status {
    case `default`
    case disabled
  }
  
  public enum Size {
    case large
    case medium
    case small
    
    var height: CGFloat {
      switch self {
      case .large:
        42
      case .medium:
        36
      case .small:
        28
      }
    }
    
    var horizontalPadding: CGFloat {
      switch self {
      case .large:
        16
      case .medium:
        10
      case .small:
        8
      }
    }
    
    var verticalPadding: CGFloat {
      switch self {
      case .large:
        11
      case .medium:
        9
      case .small:
        6
      }
    }
    
    var gap: CGFloat {
      switch self {
      case .large:
        6
      case .medium:
        4
      case .small:
        2
      }
    }
    
    var iconSize: CGFloat {
      switch self {
      case .large:
        16
      case .medium:
        14
      case .small:
        14
      }
    }
  }
  
  public struct IconOption {
    let image: Image
    let color: Color
    let position: position
    let downSized: Bool
    
    public enum position {
      case left, right
    }
    
    public init(image: Image, color: Color, position: position, downSized: Bool) {
      self.image = image
      self.color = color
      self.position = position
      self.downSized = downSized
    }
  }
  
  private var typography: Typography {
    switch size {
    case .large:
      return if labelWeight == .R { .body1_R } else if labelWeight == .SB { .body1_SB } else { .body1_R }
    case .medium:
      return if labelWeight == .R { .body2_R } else if labelWeight == .SB { .body2_SB } else { .body2_R }
    case .small:
      return if labelWeight == .R { .body3_R } else if labelWeight == .SB { .body3_SB } else { .body3_R }
    }
  }
  
  private var iconSize: CGFloat {
    size.iconSize - (iconOption?.downSized ?? false ? 2 : 0)
  }
  
  public init(
    title: String,
    titleColor: TypoColor,
    size: Size,
    labelWeight: LabelWeight,
    status: Status,
    iconOption: IconOption?,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.titleColor = titleColor
    self.size = size
    self.labelWeight = labelWeight
    self.iconOption = iconOption
    self.status = status
    self.action = action
  }
  
  public var body: some View {
    Button {
      action()
    } label: {
      HStack(spacing: size.gap) {
        if let iconOption,
           iconOption.position == .left {
          iconOption.image
            .templateIcon(size: iconSize, color: iconOption.color)
        }
        
        Text(title)
          .typo(typography, titleColor)
          .lineLimit(1)
        
        if let iconOption,
           iconOption.position == .right {
          iconOption.image
            .templateIcon(size: iconSize, color: iconOption.color)
        }
      }
      .padding(.horizontal, size.horizontalPadding)
      .padding(.vertical, size.verticalPadding)
      .frame(maxHeight: size.height)
    }
    .opacity(status == .disabled ? 0.3 : 1)
    .disabled(status == .disabled)
  }
}

#Preview {
  HStack {
    VStack(spacing: 20) {
      
      Text("Default")
      
      SDGGhostButton(
        title: "Button",
        titleColor: .neutral900,
        size: .large,
        labelWeight: .SB,
        status: .default,
        iconOption: nil,
        action: {
          
        }
      )
      .background(.gray)
      
      SDGGhostButton(
        title: "Button",
        titleColor: .neutral900,
        size: .medium,
        labelWeight: .SB,
        status: .default,
        iconOption: .init(
          image: Image(systemName: "heart.fill"),
          color: .blue,
          position: .left,
          downSized: false
        ),
        action: {
          
        }
      )
      .background(.gray)
      
      SDGGhostButton(
        title: "Button",
        titleColor: .neutral900,
        size: .small,
        labelWeight: .SB,
        status: .default,
        iconOption: .init(
          image: Image(systemName: "heart.fill"),
          color: .blue,
          position: .right,
          downSized: false
        ),
        action: {
          
        }
      )
      .background(.gray)
    }
    
    VStack(spacing: 20) {
      
      Text("Disabled")
      
      SDGGhostButton(
        title: "Button",
        titleColor: .neutral900,
        size: .large,
        labelWeight: .SB,
        status: .disabled,
        iconOption: nil,
        action: {
          
        }
      )
      .background(.gray)
      
      SDGGhostButton(
        title: "Button",
        titleColor: .neutral900,
        size: .medium,
        labelWeight: .SB,
        status: .disabled,
        iconOption: .init(
          image: Image(systemName: "heart.fill"),
          color: .blue,
          position: .left,
          downSized: false
        ),
        action: {
          
        }
      )
      .background(.gray)
      
      SDGGhostButton(
        title: "Button",
        titleColor: .neutral900,
        size: .small,
        labelWeight: .SB,
        status: .disabled,
        iconOption: .init(
          image: Image(systemName: "heart.fill"),
          color: .blue,
          position: .right,
          downSized: false
        ),
        action: {
          
        }
      )
      .background(.gray)
    }
    
    VStack(spacing: 20) {
      
      Text("DownSizedIcon")
      
      SDGGhostButton(
        title: "Button",
        titleColor: .neutral900,
        size: .large,
        labelWeight: .SB,
        status: .default,
        iconOption: .init(
          image: Image(systemName: "heart.fill"),
          color: .blue,
          position: .left,
          downSized: true
        ),
        action: {
          
        }
      )
      .background(.gray)
      
      SDGGhostButton(
        title: "Button",
        titleColor: .neutral900,
        size: .medium,
        labelWeight: .SB,
        status: .default,
        iconOption: .init(
          image: Image(systemName: "heart.fill"),
          color: .blue,
          position: .left,
          downSized: true
        ),
        action: {
          
        }
      )
      .background(.gray)
      
      SDGGhostButton(
        title: "Button",
        titleColor: .neutral900,
        size: .small,
        labelWeight: .SB,
        status: .default,
        iconOption: .init(
          image: Image(systemName: "heart.fill"),
          color: .blue,
          position: .right,
          downSized: true
        ),
        action: {
          
        }
      )
      .background(.gray)
    }
  }
}
