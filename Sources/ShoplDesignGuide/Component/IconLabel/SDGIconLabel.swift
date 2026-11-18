//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

/// 14×14pt 아이콘과 텍스트를 조합해 정보를 간결하게 전달하는 Icon Label입니다.
///
/// 아이콘과 Label은 수평으로 상단 정렬하며, 아이콘 영역의 위아래 여백은 Label 첫 줄 높이에 맞춥니다.
/// 디자인 가이드에 따라 좌우 아이콘을 모두 표시하면 Text Mode와 관계없이 1줄 말줄임(Truncate)으로 표시합니다.
public struct SDGIconLabel: View {
  /// 적용한 Icon Label 디자인 가이드 버전입니다.
  public static let version = "2.3.57"

  /// Figma `Size`(Medium·Small·XSmall)와 `Font Weight`(Normal·Bold)에 대응합니다.
  ///
  /// `isBold`가 true이면 SB(Bold), false이면 R(Normal) 타이포그래피를 사용합니다.
  public enum Size: Equatable {
    case medium(isBold: Bool)
    case small(isBold: Bool)
    case xsmall(isBold: Bool)

    var typoSize: SDG.Typography {
      switch self {
      case let .medium(isBold): return isBold ? .body1_SB : .body1_R
      case let .small(isBold): return isBold ? .body2_SB : .body2_R
      case let .xsmall(isBold): return isBold ? .body3_SB : .body3_R
      }
    }

    /// 14pt 아이콘을 Label 첫 줄 높이(20·18·16pt)에 맞추는 위아래 여백입니다.
    var iconVerticalPadding: CGFloat {
      switch self {
      case .medium: return 3
      case .small: return 2
      case .xsmall: return 1
      }
    }

    public static func == (lhs: SDGIconLabel.Size, rhs: SDGIconLabel.Size) -> Bool {
      switch (lhs, rhs) {
      case (.medium(let lhsIsBold), .medium(let rhsIsBold)):
        return lhsIsBold == rhsIsBold
      case (.small(let lhsIsBold), .small(let rhsIsBold)):
        return lhsIsBold == rhsIsBold
      case (.xsmall(let lhsIsBold), .xsmall(let rhsIsBold)):
        return lhsIsBold == rhsIsBold
      default: return false
      }
    }
  }

  /// Figma `Gap`(2·4)에 대응하는 아이콘과 Label 사이 간격입니다. 가이드의 Spacing2·Spacing4입니다.
  public enum Spacing: CGFloat, Equatable {
    case two = 2
    case four = 4
  }

  /// Figma `Text Mode`에 대응하며, Label이 가용 너비를 초과할 때의 처리 방식입니다.
  public enum TextMode: Equatable {
    /// 여러 줄로 줄바꿈하여 전체를 노출합니다. 기본값입니다.
    case wrap
    /// 1줄로 표시하고 넘치는 부분은 말줄임(...) 처리합니다.
    case truncate

    fileprivate var lineLimit: Int? {
      switch self {
      case .wrap: return nil
      case .truncate: return 1
      }
    }
  }

  private static let iconSize: CGFloat = 14

  private let size: Size
  private let spacing: Spacing
  private let leftImage: Image?
  private let rightImage: Image?
  private let title: String
  private let imageForegroundColor: Color
  private let titleColor: SDG.Color
  private let lineLimit: Int?
  private let fullSize: Bool

