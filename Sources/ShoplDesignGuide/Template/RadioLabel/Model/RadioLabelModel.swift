//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/25/25.
//

import Foundation

public struct RadioLabelModel: Equatable, Hashable {
  public let id: String
  public let isSelected: Bool
  public let isLabelColorPrimary: Bool
  public let isSelectedColorNeturel: Bool
  public let isDisabled: Bool
  public let title: String
  
  public init(
    id: String,
    isSelected: Bool,
    isLabelColorPrimary: Bool = false,
    isSelectedColorNeturel: Bool = false,
    isDisabled: Bool = false,
    title: String
  ) {
    self.id = id
    self.isSelected = isSelected
    self.isLabelColorPrimary = isLabelColorPrimary
    self.isSelectedColorNeturel = isSelectedColorNeturel
    self.isDisabled = isDisabled
    self.title = title
  }
}
