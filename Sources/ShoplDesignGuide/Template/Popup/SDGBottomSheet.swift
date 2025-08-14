//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 7/8/25.
//

import SwiftUI

public struct SDGBottomSheet<BottomContent: View>: ViewModifier {
  
  @Binding var isPresented: Bool
  
  // MARK: - Parameters
  
  var backgroundColor: Color
  
  // MARK: - Presentation State
  
  @State private var showSheet = false
  @State private var showContent = false
  @State private var opacity = 0.0
    
  var view: BottomContent
  
  var tapOutsideAction: (() -> Void)?
  
  init(isPresented: Binding<Bool>,
       backgroundColor: Color,
       tapOutsideAction: (() -> Void)?,
       @ViewBuilder view: () -> BottomContent
  ) {
    self._isPresented = isPresented
    self.backgroundColor = backgroundColor
    self.tapOutsideAction = tapOutsideAction
    self.view = view()
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
    ZStack(alignment: .bottom) {
      createBackgroundView()
      
      createView()
    }
  }
  
  func createBackgroundView() -> some View {
    backgroundColor
      .opacity(opacity)
      .edgesIgnoringSafeArea(.all)
      .onTapGesture {
        if let tapOutsideAction = tapOutsideAction {
          tapOutsideAction()
        }
      }
  }
  
  func createView() -> some View {
    Group {
      view
    }
    .compositingGroup()
    .opacity(opacity)
    .edgesIgnoringSafeArea(.all)
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
