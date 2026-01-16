//
//  SDGIconTab.swift
//  ShoplDesignGuide
//
//  Created by jerry on 1/7/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

public struct SDGIconTab: View {
  
  public enum `Type`: Equatable {
    case basic, simple
  }
  
  public struct Model: Equatable {
    public let id: String
    public let icon: Image
    public let tintColor: Color
    public let title: String
    public let count: Int
    
    public init(id: String, icon: Image, tintColor: Color, title: String, count: Int) {
      self.id = id
      self.icon = icon
      self.tintColor = tintColor
      self.title = title
      self.count = count
    }
  }
  
  private let type: `Type`
  private let list: [Model]
  
  @Binding private var selectedIndex: Int
  
  public init(
    type: `Type` = .basic,
    list: [Model],
    selectedIndex: Binding<Int>
  ) {
    self.type = type
    self.list = list
    self._selectedIndex = selectedIndex
  }
  
  public var body: some View {
    HStack(spacing: 4) {
      ForEach(list.indices, id: \.self) { index in
        tabButton(for: index)
      }
    }
  }
  
  // MARK: - Private Views
  
  @ViewBuilder
  private func tabButton(for index: Int) -> some View {
    let model = list[index]
    let isSelected = index == selectedIndex
    let fixedHeight: CGFloat = type == .simple ? 52 : 76
    
    Button {
      withAnimation {
        selectedIndex = index
      }
    } label: {
      
      ZStack {
        
        Color.clear
          .frame(width: isSelected ? nil : 50, height: fixedHeight)
          .frame(maxWidth: isSelected ? .infinity : 50)
        
        tabContent(model: model, isSelected: isSelected)
        
      }
      .background(isSelected ? .neutral600 : .neutral0)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(isSelected ? .neutral600 : .neutral200, lineWidth: 1)
      )
    }
    .buttonStyle(NoTapAnimationButtonStyle())
  }
  
  @ViewBuilder
  private func tabContent(model: Model, isSelected: Bool) -> some View {
    let textColor: SDG.Color = isSelected ? .neutral0 : .neutral500
    
    VStack(spacing: 8) {
      if isSelected {
        Text(model.title)
          .typo(.body2_R, .neutral0)
          .lineLimit(2)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 8)
      } else {
        model.icon
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(model.tintColor)
          .frame(width: 20, height: 20)
      }
      
      if type == .basic {
        Text(String(model.count))
          .typo(.body2_SB, textColor)
          .frame(height: 18)
      }
    }
    .padding(.vertical, 8)
  }
}

#Preview {
  struct SDGIconTabPreviewWrapper: View {
    @State private var firstSelectedIndex = 0
    @State private var secondSelectedIndex = 0
    @State private var thirdSelectedIndex = 0

    var body: some View {

      ZStack {
        VStack {

          Spacer()

          SDGIconTab(
            list: [
              .init(id: "0", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "1", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "Label이 길어지면 최대 두줄까지 표시하고 줄임말로 처리", count: 5),
              .init(id: "2", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5)
            ],
            selectedIndex: $firstSelectedIndex
          )
          
          SDGIconTab(
            list: [
              .init(id: "0", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "1", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "2", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "Label이 길어지면 최대 두줄까지 표시하고 줄임말로 처리", count: 5),
              .init(id: "3", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5)
            ],
            selectedIndex: $secondSelectedIndex
          )
          
          SDGIconTab(
            list: [
              .init(id: "0", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "1", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "2", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "3", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "Label이 길어지면 최대 두줄까지 표시하고 줄임말로 처리", count: 5),
              .init(id: "4", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5)
            ],
            selectedIndex: $thirdSelectedIndex
          )

          SDGIconTab(
            type: .simple,
            list: [
              .init(id: "0", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "1", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "Label이 길어지면 최대 두줄까지 표시하고 줄임말로 처리", count: 5),
              .init(id: "2", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5)
            ],
            selectedIndex: $firstSelectedIndex
          )
          
          SDGIconTab(
            type: .simple,
            list: [
              .init(id: "0", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "1", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "2", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "Label이 길어지면 최대 두줄까지 표시하고 줄임말로 처리", count: 5),
              .init(id: "3", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5)
            ],
            selectedIndex: $secondSelectedIndex
          )
          
          SDGIconTab(
            type: .simple,
            list: [
              .init(id: "0", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "1", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "2", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5),
              .init(id: "3", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "Label이 길어지면 최대 두줄까지 표시하고 줄임말로 처리", count: 5),
              .init(id: "4", icon: Image(sdg: .icClip), tintColor: .neutral500, title: "label", count: 5)
            ],
            selectedIndex: $thirdSelectedIndex
          )

          Spacer()

        }
      }
    }
  }

  return SDGIconTabPreviewWrapper()
}
