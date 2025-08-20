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
      HStack(spacing: 8) {
        ZStack {
          Image(.icCommonCheckS)
            .resizable()
            .frame(width: 12, height: 12)
            .foregroundStyle(.neutral0)
            .padding(1)
        }
        .background(_selectedImageColor)
        .cornerRadius(8)
        
        Text(_model.title)
          .typo(
            _model.size == .small ? .body2_R : .body1_R,
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

struct SDGCheckOptionLabel_Wrapper: View {
  @State var items: [CheckOptionLabelModel] = [
    CheckOptionLabelModel(
      id: "simple1",
      labelColorOption: .option1,
      size: .small,
      title: "Simple Item 1",
      isSelected: false,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple2",
      labelColorOption: .option1,
      size: .small,
      title: "Simple Item 2",
      isSelected: true,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple3",
      labelColorOption: .option1,
      size: .small,
      title: "Simple Item 3",
      isSelected: false,
      isDisabled: true
    ),
    
    CheckOptionLabelModel(
      id: "simple4",
      labelColorOption: .option1,
      size: .medium,
      title: "Simple Item 4",
      isSelected: false,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple5",
      labelColorOption: .option1,
      size: .medium,
      title: "Simple Item 5",
      isSelected: true,
      isDisabled: false
    ),
    CheckOptionLabelModel(
      id: "simple6",
      labelColorOption: .option1,
      size: .medium,
      title: "Simple Item 6",
      isSelected: false,
      isDisabled: true
    )
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
