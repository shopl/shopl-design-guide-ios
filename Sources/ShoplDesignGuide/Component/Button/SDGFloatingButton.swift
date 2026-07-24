//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/1/25.
//

import SwiftUI

public struct SDGFloatingButton: View {
  public static let version = "2.0.0"
  
  private let icon: Image
  private let iconTintColor: Color
  private let isDisabled: Bool
  private let action: () -> Void
  
  public init(
    icon: Image,
    iconTintColor: Color,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.icon = icon
    self.iconTintColor = iconTintColor
    self.isDisabled = isDisabled
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
          .foregroundStyle(iconTintColor)
          .frame(width: 40, height: 40)
          .padding(10)
      }
      .background(isDisabled ? .primary50 : .primary300)
      .cornerRadius(30)
      .shadow(
        color: .neutral900.opacity(0.1),
        radius: 10,
        x: 3,
        y: 6
      )
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .hideWhenKeyboardAppear()
  }
}

#Preview {
  VStack {
    SDGFloatingButton(
      icon: Image(sdg: .icCommonCheckS),
      iconTintColor: .neutral0,
      isDisabled: false,
      action: {
        
      }
    )
    
    SDGFloatingButton(
      icon: Image(sdg: .icCommonCheckS),
      iconTintColor: .neutral0,
      isDisabled: true,
      action: {
        
      }
    )
  }
}
