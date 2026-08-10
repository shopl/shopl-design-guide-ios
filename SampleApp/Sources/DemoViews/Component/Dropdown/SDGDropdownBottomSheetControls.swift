//
//  SDGDropdownBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/26/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGDropdownBottomSheetControls: View {
  @ObservedObject private var state = SDGDropdownDemoState.shared

  var body: some View {
    SDGSampleBottomSheetControlSection(spacing: 16) {
      Text(sdg: "배경 컬러")
        .typo(.body1_SB, .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)

      SDGSegment(
        selectedSegmentIndex: $state.selectedBackgroundIndex,
        textLine: .one,
        items: state.backgroundOptions.map(\.title)
      )
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGDropdownBottomSheetControls()
    .padding(.vertical, 24)
    .background(Color.neutral0)
}
