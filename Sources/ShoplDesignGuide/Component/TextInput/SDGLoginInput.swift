//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/25/25.
//

import SwiftUI

public struct SDGLoginInput: View {
  public enum Status: Equatable {
    case `default`
    case active
    case completed
    case disabled
    case error
  }
  
  public struct Icon {
    public let iamge: Image
    public let tintColor: Color
  }
  
  @Binding private var text: String
  @Binding private var errorMessage: String?
  
  @FocusState private var isFieldFocused: Bool
  
  private var maxCount: Int
  private var placeholder: String
  private var keyboardType: UIKeyboardType
  
  private var icon: Icon
  private var isDisabled: Bool
  @Binding private var isPasswordVisiable: Bool
  private var isPassword: Bool
  
  private var status: Status {
    if isDisabled {
      return .disabled
    }
    
    if errorMessage != nil {
      return .error
    }
    
    if isFieldFocused {
      return .active
    }
    
    if text.isEmpty {
      return .default
    }
    
    return .completed
  }
  
  private var iconTintColor: Color {
    switch status {
    case .active, .completed: return icon.tintColor
    case .error: return .red300
    default: return .neutral200
    }
  }
  
  private var strokeColor: Color {
    switch status {
    case .active: return .neutral700
    case .error: return .red300
    default: return .neutral200
    }
  }
  
  public init(
    text: Binding<String>,
    isFieldFocused: Binding<Bool>,
    placeholder: String,
    keyboardType: UIKeyboardType = .default,
    maxCount: Int = Int.max,
    errorMessage: Binding<String?> = .constant(nil),
    icon: Icon,
    isDisabled: Bool = false,
    isPasswordVisiable: Binding<Bool> = .constant(false),
    isPassword: Bool = false
  ) {
    self._text = text
    self._errorMessage = errorMessage
    self.maxCount = maxCount
    self.placeholder = placeholder
    self.keyboardType = keyboardType
    self.icon = icon
    self.isDisabled = isDisabled
    self._isPasswordVisiable = isPasswordVisiable
    self.isPassword = isPassword
  }
  
  public var body: some View {
    VStack(spacing: 10) {
      ZStack {
        HStack(spacing: 10) {
          
          self.icon.iamge
            .renderingMode(.template)
            .resizable()
            .foregroundStyle(iconTintColor)
            .frame(width: 20, height: 20)
          
          TextField("", text: $text, axis: .vertical)
            .focused($isFieldFocused)
            .placeholder(when: text.isEmpty) {
              Text(placeholder)
                .font(.system(size: 16))
                .foregroundStyle(.neutral300)
            }
            .font(.system(size: 16))
            .keyboardType(keyboardType)
            .limitText($text, to: maxCount)
            .padding(.vertical, 1)
          
          if status == .active {
            Button {
              
              text = String()
              isFieldFocused = false
              
            } label: {
              Image(.icInputDelete)
                .resizable()
                .frame(width: 18, height: 18)
            }
          }
          
          if isPassword {
            Button {
              
              isPasswordVisiable.toggle()
              
            } label: {
              Image(isPasswordVisiable ? .icView : .icHide)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(.neutral400)
                .frame(width: 18, height: 18)
            }
          }
          
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
      }
      .overlay {
        RoundedRectangle(cornerRadius: 25)
          .strokeBorder(strokeColor, lineWidth: 1)
      }
      .animation(.easeInOut(duration: 0.2), value: status)
      
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
}

struct SDGLoginInput_Preview: PreviewProvider {
  
  @State static var text: String = ""
  @State static var isFieldFocused: Bool = false
  
  static var previews: some View {
    VStack {
      SDGLoginInput(
        text: $text,
        isFieldFocused: $isFieldFocused,
        placeholder: "입력",
        icon: .init(
          iamge: Image(.icClip),
          tintColor: .neutral500
        )
      )
      
      SDGLoginInput(
        text: $text,
        isFieldFocused: $isFieldFocused,
        placeholder: "입력",
        errorMessage: .constant("에러ㅔㅇㅇ러ㅔ렁렝렁레얼엘"),
        icon: .init(
          iamge: Image(.icClip),
          tintColor: .neutral500
        )
      )
      
      SDGLoginInput(
        text: .constant("1231241"),
        isFieldFocused: $isFieldFocused,
        placeholder: "입력",
        icon: .init(
          iamge: Image(.icClip),
          tintColor: .neutral500
        )
      )
      
      SDGLoginInput(
        text: .constant("1231241"),
        isFieldFocused: $isFieldFocused,
        placeholder: "입력",
        icon: .init(
          iamge: Image(.icClip),
          tintColor: .neutral500
        ),
        isPasswordVisiable: .constant(true),
        isPassword: true
      )
      
      SDGLoginInput(
        text: .constant("1231241"),
        isFieldFocused: $isFieldFocused,
        placeholder: "입력",
        icon: .init(
          iamge: Image(.icClip),
          tintColor: .neutral500
        ),
        isPasswordVisiable: .constant(false),
        isPassword: true
      )
    }
    .padding(20)
  }
}
