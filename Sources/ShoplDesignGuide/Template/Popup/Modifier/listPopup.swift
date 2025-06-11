//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

extension View {
  public func listPopup(
    isPresented: Binding<Bool>,
    list: [ListPopupModel],
    selectAction: @escaping (String) -> Void,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.popup(
      isPresented: isPresented,
      backgroundColor: .neutral900.opacity(0.4),
      viewAlignment: .center,
      tapOutsideAction: tapOutsideAction,
      view: {
        ListPopupView(
          list: list,
          selectAction: selectAction
        )
      }
    )
  }
}

public struct ListPopupModel: Equatable {
  public let id: String
  public let title: String
  
  public init(id: String, title: String) {
    self.id = id
    self.title = title
  }
}

struct ContentHeightKey: PreferenceKey {
  static let defaultValue: CGFloat = 0
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

struct ListPopupView: View {
  private let _list: [ListPopupModel]
  private let _selectAction: (String) -> Void
  
  @Environment(\.safeAreaInsets) private var safeAreaInsets
  
  @State private var scrollViewContentSize: CGSize = .zero
  
  @State private var showView: Bool = false
  
  init(
    list: [ListPopupModel],
    selectAction: @escaping (String) -> Void
  ) {
    _list = list
    _selectAction = selectAction
  }
  
  var body: some View {
    GeometryReader { geometry in
      
      ZStack(alignment: .bottom) {
        VStack(spacing: 0) {
          
          Spacer()
          
          if showView {
            ScrollView {
              VStack(spacing: 0) {
                ForEach(self._list.indices, id: \.self) { index in
                  
                  Button {
                    showView = false
                    _selectAction(self._list[index].id)
                  } label: {
                    VStack(spacing: 0) {
                      if index != 0 {
                        Color.neutral200
                          .frame(maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                          .padding(.horizontal, 12)
                      }
                      
                      Text(self._list[index].title)
                        .typo(.body1_R, .neutral700)
                        .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 20)
                    }
                  }
                  
                }
                
                Color.neutral0
                  .frame(maxWidth: .infinity, minHeight: safeAreaInsets.bottom, maxHeight: safeAreaInsets.bottom)
              }
              .background(
                GeometryReader { geo -> Color in
                  DispatchQueue.main.async {
                    scrollViewContentSize = geo.size
                  }
                  return Color.clear
                }
              )
              .frame(maxWidth: .infinity)
            }
            .frame(
              minHeight: safeAreaInsets.bottom + 50,
              maxHeight: min(
                UIScreen.main.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom - 60,
                scrollViewContentSize.height
              )
            )
            .background(.neutral0)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .zIndex(1)
            .transition(.move(edge: .bottom))
            .animation(.spring(), value: showView)
          }
        }
      }
      .onAppear {
        showView = true
      }
      
    }
  }
}

#Preview {
  VStack {
    
    Spacer()
    
    ListPopupView(
      list: [
        .init(id: UUID().uuidString, title: "1"
             ),
        .init(id: UUID().uuidString, title: "2"),
        .init(id: UUID().uuidString, title: "3"),
        .init(id: UUID().uuidString, title: "4"),
        .init(id: UUID().uuidString, title: "5"),
        .init(id: UUID().uuidString, title: "6")
      ],
      selectAction: { _ in
        
      }
    )
  }
  .background(.neutral100)
  .ignoresSafeArea(.all)
}
