//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/25/25.
//

import SwiftUI

public struct SDGRadioLabel: View {
  
  public var model: RadioLabelModel
  
  private var textColor: TypoColor {
    if model.isDisabled { return .neutral200 }
    if model.isLabelColorPrimary { return .primary300 }
    return .neutral700
  }
  
  private var selectedColor: Color {
    if model.isSelectedColorNeturel {
      return .neutral700
    }
    
    return .primary300
  }
  
  private var onTap: (String) -> Void
  
  public init(
    model: RadioLabelModel,
    onTap: @escaping (String) -> Void
  ) {
    self.model = model
    self.onTap = onTap
  }
  
  public var body: some View {
    Button {
      
      onTap(model.id)
      
    } label : {
      HStack(alignment: .top, spacing: 8) {
        ZStack {
          Color.neutral0
            .frame(width: 8, height: 8)
            .cornerRadius(4)
            .padding(4)
        }
        .background(model.isSelected ? selectedColor : .neutral200)
        .cornerRadius(8)
        .padding(.top, 1)
        
        Text(model.title)
          .typo(.body1_R, textColor)
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
}

#Preview {
  VStack {
    SDGRadioLabel(
      model: RadioLabelModel(
        id: UUID().uuidString,
        isSelected: false,
        isLabelColorPrimary: false,
        isSelectedColorNeturel: false,
        isDisabled: false,
        title: "타이틀"
      ),
      onTap: { _ in }
    )
    
    SDGRadioLabel(
      model: RadioLabelModel(
        id: UUID().uuidString,
        isSelected: false,
        isLabelColorPrimary: false,
        isSelectedColorNeturel: false,
        isDisabled: true,
        title: "타이틀"
      ),
      onTap: { _ in }
    )
    
    SDGRadioLabel(
      model: RadioLabelModel(
        id: UUID().uuidString,
        isSelected: true,
        isLabelColorPrimary: true,
        isSelectedColorNeturel: false,
        isDisabled: false,
        title: "타이틀"
      ),
      onTap: { _ in }
    )
    
    SDGRadioLabel(
      model: RadioLabelModel(
        id: UUID().uuidString,
        isSelected: true,
        isLabelColorPrimary: false,
        isSelectedColorNeturel: true,
        isDisabled: false,
        title: "타이틀"
      ),
      onTap: { _ in }
    )
    
    SDGRadioLabel(
      model: RadioLabelModel(
        id: UUID().uuidString,
        isSelected: false,
        isLabelColorPrimary: false,
        isSelectedColorNeturel: false,
        isDisabled: false,
        title: "타이틀 명이 길다타이틀 명이 길다타이틀 명이 길다타이틀 명이 길다타이틀 명이 길다타이틀 명이 길다타이틀 명이 길다타이틀 명이 길다"
      ),
      onTap: { _ in }
    )
  }
  .padding(20)
}
