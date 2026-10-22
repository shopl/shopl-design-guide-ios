import SwiftUI
import ShoplDesignGuide

/// Icon Label Builder Test의 크기·굵기·간격과 긴 라벨을 비교하는 샘플입니다.
struct SDGIconLabelBuilderTestDemoView: View {
  private let sizeNames = ["Medium", "Small", "XSmall"]
  private let longTitle = "긴 라벨을 좁은 너비에서 표시할 때 아이콘을 유지하고 전체 문구 또는 한 줄 말줄임을 확인합니다."

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      ForEach(0..<3) { index in
        VStack(alignment: .leading, spacing: 12) {
          Text(sdg: sizeNames[index])
            .typo(.body1_SB, .neutral700)
          ForEach([false, true], id: \.self) { isBold in
            ForEach([2, 4], id: \.self) { gap in
              VStack(alignment: .leading, spacing: 8) {
                Text(sdg: "\(isBold ? "Semibold" : "Regular") · Spacing\(gap)")
                  .typo(.body3_R, .neutral400)
                label(index: index, isBold: isBold, gap: gap, icons: .both(
                  left: Image(sdg: .icCommonWarning), right: Image(sdg: .icView)
                ), title: "Label")
              }
            }
          }
        }
      }

      Text(sdg: "한쪽 아이콘 · 가용 너비 채움")
        .typo(.body1_SB, .neutral700)
      label(icons: .left(Image(sdg: .icCommonWarning)), title: "왼쪽 아이콘")
      label(icons: .right(Image(sdg: .icView)), title: "오른쪽 아이콘")

      Text(sdg: "좁은 너비 · 전체 노출 / 한 줄 말줄임")
        .typo(.body1_SB, .neutral700)
      ForEach(0..<3) { placement in
        VStack(alignment: .leading, spacing: 12) {
          label(icons: icons(for: placement), title: longTitle)
          label(icons: icons(for: placement), title: longTitle, display: .singleLine)
        }
        .frame(width: 200, alignment: .leading)
        .padding(8)
        .overlay {
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.neutral200, lineWidth: 1)
        }
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func label(
    index: Int = 0,
    isBold: Bool = false,
    gap: Int = 4,
    icons: SDGIconLabelBuilderTest.Icons,
    title: String,
    display: SDGIconLabelBuilderTest.TextDisplay = .full
  ) -> some View {
    SDGIconLabelBuilderTest(
      size: size(index: index, isBold: isBold),
      spacing: gap == 2 ? .two : .four,
      icons: icons,
      title: title,
      imageForegroundColor: .primary400,
      titleColor: isBold ? .primary400 : .neutral700,
      textDisplay: display
    )
  }

  private func size(index: Int, isBold: Bool) -> SDGIconLabel.Size {
    switch index {
    case 0: return .medium(isBold: isBold)
    case 1: return .small(isBold: isBold)
    default: return .xsmall(isBold: isBold)
    }
  }

  private func icons(for placement: Int) -> SDGIconLabelBuilderTest.Icons {
    switch placement {
    case 0: return .left(Image(sdg: .icCommonWarning))
    case 1: return .right(Image(sdg: .icView))
    default: return .both(left: Image(sdg: .icCommonWarning), right: Image(sdg: .icView))
    }
  }
}

#Preview {
  ScrollView {
    SDGIconLabelBuilderTestDemoView()
  }
}
