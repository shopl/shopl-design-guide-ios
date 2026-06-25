//
//  SDGGhostButtonDemoView.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGGhostButtonDemoView: View {
  @ObservedObject private var state = SDGGhostButtonDemoControlState.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      specSection
      usageGuidelinesSection
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
    HStack(alignment: .top, spacing: 40) {
      buttonColumn(labelWeight: .R)
      buttonColumn(labelWeight: .SB)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
  }
  
  private var usageGuidelinesSection: some View {
    VStack(alignment: .leading, spacing: 20) {
      Rectangle()
        .fill(Color.neutral200)
        .frame(height: 1)
        .frame(maxWidth: .infinity)
      
      VStack(alignment: .leading, spacing: 8) {
        sectionTitle("Usage Guidelines")
        
        Text(sdg: "# SDG 컬러 시스템의 모든 컬러 적용 가능합니다.")
          .typo(.body2_R, .neutral500)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.horizontal, 16)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var specTabModels: [SDGScrollTab.Model] {
    state.specs.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }
  
  private func buttonColumn(labelWeight: SDGGhostButton.LabelWeight) -> some View {
    VStack(spacing: 40) {
      ghostButton(labelWeight: labelWeight, iconPosition: .left)
      ghostButton(labelWeight: labelWeight, iconPosition: .right)
      ghostButton(labelWeight: labelWeight, iconPosition: nil)
    }
  }
  
  @ViewBuilder
  private func ghostButton(
    labelWeight: SDGGhostButton.LabelWeight,
    iconPosition: SDGGhostButton.IconOption.position?
  ) -> some View {
    if let iconPosition {
      ghostButtonPreview(labelWeight: labelWeight, iconPosition: iconPosition)
    } else {
      SDGGhostButton(
        title: state.title,
        titleColor: .neutral600,
        size: state.selectedSpec.buttonSize,
        labelWeight: labelWeight,
        status: state.status,
        iconOption: nil,
        action: { }
      )
    }
  }
  
  private func ghostButtonPreview(
    labelWeight: SDGGhostButton.LabelWeight,
    iconPosition: SDGGhostButton.IconOption.position
  ) -> some View {
    HStack(spacing: ghostButtonGap) {
      if iconPosition == .left {
        iconPreview
      }
      
      Text(sdg: state.title)
        .typo(typography(for: labelWeight), .neutral600)
        .lineLimit(1)
      
      if iconPosition == .right {
        iconPreview
      }
    }
    .padding(.horizontal, ghostButtonHorizontalPadding)
    .frame(height: ghostButtonHeight)
    .opacity(state.selectedState == .disabled ? 0.3 : 1)
  }
  
  private var iconPreview: some View {
    Image(sdg: .icons)
      .resizable()
      .renderingMode(.original)
      .frame(width: ghostButtonIconSize, height: ghostButtonIconSize)
      .background(Color.red300_10)
  }
  
  private var ghostButtonHeight: CGFloat {
    switch state.selectedSpec {
    case .large:
      return 42
    case .medium:
      return 36
    case .small:
      return 28
    }
  }
  
  private var ghostButtonHorizontalPadding: CGFloat {
    switch state.selectedSpec {
    case .large:
      return 16
    case .medium:
      return 10
    case .small:
      return 8
    }
  }
  
  private var ghostButtonGap: CGFloat {
    switch state.selectedSpec {
    case .large:
      return 6
    case .medium:
      return 4
    case .small:
      return 2
    }
  }
  
  private var ghostButtonIconSize: CGFloat {
    switch state.selectedSpec {
    case .large:
      return 16
    case .medium, .small:
      return 14
    }
  }
  
  private func typography(for labelWeight: SDGGhostButton.LabelWeight) -> SDG.Typography {
    switch (state.selectedSpec, labelWeight) {
    case (.large, .R):
      return .body1_R
    case (.large, .SB):
      return .body1_SB
    case (.medium, .R):
      return .body2_R
    case (.medium, .SB):
      return .body2_SB
    case (.small, .R):
      return .body3_R
    case (.small, .SB):
      return .body3_SB
    }
  }
  
  private func radioLabel(for demoState: SDGGhostButtonDemoState, index: Int) -> some View {
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
  SDGGhostButtonDemoView()
}
