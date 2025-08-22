//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

public struct SDGFixTextForm: View {
  @Binding private var _text: String
  @Binding private var _isFocused: Bool
  @Binding private var _isError: Bool
  
  private let _placeHolder: String?
  private let _backgroundColor: Color
  private let _outlineColor: Color?
  private let _maxCharacterCount: Int?
  private let _inputViewHeight: CGFloat
  
  public init(
    text: Binding<String>,
    placeHolder: String?,
    backgroundColor: Color,
    outlineColor: Color? = nil,
    maxCharacterCount: Int? = nil,
    isFocused: Binding<Bool>,
    inputViewHeight: CGFloat = 94,
    isError: Binding<Bool> = .constant(false)
  ) {
    __text = text
    _placeHolder = placeHolder
    _backgroundColor = backgroundColor
    _outlineColor = outlineColor
    _maxCharacterCount = maxCharacterCount
    __isFocused = isFocused
    _inputViewHeight = inputViewHeight
    __isError = isError
  }
  
  public var body: some View {
    
    ZStack(alignment: .topLeading) {
      
      SDGTextEditor(
        text: $_text,
        isFocused: $_isFocused
      )
      .font(.system(size: 16, weight: .regular))
      .foregroundColor(.neutral700)
      .frame(height: _inputViewHeight)
      .padding(.horizontal, 9)
      .padding(.vertical, 5)
      .background(_isError ? .red300.opacity(0.1) : _backgroundColor)
      .scrollContentBackground(.hidden)
      .onChange(of: _text) { newValue in
        if let _maxCharacterCount, newValue.count > _maxCharacterCount {
          _text = String(newValue.prefix(_maxCharacterCount))
        }
      }
    }
    .background(_backgroundColor)
    .cornerRadius(12)
  }
}
