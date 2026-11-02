//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/19/25.
//

import SwiftUI

public struct CheckOptionLabel: View {
  
  private var model: CheckOptionLabelModel
  private var action: (String) -> Void
  
  private var _selectedImageColor: Color {
    if model.option.state == .selected {
      return model.isSelectedImageColorPrimary ? .primary300 : .neutral700
    }
    
    return .neutral200
  }
  
  private var _labelColor: SDG.Color {
    if model.option.state == .disabled {
      return .neutral300
    }
    
    if model.option.state == .selected {
      return model.isSelectedTitleColorPrimary ? .primary300 : .neutral700
    }
    
    return .neutral700
  }
  
  public init(
    model: CheckOptionLabelModel,
    action: @escaping (String) -> Void
  ) {
    self.model = model
    self.action = action
  }
  
  public var body: some View {
    Button {
      action(model.id)
    } label: {
      ZStack(alignment: .topLeading) {
        SDGCheckOption(
          model: model.option,
          selected: { }
        )
        .padding(.vertical, 1.5)
      
        Text(model.title)
          .typo(
            model.size == .small ? .body2_R : .body1_R,
            _labelColor
          )
          .lineLimit(model.lineLimit)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 24)
      }
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .disabled(model.option.state == .disabled)
  }
}

struct SDGCheckOptionLabel_Wrapper: View {
  var items: [CheckOptionLabelModel] = [
    CheckOptionLabelModel(
      id: "simple1",
      size: .small,
      title: "Simple Item 1",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      option: .init(state: .default, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple2",
      size: .small,
      title: "Simple Item 2",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      option: .init(state: .selected, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple3",
      size: .small,
      title: "Simple Item 3",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      option: .init(state: .disabled, style: .solid, spec: .medim, selectColor: .normal)
    ),
    
    CheckOptionLabelModel(
      id: "simple4",
      size: .medium,
      title: "Simple Item 4",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      option: .init(state: .default, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple5",
      size: .medium,
      title: "Simple Item 5",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      option: .init(state: .selected, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      option: .init(state: .disabled, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: true,
      option: .init(state: .default, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: true,
      option: .init(state: .selected, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: true,
      option: .init(state: .disabled, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: false,
      option: .init(state: .default, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: false,
      option: .init(state: .selected, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: false,
      option: .init(state: .disabled, style: .solid, spec: .medim, selectColor: .normal)
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "타이틀이 길어질 경우 두줄로 나타나게 된다. 타이틀이 길어질 경우 두줄로 나타나게 된다. 타이틀이 길어질 경우 두줄로 나타나게 된다.",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: false,
      lineLimit: nil,
      option: .init(state: .selected, style: .solid, spec: .medim, selectColor: .normal)
    ),
  ]
    
  var body: some View {
    List {
      ForEach(items.indices, id: \.self) { index in
        CheckOptionLabel(
          model: items[index], action: { _ in }
        )
      }
    }
  }
}


struct SDGCheckOptionLabel_Previews: PreviewProvider {
  static var previews: some View {
    SDGCheckOptionLabel_Wrapper()
  }
}
