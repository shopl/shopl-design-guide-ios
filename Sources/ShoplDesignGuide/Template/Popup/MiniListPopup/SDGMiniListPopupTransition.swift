//
//  SDGMiniListPopupTransition.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/30/26.
//

import UIKit

@MainActor
enum SDGMiniListPopupTransition {
  /// 입력 컨테이너가 페이드되지 않도록 view에는 메뉴의 시각 영역만 전달한다.
  static func fade(
    _ view: UIView,
    isPresenting: Bool,
    completion: @escaping () -> Void
  ) {
    UIView.animate(
      withDuration: 0.15,
      delay: 0,
      options: [.curveEaseInOut, .allowUserInteraction],
      animations: { view.alpha = isPresenting ? 1 : 0 },
      completion: { _ in completion() }
    )
  }
}
