//
//  CheckBoxLabelModel.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/20/25.
//

import Foundation

public struct CheckBoxLabelModel: Equatable, Identifiable {
  public enum LabelColorOption: Equatable {
    case neutral
    case primary
  }

  public enum `Type`: Equatable {
    case normal
    case empha
  }

  public let id: String
  public let labelColorOption: LabelColorOption
  public let type: `Type`
  public let title: String
  public var isSelectedColorPrimary: Bool
  public var lineLimit: Int
  public var isSelected: Bool
  public var isDisabled: Bool

  public init(
    id: String,
    labelColorOption: LabelColorOption,
    type: `Type`,
    title: String,
    isSelectedColorPrimary: Bool = true,
    lineLimit: Int = 1,
    isSelected: Bool,
    isDisabled: Bool = false
  ) {
    self.id = id
    self.labelColorOption = labelColorOption
    self.type = type
    self.title = title
    self.isSelectedColorPrimary = isSelectedColorPrimary
    self.lineLimit = lineLimit
    self.isSelected = isSelected
    self.isDisabled = isDisabled
  }
}
