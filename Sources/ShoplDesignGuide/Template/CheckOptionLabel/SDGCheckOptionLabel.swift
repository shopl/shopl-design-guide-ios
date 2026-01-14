//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/19/25.
//

import SwiftUI

public struct CheckOptionLabel: View {
  
  @Binding private var _model: CheckOptionLabelModel
  
  private var _action: (String) -> Void
  
  private var _status: SDGCheckOptionStatus {
    if _model.isDisabled {
      return .disabled
    } else if _model.isSelected {
      return .selected
    } else {
      return .default
    }
  }
  
  private var _statusBinding: Binding<SDGCheckOptionStatus> {
    Binding(
      get: { _status },
      set: { _ in }
    )
  }
  
  private var _selectedImageColor: Color {
    if _model.isSelected {
      return _model.isSelectedImageColorPrimary ? .primary300 : .neutral700
    }
    
    return .neutral200
  }
  
  private var _labelColor: TypoColor {
    if _model.isDisabled {
      return .neutral300
    }
    
    if _model.isSelected {
      return _model.isSelectedTitleColorPrimary ? .primary300 : .neutral700
    }
    
    return .neutral700
  }
  
  public init(
    model: Binding<CheckOptionLabelModel>,
    action: @escaping (String) -> Void
  ) {
    self.__model = model
    self._action = action
  }
  
  public var body: some View {
    Button {
      _action(_model.id)
    } label: {
      ZStack(alignment: .topLeading) {
        SDGCheckOption(
          state: _statusBinding,
          type: .solid,
          selected: { }
        )
        .padding(.vertical, 1.5)
      
        Text(_model.title)
          .typo(
            _model.size == .small ? .body2_R : .body1_R,
            _labelColor
          )
          .lineLimit(_model.lineLimit)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 24)
      }
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .disabled(_model.isDisabled)
  }
}

struct SDGCheckOptionLabel_Wrapper: View {
  @State var items: [CheckOptionLabelModel] = [
    CheckOptionLabelModel(
      id: "simple1",
      size: .small,
      title: "Simple Item 1",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      isSelected: false,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple2",
      size: .small,
      title: "Simple Item 2",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      isSelected: true,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple3",
      size: .small,
      title: "Simple Item 3",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      isSelected: false,
      isDisabled: true
    ),
    
    CheckOptionLabelModel(
      id: "simple4",
      size: .medium,
      title: "Simple Item 4",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      isSelected: false,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple5",
      size: .medium,
      title: "Simple Item 5",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      isSelected: true,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: true,
      isSelectedImageColorPrimary: true,
      isSelected: false,
      isDisabled: true
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: true,
      isSelected: false,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: true,
      isSelected: true,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: true,
      isSelected: false,
      isDisabled: true
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: false,
      isSelected: false,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: false,
      isSelected: true,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "Simple Item 6",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: false,
      isSelected: false,
      isDisabled: true
    ),
    CheckOptionLabelModel(
      id: "simple6",
      size: .medium,
      title: "타이틀이 길어질 경우 두줄로 나타나게 된다. 타이틀이 길어질 경우 두줄로 나타나게 된다. 타이틀이 길어질 경우 두줄로 나타나게 된다.",
      isSelectedTitleColorPrimary: false,
      isSelectedImageColorPrimary: false,
      lineLimit: nil,
      isSelected: true,
      isDisabled: false
    ),
  ]
    
  var body: some View {
    List {
      ForEach(items.indices, id: \.self) { index in
        CheckOptionLabel(model: $items[index], action: { _ in })
      }
    }
  }
}


struct SDGCheckOptionLabel_Previews: PreviewProvider {
  static var previews: some View {
    SDGCheckOptionLabel_Wrapper()
  }
}
