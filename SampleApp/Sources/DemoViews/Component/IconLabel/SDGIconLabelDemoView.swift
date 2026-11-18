//
//  SDGIconLabelDemoView.swift
//  ShoplDesignGuide
//

import SwiftUI
import ShoplDesignGuide

struct SDGIconLabelDemoView: View {
  @State private var size: DemoSize = .medium
  @State private var fontWeight: DemoFontWeight = .normal
  @State private var gap: DemoGap = .four
  @State private var icon: DemoIcon = .left
  @State private var textMode: DemoTextMode = .wrap
  @State private var label: DemoLabel = .long

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      control("Size", selection: $size)
      control("Font Weight", selection: $fontWeight)
      control("Gap", selection: $gap)
      control("Icon", selection: $icon)
      control("Text Mode", selection: $textMode)
      control("Label", selection: $label)

      if icon == .both {
        Text(sdg: "좌우 아이콘을 모두 사용하면 Text Mode와 관계없이 Truncate로 표시합니다.")
          .typo(.body3_R, .neutral400)
          .fixedSize(horizontal: false, vertical: true)
      }

      previewCard
    }
    .padding(.horizontal, 16)
    .padding(.top, 16)
    .padding(.bottom, 40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var previewCard: some View {
    SDGIconLabel(
      size: componentSize,
      spacing: gap.spacing,
      leftImage: icon.showsLeft ? Image(sdg: .icCommonWarning) : nil,
      rightImage: icon.showsRight ? Image(sdg: .icView) : nil,
      title: label.text,
      titleColor: .neutral700,
      textMode: textMode.mode,
      // 가이드: 아이콘을 한쪽만 사용하면 Label이 남은 가용 너비를 채웁니다.
      fullSize: icon != .both
    )
    .frame(width: 240, alignment: .leading)
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }

  private var componentSize: SDGIconLabel.Size {
    let isBold = fontWeight == .bold
    switch size {
    case .medium: return .medium(isBold: isBold)
    case .small: return .small(isBold: isBold)
    case .xsmall: return .xsmall(isBold: isBold)
    }
  }

  private func control<Option: DemoOption>(_ title: String, selection: Binding<Option>) -> some View {
    let options = Array(Option.allCases)

    return VStack(alignment: .leading, spacing: 8) {
      Text(sdg: title)
        .typo(.body3_SB, .neutral350)
        .frame(maxWidth: .infinity, alignment: .leading)

      SDGScrollTab(
        style: .onlyText,
        size: .medium,
        items: options.map { SDGScrollTab.Item(id: $0.title, title: $0.title) },
        selectedIndex: options.firstIndex(of: selection.wrappedValue) ?? 0,
        onItemTapped: { selection.wrappedValue = options[$0] }
      )
    }
  }
}

private protocol DemoOption: CaseIterable, Equatable where AllCases: RandomAccessCollection {
  var title: String { get }
}

private enum DemoSize: DemoOption {
  case medium, small, xsmall

  var title: String {
    switch self {
    case .medium: return "Medium"
    case .small: return "Small"
    case .xsmall: return "XSmall"
    }
  }
}

private enum DemoFontWeight: DemoOption {
  case normal, bold

  var title: String {
    switch self {
    case .normal: return "Normal"
    case .bold: return "Bold"
    }
  }
}

private enum DemoGap: DemoOption {
  case two, four

  var title: String {
    switch self {
    case .two: return "2"
    case .four: return "4"
    }
  }

  var spacing: SDGIconLabel.Spacing {
    switch self {
    case .two: return .two
    case .four: return .four
    }
  }
}

/// 가이드상 아이콘을 둘 다 사용하지 않는 구성은 대상이 아니므로 제외합니다.
private enum DemoIcon: DemoOption {
  case left, right, both

  var title: String {
    switch self {
    case .left: return "Left ic"
    case .right: return "Right ic"
    case .both: return "Left ic & Right ic"
    }
  }

  var showsLeft: Bool { self != .right }
  var showsRight: Bool { self != .left }
}

private enum DemoTextMode: DemoOption {
  case wrap, truncate

  var title: String {
    switch self {
    case .wrap: return "Wrap"
    case .truncate: return "Truncate"
    }
  }

  var mode: SDGIconLabel.TextMode {
    switch self {
    case .wrap: return .wrap
    case .truncate: return .truncate
    }
  }
}

private enum DemoLabel: DemoOption {
  case short, long

  var title: String {
    switch self {
    case .short: return "Short"
    case .long: return "Long"
    }
  }

  var text: String {
    switch self {
    case .short: return "Label"
    case .long: return "Label이 길어져 정해진 너비를 초과하는 경우의 표시 예시입니다"
    }
  }
}

#Preview {
  SDGIconLabelDemoView()
}
