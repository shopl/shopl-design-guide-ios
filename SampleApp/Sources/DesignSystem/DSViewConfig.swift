//
//  DSViewConfig.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/28/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

struct DSViewConfig {
  static func configure() {
    let registry = DSViewRegistry.shared
    
    registry.register(id: "foundation_color") { SDGColorDemoView() }
    registry.register(id: "foundation_typo") { SDGTypographyDemoView() }

  }
}
