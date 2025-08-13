//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

extension View {
  public func confirmPopup(
    isPresented: Binding<Bool>,
    model: ConfirmPopupModel,
    confirmAction: @escaping () -> Void,
    cancelAction: (() -> Void)? = nil,
    tapOutsideAction: (() -> Void)? = nil,
    customView: (() -> AnyView)? = nil
  ) -> some View {
    self.popup(
      isPresented: isPresented,
      backgroundColor: .neutral900.opacity(0.4),
      viewAlignment: .center,
      tapOutsideAction: tapOutsideAction,
      view: {
        ConfirmPopup(
          model: model,
          confirmAction: confirmAction,
          cancelAction: cancelAction,
          customView: customView
        )
      }
    )
  }
}

public struct ConfirmPopupModel: Equatable {
  
  public let title: Text?
  public let subTitle: Text?
  public let confirmButtonTitle: String
  public let confirmButtonTitleColor: Color?
  public let cancelButtonTitle: String?
  public let checkValidation: Bool
  
  public init(
    title: Text?,
    subTitle: Text?,
    confirmButtonTitle: String,
    confirmButtonTitleColor: Color? = nil,
    cancelButtonTitle: String? = nil,
    checkValidation: Bool
  ) {
    self.title = title
    self.subTitle = subTitle
    self.confirmButtonTitle = confirmButtonTitle
    self.confirmButtonTitleColor = confirmButtonTitleColor
    self.cancelButtonTitle = cancelButtonTitle
    self.checkValidation = checkValidation
  }
  
  public static func basicTitleStyle(title: String) -> Text {
    Text(title)
      .font(.system(size: 18, weight: .semibold))
      .foregroundColor(.neutral700)
  }
  
  public static func basicSubTitleStyle(subTitle: String) -> Text {
    Text(subTitle)
      .font(.system(size: 16, weight: .regular))
      .foregroundColor(.neutral700)
  }
}

struct ConfirmPopup: View {
  
  @State private var _confirmable: Bool
  
  private let _model: ConfirmPopupModel
  private let _confirmAction: () -> Void
  private let _cancelAction: (() -> Void)?
  private let _customView: AnyView?
  
  init(
    model: ConfirmPopupModel,
    confirmAction: @escaping () -> Void,
    cancelAction: (() -> Void)? = nil,
    customView: (() -> AnyView)? = nil
  ) {
    _model = model
    _confirmAction = confirmAction
    _cancelAction = cancelAction
    _customView = customView?()
    
    _confirmable = !model.checkValidation
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      
      VStack(alignment: .leading, spacing: 8) {
        
        if let title = _model.title {
          title
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
        }
        
        if let subTitle = _model.subTitle {
          subTitle
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
        }
        
        if let customView = _customView {
          customView
        }
      }
      .padding(.horizontal, 28)
      .padding(.top, 32)
      
      SDGPopupButton(
        isConfirmActionEnabled: $_confirmable,
        confirmButtonTitle: _model.confirmButtonTitle,
        confirmButtonTitleColor: _model.confirmButtonTitleColor,
        cancelButtonTitle: _model.cancelButtonTitle,
        confirmAction: {
          _confirmAction()
        },
        cancelAction: _cancelAction
      )
      .padding(.top, 32)
      
    }
    .background(.neutral0)
    .cornerRadius(20)
    .padding(.horizontal, 20)
    .padding(.vertical, 60)
  }
}

#Preview {
  VStack {
    Spacer()
    
    ConfirmPopup(
      model: ConfirmPopupModel(
        title: ConfirmPopupModel.basicTitleStyle(title: "Confirm Action"),
        subTitle: ConfirmPopupModel.basicSubTitleStyle(subTitle: "Are you sure you want to proceed?"),
        confirmButtonTitle: "confirm",
        cancelButtonTitle: "canecl",
        checkValidation: false
      ),
      confirmAction: {
        
      },
      cancelAction: {
        
      }
    )
    
    Spacer()
  }
  .background(.neutral900.opacity(0.4))
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .ignoresSafeArea(.all)
}

