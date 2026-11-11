//
//  SDGScrollTabDemoView.swift
//  ShoplDesignGuide
//
//  Created by dino on 10/1/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGScrollTabDemoView: View {
  @ObservedObject private var controlState = SDGScrollTabDemoControlState.shared
  @State private var selectedStyleIndex = 0
  @State private var selectedSizeIndex = 0
  @State private var selectedIndex = 0

  private let styleItems: [SDGScrollTab.Item] = [
    .init(id: "withUnderline", title: "With Underline"),
    .init(id: "onlyText", title: "Only Text")
  ]
  private let sizeItems: [SDGScrollTab.Item] = [
    .init(id: "large", title: "Large"),
    .init(id: "medium", title: "Medium")
  ]

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      styleSection
      sizeSection
      previewCard
    }
    .padding(.horizontal, 16)
    .padding(.top, 16)
    .padding(.bottom, 40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var styleSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      sectionTitle("Style")
      SDGScrollTab(
        style: .onlyText,
        items: styleItems,
        selectedIndex: selectedStyleIndex,
        onItemTapped: { selectedStyleIndex = $0 }
      )
    }
  }

  private var sizeSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      sectionTitle("Size")
      SDGScrollTab(
        style: .onlyText,
        items: sizeItems,
        selectedIndex: selectedSizeIndex,
        onItemTapped: { selectedSizeIndex = $0 }
      )
    }
  }

  private var previewCard: some View {
    SDGScrollTab(
      style: selectedStyleIndex == 0 ? .withUnderline : .onlyText,
      size: selectedSizeIndex == 0 ? .large : .medium,
      items: controlState.items,
      selectedIndex: selectedIndex,
      onItemTapped: { selectedIndex = $0 }
    )
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue))
    .overlay {
      RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue)
        .strokeBorder(Color.neutral200, lineWidth: 1)
    }
  }

  private func sectionTitle(_ title: String) -> some View {
    Text(sdg: title)
      .typo(.body3_SB, .neutral350)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGScrollTabDemoView()
}
