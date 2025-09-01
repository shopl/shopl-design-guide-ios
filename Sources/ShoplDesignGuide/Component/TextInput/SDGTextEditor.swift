//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

struct SDGTextEditor: View {
  
  @FocusState private var _isFucused: Bool
  
  @Binding private var _text: String
  @Binding private var _isFocus: Bool
  
  public init(
    text: Binding<String>,
    isFocused: Binding<Bool>
  ) {
    UITextView.appearance().backgroundColor = .clear
    
    __isFocus = isFocused
    __text = text
  }
  
  var body: some View {
    TextEditor(text: $_text)
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
