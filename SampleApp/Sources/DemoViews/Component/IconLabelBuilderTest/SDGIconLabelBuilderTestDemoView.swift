import SwiftUI
import ShoplDesignGuide

/// Icon Label Builder Test의 크기·굵기·간격·아이콘 및 긴 라벨 처리를 비교합니다.
struct SDGIconLabelBuilderTestDemoView: View {
  private let longTitle = "아이콘과 텍스트를 조합하여 보여주는 템플릿입니다. 긴 라벨의 전체 표시와 한 줄 말줄임을 확인합니다."

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      ForEach(0..<3, id: \.self) { sizeIndex in
        VStack(alignment: .leading, spacing: 12) {
          Text(["Medium · Body1", "Small · Body2", "XSmall · Body3"][sizeIndex])
            .typo(.body1_SB, .neutral700)

          ForEach([false, true], id: \.self) { isBold in
            ForEach(0..<2, id: \.self) { spacingIndex in
              examples(sizeIndex: sizeIndex, isBold: isBold, spacingIndex: spacingIndex)
            }
          }
        }
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func examples(sizeIndex: Int, isBold: Bool, spacingIndex: Int) -> some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("\(isBold ? "SemiBold" : "Regular") · Spacing\(spacingIndex == 0 ? 2 : 4)")
        .typo(.body3_SB, .neutral400)

      SDGIconLabelBuilderTest(
        size: size(sizeIndex, isBold: isBold),
        spacing: spacingIndex == 0 ? .two : .four,
        icons: icons(2),
        title: "Label",
        imageForegroundColor: .neutral700,
        titleColor: .neutral700
      )

      ForEach(0..<3, id: \.self) { iconIndex in
        Text(["왼쪽", "오른쪽", "양쪽"][iconIndex] + " · 전체 표시 / 한 줄 말줄임")
          .typo(.body3_R, .neutral400)

        SDGIconLabelBuilderTest(
          size: size(sizeIndex, isBold: isBold),
          spacing: spacingIndex == 0 ? .two : .four,
          icons: icons(iconIndex),
          title: longTitle,
          imageForegroundColor: .neutral700,
          titleColor: .neutral700
        )

        SDGIconLabelBuilderTest(
          size: size(sizeIndex, isBold: isBold),
          spacing: spacingIndex == 0 ? .two : .four,
          icons: icons(iconIndex),
          title: longTitle,
          imageForegroundColor: .primary300,
          titleColor: .primary300,
          textBehavior: .singleLine
        )
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .overlay {
      RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }

  private func size(_ index: Int, isBold: Bool) -> SDGIconLabelBuilderTest.Size {
    switch index {
    case 0: return .medium(isBold: isBold)
    case 1: return .small(isBold: isBold)
    default: return .xsmall(isBold: isBold)
    }
  }

  private func icons(_ index: Int) -> SDGIconLabelBuilderTest.Icons {
    switch index {
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