  /// - Parameters:
  ///   - size: Figma `Size`·`Font Weight`에 대응하는 크기와 굵기입니다.
  ///   - spacing: Figma `Gap`에 대응하는 아이콘과 Label 사이 간격입니다. 기본값은 `.two`입니다.
  ///   - leftImage: Figma `Left ic`에 대응하는 왼쪽 아이콘입니다. nil이면 표시하지 않습니다. 14×14pt로 표시합니다.
  ///   - rightImage: Figma `Right ic`에 대응하는 오른쪽 아이콘입니다. nil이면 표시하지 않습니다. 14×14pt로 표시합니다.
  ///   - title: Figma `Label` 텍스트입니다.
  ///   - imageForegroundColor: 아이콘 색상입니다. nil(기본값)이면 `titleColor`와 같은 색상을 사용합니다.
  ///   - titleColor: Label 색상입니다. SDG 컬러 시스템의 모든 컬러를 사용할 수 있습니다.
  ///   - textMode: Figma `Text Mode`입니다. 기본값은 `.wrap`입니다.
  ///     `leftImage`와 `rightImage`를 모두 전달하면 이 값과 관계없이 `.truncate`로 표시합니다.
  ///   - fullSize: true이면 Label이 남은 가용 너비를 가득 채웁니다.
  ///     가이드에 따라 아이콘을 한쪽만 사용할 때 Label이 남은 너비를 채워야 하면 true로 전달합니다.
  ///
  /// 가이드상 아이콘을 하나도 사용하지 않는 구성은 이 컴포넌트의 사용 대상이 아닙니다.
  public init(
    size: Size,
    spacing: Spacing = .two,
    leftImage: Image? = nil,
    rightImage: Image? = nil,
    title: String,
    imageForegroundColor: Color? = nil,
    titleColor: SDG.Color,
    textMode: TextMode = .wrap,
    fullSize: Bool = false
  ) {
    self.size = size
    self.spacing = spacing
    self.leftImage = leftImage
    self.rightImage = rightImage
    self.title = title
    self.imageForegroundColor = imageForegroundColor ?? titleColor.color
    self.titleColor = titleColor
    self.lineLimit = textMode.lineLimit
    self.fullSize = fullSize
  }

  /// 기존 줄 수 지정 방식의 초기화 함수입니다. 디자인 가이드의 Text Mode에 맞춰 `textMode`를 사용하는 초기화 함수로 전환하세요.
  ///
  /// - Parameters:
  ///   - lineLimit: Label의 최대 줄 수입니다. nil이면 줄 수 제한 없이 줄바꿈합니다.
  ///     `leftImage`와 `rightImage`를 모두 전달하면 이 값과 관계없이 1줄 말줄임으로 표시합니다.
  ///
  /// 나머지 파라미터는 `textMode`를 사용하는 초기화 함수와 같습니다.
  @available(*, deprecated, message: "lineLimit 대신 Figma Text Mode에 대응하는 textMode(.wrap/.truncate)를 사용하세요.")
  public init(
    size: Size,
    spacing: Spacing = .two,
    leftImage: Image? = nil,
    rightImage: Image? = nil,
    title: String,
    imageForegroundColor: Color,
    titleColor: SDG.Color,
    lineLimit: Int?,
    fullSize: Bool = false
  ) {
    self.size = size
    self.spacing = spacing
    self.leftImage = leftImage
    self.rightImage = rightImage
    self.title = title
    self.imageForegroundColor = imageForegroundColor
    self.titleColor = titleColor
    self.lineLimit = lineLimit
    self.fullSize = fullSize
  }

  /// 가이드: 아이콘을 둘 다 노출할 경우 Text Mode는 Truncate를 사용합니다.
  private var resolvedLineLimit: Int? {
    if leftImage != nil && rightImage != nil {
      return TextMode.truncate.lineLimit
    }
    return lineLimit
  }

  public var body: some View {
    HStack(alignment: .top, spacing: self.spacing.rawValue) {
      if let image = leftImage {
        iconImage(image)
      }

      titleText

      if let image = rightImage {
        iconImage(image)
      }
    }
  }

  private var titleText: some View {
    Text(title)
      .typo(size.typoSize, titleColor)
      .applyIf(self.fullSize) {
        $0.frame(maxWidth: .infinity, alignment: .leading)
      }
      .multilineTextAlignment(.leading)
      .lineLimit(self.resolvedLineLimit)
      .fixedSize(horizontal: false, vertical: true)
      .truncationMode(.tail)
  }

  private func iconImage(_ image: Image) -> some View {
    image
      .resizable()
      .frame(width: Self.iconSize, height: Self.iconSize)
      .foregroundStyle(self.imageForegroundColor)
      .padding(.vertical, size.iconVerticalPadding)
  }
}

#Preview {
  VStack(alignment: .leading, spacing: 16) {
    SDGIconLabel(
      size: .medium(isBold: false),
      leftImage: Image(sdg: .icCommonWarning),
      title: "선택한 항목 중, 스케줄 배정 규칙에 어긋난 스케줄 변경 신청 건이 있습니다.",
      titleColor: .red300,
      fullSize: true
    )

    SDGIconLabel(
      size: .medium(isBold: false),
      spacing: .four,
      leftImage: Image(sdg: .icCommonWarning),
      rightImage: Image(sdg: .icView),
      title: "Label이 길어져 정해진 너비를 초과하는 경우의 표시 예시입니다",
      titleColor: .neutral700
    )
    .frame(width: 240, alignment: .leading)
  }
  .padding(20)
}
