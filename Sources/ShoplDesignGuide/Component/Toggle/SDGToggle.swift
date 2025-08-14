//
//  SDGToggle.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGToggle: View {
  
  public enum ToggleState {
    case normal
    case disabled
  }
  
  public enum Size {
    case m, s
    
    var width: CGFloat {
      return self == .m ? 40 : 30
    }
    
    var height: CGFloat {
      return self == .m ? 22 : 16
    }
    
    var toggleSize: CGFloat {
      return self == .m ? 18 : 14
    }
    
    var offSet: CGFloat {
      return self == .m ? 9 : 6.75
    }
  }
  
  private var toggleState: ToggleState
  private var size: Size
  @Binding private var isOn: Bool
  
  private var backgroundColor: Color {
    switch toggleState {
      case .normal:
        return isOn ? .primary300 : .neutral300
      case .disabled:
        return isOn ? .primary50 : .neutral200
    }
  }
  
  public init(
    size: Size,
    toggleState: ToggleState,
    isOn: Binding<Bool>
  ) {
    self.size = size
    self.toggleState = toggleState
    self._isOn = isOn
  }
  
  public var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: size.toggleSize / 2)
        .fill(Color.white)
        .frame(width: size.toggleSize, height: size.toggleSize)
        .offset(x: isOn ? size.offSet : -size.offSet)
        .animation(Animation.easeInOut(duration: 0.2), value: isOn)
    }
    .frame(width: size.width, height: size.height)
    .background(backgroundColor)
    .cornerRadius(size.height / 2)
    .onTapGesture {
      if self.toggleState == .normal {
        isOn.toggle()
      }
    }
  }
}

#Preview {
  VStack {
    SDGToggle(size: .m, toggleState: .normal, isOn: .constant(true))
    SDGToggle(size: .m, toggleState: .disabled, isOn: .constant(true))
    SDGToggle(size: .s, toggleState: .normal, isOn: .constant(true))
    SDGToggle(size: .s, toggleState: .disabled, isOn: .constant(true))
    
    SDGToggle(size: .m, toggleState: .normal, isOn: .constant(false))
    SDGToggle(size: .m, toggleState: .disabled, isOn: .constant(false))
    SDGToggle(size: .s, toggleState: .normal, isOn: .constant(false))
    SDGToggle(size: .s, toggleState: .disabled, isOn: .constant(false))
  }
}

public final class Toggle_UIKit: UISwitch {
  
  public enum Size {
    case m, s
  }
  
  public var size: Size = .m {
    didSet {
      switch size {
        case .m:
          transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        case .s:
          transform = CGAffineTransform(scaleX: 0.5625, y: 0.5625)
      }
    }
  }
  
  public init(size: Size) {
    super.init(frame: CGRect.zero)
    
    switch size {
      case .m:
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      case .s:
        transform = CGAffineTransform(scaleX: 0.5625, y: 0.5625)
    }
    
    tintColor = UIColor.neutral300
    onTintColor = UIColor.primary300
    thumbTintColor = UIColor.neutral0
    backgroundColor = .clear
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    tintColor = UIColor.neutral300
    onTintColor = UIColor.primary300
    thumbTintColor = UIColor.neutral0
    backgroundColor = .clear

  }
}

