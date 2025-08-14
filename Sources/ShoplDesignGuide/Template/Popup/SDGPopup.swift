//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

extension View {
  func popup<PopupContent: View>(
    isPresented: Binding<Bool>,
    backgroundColor: Color = .neutral900.opacity(0.4),
    viewAlignment: Alignment,
    tapOutsideAction: (() -> Void)?,
    @ViewBuilder view: @escaping () -> PopupContent
  ) -> some View {
    self.modifier(
      SDGPopup(
        isPresented: isPresented,
        backgroundColor: backgroundColor,
        viewAlignment: viewAlignment,
        tapOutsideAction: tapOutsideAction,
        view: view
      )
    )
  }
}

struct SDGPopup<PopupContent: View>: ViewModifier {
  
  @Binding var isPresented: Bool
  
  // MARK: - Parameters
  
  var backgroundColor: Color
  
  var viewAlignment: Alignment
  
  // MARK: - Presentation State
  
  @State private var showSheet = false
  @State private var showContent = false
  @State private var opacity = 0.0
    
  var view: () -> PopupContent
  
  var tapOutsideAction: (() -> Void)?
  
  init(isPresented: Binding<Bool>,
       backgroundColor: Color,
       viewAlignment: Alignment,
       tapOutsideAction: (() -> Void)?,
       view: @escaping () -> PopupContent
  ) {
    self._isPresented = isPresented
    self.backgroundColor = backgroundColor
    self.viewAlignment = viewAlignment
    self.tapOutsideAction = tapOutsideAction
    self.view = view
  }
  
  public func body(content: Content) -> some View {
    
    main(content: content)
      .onChange(of: isPresented) { newValue in
        appearAction()
      }
      .onAppear {
        if isPresented {
          appearAction()
        }
      }
  }
  
  public func main(content: Content) -> some View {
    
    content
      .fullScreenCover(isPresented: $showSheet, content: {
        ZStack {
          constructPopup()
        }
        .background(FullScreenCoverBackgroundRemovalView())
      })
    
  }
  
  func constructPopup() -> some View {
    ZStack(alignment: viewAlignment) {
      createBackgroundView()
      
      createView()
    }
  }
  
  func createBackgroundView() -> some View {
    backgroundColor
      .opacity(opacity)
//      .animation(.linear(duration: 0.3), value: opacity)
      .edgesIgnoringSafeArea(.all)
      .onTapGesture {
        if let tapOutsideAction = tapOutsideAction {
          tapOutsideAction()
        }
      }
  }
  
  func createView() -> some View {
    Group {
      view()
    }
    .compositingGroup()
    .opacity(opacity)
    .edgesIgnoringSafeArea(.all)
//    .animation(.linear(duration: 0.2), value: opacity)
  }
  
  func appearAction() {
    if isPresented {
      showSheet = true
      performWithDelay(0.1) {
        opacity = 1
      }
      UIView.setAnimationsEnabled(false)

    } else {
      opacity = 0
      performWithDelay(0.2) {
        showSheet = false
        isPresented = false
      }
      UIView.setAnimationsEnabled(true)

    }
  }
  
  func performWithDelay(_ delay: Double, block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      block()
    }
  }
}

private struct FullScreenCoverBackgroundRemovalView: UIViewRepresentable {
  
  private class BackgroundRemovalView: UIView {
    
    override func didMoveToWindow() {
      super.didMoveToWindow()
      
      superview?.superview?.backgroundColor = .clear
    }
  }
  
  func makeUIView(context: Context) -> UIView {
    return BackgroundRemovalView()
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {}
}
