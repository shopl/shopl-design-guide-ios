//
//  SDGAvatarBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGAvatarBottomSheetControls: View {
  @ObservedObject private var state = SDGAvatarDemoState.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 28) {
      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "사진") {
          SDGToggle(size: .m, isOn: $state.isPhotoEnabled)
        }
      }
      
      SDGSampleBottomSheetDivider()
      
      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "아이콘") {
          SDGToggle(size: .m, isOn: $state.isIconEnabled)
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
        SDGSampleBottomSheetControlRow(title: "Retry") {
          SDGToggle(size: .m, isOn: $state.isRetryEnabled)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGAvatarBottomSheetControls()
}
