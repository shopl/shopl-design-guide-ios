//
//  SDGButtonHeader.swift
//  SDGSampleApp
//
//  Created by jerry on 1/12/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

public struct SDGButtonHeader: View {

  public enum `Type`: Equatable {
    case box, capsule
  }

  public struct ButtonModel {
    
    public let icon: SDGButtonOptionIcon?
    public let title: String
    public let color: SDGButtonColor
    public let selectedColor: SDGButtonColor
    public let isSelected: Binding<Bool>
    public let isLoading: Binding<Bool>
    public let action: () -> Void
    
    public init(
      icon: SDGButtonOptionIcon? = nil,
      title: String,
      color: SDGButtonColor,
      selectedColor: SDGButtonColor,
      isSelected: Binding<Bool>,
      isLoading: Binding<Bool>,
      action: @escaping () -> Void
    ) {
      self.icon = icon
      self.title = title
      self.color = color
      self.selectedColor = selectedColor
      self.isSelected = isSelected
      self.isLoading = isLoading
      self.action = action
    }
  }

  public let type: `Type`
  public let title: SDGListHeaderLabel.Model
  public let buttonModel: ButtonModel

  public init(
    type: `Type`,
    title: SDGListHeaderLabel.Model,
    buttonModel: ButtonModel,
  ) {
    self.type = type
    self.title = title
    self.buttonModel = buttonModel
  }

  public var body: some View {

    HStack(spacing: 12) {

      SDGListHeaderLabel(
        model: title
      )

      Spacer(minLength: 0)

      switch type {
      case .capsule:
        SDGCapsuleButton(
          option: .init(
            size: .xsmall,
            icon: self.buttonModel.icon,
            title: self.buttonModel.title,
            color: self.buttonModel.color,
            selectedColor: self.buttonModel.selectedColor
          ),
          isSelected: self.buttonModel.isSelected,
          isLoading: self.buttonModel.isLoading,
          action: self.buttonModel.action
        )

      case .box:
        SDGBoxButton(
          option: .init(
            size: .xsmall,
            icon: self.buttonModel.icon,
            title: self.buttonModel.title,
            color: self.buttonModel.color,
            selectedColor: self.buttonModel.selectedColor
          ),
          isSelected: self.buttonModel.isSelected,
          isLoading: self.buttonModel.isLoading,
          action: self.buttonModel.action
        )
        
      }

    }
    .padding(.horizontal, 4)

  }

}

#Preview {
  VStack {
    SDGButtonHeader(
      type: .box,
      title: .init(title: "title", count: 9999, isShowDropdownIcon: true),
      buttonModel: SDGButtonHeader.ButtonModel(
        icon: .right(image: Image(.icClip), color: .neutral0),
        title: "Button",
        color: SDGButtonColor(backgroundColor: .neutral400, textColor: .neutral0),
        selectedColor: SDGButtonColor(backgroundColor: .neutral400, textColor: .neutral0),
        isSelected: .constant(false),
        isLoading: .constant(false),
        action: { }
      )
    )
    
    SDGButtonHeader(
      type: .capsule,
      title: .init(title: "title", count: 9999, isShowDropdownIcon: true),
      buttonModel: SDGButtonHeader.ButtonModel(
        icon: .right(image: Image(.icClip), color: .neutral0),
        title: "Button",
        color: SDGButtonColor(backgroundColor: .neutral400, textColor: .neutral0),
        selectedColor: SDGButtonColor(backgroundColor: .neutral400, textColor: .neutral0),
        isSelected: .constant(false),
        isLoading: .constant(false),
        action: { }
      )
    )
  }
}
