//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

extension View {
  public func infoPopup(
    isPresented: Binding<Bool>,
    title: String,
    subTitle: String?,
    subTtileColor: Color?,
    tapOutsideAction: (() -> Void)? = nil,
    buttonText: String = "확인 (스크립트)",
    confirmAction: @escaping () -> Void
  ) -> some View {
    
    let subTitleColor: Color = subTtileColor ?? .neutral700
    
    return self.popup(
      isPresented: isPresented,
      backgroundColor: .neutral900.opacity(0.4),
      viewAlignment: .center,
      tapOutsideAction: tapOutsideAction,
      view: {
        InfoPopup(
          title: title,
          subTitle: subTitle,
          subTtileColor: subTitleColor,
          buttonText: buttonText,
          confirmAction: confirmAction
        )
      }
    )
  }
}

struct InfoPopup: View {
  
  private let _title: String
  private let _subTitle: String?
  private let _subTtileColor: Color
  private let _buttonText: String
  
  private let _confirmAction: () -> Void
  
  init(
    title: String,
    subTitle: String?,
    subTtileColor: Color,
    buttonText: String,
    confirmAction: @escaping () -> Void
  ) {
    _title = title
    _subTitle = subTitle
    _subTtileColor = subTtileColor
    _buttonText = buttonText
    _confirmAction = confirmAction
  }
  
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      VStack(alignment: .leading, spacing: 16) {
        
        Text(_title)
          .font(.system(size: 18, weight: .semibold))
          .foregroundColor(.neutral700)
          .lineLimit(nil)
          .multilineTextAlignment(.leading)
        
        if let subTitle = _subTitle {
          Text(subTitle)
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(_subTtileColor)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
        }
      }
      .padding(.horizontal, 28)
      .padding(.top, 32)
      
      PopupButton(
        isConfirmActionEnabled: .constant(true),
        confirmButtonTitle: _buttonText,
        confirmAction: {
          _confirmAction()
        }
      )
      .padding(.top, 32)

    }
    .background(.neutral0)
    .cornerRadius(20)
    .padding(.horizontal, 20)
    
  }
}

struct BasicPopup_Preview: PreviewProvider {
  static var previews: some View {
    
    VStack {
      InfoPopup(
        title: "testtesttestesttesttesttesttesttesttesttest",
        subTitle: "testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest",
        subTtileColor: .neutral600,
        buttonText: "확인",
        confirmAction: {
      })
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.neutral900.opacity(0.4))
    
    
  }
}
