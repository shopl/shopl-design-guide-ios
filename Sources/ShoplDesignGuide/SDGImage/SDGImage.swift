//
//  SDGImage.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/29/25.
//

import SwiftUI

public struct SDGImage: @unchecked Sendable  {
  public let name: String
  let bundle: Bundle?
  
  init(name: String, bundle: Bundle? = nil) {
    self.name = name
    self.bundle = bundle ?? SDGImageBundle.imagesBundle
  }
}

public extension Image {
  init(_ resource: SDGImage) {
    self.init(resource.name, bundle: resource.bundle)
  }
}
