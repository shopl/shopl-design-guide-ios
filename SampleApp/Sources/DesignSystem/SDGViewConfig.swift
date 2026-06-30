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
    registry.register(id: "foundation_iconography") { SDGIconographyDemoView() }
    registry.register(id: "foundation_spacing") { SDGSpacingDemoView() }
    registry.register(id: "foundation_typo") { SDGTypographyDemoView() }
    registry.register(id: "component_attachment_element") { SDGAttachmentElementDemoView() }
    registry.register(id: "component_avatar") { SDGAvatarDemoView() }
    registry.register(id: "component_bottom_button") { SDGBottomButtonDemoView() }
    registry.register(id: "component_box_button") { SDGBoxButtonDemoView() }
    registry.register(id: "component_capsule_button") { SDGCapsuleButtonDemoView() }
    registry.register(id: "component_checkbox") { SDGCheckBoxDemoView() }
    registry.register(id: "component_floating_button") { SDGFloatingButtonDemoView() }
    registry.register(id: "component_ghost_button") { SDGGhostButtonDemoView() }
    
    let bottomSheetControlRegistry = SDGBottomSheetControlRegistry.shared
    bottomSheetControlRegistry.register(id: "component_avatar") {
      SDGAvatarBottomSheetControls()
    }
    bottomSheetControlRegistry.register(id: "component_attachment_element") {
      SDGAttachmentElementBottomSheetControls()
    }
    bottomSheetControlRegistry.register(id: "component_bottom_button") {
      SDGBottomButtonBottomSheetControls()
    }
    bottomSheetControlRegistry.register(id: "component_box_button") {
      SDGBoxButtonBottomSheetControls()
    }
    bottomSheetControlRegistry.register(id: "component_capsule_button") {
      SDGCapsuleButtonBottomSheetControls()
    }
    bottomSheetControlRegistry.register(id: "component_ghost_button") {
      SDGGhostButtonBottomSheetControls()
    }

  }
}
