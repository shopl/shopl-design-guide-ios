//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

public struct FormIconModel {
  public let image: Image
  public let tintColor: Color
  public let onImageTap: (() -> Void)?
  
  public init(
    image: Image,
    tintColor: Color,
    onImageTap: (() -> Void)? = nil
  ) {
    self.image = image
    self.tintColor = tintColor
    self.onImageTap = onImageTap
  }
}
