//
//  SDGAvatarBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

/// Figma의 Show Face·Show Retry·Show Outline·Show Ic를 독립적으로 조절합니다.
struct SDGAvatarBottomSheetControls: View {
  @ObservedObject private var state = SDGAvatarDemoState.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 28) {
      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "Show Face") {
          SDGToggle(size: .m, isOn: $state.isPhotoEnabled)
        }

        SDGSampleBottomSheetControlRow(title: "Show Retry") {
          SDGToggle(size: .m, isOn: $state.isRetryEnabled)
        }
      }

      SDGSampleBottomSheetDivider()

      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "Show Outline") {
          SDGToggle(size: .m, isOn: $state.isOutlineEnabled)
        }

        if state.isOutlineEnabled {
          SDGSegment(
            selectedSegmentIndex: $state.selectedOutlineColorIndex,
            textLine: .one,
            items: state.outlineColors.map(\.rawValue)
          )
        }
      }

      SDGSampleBottomSheetDivider()

      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "Show Ic") {
          SDGToggle(size: .m, isOn: $state.isIconEnabled)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGAvatarBottomSheetControls()
}
