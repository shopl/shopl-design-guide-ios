//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/25/25.
//

import SwiftUI

public struct SDGFixedTextInput: View {
  
  public enum `Type`: Equatable {
    case solid
    case line(color: Color)
  }
  
  @Binding private var text: String
  @Binding private var isFocused: Bool
  @Binding private var isError: String?

  private let type: `Type`
  private let placeHolder: String?
  private let backgroundColor: Color
  private let maxCharacterCount: Int?
  private let inputViewHeight: CGFloat
  
  private var _backgroundColor: Color {
    switch type {
    case .solid:
      return isError == nil ? backgroundColor : .red300.opacity(0.1)
    case .line:
      return .neutral0
    }
  }
  
  private var _strokeColor: Color {
    switch type {
    case .solid: return .clear
    case .line(color: let color): return color
    }
  }
  
  public init(
    type: `Type`,
    text: Binding<String>,
    placeHolder: String?,
    backgroundColor: Color,
    maxCharacterCount: Int? = nil,
    isFocused: Binding<Bool>,
    inputViewHeight: CGFloat = 94,
    isError: Binding<String?> = .constant(nil)
  ) {
    self.type = type
    self._text = text
    self.placeHolder = placeHolder
    self.backgroundColor = backgroundColor
    self.maxCharacterCount = maxCharacterCount
    self._isFocused = isFocused
    self.inputViewHeight = inputViewHeight
    self._isError = isError
  }
  
  public var body: some View {
    
    VStack(spacing: 10) {
      
      ZStack(alignment: .topLeading) {
        
        SDGTextEditor(
          text: $text,
          isFocused: $isFocused
        )
        .font(.system(size: 16, weight: .regular))
        .foregroundColor(.neutral700)
        .frame(height: inputViewHeight)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(_backgroundColor)
        .scrollContentBackground(.hidden)
        .onChange(of: text) { newValue in
          if let maxCharacterCount, newValue.count > maxCharacterCount {
            text = String(newValue.prefix(maxCharacterCount))
          }
        }
        
        if text.isEmpty {
          if let placeHolder = placeHolder {
            Text(placeHolder)
              .font(.system(size: 16, weight: .regular))
              .foregroundColor(.neutral300)
              .padding(.horizontal, 12)
              .padding(.top, 12)
          }
        }
        
      }
      .background(backgroundColor)
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(_strokeColor, lineWidth: 1)
      )
      
      if let errorMessage = isError {
        Text(errorMessage)
          .typo(.body3_R, .red300)
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
}

