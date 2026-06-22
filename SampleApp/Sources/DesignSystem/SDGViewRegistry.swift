//
//  SDGViewRegistry.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/28/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

typealias ViewBuilderBlock = () -> AnyView

final class SDGViewRegistry {
  static let shared = SDGViewRegistry()
  private var builders: [String: ViewBuilderBlock] = [:]
  
  func register<V: View>(id: String, view: @escaping () -> V) {
    builders[id] = { AnyView(view()) }
  }
  
  func contains(id: String) -> Bool {
    builders[id] != nil
  }
  
  func build(id: String) -> AnyView {
    guard let builder = builders[id] else {
      return AnyView(
        Text(sdg: "연결된 뷰 없음: \(id)")
          .foregroundStyle(.red)
          .padding()
      )
    }
    return builder()
  }
}
