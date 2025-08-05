//
//  PopupHostingView.swift
//  DesignSystem
//
//  Created by Dino on 7/24/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

public class PopupHostingViewController<BodyContent: View>: UIHostingController<AnyView> {
  
  public init(
    title: SDGPopupTitle?,
    button: SDGPopupButton,
    tapOutsideAction: (() -> Void)? = nil,
    @ViewBuilder body: @escaping () -> BodyContent
  ) {
    let popupContent = {
      SDGCenterPopup(
        title: title,
        bodyContent: body,
        button: button
      )
    }
    
    let rootView = PopupPresenter(
      isPresented: true,
      content: popupContent,
      tapOutsideAction: tapOutsideAction
    )
    
    super.init(rootView: AnyView(rootView))
    
    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
    self.view.backgroundColor = .clear
  }
  
  required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
