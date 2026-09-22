//
//  SDGIconTabDemoView.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/18/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGIconTabDemoView: View {
  @ObservedObject private var state = SDGIconTabDemoState.shared

  var body: some View {
    previewCard
      .padding(.horizontal, 16)
      .padding(.top, 16)
      .padding(.bottom, 40)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var previewCard: some View {
    SDGIconTab(
      option: state.option,
      selectedIndex: state.selectedIndex,
      onTabClick: state.tabClicked
    )
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous)
        .strokeBorder(Color.neutral200, lineWidth: 1)
    }
  }
}

#Preview {
  SDGIconTabDemoView()
}
