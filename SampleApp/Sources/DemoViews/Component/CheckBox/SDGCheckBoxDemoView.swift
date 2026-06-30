//
//  SDGCheckBoxDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGCheckBoxDemoView: View {
  @StateObject private var state = SDGCheckBoxDemoState()

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      VStack(alignment: .leading, spacing: 8) {
        sectionTitle("Spec")

        SDGScrollTab(
          type: .text,
          list: sizeTabModels,
          selectedIndex: $state.selectedSizeIndex
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
    VStack(spacing: 0) {
      statusSelector
      checkBoxPreview
    }
    .frame(maxWidth: .infinity)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: SDGCornerRadius.radius8.rawValue, style: .continuous)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }

  private var statusSelector: some View {
    VStack(spacing: 16) {
      VStack(alignment: .leading, spacing: 16) {
        HStack(spacing: 8) {
          radioLabel(for: .default)
            .frame(width: 144)

          radioLabel(for: .selected)
            .frame(width: 144)
        }

        radioLabel(for: .disabled)
          .frame(width: 144)
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

  private var checkBoxPreview: some View {
    VStack(spacing: 40) {
      ForEach(Array(state.previewModels.enumerated()), id: \.offset) { item in
        SDGCheckBox(model: item.element)
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
  }

  private var sizeTabModels: [SDGScrollTab.Model] {
    state.sizes.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }

  private func radioLabel(for status: SDGCheckBoxDemoStatus) -> some View {
    SDGRadioLabel(
      model: RadioLabelModel(
        id: status.id,
        isSelected: state.selectedStatus == status,
        isSelectedColorNeturel: true,
        title: status.title
      ),
      onTap: { _ in
        state.selectedStatus = status
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
  SDGCheckBoxDemoView()
}
