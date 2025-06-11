//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

public struct PopupButton: View {
  
  @Binding private var _isConfirmActionEnabled: Bool
  
  private let _cancelAction: (() -> Void)?
  private let _confirmAction: () -> Void
  
  private let _cancelButtonTitle: String?
  private let _confirmButtonTitle: String
  private let _confirmButtonTitleColor: Color?

  public init(
    isConfirmActionEnabled: Binding<Bool>,
    confirmButtonTitle: String,
    confirmButtonTitleColor: Color? = nil,
    cancelButtonTitle: String? = nil,
    confirmAction: @escaping () -> Void,
    cancelAction: (() -> Void)? = nil
  ) {
    __isConfirmActionEnabled = isConfirmActionEnabled
    _confirmButtonTitle = confirmButtonTitle
    _confirmButtonTitleColor = confirmButtonTitleColor
    _cancelButtonTitle = cancelButtonTitle
    _cancelAction = cancelAction
    _confirmAction = confirmAction
  }
  
  public var body: some View {
    
    VStack(spacing: 0) {
      
      Divider(color: .neutral200, option: .init(direction: .horizental, thickness: 1))
      
      if _cancelAction != nil {
        HStack(spacing: 0) {

          Button {
            _cancelAction?()
          } label: {

            if let cancelButtonTitle = _cancelButtonTitle {
              Text(cancelButtonTitle)
                .foregroundColor(.neutral700)
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
              Text("취소 (스크립트)")
                .foregroundColor(.neutral700)
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .center)
            }

          }

          Divider(color: .neutral200, option: .init(direction: .vertical, thickness: 1))
            .frame(maxHeight: 51)

          Button {
            _confirmAction()
          } label: {
            if let confirmButtonTitleColor = _confirmButtonTitleColor {
              Text(_confirmButtonTitle)
                .foregroundColor(
                  _isConfirmActionEnabled
                  ? confirmButtonTitleColor
                  : .neutral300
                )
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
              Text(_confirmButtonTitle)
                .foregroundColor(
                  _isConfirmActionEnabled
                  ? .neutral700
                  : .neutral300
                )
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .center)
            }
          }
          .disabled(!_isConfirmActionEnabled)
          
        }
      } else {
        
        Button {
          _confirmAction()
        } label: {
          
          if let confirmButtonTitleColor = _confirmButtonTitleColor {
            Text(_confirmButtonTitle)
              .foregroundColor(
                _isConfirmActionEnabled
                ? confirmButtonTitleColor
                : .neutral300
              )
              .font(.system(size: 16, weight: .semibold))
              .frame(maxWidth: .infinity, minHeight: 51, alignment: .center)
          } else {
            Text(_confirmButtonTitle)
              .foregroundColor(
                _isConfirmActionEnabled
                ? .neutral700
                : .neutral300
              )
              .font(.system(size: 16, weight: .semibold))
              .frame(maxWidth: .infinity, minHeight: 51, alignment: .center)
          }
        }
        .disabled(!_isConfirmActionEnabled)
        
      }
    }
  }
}

