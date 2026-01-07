//
//  DSViewRegistry.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/28/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

typealias ViewBuilderBlock = () -> AnyView

final class DSViewRegistry {
  static let shared = DSViewRegistry()
  private var builders: [String: ViewBuilderBlock] = [:]
  
  func register<V: View>(id: String, view: @escaping () -> V) {
    builders[id] = { AnyView(view()) }
  }
  
  func build(id: String) -> AnyView {
    guard let builder = builders[id] else {
      return AnyView(
        Text("연결된 뷰 없음: \(id)")
          .foregroundStyle(.red)
          .padding()
      )
    }
    return builder()
  }
}
