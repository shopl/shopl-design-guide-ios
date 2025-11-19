//
//  SDGIconPopup.swift
//  DesignSystem
//
//  Created by Dino on 7/25/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

extension View {
  public func iconPopup<Content: View>(
    isPresented: Bool,
    @ViewBuilder icon: @escaping () -> Content,
    iconAlignment: Alignment,
    title: SDGPopupTitle?,
    subText: SDGPopupBodyText?,
    button: SDGCenterPopupButton,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.modifier(
      PopupModifier(
        isPresented: isPresented,
        tapOutsideAction: tapOutsideAction
      ) {
        SDGIconPopup(
          iconAreaContent: icon,
          iconAlignment: iconAlignment,
          title: title,
          subText: subText,
          button: button
        )
      }
    )
  }
}

struct SDGIconPopup<IconAreaContent: View>: View {
  
  private let iconAreaContent: IconAreaContent
  private let iconAlignment: Alignment
  private let title: SDGPopupTitle?
  private let subText: SDGPopupBodyText?
  private let button: SDGCenterPopupButton
  
  @State private var iconHeight: CGFloat = 0
  @State private var titleHeight: CGFloat = 0
  @State private var buttonHeight: CGFloat = 0
  
  private let topPadding: CGFloat = 24
  private let contentSpacing: CGFloat = 12
  private let popupHeightLimitSpacing: CGFloat = 60 * 2
  private let bodyContentTopPadding: CGFloat = 4
  private let bodyContentBottomPadding: CGFloat = 28
  private var totalContentSpacing: CGFloat {
    let result: CGFloat
    if title == nil && subText == nil {
      result = contentSpacing
    } else if title == nil {
      result = contentSpacing
    } else if subText == nil {
      result = contentSpacing * 2
    } else {
      result = contentSpacing * 2
    }
    return result
  }
  
  init(
    @ViewBuilder iconAreaContent: () -> IconAreaContent,
    iconAlignment: Alignment,
    title: SDGPopupTitle?,
    subText: SDGPopupBodyText?,
    button: SDGCenterPopupButton
  ) {
    self.iconAreaContent = iconAreaContent()
    self.iconAlignment = iconAlignment
    self.title = title
    self.subText = subText
    self.button = button
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        VStack(spacing: contentSpacing) {
          iconAreaContent
            .frame(maxHeight: 75)
            .fixedSize(horizontal: false, vertical: true)
            .clipped()
            .frame(maxWidth: .infinity, alignment: iconAlignment)
            .readHeight(to: $iconHeight)
          
          if let title {
            title
              .readHeight(to: $titleHeight)
              .padding(.bottom, subText == nil ? contentSpacing : 0)
          }
          
          if subText != nil {
            SDGPopupBody(maxHeight: calculateBodyHeight(in: geometry.size)) {
              subText
                .padding(.top, bodyContentTopPadding)
                .padding(.bottom, bodyContentBottomPadding)
            }
          }
        }
        .padding(.top, topPadding)
        .padding(.horizontal, 24)
        
        button
          .readHeight(to: $buttonHeight)
      }
      .background(.neutral0)
      .cornerRadius(20)
      .padding(.horizontal, 20)
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }
  
  private func calculateBodyHeight(in containerSize: CGSize) -> CGFloat {
    let fixedHeight = iconHeight + titleHeight + buttonHeight + topPadding + totalContentSpacing
    let availableHeight = containerSize.height - fixedHeight - popupHeightLimitSpacing
    return max(0, availableHeight)
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var showPopup = false
    
    var body: some View {
      Button("팝업 띄우기") {
        showPopup.toggle()
      }
      .padding()
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(8)
      .iconPopup(
        isPresented: showPopup,
        icon: {
          Image(systemName: "exclamationmark.triangle.fill")
            .frame(width: 20, height: 20)
            .padding(10)
            .background(.neutral100)
            .cornerRadius(8)
        },
        iconAlignment: .leading,
        title: .init(
          title: "타이틀",
          color: .neutral400,
          alignment: .leading
        ),
        subText: .init(
          bodyText: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용",
          labelWeight: .R,
          color: .neutral700,
          alignment: .leading
        ),
        button: .init(
          button: .twoOptions(
            option1: .init(
              title: "취소",
              action: {
                showPopup.toggle()
              }
            ),
            option2: .init(
              title: "확인",
              action: {
                showPopup.toggle()
              }
            )
          )
        )
      )
    }
  }
  
  return PreviewWrapper()
}
