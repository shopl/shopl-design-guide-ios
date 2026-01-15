//
//  SDGCheckOption.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGCheckOption: View {
  public enum CheckType: Equatable {
    case solid
    case line
  }
  
  public enum Spec: Equatable {
    case large
    case medim
    
    fileprivate var size: CGFloat {
      switch self {
      case .large: return 18
      case .medim: return 16
      }
    }
  }
  
  public struct Model: Equatable {
    public var status: SDGCheckOptionStatus
    public var type: CheckType
    public let spec: Spec
    
    public init(status: SDGCheckOptionStatus, type: CheckType, spec: Spec) {
      self.status = status
      self.type = type
      self.spec = spec
    }
  }
  
  private var model: Model
  private var selected: (() -> ())
  
  public init(
    model: Model,
    selected: @escaping (() -> ())
  ) {
    self.model = model
    self.selected = selected
  }
  
  public var body: some View {
    Button {
      self.selected()
    } label: {
      switch model.type {
      case .solid:
        Image(.icCommonCheckS)
          .resizable()
          .renderingMode(.template)
          .frame(width: model.spec.size, height: model.spec.size, alignment: .center)
          .background(model.status == .selected ? .primary300 : .neutral200)
          .foregroundStyle(.neutral0)
          .clipShape(Circle())
        
      case .line:
        ZStack {
          Image(.icCommonCheckS)
            .resizable()
            .renderingMode(.template)
            .frame(width: model.spec.size, height: model.spec.size, alignment: .center)
            .background(.clear)
            .tint(model.status == .selected ? .primary300 : .neutral350)
            .clipShape(Circle())
        }
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(model.status == .selected ? .primary300 : .neutral350, lineWidth: 1)
        )
        
      }
    }
    .allowsHitTesting(model.status != .disabled)
  }
}


#Preview {
  ZStack {
    VStack {
      HStack {
        SDGCheckOption(
          model: .init(
            status: .default,
            type: .solid,
            spec: .medim
          ),
          selected: {
            
          }
        )
        SDGCheckOption(
          model: .init(
            status: .selected,
            type: .solid,
            spec: .medim
          ),
          selected: {
            
          }
        )
        
        SDGCheckOption(
          model: .init(
            status: .disabled,
            type: .solid,
            spec: .medim
          ),
          selected: {
            
          }
        )
      }
      
      HStack {
        
        SDGCheckOption(
          model: .init(
            status: .default,
            type: .line,
            spec: .medim
          ),
          selected: {
            
          }
        )
        SDGCheckOption(
          model: .init(
            status: .selected,
            type: .line,
            spec: .medim
          ),
          selected: {
            
          }
        )
        
        SDGCheckOption(
          model: .init(
            status: .disabled,
            type: .line,
            spec: .medim
          ),
          selected: {
            
          }
        )
      }
      
      HStack {
        SDGCheckOption(
          model: .init(
            status: .default,
            type: .solid,
            spec: .large
          ),
          selected: {
            
          }
        )
        SDGCheckOption(
          model: .init(
            status: .selected,
            type: .solid,
            spec: .large
          ),
          selected: {
            
          }
        )
        
        SDGCheckOption(
          model: .init(
            status: .disabled,
            type: .solid,
            spec: .large
          ),
          selected: {
            
          }
        )
      }
      
      HStack {
        
        SDGCheckOption(
          model: .init(
            status: .default,
            type: .line,
            spec: .large
          ),
          selected: {
            
          }
        )
        SDGCheckOption(
          model: .init(
            status: .selected,
            type: .line,
            spec: .large
          ),
          selected: {
            
          }
        )
        
        SDGCheckOption(
          model: .init(
            status: .disabled,
            type: .line,
            spec: .large
          ),
          selected: {
            
          }
        )
      }
      
    }
  }
}
