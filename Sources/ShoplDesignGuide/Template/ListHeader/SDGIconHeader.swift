//
//  SDGIconHeader.swift
//  SDGSampleApp
//
//  Created by jerry on 1/12/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

public struct SDGIconHeader: View {

  public enum `Type`: Equatable {
    case box, normal
  }
  
  public struct IconModel: Equatable, Identifiable {
    public let id: String
    public let icon: Image
    public let tintColor: Color
    
    public init(id: String, icon: Image, tintColor: Color) {
      self.id = id
      self.icon = icon
      self.tintColor = tintColor
    }
  }
  
  public let type: `Type`
  public let title: SDGListHeaderLabel.Model
  public let icons: [IconModel]
  
  public let selectedIcon: (IconModel) -> ()
  
  public init(
    type: `Type`,
    title: SDGListHeaderLabel.Model,
    icons: [IconModel],
    selectedIcon: @escaping (IconModel) -> ()
  ) {
    self.type = type
    self.title = title
    self.icons = icons
    self.selectedIcon = selectedIcon
  }
  
  public var body: some View {
    
    HStack(spacing: 12) {
      
      SDGListHeaderLabel(
        model: title
      )
      
      Spacer(minLength: 0)
      
      
      switch type {
      case .box:
        
        ZStack {
          icon()
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
        }
        .cornerRadius(6)
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(.neutral200, lineWidth: 1)
        )
        
      case .normal:
        icon()
      }
      
    }
    .padding(.horizontal, 4)
    
  }
  
  
  // MARK: - Private Views
  
  @ViewBuilder
  private func icon() -> some View {
    HStack(spacing: 6) {
      ForEach(icons, id: \.id) { icon in
        Button {
          selectedIcon(icon)
        } label: {
          
          ZStack {
            icon.icon
              .renderingMode(.template)
              .resizable()
              .foregroundStyle(icon.tintColor)
              .frame(width: 20, height: 20)
              .padding(.horizontal, 2)
          }
          
        }
        .buttonStyle(NoTapAnimationButtonStyle())
        
        if icon.id != icons.last?.id {
          Color.neutral200.frame(width: 1, height: 14)
        }
      }
    }
  }
}


#Preview {
  
  VStack {
    
    SDGIconHeader(
      type: .box,
      title: .init(title: "Title", count: 1, isShowDropdownIcon: true),
      icons: [.init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400)],
      selectedIcon: { _ in }
    )
    
    SDGIconHeader(
      type: .box,
      title: .init(title: "Title", count: 1, isShowDropdownIcon: true),
      icons: [
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400),
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400)
      ],
      selectedIcon: { _ in }
    )
    
    SDGIconHeader(
      type: .box,
      title: .init(title: "Title", count: 1, isShowDropdownIcon: true),
      icons: [
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400),
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400),
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400)
      ],
      selectedIcon: { _ in }
    )
    
    SDGIconHeader(
      type: .normal,
      title: .init(title: "Title", count: 1, isShowDropdownIcon: true),
      icons: [.init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400)],
      selectedIcon: { _ in }
    )
    
    SDGIconHeader(
      type: .normal,
      title: .init(title: "Title", count: 1, isShowDropdownIcon: true),
      icons: [
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400),
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400)
      ],
      selectedIcon: { _ in }
    )
    
    SDGIconHeader(
      type: .normal,
      title: .init(title: "Title", count: 1, isShowDropdownIcon: true),
      icons: [
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400),
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400),
        .init(id: UUID().uuidString, icon: Image(.icClip), tintColor: .neutral400)
      ],
      selectedIcon: { _ in }
    )
  }
}
