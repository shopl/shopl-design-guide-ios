//
//  SDGAvatarDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGAvatarDemoView: View {
  @ObservedObject private var state = SDGAvatarDemoState.shared
  
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
          list: roleTabModels,
          selectedIndex: $state.selectedRoleIndex,
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
          list: sizeTabModels,
          selectedIndex: $state.selectedSizeIndex
        )
      }
      
      avatarPreviewCard
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var avatarPreviewCard: some View {
    VStack(spacing: 0) {
      SDGAvatar(
        type: .round,
        model: state.avatarModel,
        size: state.selectedSize.avatarSize,
        action: { _ in }
      )
      .id(state.avatarPreviewID)
    }
    .frame(maxWidth: .infinity)
    .frame(minHeight: 170)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }
  
  private var roleTabModels: [SDGScrollTab.Model] {
    state.roles.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }
  
  private var sizeTabModels: [SDGScrollTab.Model] {
    state.sizes.map {
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
  SDGAvatarDemoView()
}
