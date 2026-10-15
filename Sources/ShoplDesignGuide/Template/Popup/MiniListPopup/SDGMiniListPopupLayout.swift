//
//  SDGMiniListPopupLayout.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/30/26.
//

import UIKit

enum SDGMiniListPopupLayout {
  /// anchor와 container는 오버레이 좌표다. 한 행도 배치할 수 없으면 nil을 반환한다.
  /// Safe Area에 호출부의 경계 여백을 더해 사용 영역을 정한다.
  static func frame(
    anchor: CGRect,
    container: CGRect,
    safeAreaInsets: UIEdgeInsets,
    contentSize: CGSize,
    options: SDGMiniListPopup.PresentationOptions
  ) -> CGRect? {
    let insets = UIEdgeInsets(
      top: safeAreaInsets.top + options.screenInsets.top,
      left: safeAreaInsets.left + options.screenInsets.left,
      bottom: safeAreaInsets.bottom + options.screenInsets.bottom,
      right: safeAreaInsets.right + options.screenInsets.right
    )
    // 여백이 화면보다 클 때 inset으로 뒤집힌 영역이 생기지 않도록 먼저 크기를 확인한다.
    guard !anchor.isEmpty, contentSize.width > 0,
      contentSize.height >= SDGMiniListPopupStyle.rowHeight,
      container.width - insets.left - insets.right >= contentSize.width,
      container.height - insets.top - insets.bottom >= SDGMiniListPopupStyle.rowHeight
    else { return nil }
    let available = container.inset(by: insets)

    let aboveEnd = min(anchor.minY - options.sourceSpacing, available.maxY)
    let belowStart = max(anchor.maxY + options.sourceSpacing, available.minY)
    let above = max(0, aboveEnd - available.minY)
    let below = max(0, available.maxY - belowStart)
    // 더 넓은 쪽(같으면 아래)에 놓고, 높이를 넘는 행은 메뉴 내부에서 스크롤한다.
    let usesBelow = below >= above
    let height = min(contentSize.height, usesBelow ? below : above)
    guard height >= SDGMiniListPopupStyle.rowHeight else { return nil }

    // 버튼 중앙에 맞추되 메뉴가 사용 영역의 좌우 경계를 넘지 않도록 보정한다.
    let x = min(
      max(anchor.midX - contentSize.width / 2, available.minX),
      available.maxX - contentSize.width
    )
    let y = usesBelow ? belowStart : aboveEnd - height
    return CGRect(x: x, y: y, width: contentSize.width, height: height)
  }

  /// 픽셀 미만의 좌표 흔들림을 제거해 불필요한 재배치를 줄인다.
  static func normalized(_ rect: CGRect, scale: CGFloat) -> CGRect {
    let scale = max(1, scale)
    return CGRect(
      x: (rect.minX * scale).rounded() / scale,
      y: (rect.minY * scale).rounded() / scale,
      width: (rect.width * scale).rounded() / scale,
      height: (rect.height * scale).rounded() / scale
    )
  }
}
