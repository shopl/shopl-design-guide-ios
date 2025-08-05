//
//  SDGCenterPopup.swift
//  DesignSystem
//
//  Created by Dino on 7/22/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

extension View {
  public func centerPopup<Content: View>(
    isPresented: Bool,
    title: SDGPopupTitle?,
    @ViewBuilder body: @escaping () -> Content,
    button: SDGPopupButton,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.modifier(
      PopupModifier(
        isPresented: isPresented,
        tapOutsideAction: tapOutsideAction
      ) {
        SDGCenterPopup(
          title: title,
          bodyContent: body,
          button: button
        )
      }
    )
  }
}

struct SDGCenterPopup<BodyContent: View>: View {
  
  private let title: SDGPopupTitle?
  private let bodyContent: BodyContent
  private let button: SDGPopupButton
  
  @State private var titleHeight: CGFloat = 0
  @State private var buttonHeight: CGFloat = 0
  
  private let topPadding: CGFloat = 24
  private let contentSpacing: CGFloat = 12
  private let spacing: CGFloat = 60 * 2
  private var totalContentSpacing: CGFloat {
    let result: CGFloat
    if title == nil && bodyContent.isEmpty {
      result = 0
    } else if title == nil {
      result = 0
    } else if bodyContent.isEmpty {
      result = contentSpacing
    } else {
      result = contentSpacing
    }
    return result
  }
  
  init(
    title: SDGPopupTitle?,
    @ViewBuilder bodyContent: () -> BodyContent,
    button: SDGPopupButton
  ) {
    self.title = title
    self.bodyContent = bodyContent()
    self.button = button
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        VStack(spacing: contentSpacing) {
          if let title {
            title
              .readHeight(to: $titleHeight)
              .padding(.bottom, bodyContent.isEmpty ? contentSpacing : 0)
          }
          
          if !bodyContent.isEmpty {
            SDGPopupBody(maxHeight: calculateBodyHeight(in: geometry.size)) {
              bodyContent
            }
          }
        }
        .padding(.top, topPadding)
        .padding(.horizontal, 24)
        
        button
          .readHeight(to: $buttonHeight)
      }
      .background(TypoColor.neutral0.color)
      .cornerRadius(20)
      .padding(.horizontal, 20)
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }
  
  private func calculateBodyHeight(in containerSize: CGSize) -> CGFloat {
    let fixedHeight = titleHeight + buttonHeight + topPadding + totalContentSpacing
    let availableHeight = containerSize.height - fixedHeight - spacing
    return max(0, availableHeight)
  }
}


#Preview {
  VStack(spacing: 0) {
    Color.clear
      .centerPopup(
        isPresented: true,
        title: .init(
          title: "타이틀",
          color: .neutral400,
          alignment: .leading
        ),
        body: {
          SDGPopupBodyText(
            bodyText: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용",
            labelWeight: .R,
            color: TypoColor.neutral700,
            alignment: .leading
          )
        },
        button: .init(
          button: .oneOption(
            option: .init(
              title: "확인",
              action: {
                print("확인")
              }
            )
          )
        )
      )
    
    Color.clear
      .centerPopup(
        isPresented: true,
        title: .init(
          title: "타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀",
          color: .neutral400,
          alignment: .leading
        ),
        body: {
          VStack(spacing: 0) {
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
            Text("길어지면")
          }
          .frame(maxWidth: .infinity)
        },
        button: .init(
          button: .twoOptions(
            option1: .init(
              title: "취소취소취소취소취소취소취소취소취소취소취소취소",
              action: {
                print("취소")
              }
            ),
            option2: .init(
              title: "확인확인확인확인확인확인확인확인확인확인확인확인",
              action: {
                print("확인")
              }
            )
          )
        )
      )
  }
}

