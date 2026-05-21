//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGIconLabel: View {

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

  public enum Spacing: CGFloat, Equatable {
    case two = 2
    case four = 4
  }

  private let size: Size
  private let spacing: Spacing
  private let leftImage: Image?
  private let rightImage: Image?
  private let title: String
  private let imageForegroundColor: Color
  private let titleColor: SDG.Color
  private let lineLimit: Int?
  private let fullSize: Bool

  public init(
    size: Size,
    spacing: Spacing = .two,
    leftImage: Image? = nil,
    rightImage: Image? = nil,
    title: String,
    imageForegroundColor: Color,
    titleColor: SDG.Color,
    lineLimit: Int? = nil,
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

  public var body: some View {
    if usesCompactRightImageLayout {
      SDGIconLabelCompactLayout(spacing: self.spacing.rawValue) {
        if let image = leftImage {
          iconImage(image)
            .layoutValue(key: SDGIconLabelLayoutRoleKey.self, value: .leftImage)
        }

        titleText
          .layoutValue(key: SDGIconLabelLayoutRoleKey.self, value: .title)

        if let image = rightImage {
          iconImage(image)
            .layoutValue(key: SDGIconLabelLayoutRoleKey.self, value: .rightImage)
        }
      }
    } else {
      defaultLayout
    }
  }

  private var usesCompactRightImageLayout: Bool {
    self.rightImage != nil && self.lineLimit == nil && !self.fullSize
  }

  private var defaultLayout: some View {
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
      .lineLimit(self.lineLimit)
      .fixedSize(horizontal: false, vertical: true)
      .truncationMode(.tail)
  }

  private func iconImage(_ image: Image) -> some View {
    image
      .resizable()
      .frame(width: 14, height: 14)
      .foregroundStyle(self.imageForegroundColor)
      .padding(.top, 1)
  }
}

private enum SDGIconLabelLayoutRole {
  case leftImage
  case title
  case rightImage
}

private struct SDGIconLabelLayoutRoleKey: LayoutValueKey {
  static let defaultValue: SDGIconLabelLayoutRole = .title
}

private struct SDGIconLabelCompactLayout: Layout {

  private struct Metrics {
    let left: LayoutSubview?
    let title: LayoutSubview
    let right: LayoutSubview?
    let leftSize: CGSize
    let titleSize: CGSize
    let rightSize: CGSize
    let totalSpacing: CGFloat

    var width: CGFloat {
      leftSize.width + titleSize.width + rightSize.width + totalSpacing
    }

    var height: CGFloat {
      max(leftSize.height, titleSize.height, rightSize.height)
    }
  }

  let spacing: CGFloat

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    guard let metrics = makeMetrics(subviews: subviews, availableWidth: proposal.width) else {
      return .zero
    }

    return CGSize(width: metrics.width, height: metrics.height)
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    guard let metrics = makeMetrics(
      subviews: subviews,
      availableWidth: proposal.width ?? bounds.width
    ) else {
      return
    }

    var x = bounds.minX

    if let left = metrics.left {
      left.place(
        at: CGPoint(x: x, y: bounds.minY),
        anchor: .topLeading,
        proposal: ProposedViewSize(width: metrics.leftSize.width, height: metrics.leftSize.height)
      )
      x += metrics.leftSize.width + spacing
    }

    metrics.title.place(
      at: CGPoint(x: x, y: bounds.minY),
      anchor: .topLeading,
      proposal: ProposedViewSize(width: metrics.titleSize.width, height: metrics.titleSize.height)
    )
    x += metrics.titleSize.width

    if let right = metrics.right {
      x += spacing
      right.place(
        at: CGPoint(x: x, y: bounds.minY),
        anchor: .topLeading,
        proposal: ProposedViewSize(width: metrics.rightSize.width, height: metrics.rightSize.height)
      )
    }
  }

  private func makeMetrics(subviews: Subviews, availableWidth: CGFloat?) -> Metrics? {
    guard let title = subviews.first(where: { $0[SDGIconLabelLayoutRoleKey.self] == .title }) else {
      return nil
    }

    let left = subviews.first(where: { $0[SDGIconLabelLayoutRoleKey.self] == .leftImage })
    let right = subviews.first(where: { $0[SDGIconLabelLayoutRoleKey.self] == .rightImage })
    let leftSize = left?.sizeThatFits(.unspecified) ?? .zero
    let rightSize = right?.sizeThatFits(.unspecified) ?? .zero
    let spacingCount = CGFloat(max(subviews.count - 1, 0))
    let occupiedWidth = leftSize.width + rightSize.width + spacing * spacingCount
    let titleMaxWidth = availableWidth.map { max($0 - occupiedWidth, 0) }
    let titleSize = compactTitleSize(for: title, maxWidth: titleMaxWidth)

    return Metrics(
      left: left,
      title: title,
      right: right,
      leftSize: leftSize,
      titleSize: titleSize,
      rightSize: rightSize,
      totalSpacing: spacing * spacingCount
    )
  }

  private func compactTitleSize(for title: LayoutSubview, maxWidth: CGFloat?) -> CGSize {
    let idealSize = title.sizeThatFits(.unspecified)

    guard let maxWidth, maxWidth.isFinite else {
      return idealSize
    }

    guard idealSize.width > maxWidth else {
      return idealSize
    }

    let maxSize = title.sizeThatFits(ProposedViewSize(width: maxWidth, height: nil))
    var lowerBound: CGFloat = 1
    var upperBound: CGFloat = max(maxWidth, 1)

    for _ in 0..<18 {
      let mid = (lowerBound + upperBound) / 2
      let candidateSize = title.sizeThatFits(ProposedViewSize(width: mid, height: nil))

      if candidateSize.height <= maxSize.height + 0.5 {
        upperBound = mid
      } else {
        lowerBound = mid
      }
    }

    let compactSize = title.sizeThatFits(ProposedViewSize(width: upperBound, height: nil))
    let compactWidth = min(maxWidth, max(compactSize.width, upperBound))

    return CGSize(width: ceil(compactWidth), height: compactSize.height)
  }
}

#Preview {
  VStack {
    SDGIconLabel(
      size: .medium(isBold: false),
      leftImage: Image(sdg: .icCommonWarning),
      title: "이 직원에 대한 출퇴근 현황 조회 권한이 없습니다.",
      imageForegroundColor: .neutral400,
      titleColor: .neutral400,
      lineLimit: 1,
      fullSize: true
    )

    SDGIconLabel(
      size: .medium(isBold: false),
      leftImage: Image(sdg: .icCommonWarning),
      title: "선택한 항목 중, 스케줄 배정 규칙에 어긋난 스케줄 변경 신청 건이 있습니다.",
      imageForegroundColor: .red300,
      titleColor: .red300,
      fullSize: true
    )

    SDGIconLabel(
      size: .medium(isBold: false),
      rightImage: Image(sdg: .icView),
      title: "고정",
      imageForegroundColor: .neutral400,
      titleColor: .neutral400,
      lineLimit: 1
    )

    
    SDGIconLabel(
      size: .xsmall(isBold: false),
      spacing: .four,
      leftImage: Image(sdg: .icCommonWarning),
      title: "텍스트가 길어질 경우 전체 노출이 필요한 경우는 줄바꿈이 될텐데 그랬을 때는 아이콘의 위치는 상단에 고정시킵니다.",
      imageForegroundColor: .red300,
      titleColor: .red300,
      fullSize: true
    )
  }
  .padding(20)
}
