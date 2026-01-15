//
//  SDGUnderlineInput.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGUnderlineInput: View {
  
  private let _placeHolder: String
  private let _isSecureTextEntry: Bool
  @Binding private var _text: String
  @Binding private var _option: UnderlineInputOption
  @Binding private var _isFocused: Bool
  
  @State private var _showText: Bool
  private let _isDisabled: Bool
  
  public struct UnderlineInputOption: Equatable {
    
    public struct ValidateMessage: Equatable {
      public enum Status: Equatable {
        case solved, notSolved
      }
      
      public let status: Status
      public let message: String
      
      public init(status: Status, message: String) {
        self.status = status
        self.message = message
      }
    }
    
    var isError: Bool {
      return validateMessages.contains { $0.status == .notSolved }
    }
    
    var messages: [String]
    var validateMessages: [ValidateMessage]
    let characterLimit: Int?

    public init(messages: [String], validateMessages: [ValidateMessage], characterLimit: Int? = nil) {
      self.messages = messages
      self.validateMessages = validateMessages
      self.characterLimit = characterLimit
    }
  }
  
  private var _isHiddenClearButton: Bool {
    if !_isFocused { return true }
    return _text == ""
  }
  
  public init(
    placeHolder: String,
    text: Binding<String>,
    option: Binding<UnderlineInputOption>? = nil,
    isFocused: Binding<Bool>,
    isSecureTextEntry: Bool,
    isDisabled: Bool = false
  ) {
    _placeHolder = placeHolder
    __text = text
    __isFocused = isFocused
    _isSecureTextEntry = isSecureTextEntry
    
    _showText = !isSecureTextEntry
    _isDisabled = isDisabled
    
    if let option = option {
      __option = option
    } else {
      __option = .constant(.init(messages: [], validateMessages: [], characterLimit: nil))
    }
    
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      
      HStack(spacing: 10) {
        
        Group {
          if _showText {
            
            TextField(_placeHolder, text: $_text, onEditingChanged: { editingChanged in
              _isFocused = editingChanged
            })
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(_isDisabled ? .neutral300 : .neutral700)
            .onChange(of: _text) { newValue in
              if let characterLimit = _option.characterLimit,
                 newValue.count > characterLimit {
                _text = String(newValue.prefix(characterLimit))
              }
            }
            .disabled(_isDisabled)
            
          } else {
            
            SecureField(_placeHolder, text: $_text)
              .onSubmit {
                _isFocused = false
              }
              .font(.system(size: 18, weight: .regular))
              .foregroundColor(.neutral700)
              .frame(height: 23.5)
              .onTapGesture {
                _isFocused = true
              }
              .disabled(_isDisabled)

          }
        }
        .onChange(of: _showText) { showText in
        }
        
        Button {
          _text = ""
        } label: {
          Image(sdg: .icInputDelete)
            .resizable()
            .frame(width: 18, height: 18)
        }
        .isHidden(_isHiddenClearButton)
        
        if _isSecureTextEntry {
          
          Button {
            _showText.toggle()
          } label: {
            
            if _showText {
              Image(sdg: .icView)
                .resizable()
                .frame(width: 20, height: 20)
            } else {
              Image(sdg: .icHide)
                .resizable()
                .frame(width: 20, height: 20)
            }
            
          }
        }
        
        
      }
      
      Divider(
        color: _option.isError ? .red300 : .neutral200,
        option: .init(direction: .horizental, thickness: 1)
      )
        .padding(.top, 4)
        .padding(.bottom, 8)
      
      VStack(spacing: 2) {
        
        ForEach(_option.validateMessages, id: \.message) { validateMessage in
          
          switch validateMessage.status {
            case .solved:
              HStack(spacing: 4) {
                Image(sdg: .icCommonCheckS)
                  .resizable()
                  .frame(width: 14, height: 14)
                  .foregroundColor(.primary300)
                
                Text(validateMessage.message)
                  .font(.system(size: 12, weight: .regular))
                  .foregroundColor(.primary300)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .lineLimit(nil)
                  .multilineTextAlignment(.leading)
                
              }
            case .notSolved:
              HStack(spacing: 4) {
                Image(sdg: .icCommonX)
                  .resizable()
                  .frame(width: 14, height: 14)
                  .foregroundColor(.red300)
                
                Text(validateMessage.message)
                  .font(.system(size: 12, weight: .regular))
                  .foregroundColor(.red300)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .lineLimit(nil)
                  .multilineTextAlignment(.leading)
                
              }
          }
        }
        
        ForEach(_option.messages, id: \.self) { error in
          Text(error)
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.neutral400)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
        }
      }
      .padding(.top, 2)
      
    }
  }
}

#Preview {
  ZStack {
    VStack {
      SDGUnderlineInput(
        placeHolder: "placeHolder",
        text: .constant(""),
        option: .constant(
          .init(
            messages: ["dd", "d"],
            validateMessages: [
              .init(
                status: .notSolved,
                message: "dd"
              )
            ]
          )
        ),
        isFocused: .constant(false),
        isSecureTextEntry: false
      )
    }
    .padding()
  }
}
