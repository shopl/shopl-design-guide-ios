//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

public struct SDGCheckBoxLabel: View {

  @Binding private var _model: CheckBoxLabelModel

  private var _action: (String) -> Void

  private enum Status {
    case `default`
    case selected
    case disabled
  }

  private var _status: Status {
    if _model.isDisabled {
      return .disabled
    } else if _model.isSelected {
      return .selected
    } else {
      return .default
    }
  }

  private var _selectedImageColor: Color {
    if _model.isSelected {
      return _model.isSelectedColorPrimary ? .primary300 : .neutral700
    }

    return .neutral200
  }

  private var _labelColor: TypoColor {
    if _model.isDisabled {
      return .neutral300
    }

    switch _model.labelColorOption {
    case .option1:
      return .neutral700

    case .option2:
      return _model.isSelected ? .primary300 : .neutral400
    }
  }

  public init(
    model: Binding<CheckBoxLabelModel>,
    action: @escaping (String) -> Void
  ) {
    self.__model = model
    self._action = action
  }

  public var body: some View {
    Button {
      _action(_model.id)
    } label: {
      HStack(spacing: 8) {
        SDGCheckBox(
          isSelected: _model.isSelected
        )

        Text(_model.title)
          .typo(
            _model.type == .normal ? .body1_R : .body1_SB,
            _labelColor
          )
          .lineLimit(_model.lineLimit)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .disabled(_model.isDisabled)
  }
}

struct SDGCheckBoxLabel_Wrapper: View {
  @State var items: [CheckBoxLabelModel] = [
    CheckBoxLabelModel(
      id: "simple1",
      labelColorOption: .option1,
      type: .normal,
      title: "Simple Item 1",
      isSelected: false,
      isDisabled: false
    ),
    CheckBoxLabelModel(
      id: "simple2",
      labelColorOption: .option1,
      type: .normal,
      title: "Simple Item 2",
      isSelected: true,
      isDisabled: false
    ),
    CheckBoxLabelModel(
      id: "simple3",
      labelColorOption: .option1,
      type: .normal,
      title: "Simple Item 3",
      isSelected: false,
      isDisabled: true
    ),

    CheckBoxLabelModel(
      id: "simple4",
      labelColorOption: .option1,
      type: .empha,
      title: "Simple Item 4",
      isSelected: false,
      isDisabled: false
    ),
    CheckBoxLabelModel(
      id: "simple5",
      labelColorOption: .option1,
      type: .empha,
      title: "Simple Item 5",
      isSelected: true,
      isDisabled: false
    ),
    CheckBoxLabelModel(
      id: "simple6",
      labelColorOption: .option1,
      type: .empha,
      title: "Simple Item 6",
      isSelected: false,
      isDisabled: true
    )
  ]

  var body: some View {
    List {
      ForEach(items.indices, id: \.self) { index in
        SDGCheckBoxLabel(model: $items[index], action: { _ in })
      }
    }
  }
}


struct SDGCheckBoxLabel_Previews: PreviewProvider {
  static var previews: some View {
    SDGCheckBoxLabel_Wrapper()
  }
}
