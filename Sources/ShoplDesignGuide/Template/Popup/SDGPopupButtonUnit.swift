//
//  PopupButtonUnit.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 7/8/25.
//

import SwiftUI

public struct SDGPopupButtonUnit: View {
  public enum `Type` {
    case option1(cancel: () -> Void)
    case option2(cancel: () -> Void, confirm: () -> Void)
    case delete(cancel: () -> Void, delete: () -> Void)
  }
  
  public enum State {
    case `default`
    case isDisabled(Binding<Bool>)
  }
  
  private let type: `Type`
  @Binding private var isDisabled: Bool
  
  public init(type: `Type`, state: State) {
    self.type = type
    switch state {
      case .default:
        self._isDisabled = .constant(false)
      case .isDisabled(let binding):
        self._isDisabled = binding
    }
  }
  
  @ViewBuilder
  private func ghostButton(
    title: String,
    color: Color,
    disabled: Binding<Bool> = .constant(false),
    action: @escaping () -> Void
  ) -> some View {
    GhostButton(
      image: nil,
      title: title,
      size: .l,
      titleColor: color,
      fullSize: true,
      isDisabled: disabled,
      action: action
    )
  }
  
  public var body: some View {
    VStack(spacing: 8) {
      Divider(
        color: .neutral150, option: .init(direction: .horizental, thickness: 1)
      )
      
      HStack(spacing: 0) {
        switch type {
          case let .option1(cancel):
            ghostButton(
              title: "취소 (스크립트)",
              color: .neutral700,
              action: cancel
            )
            
          case let .option2(cancel, confirm):
            ghostButton(
              title: "취소 (스크립트)",
              color: .neutral700,
              action: cancel
            )
            
            Divider(
              color: .neutral150, option: .init(direction: .vertical, thickness: 1)
            )
              .frame(height: 18)
            
            ghostButton(
              title: "확인 (스크립트)",
              color: .neutral700,
              disabled: $isDisabled,
              action: confirm
            )
            
          case let .delete(cancel, deleteAction):
            ghostButton(
              title: "취소 (스크립트)",
              color: .neutral700,
              action: cancel
            )
            
            Divider(
              color: .neutral150, option: .init(direction: .vertical, thickness: 1)
            )
              .frame(height: 18)
            
            ghostButton(
              title: "삭제 (스크립트)",
              color: .red300,
              disabled: $isDisabled,
              action: deleteAction
            )
        }
      }
      .padding(.bottom, 8)
    }
  }
}


#Preview {
  ZStack {
    VStack(spacing: 10) {
      SDGPopupButtonUnit(
        type: .option1(cancel: { }),
        state: .default
      )
      
      SDGPopupButtonUnit(
        type: .option2(cancel: { }, confirm: { }),
        state: .isDisabled(.constant(true))
      )
      
      SDGPopupButtonUnit(
        type: .option2(cancel: { }, confirm: { }),
        state: .isDisabled(.constant(false))
      )
      
      SDGPopupButtonUnit(
        type: .delete(cancel: { }, delete: { }),
        state: .isDisabled(.constant(true))
      )
      
      SDGPopupButtonUnit(
        type: .delete(cancel: { }, delete: { }),
        state: .isDisabled(.constant(false))
      )
    }
    .padding()
  }
  
}

