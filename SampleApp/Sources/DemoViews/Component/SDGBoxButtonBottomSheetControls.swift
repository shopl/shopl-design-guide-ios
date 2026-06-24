//
//  SDGBoxButtonBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGBoxButtonBottomSheetControls: View {
  @ObservedObject private var controlState = SDGBoxButtonDemoControlState.shared
  
  var body: some View {
    VStack(spacing: 28) {
      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "Preview") {
          SDGToggle(size: .m, isOn: $controlState.isPreviewEnabled)
        }
      }
      
      SDGSampleBottomSheetDivider()
      
      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "Size") {
          SDGToggle(size: .m, isOn: $controlState.isSizeControlEnabled)
        }
        
        SDGSegment(
          selectedSegmentIndex: $controlState.selectedSizeIndex,
          textLine: .one,
          items: ["Medium", "Small", "XSmall"]
        )
        .disabled(!controlState.isSizeControlEnabled)
        .opacity(controlState.isSizeControlEnabled ? 1 : 0.35)
      }
      
      SDGSampleBottomSheetDivider()
      
      SDGSampleBottomSheetControlSection {
        SDGSampleBottomSheetControlRow(title: "Style") {
          SDGToggle(size: .m, isOn: $controlState.isStyleControlEnabled)
        }
        
        SDGSegment(
          selectedSegmentIndex: $controlState.selectedStyleIndex,
          textLine: .one,
          items: ["Basic", "Icon"]
        )
        .disabled(!controlState.isStyleControlEnabled)
        .opacity(controlState.isStyleControlEnabled ? 1 : 0.35)
      }
      
      SDGSampleBottomSheetDivider()
      
      SDGSampleBottomSheetControlSection(spacing: 20) {
        SDGSampleBottomSheetControlRow(title: "State") {
          SDGToggle(size: .m, isOn: $controlState.isStateControlEnabled)
        }
        
        SDGSegment(
          selectedSegmentIndex: $controlState.selectedStateIndex,
          textLine: .one,
          items: ["Default", "Selected", "Disabled"]
        )
        .disabled(!controlState.isStateControlEnabled)
        .opacity(controlState.isStateControlEnabled ? 1 : 0.35)
        
        SDGSampleBottomSheetMessage(text: "*Message Area")
      }
    }
  }
}

#Preview {
  ScrollView {
    SDGBoxButtonBottomSheetControls()
      .padding(.vertical, 24)
  }
  .background(Color.neutral0)
}
