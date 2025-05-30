//
//  CheckList.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct CheckOption: View {
  public enum CheckState: Equatable {
    case `default`
    case selected
    case disabled
  }
  
  public enum CheckType: Equatable {
    case normal
    case empha
  }
  
  @Binding private var _state: CheckState
  
  private var _title: String
  private var _size: CGFloat
  private var _type: CheckType
  
  private var _selected: (() -> ())
  
  public init(
    state: Binding<CheckState>,
    title: String,
    size: CGFloat,
    type: CheckType,
    selected: @escaping (() -> ())
  ) {
    self.__state = state
    self._title = title
    self._size = size
    self._type = type
    self._selected = selected
  }
  
  public var body: some View {
    Button {
      self._selected()
    } label: {
      HStack(spacing: 6) {
        Image(.icCommonCheckS)
          .frame(width: 14, height: 14, alignment: .center)
          .background(_state == .selected ? .primary300 : .neutral200)
          .tint(.neutral0)
          .clipShape(Circle())
        
        Text(_title)
          .font(
            .system(
              size: self._size,
              weight: self._type == .normal ? .regular : .semibold
            )
          )
          .foregroundColor(.neutral700)
      }
    }
    .allowsHitTesting(self._state != .disabled)
  }
}


#Preview {
  ZStack {
    HStack {
      CheckOption(
        state: .constant(.default),
        title: "",
        size: 14,
        type: .empha,
        selected: {
          
        }
      )
      
      CheckOption(
        state: .constant(.default),
        title: "기본",
        size: 14,
        type: .empha,
        selected: {
          
        }
      )
      
      CheckOption(
        state: .constant(.selected),
        title: "선택",
        size: 14,
        type: .empha,
        selected: {
          
        }
      )
      
      CheckOption(
        state: .constant(.disabled),
        title: "선택 불가",
        size: 14,
        type: .empha,
        selected: {
          
        }
      )
    }
  }
}
