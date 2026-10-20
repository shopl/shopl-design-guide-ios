//
//  SDGAvatarBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

/// 가이드의 Face·Retry·Outline·ic 표시 옵션을 독립적으로 조절합니다.
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
        SDGSampleBottomSheetControlRow(title: "Outline") {
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
        SDGSampleBottomSheetControlRow(title: "ic") {
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
