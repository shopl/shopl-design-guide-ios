//
//  TopNaviButtonOption.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/14/25.
//

import SwiftUI

public struct TopNaviButtonOption: Identifiable {
  
  public let id: String
  public let image: Image
  public let tintColor: Color
  public let isBullet: Bool
  public let isEnable: Bool
  public let touchUpInside: (() -> ())?
  
  public init(
    image: Image,
    tintColor: Color,
    isBullet: Bool = false,
    isEnable: Bool = true,
    touchUpInside: (() -> ())? = nil
  ) {
    self.id = UUID().uuidString
    self.image = image
    self.tintColor = tintColor
    self.isBullet = isBullet
    self.isEnable = isEnable
    self.touchUpInside = touchUpInside
  }
}
