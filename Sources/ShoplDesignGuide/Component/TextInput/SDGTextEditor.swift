//
//  SDGTextEditor.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

struct SDGTextEditor: View {
  
  @FocusState private var _isFucused: Bool
  
  @Binding private var _text: String
  @Binding private var _isFocus: Bool
  
  private let _placeHolder: String?
  private let _backgroundColor: Color
  private let _outlineColor: Color?
  
  public init(
    text: Binding<String>,
    placeHolder: String?,
    backgroundColor: Color,
    outlineColor: Color? = nil,
    isFocused: Binding<Bool>
  ) {
    if #unavailable(iOS 16.0) {
      UITextView.appearance().backgroundColor = .clear
    }
    
    __isFocus = isFocused
    __text = text
    
    _placeHolder = placeHolder
    _backgroundColor = backgroundColor
    _outlineColor = outlineColor
  
  }
  
  var body: some View {
    SwiftUI.TextEditor(text: $_text)
      .focused($_isFucused)
      .onChange(of: _isFocus) { newValue in
        if _isFucused != newValue {
          _isFucused = newValue
        }
      }
      .onChange(of: _isFucused) { newValue in
        if _isFocus != newValue {
          _isFocus = newValue
        }
      }
  }
}
