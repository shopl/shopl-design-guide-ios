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
  
  private let _isSelected: Bool
  private let _size: Size
  private let _isDisabled: Bool
  private let _selectedColor: Color
  
  public init(
    isSelected: Bool,
    size: Size,
    isDisabled: Bool = false,
    selectedColor: Color? = nil
  ) {
    _isSelected = isSelected
    _size = size
    _isDisabled = isDisabled
    
    if let selectedColor = selectedColor {
      _selectedColor = selectedColor
    } else {
      _selectedColor = .primary300
    }
  }
  
  public var body: some View {
    HStack {
      Image(.icCommonCheckS)
        .resizable()
        .frame(width: _size.value, height: _size.value)
        .foregroundColor(.neutral0)
    }
    .background(_isSelected ? _selectedColor : .neutral200)
    .applyIf(_isDisabled) {
      $0.background(.neutral200)
    }
    .cornerRadius(4)
  }
}

struct CheckBox_Multi_Preview: PreviewProvider {
  static var previews: some View {
    VStack {
      HStack {
        SDGCheckBox(isSelected: false, size: .large)
        
        SDGCheckBox(isSelected: true, size: .large)
        
        SDGCheckBox(isSelected: true, size: .large, selectedColor: .neutral700)
      }
      
      HStack {
        SDGCheckBox(isSelected: false, size: .medim)
        
        SDGCheckBox(isSelected: true, size: .medim)
        
        SDGCheckBox(isSelected: true, size: .medim, selectedColor: .neutral700)
      }
    }
    
  }
}

