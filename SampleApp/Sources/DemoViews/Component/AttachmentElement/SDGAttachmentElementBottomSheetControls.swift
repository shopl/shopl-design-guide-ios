//
//  SDGAttachmentElementBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGAttachmentElementBottomSheetControls: View {
  @ObservedObject private var state = SDGAttachmentElementDemoState.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 28) {
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
  SDGAttachmentElementBottomSheetControls()
}
