//
//  SDGPopupButton.swift
//  DesignSystem
//
//  Created by Dino on 7/22/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

public struct SDGPopupButton: View {
  
  public enum Button {
    case oneOption(option: Option)
    case twoOptions(option1: Option, option2: Option)
    case delete(option1: Option, option2: Option)
    
    public struct Option {
      let title: String
      let action: () -> Void
      
      public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
      }
    }
  }
  
  public enum Status {
    case active
    case disabled
  }
  
  @Binding private var status: Status
  private let button: Button
  
  private var isDisabledBinding: Binding<Bool> {
    Binding(
      get: {
        self.status == .disabled
      },
      set: { newValue in
        self.status = newValue ? .disabled : .active
      }
    )
  }
  
  public init(status: Binding<Status> = .constant(.active), button: Button) {
    self._status = status
    self.button = button
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TypoColor.neutral200.color
        .frame(height: 1)
      
      switch button {
      case let .oneOption(option):
        GhostButton(
          image: nil,
          title: option.title,
          size: .l,
          titleColor: TypoColor.neutral700.color,
          weight: .SB,
          isDisabled: isDisabledBinding,
          action: option.action
        )
        
      case let .twoOptions(option1, option2):
        HStack(spacing: 0) {
          GhostButton(
            image: nil,
            title: option1.title,
            size: .l,
            titleColor: TypoColor.neutral700.color,
            action: option1.action
          )
          .frame(maxWidth: .infinity, alignment: .center)
          .onTapGesture {
            option1.action()
          }
          
          TypoColor.neutral200.color
            .frame(width: 1)
          
          GhostButton(
            image: nil,
            title: option2.title,
            size: .l,
            titleColor: TypoColor.neutral700.color,
            weight: .SB,
            isDisabled: isDisabledBinding,
            action: option2.action
          )
          .frame(maxWidth: .infinity, alignment: .center)
          .onTapGesture {
            option2.action()
          }
        }
        
      case let .delete(option1, option2):
        HStack(spacing: 0) {
          
          GhostButton(
            image: nil,
            title: option1.title,
            size: .l,
            titleColor: TypoColor.neutral700.color,
            fullSize: true,
            action: option1.action
          )
          
          TypoColor.neutral200.color
            .frame(width: 1)

          GhostButton(
            image: nil,
            title: option2.title,
            size: .l,
            titleColor: TypoColor.red300.color,
            weight: .SB,
            fullSize: true,
            isDisabled: isDisabledBinding,
            action: option2.action
          )
        }
      }
    }
    .frame(height: 51)
  }
}

struct SDGPopupButtonUnit_Preview: PreviewProvider {
  static var previews: some View {
    SDGPopupButton(
      status: .constant(.active),
      button: .twoOptions(
        option1: .init(
          title: "취소",
          action: { }
        ),
        option2: .init(
          title: "확인",
          action: { }
        )
      )
    )
  }
}
