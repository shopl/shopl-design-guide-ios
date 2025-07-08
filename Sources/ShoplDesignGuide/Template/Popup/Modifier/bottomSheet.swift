//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 7/8/25.
//

import SwiftUI

extension View {
  public func bottomSheet(
    isPresented: Binding<Bool>,
    customView: () -> some View,
    popupButtonUnitModel: (type: PopupButtonUnit.`Type`, state: PopupButtonUnit.State)?,
    tapOutsideAction: (() -> Void)? = nil,
    confirmAction: @escaping () -> Void
  ) -> some View {
    self.modifier(
      BottomSheet(
        isPresented: isPresented,
        backgroundColor: .neutral900.opacity(0.4),
        tapOutsideAction: tapOutsideAction,
        view: {
          ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
              
              customView()
                .padding(.vertical, 32)
                .padding(.horizontal, 28)
              
              if let popupButtonUnitModel = popupButtonUnitModel {
                PopupButtonUnit(
                  type: popupButtonUnitModel.type,
                  state: popupButtonUnitModel.state
                )
              }
            }
            .background(.neutral0)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            
            Color.neutral0
              .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
              .padding(.bottom, -50)
          }
        }
      )
    )
  }
}

#Preview {
  ZStack { }
  .bottomSheet(
    isPresented: .constant(true),
    customView: {
      VStack(spacing: 12) {
        Text("Title")
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text("Subtitle")
          .frame(maxWidth: .infinity, alignment: .leading)
          
      }
    },
    popupButtonUnitModel: (.option2(cancel: {
      
    }, confirm: {
      
    }), .default),
    confirmAction: {
      
    }
  )
}

