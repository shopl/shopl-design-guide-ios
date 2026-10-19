//
//  SDGScrollTabDemoControlState.swift
//  ShoplDesignGuide
//
//  Created by dino on 10/2/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGScrollTabDemoControlState: ObservableObject {
  static let shared = SDGScrollTabDemoControlState()

  @Published var isLongTextEnabled = false

  private init() { }

  var items: [SDGScrollTab.Item] {
    (0..<5).map { index in
      .init(
        id: String(index),
        title: isLongTextEnabled && index == 0
          ? "가슴속에 못 시인의 나의 별이 봅니다."
          : "Label"
      )
    }
  }
}
