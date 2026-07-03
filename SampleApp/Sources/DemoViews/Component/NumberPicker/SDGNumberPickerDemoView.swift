//
//  SDGNumberPickerDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/26/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGNumberPickerDemoView: View {
  @ObservedObject private var state = SDGNumberPickerDemoState.shared

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

      previewCard
    }
    .padding(.horizontal, 16)
    .padding(.top, 16)
    .padding(.bottom, 40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var previewCard: some View {
    VStack {
      numberPicker
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .id(state.selectedType.id)
        .environment(\.colorScheme, .light)
        .frame(height: 216)
        .padding(8)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.neutral0)
    .overlay {
      RoundedRectangle(
        cornerRadius: SDGCornerRadius.radius12.rawValue,
        style: .continuous
      )
      .stroke(Color.neutral200, lineWidth: 1)
    }
  }

  @ViewBuilder
  private var numberPicker: some View {
    switch state.selectedType {
    case .oneOption:
      SDGNumberPicker(
        type: .one(
          $state.selectedValue,
          state.oneOptionValues
        )
      )
    case .twoOption:
      SDGNumberPicker(
        type: .two(
          $state.selectedFirstValue,
          state.firstOptionValues,
          $state.selectedSecondValue,
          state.secondOptionValues
        )
      )
    }
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
  SDGNumberPickerDemoView()
}
