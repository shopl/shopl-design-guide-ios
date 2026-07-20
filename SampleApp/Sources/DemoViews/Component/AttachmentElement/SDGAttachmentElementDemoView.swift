//
//  SDGAttachmentElementDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGAttachmentElementDemoView: View {
  @ObservedObject private var state = SDGAttachmentElementDemoState.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      VStack(alignment: .leading, spacing: 8) {
        sectionTitle("Type")
        
        SDGScrollTab(
          type: .text,
          list: typeTabModels,
          selectedIndex: $state.selectedTypeIndex
        )
      }
      
      attachmentPreviewCard
    }
    .padding(.horizontal, 16)
    .padding(.top, 16)
    .padding(.bottom, 40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var attachmentPreviewCard: some View {
    VStack(spacing: 0) {
      attachmentPreview
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }
  
  private var attachmentPreview: some View {
    SDGAttachmentElement(
      model: state.attachmentModel,
      selectedItem: { _ in }
    )
    .id(state.attachmentPreviewID)
    .fixedSize(horizontal: !state.isLongTextEnabled, vertical: false)
    .frame(maxWidth: .infinity, alignment: .center)
  }
  
  private var typeTabModels: [SDGScrollTab.Model] {
    state.types.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }
  
  private func sectionTitle(_ title: String) -> some View {
    Text(sdg: title)
      .typo(.body3_SB, .neutral350)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGAttachmentElementDemoView()
}
