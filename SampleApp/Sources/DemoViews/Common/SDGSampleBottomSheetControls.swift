//
//  SDGSampleBottomSheetControls.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGSampleBottomSheetControlSection<Content: View>: View {
  private let spacing: CGFloat
  private let content: Content
  
  init(
    spacing: CGFloat = 16,
    @ViewBuilder content: () -> Content
  ) {
    self.spacing = spacing
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: spacing) {
      content
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct SDGSampleBottomSheetControlRow<Trailing: View>: View {
  private let title: String
  private let trailing: Trailing
  
  init(
    title: String,
    @ViewBuilder trailing: () -> Trailing
  ) {
    self.title = title
    self.trailing = trailing()
  }
  
  var body: some View {
    HStack(spacing: 4) {
      Text(sdg: title)
        .typo(.body1_SB, .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      trailing
    }
    .frame(maxWidth: .infinity)
  }
}

struct SDGSampleBottomSheetDivider: View {
  var body: some View {
    Rectangle()
      .fill(Color.neutral100)
      .frame(height: 1)
      .frame(maxWidth: .infinity)
  }
}

struct SDGSampleBottomSheetMessage: View {
  let text: String
  
  var body: some View {
    Text(sdg: text)
      .typo(.body3_R, .neutral400)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  VStack(spacing: 28) {
    SDGSampleBottomSheetControlSection {
      SDGSampleBottomSheetControlRow(title: "Label") {
        SDGToggle(size: .m, isOn: .constant(true))
      }
    }
    
    SDGSampleBottomSheetDivider()
    
    SDGSampleBottomSheetControlSection {
      SDGSampleBottomSheetControlRow(title: "Label") {
        SDGToggle(size: .m, isOn: .constant(false))
      }
      
      SDGSegment(
        selectedSegmentIndex: .constant(0),
        textLine: .one,
        items: ["Basic", "Simple"]
      )
      
      SDGSampleBottomSheetMessage(text: "*Message Area")
    }
  }
  .padding(.vertical, 24)
  .background(Color.neutral0)
}
