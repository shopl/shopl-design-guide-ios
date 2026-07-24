//
//  SDGBottomSheetControlRegistry.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI

typealias BottomSheetControlBuilder = () -> AnyView

final class SDGBottomSheetControlRegistry {
  static let shared = SDGBottomSheetControlRegistry()
  
  private var builders: [String: BottomSheetControlBuilder] = [:]
  
  func register<V: View>(id: String, view: @escaping () -> V) {
    builders[id] = { AnyView(view()) }
  }
  
  func contains(id: String) -> Bool {
    builders[id] != nil
  }
  
  func build(id: String) -> AnyView? {
    builders[id]?()
  }
}
