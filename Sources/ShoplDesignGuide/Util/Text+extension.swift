//
//  Text+extension.swift
//  ShoplDesignGuide
//
//  Created by jerry on 6/16/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI
import UIKit

public extension Text {
  init(sdg content: String) {
    
    let hangul = content.split(separator: " ", omittingEmptySubsequences: false)
      .map { $0.map(String.init).joined(separator: "\u{2060}") }
      .joined(separator: " ")
    
    self.init(hangul)
  }
}
