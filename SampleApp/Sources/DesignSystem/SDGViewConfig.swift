//
//  SDGViewConfig.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/28/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

struct SDGViewConfig {
  static func configure() {
    let registry = SDGViewRegistry.shared
    
    registry.register(id: "foundation_color") { SDGColorDemoView() }
    registry.register(id: "foundation_typo") { SDGTypographyDemoView() }

  }
}
