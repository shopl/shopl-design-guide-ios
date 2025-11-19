//
//  Divider.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct Divider: View {
  
  public struct Option {
    public enum Direction {
      case horizental, vertical
    }
    
    let direction: Direction
    let thickness: CGFloat
    
    public init(direction: Direction, thickness: CGFloat) {
      self.direction = direction
      self.thickness = thickness
    }
  }
  
  private let _color: Color
  private let _option: Option
  
  public init(color: Color, option: Option) {
    _color = color
    _option = option
  }
  
  public var body: some View {
    switch _option.direction {
      case .horizental:
        _color
          .frame(height: _option.thickness)
      case .vertical:
        _color
          .frame(width: _option.thickness)
    }
  }
}

struct Divider_Previews: PreviewProvider {
  static var previews: some View {
    Divider(
      color: .primary300,
      option: .init(direction: .horizental, thickness: 1)
    )
  }
}

