//
//  SDGCheckBox.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGCheckBox: View {
  
  public enum Size: Equatable {
    case large, medim
    
    fileprivate var value: CGFloat {
      switch self {
      case .large: return 18
      case .medim: return 16
      }
    }
  }
  
  public struct Model: Equatable {
    public let size: Size
    public let selectedColor: Color
    
    public init(size: Size, selectedColor: Color = .primary300) {
      self.size = size
      self.selectedColor = selectedColor
    }
  }
  
  private let model: Model
  @Binding private var status: SDGCheckBoxStatus
  
  private var onSelect: (() -> ())?
  
  public init(
    model: Model,
    status: Binding<SDGCheckBoxStatus>,
    onSelect: (() -> ())? = nil
  ) {
    self.model = model
    self._status = status
    self.onSelect = onSelect
  }
  
  public var body: some View {
    Button {
      onSelect?()
    } label: {
      HStack {
        Image(.icCommonCheckS)
          .resizable()
          .frame(width: model.size.value, height: model.size.value)
          .foregroundColor(.neutral0)
      }
      .background(status == .selected ? model.selectedColor : .neutral200)
      .applyIf(status == .disabled) {
        $0.background(.neutral200)
      }
      .cornerRadius(4)
    }
    .buttonStyle(NoTapAnimationButtonStyle())
  }
}

struct CheckBox_Multi_Preview: PreviewProvider {
  static var previews: some View {
    VStack {
      HStack {
        SDGCheckBox(
          model: .init(size: .large),
          status: .constant(.default)
        )
        
        SDGCheckBox(
          model: .init(size: .large),
          status: .constant(.selected)
        )
        
        SDGCheckBox(
          model: .init(size: .large, selectedColor: .neutral700),
          status: .constant(.selected)
        )
        
        SDGCheckBox(
          model: .init(size: .large),
          status: .constant(.disabled)
        )
      }
      
      HStack {
        SDGCheckBox(
          model: .init(size: .medim),
          status: .constant(.default)
        )
        
        SDGCheckBox(
          model: .init(size: .medim),
          status: .constant(.selected)
        )
        
        SDGCheckBox(
          model: .init(size: .medim, selectedColor: .neutral700),
          status: .constant(.selected)
        )
        
        SDGCheckBox(
          model: .init(size: .medim),
          status: .constant(.disabled)
        )
      }
    }
    
  }
}

