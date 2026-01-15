//
//  SDGDropdown.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGDropdown: View {
  
  private let _placeHolder: String
  private let _text: String
  @Binding private var _disabled: Bool
  @Binding private var _backgroundColor: Color
  private let _countText: String?

  private var _textColor: Color {
    return (_text == "" || _disabled) ? .neutral300 : .neutral700
  }
  
  private var _iconColor: Color {
    return _disabled ? .neutral300 : .neutral700
  }
  
  public init(
    placeHolder: String,
    text: String,
    disabled: Binding<Bool>,
    backgroundColor: Binding<Color>,
    countText: String? = nil
  ) {
    _placeHolder = placeHolder
    _text = text
    _countText = countText
    __disabled = disabled
    __backgroundColor = backgroundColor
  }
  
  public var body: some View {

    HStack(spacing: 10) {
      
      HStack(spacing: 0) {
        Text(_text == "" ? _placeHolder : _text)
          .font(.system(size: 16, weight: .regular))
          .foregroundColor(_textColor)
       
        if let countText = _countText {
          Text(countText)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(_textColor)
            .layoutPriority(1)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .lineLimit(1)

      Image(sdg: .icCommonDropdown)
        .resizable()
        .frame(width: 20, height: 20)
        .foregroundColor(_iconColor)
        
    }
    .padding([.vertical, .trailing], 10)
    .padding(.leading, 12)
    .background(_backgroundColor)
    .cornerRadius(12)
  }
  
}

struct BasicDropdown_Preview: PreviewProvider {
  static var previews: some View {
    
    VStack {
      Spacer()
      
      HStack(spacing: 8) {
        SDGDropdown(
          placeHolder: "Hint",
          text: "2023.08.04(금)",
          disabled: .constant(false),
          backgroundColor: .constant(.neutral50)
        )
        
        SDGDropdown(
          placeHolder: "Hint",
          text: "16:00",
          disabled: .constant(false),
          backgroundColor: .constant(.neutral50)
        )
        .frame(width: 112)
      }
      
      SDGDropdown(
        placeHolder: "Hint",
        text: "Selected",
        disabled: .constant(false),
        backgroundColor: .constant(.neutral0)
      )
      
      
      SDGDropdown(
        placeHolder: "Hint",
        text: "",
        disabled: .constant(false),
        backgroundColor: .constant(.neutral0)
      )
      
      SDGDropdown(
        placeHolder: "Hint",
        text: "",
        disabled: .constant(true),
        backgroundColor: .constant(.neutral50)
      )
      
      Spacer()
    }
    .padding()
    .background(
      Color.neutral700
        .ignoresSafeArea()
    )
    
  }
}

