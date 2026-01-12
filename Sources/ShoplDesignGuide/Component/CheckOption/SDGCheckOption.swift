//
//  SDGCheckOption.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGCheckOption: View {
  public enum CheckState: Equatable {
    case `default`
    case selected
    case disabled
  }
  
  public enum CheckType: Equatable {
    case solid
    case line
  }
  
  @Binding private var state: CheckState
  
  private var type: CheckType
  
  private var selected: (() -> ())
  
  public init(
    state: Binding<CheckState>,
    type: CheckType,
    selected: @escaping (() -> ())
  ) {
    self._state = state
    self.type = type
    self.selected = selected
  }
  
  public var body: some View {
    Button {
      self.selected()
    } label: {
      switch type {
      case .solid:
        Image(.icCommonCheckS)
          .frame(width: 16, height: 16, alignment: .center)
          .background(state == .selected ? .primary300 : .neutral200)
          .tint(.neutral0)
          .clipShape(Circle())
        
      case .line:
        ZStack {
          Image(.icCommonCheckS)
            .frame(width: 16, height: 16, alignment: .center)
            .background(.clear)
            .tint(state == .selected ? .primary300 : .neutral350)
            .clipShape(Circle())
        }
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(state == .selected ? .primary300 : .neutral350, lineWidth: 1)
        )
        
      }
    }
    .allowsHitTesting(self.state != .disabled)
  }
}


#Preview {
  ZStack {
    VStack {
      HStack {
        SDGCheckOption(
          state: .constant(.default),
          type: .solid,
          selected: {
            
          }
        )
        
        SDGCheckOption(
          state: .constant(.default),
          type: .solid,
          selected: {
            
          }
        )
        
        SDGCheckOption(
          state: .constant(.selected),
          type: .solid,
          selected: {
            
          }
        )
        
        SDGCheckOption(
          state: .constant(.disabled),
          type: .solid,
          selected: {
            
          }
        )
      }
      
      HStack {
        SDGCheckOption(
          state: .constant(.default),
          type: .line,
          selected: {
            
          }
        )
        
        SDGCheckOption(
          state: .constant(.default),
          type: .line,
          selected: {
            
          }
        )
        
        SDGCheckOption(
          state: .constant(.selected),
          type: .line,
          selected: {
            
          }
        )
        
        SDGCheckOption(
          state: .constant(.disabled),
          type: .line,
          selected: {
            
          }
        )
      }
      
    }
  }
}
