//
//  SDGIconTabBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/18/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGIconTabBottomSheetControls: View {
  @ObservedObject private var state = SDGIconTabDemoState.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 28) {
      SDGSampleBottomSheetControlSection(spacing: 20) {
        Text(sdg: "Tab 개수")
          .typo(.body1_SB, .neutral700)
          .frame(maxWidth: .infinity, alignment: .leading)

        SDGSegment(
          selectedSegmentIndex: $state.selectedOptionIndex,
          textLine: .one,
          items: state.optionTitles
        )
      }

      SDGSampleBottomSheetDivider()

      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "텍스트 길게 입력") {
          SDGToggle(size: .m, isOn: $state.isLongTextEnabled)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGIconTabBottomSheetControls()
    .padding(.vertical, 24)
    .background(Color.neutral0)
}
