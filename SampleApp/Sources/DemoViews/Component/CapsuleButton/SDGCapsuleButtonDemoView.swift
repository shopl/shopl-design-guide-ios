//
//  SDGCapsuleButtonDemoView.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGCapsuleButtonDemoView: View {
  @ObservedObject private var state = SDGCapsuleButtonDemoControlState.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      typeSection
      specSection
    }
    .padding(.top, 16)
    .padding(.bottom, 40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var typeSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      VStack(alignment: .leading, spacing: 8) {
        sectionTitle("Type")
          .padding(.horizontal, 16)
        
        SDGScrollTab(
          type: .text,
          list: typeTabModels,
          selectedIndex: $state.selectedTypeIndex,
          horizontalPadding: 16
        )
      }
      
      Rectangle()
        .fill(Color.neutral200)
        .frame(height: 1)
        .frame(maxWidth: .infinity)
    }
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
        ForEach(state.states.indices, id: \.self) { index in
          radioLabel(for: state.states[index], index: index)
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
      SDGCapsuleButton(
        option: state.previewOption,
        isSelected: $state.isPreviewSelected,
        isDisable: state.isPreviewDisabled,
        isLoading: .constant(false)
      ) {
        state.togglePreviewSelected()
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
  }
  
  private var typeTabModels: [SDGScrollTab.Model] {
    state.types.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }
  
  private var specTabModels: [SDGScrollTab.Model] {
    state.specs.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }
  
  private func radioLabel(for demoState: SDGCapsuleButtonDemoState, index: Int) -> some View {
    SDGRadioLabel(
      model: RadioLabelModel(
        id: demoState.id,
        isSelected: state.selectedStateIndex == index,
        isSelectedColorNeturel: true,
        title: demoState.title
      ),
      onTap: { _ in
        state.selectedStateIndex = index
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
  SDGCapsuleButtonDemoView()
}
