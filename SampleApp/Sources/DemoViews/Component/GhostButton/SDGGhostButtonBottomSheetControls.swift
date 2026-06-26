//
//  SDGGhostButtonBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGGhostButtonBottomSheetControls: View {
  @ObservedObject private var state = SDGGhostButtonDemoControlState.shared
  
  var body: some View {
    SDGSampleBottomSheetControlSection {
      SDGSampleBottomSheetControlRow(title: "텍스트 길게 입력") {
        SDGToggle(size: .m, isOn: $state.isLongTextEnabled)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGGhostButtonBottomSheetControls()
    .padding(.vertical, 24)
    .background(Color.neutral0)
}
