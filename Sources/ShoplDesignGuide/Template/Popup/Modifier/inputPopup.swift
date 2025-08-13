//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

extension View {
  public func inputPopup(
    isPresented: Binding<Bool>,
    model: InputPopupModel,
    text: Binding<String>,
    confirmAction: @escaping () -> Void,
    cancelAction: @escaping () -> Void,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.popup(
      isPresented: isPresented,
      backgroundColor: .neutral900.opacity(0.4),
      viewAlignment: .center,
      tapOutsideAction: tapOutsideAction,
      view: {
        InputPopup(
          model: model,
          text: text,
          confirmAction: confirmAction,
          cancelAction: cancelAction
        )
      }
    )
  }
}

public struct InputPopupModel: Equatable {
  
  public let title: String
  public let subTitle: String?
  public let textTitle: String?
  public let placeHolder: String?
  public let initialText: String?
  public let maxCharacterCount: Int?
  public let checkValidation: Bool
  public let confirmButtonTitle: String
  public let cancelButtonTitle: String?
  public let inputBackgroundColor: Color
  
  public init(
    title: String,
    subTitle: String?,
    textTitle: String?,
    placeHolder: String?,
    initialText: String? = nil,
    maxCharacterCount: Int? = nil,
    checkValidation: Bool,
    confirmButtonTitle: String,
    cancelButtonTitle: String? = nil,
    inputBackgroundColor: Color? = nil
  ) {
    let inputBackgroundColor: Color = inputBackgroundColor ?? .neutral200
    
    self.title = title
    self.subTitle = subTitle
    self.textTitle = textTitle
    self.placeHolder = placeHolder
    self.initialText = initialText
    self.maxCharacterCount = maxCharacterCount
    self.checkValidation = checkValidation
    self.confirmButtonTitle = confirmButtonTitle
    self.cancelButtonTitle = cancelButtonTitle
    self.inputBackgroundColor = inputBackgroundColor
  }
}

struct InputPopup: View {
  
  @State private var _confirmable: Bool
  
  @Binding var _text: String
  @State var _isFocused: Bool = false
  
  private let _model: InputPopupModel
  private let _confirmAction: () -> Void
  private let _cancelAction: () -> Void
  
  init(
    model: InputPopupModel,
    text: Binding<String>,
    confirmAction: @escaping () -> Void,
    cancelAction: @escaping () -> Void
  ) {
    _model = model
    __text = text
    _confirmAction = confirmAction
    _cancelAction = cancelAction
    
    _confirmable = !model.checkValidation
  }
  
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      VStack(alignment: .leading, spacing: 0) {
        
        Text(_model.title)
          .font(.system(size: 18, weight: .semibold))
          .foregroundColor(.neutral700)
          .lineLimit(nil)
          .multilineTextAlignment(.leading)
        
        if let subTitle = _model.subTitle {
          Text(subTitle)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.neutral600)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .padding(.top, 12)
        }
      }
      .padding(.horizontal, 28)
      .padding(.top, 32)
      
      
      if let textTitle = _model.textTitle {
        Text("")
          .attributeText(
            fullText: textTitle,
            defaultFont: .system(size: 16),
            defaultColor: .neutral400,
            highlights: [
              .init(word: "*", font: .system(size: 16), color: .red300, underline: false)
            ]
          )
          .padding(.top, 16)
          .padding(.horizontal, 28)
      }
      
      FixedInput(
        text: $_text,
        placeHolder: _model.placeHolder,
        backgroundColor: _model.inputBackgroundColor,
        maxCharacterCount: _model.maxCharacterCount,
        isFocused: $_isFocused
      )
      .padding(.top, _model.textTitle == nil ? 16 : 8)
      .padding(.horizontal, 28)
      .onChange(of: _text) { newValue in
        if _model.checkValidation {
          _confirmable = newValue != "" && !(newValue.allSatisfy { $0.isWhitespace })
          
          if let initialText = _model.initialText {
            _confirmable = initialText != _text
          }
        }
      }
      
      SDGPopupButton(
        isConfirmActionEnabled: $_confirmable,
        confirmButtonTitle: _model.confirmButtonTitle,
        cancelButtonTitle: _model.cancelButtonTitle,
        confirmAction: {
          _confirmAction()
        },
        cancelAction: {
          _cancelAction()
        }
      )
      .padding(.top, 32)
      
    }
    .background(.neutral0)
    .cornerRadius(20)
    .padding(.horizontal, 20)
    .onTapGesture {
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
      )
    }
    
  }
}


#Preview {
  VStack {
    InputPopup(
      model: InputPopupModel(
        title: "title",
        subTitle: "subTitle",
        textTitle: "textTitle*",
        placeHolder: "placeHolder",
        initialText: nil,
        maxCharacterCount: nil,
        checkValidation: false,
        confirmButtonTitle: "confirm",
        cancelButtonTitle: "cancel",
        inputBackgroundColor: .neutral50
      ),
      text: .constant(""),
      confirmAction: {
        
      },
      cancelAction: {
        
      }
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .ignoresSafeArea(.all)
  .background(.neutral900.opacity(0.4))
}
