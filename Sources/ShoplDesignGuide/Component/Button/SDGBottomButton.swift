//
//  SDGBottomButton.swift
//  ShoplDesignGuide
//
//  Created by jerry on 2/25/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

public struct SDGBottomButton: View {
    
  public struct Option {
    let type: `Type`
    let spec: Spec
    let title: String
    
    public init(
      type: `Type`,
      spec: Spec,
      title: String
    ) {
      self.type = type
      self.spec = spec
      self.title = title
    }
    
    public enum `Type`: Equatable {
      case primary, neutral, point, normal
      
      var defaultColor: Color {
        switch self {
        case .primary: return .primary300
        case .neutral: return .neutral700
        case .point: return .red300
        case .normal: return .neutral200
        }
      }
      
      var pressedColor: Color {
        switch self {
        case .primary: return .primary400
        case .neutral: return .neutral900
        case .point: return .red400
        case .normal: return .neutral300
        }
      }
      
      var disabledColor: Color {
        switch self {
        case .primary: return .primary50
        case .neutral: return .neutral300
        case .point: return .red50
        case .normal: return .neutral200
        }
      }
      
      var textColor: Color {
        switch self {
        case .primary, .neutral, .point: return .neutral0
        case .normal: return .neutral700
        }
      }
      
      var disabledTextColor: Color {
        switch self {
        case .primary, .neutral, .point: return .neutral0
        case .normal: return .neutral350
        }
      }
    }
    
    public enum Spec: Equatable {
      case full, adaptive
    }
  }
  
  private let _option: Option
  private let _isDisable: Bool
  private let _action: () -> Void
  
  public init(
    option: Option,
    isDisable: Bool = false,
    action: @escaping () -> Void
  ) {
    _option = option
    _isDisable = isDisable
    _action = action
  }
  
  public var body: some View {
    Button {
      _action()
    } label: {
      Text(_option.title)
        .lineLimit(1)
        .typo(.body1_R)
        .padding(.horizontal, 16)
        .frame(height: 50)
        .frame(
          minWidth: _option.spec == .adaptive ? 80 : nil,
          maxWidth: _option.spec == .full ? .infinity : nil
        )
    }
    .buttonStyle(
      SDGBottomButtonStyle(
        type: _option.type,
        isDisable: _isDisable
      )
    )
    .disabled(_isDisable)
  }
}

private struct SDGBottomButtonStyle: ButtonStyle {
  
  let type: SDGBottomButton.Option.`Type`
  let isDisable: Bool
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(isDisable ? type.disabledTextColor : type.textColor)
      .background(backgroundColor(isPressed: configuration.isPressed))
      .clipShape(RoundedRectangle(cornerRadius: 25))
  }
  
  private func backgroundColor(isPressed: Bool) -> Color {
    if isDisable { return type.disabledColor }
    if isPressed { return type.pressedColor }
    return type.defaultColor
  }
}

#Preview {
  
  VStack(spacing: 16) {
    
    Text("Full Size").font(.headline)
    
    SDGBottomButton(
      option: .init(type: .primary, spec: .full, title: "Primary"),
      action: { }
    )
    
    SDGBottomButton(
      option: .init(type: .neutral, spec: .full, title: "Neutral"),
      action: { }
    )
    
    SDGBottomButton(
      option: .init(type: .point, spec: .full, title: "Point"),
      action: { }
    )
    
    SDGBottomButton(
      option: .init(type: .normal, spec: .full, title: "Normal"),
      action: { }
    )
    
    Text("Disabled").font(.headline)
    
    SDGBottomButton(
      option: .init(type: .primary, spec: .full, title: "Primary Disabled"),
      isDisable: true,
      action: { }
    )
    
    SDGBottomButton(
      option: .init(type: .neutral, spec: .full, title: "Normal Disabled"),
      isDisable: true,
      action: { }
    )
    
    SDGBottomButton(
      option: .init(type: .point, spec: .full, title: "Normal Disabled"),
      isDisable: true,
      action: { }
    )
    
    SDGBottomButton(
      option: .init(type: .normal, spec: .full, title: "Normal Disabled"),
      isDisable: true,
      action: { }
    )
    
    Text("Adaptive Size").font(.headline)
    
    HStack(spacing: 8) {
      SDGBottomButton(
        option: .init(type: .primary, spec: .adaptive, title: "Label"),
        action: { }
      )
      
      SDGBottomButton(
        option: .init(type: .neutral, spec: .adaptive, title: "Label"),
        action: { }
      )
      
      SDGBottomButton(
        option: .init(type: .point, spec: .adaptive, title: "Label"),
        isDisable: true,
        action: { }
      )
      
      SDGBottomButton(
        option: .init(type: .normal, spec: .adaptive, title: "Label"),
        action: { }
      )
    }
  }
  .padding(.horizontal, 20)
  
}
