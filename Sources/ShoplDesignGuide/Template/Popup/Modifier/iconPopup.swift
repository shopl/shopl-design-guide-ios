//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

extension View {
  public func iconPopup(
    isPresented: Binding<Bool>,
    model: IconPopupModel,
    tapOutsideAction: (() -> Void)? = nil,
    confirmAction: @escaping () -> Void,
    customView: (() -> AnyView)? = nil
  ) -> some View {
    self.popup(
      isPresented: isPresented,
      backgroundColor: .neutral900.opacity(0.4),
      viewAlignment: .center,
      tapOutsideAction: tapOutsideAction
    ) {
      IconPopup(
        model: model,
        confirmAction: confirmAction,
        customView: customView
      )
    }
  }
}

public struct IconPopupModel: Equatable {
  
  public let image: Image
  public let title: String
  public let subTitle: String?
  
  public init(image: Image, title: String, subTitle: String?) {
    self.image = image
    self.title = title
    self.subTitle = subTitle
  }
}

public struct IconPopup: View {
  
  private let _model: IconPopupModel
  
  private let _confirmAction: () -> Void
  private let _customView: AnyView?
  
  public init(
    model: IconPopupModel,
    confirmAction: @escaping () -> Void,
    customView: (() -> AnyView)? = nil
  ) {
    _model = model
    _confirmAction = confirmAction
    _customView = customView?()
  }
  
  public var body: some View {
    VStack(alignment: .center, spacing: 0) {
      
      _model.image
        .resizable()
        .frame(width: 75, height: 75)
        .padding(.top, 32)
      
      VStack(spacing: 10) {
        
        Text(_model.title)
          .multilineTextAlignment(.center)
          .font(.system(size: 18, weight: .semibold))
          .foregroundColor(.neutral700)
        
        if let subTitle = _model.subTitle {
          Text(subTitle)
            .multilineTextAlignment(.center)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.neutral700)
            
        }
        
        if let customView = _customView {
          customView
        }
      }
      .padding(.top, 20)
      .padding(.horizontal, 28)
      
      PopupButton(
        isConfirmActionEnabled: .constant(true),
        confirmButtonTitle: "confirm (스크립트)",
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

struct BasicIconPopup_Previews: PreviewProvider {
    
    static var previews: some View {
        
      Rectangle()
        .foregroundColor(.blue)
        .iconPopup(
          isPresented: .constant(true),
          model: .init(
            image: Image(.popupWarning),
            title: "OK",
            subTitle: "Not OK"
          ),
          confirmAction: {
            
          }
        )
    }
}

