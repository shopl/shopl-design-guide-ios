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
        SDGSampleBottomSheetControlRow(title: "임산부 설정") {
          SDGToggle(size: .m, isOn: $state.isMaternityEnabled)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGAvatarBottomSheetControls()
}
