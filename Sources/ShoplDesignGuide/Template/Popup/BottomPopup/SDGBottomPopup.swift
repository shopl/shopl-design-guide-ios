//
//  SDGBottomPopup.swift
//  ShoplDesignGuide
//
//  Created by Dino on 8/20/25.
//

import SwiftUI
import UIKit

extension View {
  public func bottomPopup<Content: View>(
    isPresented: Bool,
    title: SDGPopupTitle?,
    @ViewBuilder body: @escaping () -> Content,
    button: SDGBottomPopupButton,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.modifier(
      PopupModifier(
        isPresented: isPresented,
        tapOutsideAction: tapOutsideAction
      ) {
        SDGBottomPopup(
          title: title,
          bodyContent: body,
          button: button
        )
      }
    )
  }
}

struct SDGBottomPopup<BodyContent: View>: View {
  
  private let title: SDGPopupTitle?
  private let bodyContent: BodyContent
  private let button: SDGBottomPopupButton
  
  @State private var screenHeight: CGFloat = 0
  @State private var titleHeight: CGFloat = 0
  @State private var buttonHeight: CGFloat = 0
  
  private let topPadding: CGFloat = 24
  private let contentSpacing: CGFloat = 12
  private var popupHeightLimitSpacing: CGFloat {
    screenHeight * 0.3
  }
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
    button: SDGBottomPopupButton
  ) {
    self.title = title
    self.bodyContent = bodyContent()
    self.button = button
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
        
        ZStack(alignment: .bottom) {
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
          .background(.neutral0)
          .cornerRadius(20, corners: [.topLeft, .topRight])
          .frame(height: .infinity)
          
          Color.neutral0
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
            .padding(.bottom, -50)
        }
      }
      .onAppear {
        self.screenHeight = geometry.size.height
      }
    }
  }
  
  private func calculateBodyHeight(in containerSize: CGSize) -> CGFloat {
    let fixedHeight = titleHeight + buttonHeight + topPadding + totalContentSpacing
    let availableHeight = containerSize.height - fixedHeight - popupHeightLimitSpacing
    return max(0, availableHeight)
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var showPopup = false
    @State private var showScrollablePopup = false
    var body: some View {
      VStack(spacing: 20) {
        Button("팝업 띄우기") {
          showPopup.toggle()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        
        Button("내용이 긴 팝업 띄우기") {
          showScrollablePopup.toggle()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
      }
      .bottomPopup(
        isPresented: showPopup,
        title: .init(
          title: "타이틀",
          color: .neutral400,
          alignment: .leading
        ),
        body: {
          SDGPopupBodyText(
            bodyText: "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용",
            labelWeight: .R,
            color: .neutral700,
            alignment: .leading
          )
        },
        button: .init(
          button: .oneOption(
            option: .init(
              title: "확인",
              action: {
                showPopup.toggle()
              }
            )
          )
        )
      )
      .bottomPopup(
        isPresented: showScrollablePopup,
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
                showScrollablePopup.toggle()
              }
            ),
            option2: .init(
              title: "확인확인확인확인확인확인확인확인확인확인확인확인",
              action: {
                showScrollablePopup.toggle()
              }
            )
          ),
          status: .disabled
        )
      )
    }
  }
  
  return PreviewWrapper()
}
