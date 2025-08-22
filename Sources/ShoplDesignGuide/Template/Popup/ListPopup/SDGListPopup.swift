//
//  SDGListPopup.swift
//  ShoplDesignGuide
//
//  Created by Dino on 8/20/25.
//


import SwiftUI

extension View {
  public func listPopup(
    isPresented: Bool,
    list: [ListPopupModel],
    selectAction: @escaping (String) -> Void,
    tapOutsideAction: (() -> Void)? = nil
  ) -> some View {
    self.modifier(
      PopupModifier(
        isPresented: isPresented,
        animation: .slideBottomTop,
        tapOutsideAction: tapOutsideAction
      ) {
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
  public let status: Status
  
  public enum Status {
    case `default`
    case delete
    case selected
    
    var typoColor: TypoColor {
      switch self {
      case .default:
          .neutral700
      case .delete:
          .red300
      case .selected:
          .primary300
      }
    }
  }
  
  public init(id: String, title: String, status: Status = .default) {
    self.id = id
    self.title = title
    self.status = status
  }
}

struct ListPopupView: View {
  private let list: [ListPopupModel]
  private let selectAction: (String) -> Void
  
  @Environment(\.safeAreaInsets) private var safeAreaInsets
  @State private var screenHeight: CGFloat = 0
  @State private var contentHeight: CGFloat = 0
  @State private var maxHeight: CGFloat = 0
  
  private var popupHeightLimitSpacing: CGFloat {
    screenHeight * 0.3
  }
  
  init(
    list: [ListPopupModel],
    selectAction: @escaping (String) -> Void
  ) {
    self.list = list
    self.selectAction = selectAction
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
        
        ZStack(alignment: .bottom) {
          VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
              VStack(spacing: 0) {
                ForEach(self.list.indices, id: \.self) { index in
                  Button {
                    selectAction(self.list[index].id)
                  } label: {
                    VStack(spacing: 0) {
                      if index != 0 {
                        Color.neutral200
                          .frame(height: 1)
                      }
                      
                      Text(self.list[index].title)
                        .typo(.body1_R, list[index].status.typoColor)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 8)
                        .lineLimit(nil)
                    }
                    .padding(.horizontal, 12)
                  }
                }
                
                Spacer()
                  .frame(height: 10)
                
              }
              .readHeight(to: $contentHeight)
            }
            .scrollDisabled(contentHeight <= maxHeight + 1)
            .frame(maxHeight: min(maxHeight, contentHeight))
            .padding(.bottom, safeAreaInsets.bottom)
          }
          .background(.neutral0)
          .cornerRadius(20, corners: [.topLeft, .topRight])
          .frame(height: .infinity)
        }
      }
      .ignoresSafeArea()
      .onAppear {
        self.screenHeight = geometry.size.height
        self.maxHeight = calculateBodyHeight(in: geometry.size)
      }
    }
  }
  
  private func calculateBodyHeight(in containerSize: CGSize) -> CGFloat {
    let availableHeight = containerSize.height - popupHeightLimitSpacing
    return max(0, availableHeight)
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var showPopup = false
    @State private var showScrollablePopup = false
    @State private var selectedID: String = ""
    @State private var list = Array(1...8).map(\.description)
    
    var body: some View {
      VStack(spacing: 20) {
        Button("팝업 띄우기") {
          showPopup.toggle()
        }
        .padding()
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        
        Button("내용이 긴 팝업 띄우기") {
          showScrollablePopup.toggle()
        }
        .padding()
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
      }
      .listPopup(
        isPresented: showPopup,
        list:
          list.map {
            .init(id: $0, title: $0, status: $0 == selectedID ? .selected : .default)
          },
        selectAction: { id in
          showPopup.toggle()
          selectedID = id
        }
      )
      .listPopup(
        isPresented: showScrollablePopup,
        list:[
          .init(id: UUID().uuidString, title: "내용이 길어지면 전체 노출 내용이 길어지면 전체 노출 내용이 길어지면 전체 노출"),
          .init(id: UUID().uuidString, title: "1"),
          .init(id: UUID().uuidString, title: "2"),
          .init(id: UUID().uuidString, title: "3"),
          .init(id: UUID().uuidString, title: "4"),
          .init(id: UUID().uuidString, title: "5"),
          .init(id: UUID().uuidString, title: "6"),
          .init(id: UUID().uuidString, title: "7"),
          .init(id: UUID().uuidString, title: "8"),
          .init(id: UUID().uuidString, title: "9"),
          .init(id: UUID().uuidString, title: "10"),
          .init(id: UUID().uuidString, title: "11"),
          .init(id: UUID().uuidString, title: "12"),
          .init(id: UUID().uuidString, title: "13"),
          .init(id: UUID().uuidString, title: "delete", status: .delete)
        ],
        selectAction: { id in
          showScrollablePopup.toggle()
        }
      )
    }
  }
  
  return PreviewWrapper()
}
