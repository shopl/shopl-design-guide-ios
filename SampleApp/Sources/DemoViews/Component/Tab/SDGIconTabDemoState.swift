//
//  SDGIconTabDemoState.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/18/26.
//

import SwiftUI
import ShoplDesignGuide

final class SDGIconTabDemoState: ObservableObject {
  static let shared = SDGIconTabDemoState()

  let optionTitles = ["3", "4", "5"]

  @Published var selectedOptionIndex = 0 {
    didSet { selectedIndex = 0 }
  }
  @Published var selectedIndex = 0
  @Published var isLongTextEnabled = false

  private init() { }

  var option: SDGIconTab.Option {
    switch selectedOptionIndex {
    case 1:
      return .four(item(0), item(1), item(2), item(3))
    case 2:
      return .five(item(0), item(1), item(2), item(3), item(4))
    default:
      return .three(item(0), item(1), item(2))
    }
  }

  func tabClicked(_ index: Int) {
    selectedIndex = index
  }

  private func item(_ index: Int) -> SDGIconTab.Item {
    .init(
      id: String(index),
      icon: Image(sdg: .icClip),
      tintColor: .neutral500,
      title: isLongTextEnabled
        ? "긴 제목은 최대 두 줄까지 표시하고 나머지는 말줄임으로 처리합니다"
        : "Label",
      count: 5
    )
  }
}
