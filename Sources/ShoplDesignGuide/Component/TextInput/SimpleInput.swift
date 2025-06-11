//
//  SimpleInput.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SimpleInput: View {
  public enum InputState: Equatable {
    case `default`
    case active
    case completed
    case error
    case disabled
  }
  
  @Binding private var _state: SimpleInput.InputState
  @Binding private var _text: String
  
  private let _backgroundColor: Color
  private let _hint: String
  private let _keyboardType: UIKeyboardType
  
  private let _maxCount: Int
  
  public init(
    state: Binding<SimpleInput.InputState>,
    text: Binding<String>,
    hint: String,
    keyboardType: UIKeyboardType = .default,
    backgroundColor: Color? = nil,
    maxCount: Int = 10000
  ) {
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
    ZStack {
      if #available(iOS 16.0, *) {
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
      } else {
        TextField("", text: $_text)
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
        
        Text(_text)
          .font(.system(size: 16))
          .opacity(0)
          .padding(.horizontal, 13)
          .padding(.vertical, 11)
      }
    }
    .background(
      _state == .error ?
      .neutral300.opacity(0.1) :
        _backgroundColor
    )
    .cornerRadius(12)
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
      SimpleInput(
        state: .constant(.active),
        text: .constant(""),
        hint: "hint"
      )
      
      SimpleInput(
        state: .constant(.completed),
        text: .constant(""),
        hint: "hint"
      )
      
      SimpleInput(
        state: .constant(.default),
        text: .constant(""),
        hint: "hint"
      )
      
      SimpleInput(
        state: .constant(.disabled),
        text: .constant(""),
        hint: "hint"
      )
      
      SimpleInput(
        state: .constant(.error),
        text: .constant(""),
        hint: "hint"
      )
    }
    .padding()
  }
}
