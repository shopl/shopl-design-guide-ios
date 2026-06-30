//
//  SDGCapsuleButtonBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGCapsuleButtonBottomSheetControls: View {
  @ObservedObject private var state = SDGCapsuleButtonDemoControlState.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 28) {
      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "텍스트 길게 입력") {
          SDGToggle(size: .m, isOn: $state.isLongTextEnabled)
        }
      }
      
      SDGSampleBottomSheetDivider()
      
      SDGSampleBottomSheetControlSection(spacing: 16) {
        Text(sdg: "아이콘")
          .typo(.body1_SB, .neutral700)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        SDGSegment(
          selectedSegmentIndex: $state.selectedIconIndex,
          textLine: .one,
          items: state.iconOptions.map(\.title)
        )
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGCapsuleButtonBottomSheetControls()
    .padding(.vertical, 24)
    .background(Color.neutral0)
}
