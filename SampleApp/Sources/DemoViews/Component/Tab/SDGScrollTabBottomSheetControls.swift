//
//  SDGScrollTabBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by dino on 10/2/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGScrollTabBottomSheetControls: View {
  @ObservedObject private var state = SDGScrollTabDemoControlState.shared

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
  SDGScrollTabBottomSheetControls()
    .padding(.vertical, 24)
    .background(Color.neutral0)
}
