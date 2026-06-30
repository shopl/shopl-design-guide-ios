//
//  SDGFloatingButtonDemoView.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGFloatingButtonDemoView: View {
  @StateObject private var state = SDGFloatingButtonDemoState()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      specSection
    }
    .padding(.top, 16)
    .padding(.bottom, 40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var specSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      VStack(alignment: .leading, spacing: 8) {
        sectionTitle("Spec")
        
        SDGScrollTab(
          type: .text,
          list: specTabModels,
          selectedIndex: $state.selectedSpecIndex
        )
      }
      
      previewCard
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var previewCard: some View {
    VStack(spacing: 0) {
      stateSelector
      buttonPreview
    }
    .frame(maxWidth: .infinity)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }
  
  private var stateSelector: some View {
    VStack(spacing: 16) {
      HStack(spacing: 8) {
        ForEach(SDGFloatingButtonDemoButtonState.allCases) { demoState in
          radioLabel(for: demoState)
            .frame(width: 144)
        }
      }
      .padding(.horizontal, 16)
      
      Rectangle()
        .fill(Color.neutral200)
        .frame(height: 1)
        .frame(maxWidth: .infinity)
    }
    .padding(.top, 16)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var buttonPreview: some View {
    VStack(spacing: 0) {
      SDGFloatingButton(
        icon: Image(sdg: .icAddPlus),
        iconTintColor: .neutral0,
        isDisabled: state.isPreviewDisabled,
        action: { }
      )
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
  }
  
  private var specTabModels: [SDGScrollTab.Model] {
    state.specs.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }
  
  private func radioLabel(for demoState: SDGFloatingButtonDemoButtonState) -> some View {
    SDGRadioLabel(
      model: RadioLabelModel(
        id: demoState.id,
        isSelected: state.selectedState == demoState,
        isSelectedColorNeturel: true,
        title: demoState.title
      ),
      onTap: { _ in
        state.selectedState = demoState
      }
    )
  }
  
  private func sectionTitle(_ title: String) -> some View {
    Text(sdg: title)
      .typo(.body3_SB, .neutral350)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGFloatingButtonDemoView()
}
