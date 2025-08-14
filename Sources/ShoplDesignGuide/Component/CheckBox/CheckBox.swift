//
//  CheckBox.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGCheckBox: View {
  
  private let _isSelected: Bool
  private let _size: CGFloat
  private let _isDisabled: Bool
  
  public init(isSelected: Bool,
              size: CGFloat = 16,
              isDisabled: Bool = false) {
    _isSelected = isSelected
    _size = size
    _isDisabled = isDisabled
  }
  
  public var body: some View {
    HStack {
      Image(.icCommonCheckS)
        .resizable()
        .frame(width: _size - 2, height: _size - 2)
        .foregroundColor(.neutral0)
    }
    .frame(width: _size, height: _size)
    .background(_isSelected ? .primary300 : .neutral200)
    .applyIf(_isDisabled) {
      $0.background(.neutral200)
    }
    .cornerRadius(4)
  }
}

struct CheckBox_Multi_Preview: PreviewProvider {
  static var previews: some View {
    VStack {
      SDGCheckBox(isSelected: false)
        
      SDGCheckBox(isSelected: true)
    }
    
  }
}

