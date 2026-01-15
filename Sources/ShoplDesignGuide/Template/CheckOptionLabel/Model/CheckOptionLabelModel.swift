//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/19/25.
//

import Foundation

public struct CheckOptionLabelModel: Equatable, Identifiable {
  
  public enum Size: Equatable {
    case small
    case medium
  }
  
  public let id: String
  public let size: Size
  public let title: String
  public var isSelectedTitleColorPrimary: Bool
  public var isSelectedImageColorPrimary: Bool
  public var lineLimit: Int?
  public let status: SDGCheckOptionStatus
  
  public init(
    id: String,
    size: Size,
    title: String,
    isSelectedTitleColorPrimary: Bool = true,
    isSelectedImageColorPrimary: Bool = true,
    lineLimit: Int? = nil,
    status: SDGCheckOptionStatus
  ) {
    self.id = id
    self.size = size
    self.title = title
    self.isSelectedTitleColorPrimary = isSelectedTitleColorPrimary
    self.isSelectedImageColorPrimary = isSelectedImageColorPrimary
    self.lineLimit = lineLimit
    self.status = status
  }
}
