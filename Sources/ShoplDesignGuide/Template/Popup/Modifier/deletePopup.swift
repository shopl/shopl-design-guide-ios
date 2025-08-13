//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

extension View {
  public func deletePopup(
    isPresented: Binding<Bool>,
    model: DeletePopupModel,
    deleteAction: @escaping () -> Void,
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
        DeletePopup(
          model: model,
          deleteAction: deleteAction,
          cancelAction: cancelAction,
          customView: customView
        )
      }
    )
  }
}

public struct DeletePopupModel: Equatable {
  
  public let title: Text?
  public let subTitle: Text?
  public let deleteButtonTitle: String
  public let cancelButtonTitle: String?
  public let checkValidation: Bool
  
  public init(
    title: Text?,
    subTitle: Text?,
    deleteButtonTitle: String,
    cancelButtonTitle: String? = nil,
    checkValidation: Bool
  ) {
    self.title = title
    self.subTitle = subTitle
    self.deleteButtonTitle = deleteButtonTitle
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

struct DeletePopup: View {
  
  @State private var _confirmable: Bool
  
  private let _model: DeletePopupModel
  private let _deleteAction: () -> Void
  private let _cancelAction: (() -> Void)?
  private let _customView: AnyView?
  
  init(
    model: DeletePopupModel,
    deleteAction: @escaping () -> Void,
    cancelAction: (() -> Void)? = nil,
    customView: (() -> AnyView)? = nil
  ) {
    _model = model
    _deleteAction = deleteAction
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
        confirmButtonTitle: _model.deleteButtonTitle,
        confirmButtonTitleColor: .red300,
        cancelButtonTitle: _model.cancelButtonTitle,
        confirmAction: {
          _deleteAction()
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
    
    DeletePopup(
      model: DeletePopupModel(
        title: DeletePopupModel.basicTitleStyle(title: "Delete Action"),
        subTitle: DeletePopupModel.basicSubTitleStyle(subTitle: "Are you sure you want to proceed?"),
        deleteButtonTitle: "delete",
        cancelButtonTitle: "canecl",
        checkValidation: false
      ),
      deleteAction: {
        
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

