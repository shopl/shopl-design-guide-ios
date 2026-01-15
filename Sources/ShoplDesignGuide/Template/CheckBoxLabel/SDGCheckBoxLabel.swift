//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import SwiftUI

public struct SDGCheckBoxLabel: View {

  public struct Model: Equatable {
    public let id: String
    public let box: SDGCheckBox.Model
    public let title: String
    public let isEmphasis: Bool = false
    public let lineLimit: Int?
    public let selectedTitleColor: SDG.Color
    
    public init(
      id: String,
      box: SDGCheckBox.Model,
      isEmphasis: Bool = false,
      title: String,
      lineLimit: Int? = nil,
      selectedTitleColor: SDG.Color = .primary300
    ) {
      self.id = id
      self.box = box
      self.title = title
      self.lineLimit = lineLimit
      self.selectedTitleColor = selectedTitleColor
    }
  }

  private var model: Model
  
  private var onSelect: (String) -> Void
  
  public init(
    model: Model,
    onSelect: @escaping (String) -> Void
  ) {
    self.model = model
    self.onSelect = onSelect
  }

  public var body: some View {
    Button {
      onSelect(model.id)
    } label: {
      HStack(spacing: 8) {
        SDGCheckBox(
          model: model.box,
        )

        Text(model.title)
          .typo(
            model.isEmphasis ? .body1_SB : .body1_R,
            model.box.status == .selected ? model.selectedTitleColor :
              model.box.status == .disabled ? .neutral300 : .neutral700
          )
          .lineLimit(model.lineLimit)
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .disabled(model.box.status == .disabled)
  }
}

struct SDGCheckBoxLabel_Wrapper: View {

  var body: some View {
    VStack {
      SDGCheckBoxLabel(
        model: SDGCheckBoxLabel.Model(
          id: UUID().uuidString,
          box: SDGCheckBox.Model(
            size: .medim,
            status: .default
          ),
          title: "옵션"
        ),
        onSelect: { _ in }
      )
      
      SDGCheckBoxLabel(
        model: SDGCheckBoxLabel.Model(
          id: UUID().uuidString,
          box: SDGCheckBox.Model(
            size: .medim,
            status: .selected
          ),
          title: "옵션"
        ),
        onSelect: { _ in }
      )
      
      SDGCheckBoxLabel(
        model: SDGCheckBoxLabel.Model(
          id: UUID().uuidString,
          box: SDGCheckBox.Model(
            size: .medim,
            status: .disabled
          ),
          title: "옵션"
        ),
        onSelect: { _ in }
      )
      
      SDGCheckBoxLabel(
        model: SDGCheckBoxLabel.Model(
          id: UUID().uuidString,
          box: SDGCheckBox.Model(
            size: .medim,
            status: .default
          ),
          isEmphasis: true,
          title: "옵션"
        ),
        onSelect: { _ in }
      )
      
      SDGCheckBoxLabel(
        model: SDGCheckBoxLabel.Model(
          id: UUID().uuidString,
          box: SDGCheckBox.Model(
            size: .medim,
            status: .selected
          ),
          isEmphasis: true,
          title: "옵션"
        ),
        onSelect: { _ in }
      )
      
      SDGCheckBoxLabel(
        model: SDGCheckBoxLabel.Model(
          id: UUID().uuidString,
          box: SDGCheckBox.Model(
            size: .medim,
            status: .disabled
          ),
          isEmphasis: true,
          title: "옵션"
        ),
        onSelect: { _ in }
      )
    }
  }
}


struct SDGCheckBoxLabel_Previews: PreviewProvider {
  static var previews: some View {
    SDGCheckBoxLabel_Wrapper()
  }
}
