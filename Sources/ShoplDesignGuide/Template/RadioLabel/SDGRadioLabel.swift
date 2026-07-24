//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/25/25.
//

import SwiftUI

public struct SDGRadioLabel: View {
  
  public var model: RadioLabelModel
  
  private var radioStatus: SDGRadioStatus {
    if model.isDisabled { return .disabled }
    if model.isSelected { return .selected }
    return .default
  }
  
  private var radioModel: SDGRadio.Model {
    return SDGRadio.Model(
      status: radioStatus,
      spec: .large,
      isPrimaryColor: !model.isSelectedColorNeturel
    )
  }
  
  private var textColor: SDG.Color {
    if model.isDisabled { return .neutral200 }
    if model.isLabelColorPrimary { return .primary300 }
    return .neutral700
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
        SDGRadio(
          model: radioModel
        )
        .padding(.top, 1)
        
        Text(model.title)
          .typo(.body1_R, textColor)
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .disabled(model.isDisabled)
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
