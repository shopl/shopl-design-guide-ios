//
//  Radio.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct Radio: View {
  
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
    
    ZStack(alignment: .center) {
      Circle()
        .frame(width: _size, height: _size)
        .foregroundColor(_isSelected ? .primary300 : .neutral200)
        .applyIf(_isDisabled) {
          $0.foregroundStyle(.neutral200)
        }
      
      Circle()
        .frame(width: _size / 2, height: _size / 2)
        .foregroundColor(.neutral0)
    }
  }
}

struct Radio_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 10) {
      Radio(isSelected: true)
      Radio(isSelected: false)
    }
  }
}
