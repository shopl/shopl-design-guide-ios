//
//  SDGSimpleInput.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGSimpleInput: View {
  
  public enum `Type`: Equatable {
    case solid
    case line
  }
  
  public enum InputState: Equatable {
    case `default`
    case active
    case completed
    case error(String?)
    case disabled
    
    public static func == (lhs: InputState, rhs: InputState) -> Bool {
      switch (lhs, rhs) {
      case (.default, .default),
        (.active, .active),
        (.completed, .completed),
        (.disabled, .disabled): return true
      case (.error(let lhsError), .error(let rhsError)):
        return lhsError == rhsError
      default: return false
      }
    }
  }
  
  private var _type: `Type`
  
  @Binding private var _state: SDGSimpleInput.InputState
  @Binding private var _text: String
  
  private let _backgroundColor: Color
  private let _hint: String
  private let _keyboardType: UIKeyboardType
  
  private let _maxCount: Int
  
  private var backgroundColor: Color {
    switch _type {
    case .solid:
      switch _state {
      case .error: return .red300.opacity(0.1)
      default: return _backgroundColor
      }
      
    case .line:
      return .neutral0
    }
  }
  
  private var strokeColor: Color {
    switch _type {
    case .solid:
      return .clear
      
    case .line:
      switch _state {
      case .error: return .red300
      default: return .neutral200
      }
    }
  }
  
  private var errorMessage: String? {
    switch _state {
    case .error(let error): return error
    default: return nil
    }
  }
  
  public init(
    type: `Type`,
    state: Binding<SDGSimpleInput.InputState>,
    text: Binding<String>,
    hint: String,
    keyboardType: UIKeyboardType = .default,
    backgroundColor: Color? = nil,
    maxCount: Int = 10000
  ) {
    self._type = type
    self.__state = state
    self.__text = text
    self._hint = hint
    self._keyboardType = keyboardType
    
    if let backgroundColor = backgroundColor {
      self._backgroundColor = backgroundColor
    } else {
      self._backgroundColor = .neutral50
    }
    
    self._maxCount = maxCount
  }
  
  public var body: some View {
    VStack(spacing: 10) {
      
      ZStack {
        TextField("", text: $_text, axis: .vertical)
          .placeholder(when: _text.isEmpty) {
            Text(_hint)
              .font(.system(size: 16))
              .foregroundStyle(.neutral300)
          }
          .font(.system(size: 16))
          .keyboardType(_keyboardType)
          .onChange(of: _text) { newValue in
            if _keyboardType == .numberPad {
              _text = newValue.filter { "0123456789".contains($0) }
            }
          }
          .limitText($_text, to: _maxCount)
          .foregroundStyle(_state == .disabled ? .neutral300 : .neutral700)
          .padding(.horizontal, 12)
          .padding(.vertical, 10)
      }
      .background(backgroundColor)
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(strokeColor, lineWidth: 1)
      )
      
      if let errorMessage = errorMessage {
        Text(errorMessage)
          .typo(.body3_R, .red300)
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
  
  func limitText(_ upper: Int) {
    if _text.count > upper {
      _text = String(_text.prefix(upper))
    }
  }
}

#Preview {
  ZStack {
    VStack {
      SDGSimpleInput(
        type: .solid,
        state: .constant(.active),
        text: .constant(""),
        hint: "hint"
      )
      
      SDGSimpleInput(
        type: .solid,
        state: .constant(.completed),
        text: .constant(""),
        hint: "hint"
      )
      
      SDGSimpleInput(
        type: .solid,
        state: .constant(.default),
        text: .constant(""),
        hint: "hint"
      )
      
      SDGSimpleInput(
        type: .solid,
        state: .constant(.disabled),
        text: .constant(""),
        hint: "hint"
      )
      
      SDGSimpleInput(
        type: .line,
        state: .constant(.completed),
        text: .constant(""),
        hint: "hint"
      )
      
      SDGSimpleInput(
        type: .solid,
        state: .constant(.error("ㅇㅇ")),
        text: .constant(""),
        hint: "hint"
      )
      
      SDGSimpleInput(
        type: .line,
        state: .constant(.error("ㅇㅇ")),
        text: .constant(""),
        hint: "hint"
      )
    }
    .padding()
  }
}
