//
//  SDGBottomPopupButton.swift
//  ShoplDesignGuide
//
//  Created by Dino on 8/20/25.
//

import SwiftUI

public struct SDGBottomPopupButton: View {
  
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
  
  private let status: Status
  private let button: Button
  
  public init(button: Button, status: Status = .active) {
    self.button = button
    self.status = status
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Color.neutral200
        .frame(height: 1)
      
      switch button {
      case let .oneOption(option):
        SDGGhostButton(
          title: option.title,
          titleColor: .neutral700,
          size: .large,
          labelWeight: .SB,
          status: status == .disabled ? .disabled : .default,
          iconOption: nil,
          action: option.action
        )
        .expandTouchArea(isDisabled: status == .disabled) {
          option.action()
        }
        
      case let .twoOptions(option1, option2):
        HStack(spacing: 0) {
          SDGGhostButton(
            title: option1.title,
            titleColor: .neutral700,
            size: .large,
            labelWeight: .R,
            status: .default,
            iconOption: nil,
            action: option1.action
          )
          .expandTouchArea(isDisabled: false) {
            option1.action()
          }
          
          Color.neutral200
            .frame(width: 1, height: 18)
          
          SDGGhostButton(
            title: option2.title,
            titleColor: .neutral700,
            size: .large,
            labelWeight: .SB,
            status: status == .disabled ? .disabled : .default,
            iconOption: nil,
            action: option2.action
          )
          .expandTouchArea(isDisabled: status == .disabled) {
            option2.action()
          }
        }
        
      case let .delete(option1, option2):
        HStack(spacing: 0) {
          SDGGhostButton(
            title: option1.title,
            titleColor: .neutral700,
            size: .large,
            labelWeight: .R,
            status: .default,
            iconOption: nil,
            action: option1.action
          )
          .expandTouchArea(isDisabled: false) {
            option1.action()
          }
          
          Color.neutral200
            .frame(width: 1, height: 18)

          SDGGhostButton(
            title: option2.title,
            titleColor: .red300,
            size: .large,
            labelWeight: .SB,
            status: status == .disabled ? .disabled : .default,
            iconOption: nil,
            action: option2.action
          )
          .expandTouchArea(isDisabled: status == .disabled) {
            option2.action()
          }
        }
      }
    }
    .frame(height: 59)
  }
}

#Preview {
  VStack {
    SDGBottomPopupButton(
      button: .oneOption(
        option: .init(
          title: "확인",
          action: { print("확인") }
        )
      ),
      status: .active
    )
    
    SDGBottomPopupButton(
      button: .twoOptions(
        option1: .init(
          title: "취소",
          action: { print("취소") }
        ),
        option2: .init(
          title: "확인",
          action: { print("확인") }
        )
      ),
      status: .active
    )
    
    SDGBottomPopupButton(
      button: .delete(
        option1: .init(
          title: "취소",
          action: { print("취소") }
        ),
        option2: .init(
          title: "삭제",
          action: { print("삭제") }
        )
      ),
      status: .disabled
    )
  }
}
