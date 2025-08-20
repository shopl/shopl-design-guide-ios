//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/19/25.
//

import Foundation

public struct CheckOptionLabelModel: Equatable, Identifiable {
  public enum LabelColorOption: Equatable {
    case option1
    case option2
  }
  
  public enum Size: Equatable {
    case small
    case medium
  }
  
  public let id: String
  public let labelColorOption: LabelColorOption
  public let size: Size
  public let title: String
  public var isSelectedColorPrimary: Bool
  public var lineLimit: Int
  public var isSelected: Bool
  public var isDisabled: Bool
  
  public init(
    id: String,
    labelColorOption: LabelColorOption,
    size: Size,
    title: String,
    isSelectedColorPrimary: Bool = true,
    lineLimit: Int = 1,
    isSelected: Bool,
    isDisabled: Bool = false
  ) {
    self.id = id
    self.labelColorOption = labelColorOption
    self.size = size
    self.title = title
    self.isSelectedColorPrimary = isSelectedColorPrimary
    self.lineLimit = lineLimit
    self.isSelected = isSelected
    self.isDisabled = isDisabled
  }
}
