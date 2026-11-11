import SwiftUI

extension SDGTextNavi {
  /// Figma Text Navi의 표시 설정과 콘텐츠를 묶습니다.
  /// 표시 Bool을 꺼도 label과 actionIc 값은 유지되며, 다시 켜면 같은 값을 표시합니다.
  public struct Model {
    /// Figma `Show Label`: 타이틀 노출 여부입니다.
    public var showLabel: Bool
    /// Figma `Label`: 타이틀 문구입니다.
    public var label: String
    /// Figma `Show Action ic`: 우측 아이콘 노출 여부입니다.
    public var showActionIc: Bool
    /// Figma `Action Label`: 항상 노출하는 우측 액션 문구입니다.
    public var actionLabel: String
    /// 우측 20×20pt 아이콘입니다. nil이면 showActionIc가 true여도 아이콘을 그리지 않습니다.
    public var actionIc: Image?
    /// Figma `Back ic`: 40×40pt 영역의 뒤로가기 아이콘입니다.
    public var backIc: Image
    /// 타이틀 색상입니다.
    public var labelColor: Color
    /// 우측 아이콘과 액션 문구 색상입니다.
    public var actionColor: Color
    /// 뒤로가기 아이콘 색상입니다.
    public var backColor: Color
    /// 내비게이션 배경색입니다. .clear로 배경만 숨길 수 있습니다.
    public var backgroundColor: Color

    /// - Parameters:
    ///   - showLabel: 타이틀 표시 여부. false여도 label 데이터는 보존합니다.
    ///   - label: 한 줄 타이틀. 가용 폭을 넘으면 끝을 말줄임합니다.
    ///   - showActionIc: 액션 아이콘 표시 여부. false여도 actionIc 데이터는 보존합니다.
    ///   - actionLabel: 항상 표시할 액션 문구. 타이틀보다 우선 표시하되 폭을 넘으면 말줄임합니다.
    ///   - actionIc: 표시할 액션 아이콘. nil이면 아이콘을 생략합니다.
    ///   - backIc: 뒤로가기 아이콘. 기본값은 SDG iOS 뒤로가기 아이콘입니다.
    ///   - labelColor: 타이틀 색상. 기본값은 Neutral/900입니다.
    ///   - actionColor: 액션 색상. 기본값은 Neutral/700입니다.
    ///   - backColor: 뒤로가기 색상. 기본값은 Neutral/700입니다.
    ///   - backgroundColor: 배경색. 기본값은 Neutral/100이며 투명색도 허용합니다.
    public init(
      showLabel: Bool,
      label: String,
      showActionIc: Bool,
      actionLabel: String,
      actionIc: Image? = nil,
      backIc: Image = Image(sdg: .icNaviBack),
      labelColor: Color = .neutral900,
      actionColor: Color = .neutral700,
      backColor: Color = .neutral700,
      backgroundColor: Color = .neutral100
    ) {
      self.showLabel = showLabel
      self.label = label
      self.showActionIc = showActionIc
      self.actionLabel = actionLabel
      self.actionIc = actionIc
      self.backIc = backIc
      self.labelColor = labelColor
      self.actionColor = actionColor
      self.backColor = backColor
      self.backgroundColor = backgroundColor
    }
  }
}
