//
//  SDGRadioDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/26/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGRadioDemoView: View {
  @ObservedObject private var state = SDGRadioDemoState.shared

  var body: some View {
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
    .padding(.top, 16)
    .padding(.bottom, 40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var previewCard: some View {
    VStack(spacing: 0) {
      statusSelector
      radioPreview
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
          radioLabel(for: .default, index: 0)
            .frame(width: 144)

          radioLabel(for: .selected, index: 1)
            .frame(width: 144)
        }

        radioLabel(for: .disabled, index: 2)
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

  private var radioPreview: some View {
    VStack(spacing: 40) {
      ForEach(state.previewItems) { item in
        SDGRadio(
          model: item.model,
          selected: { }
        )
      }
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

  private func radioLabel(for status: SDGRadioDemoStatus, index: Int) -> some View {
    SDGRadioLabel(
      model: RadioLabelModel(
        id: status.id,
        isSelected: state.selectedStatusIndex == index,
        isSelectedColorNeturel: true,
        title: status.title
      ),
      onTap: { _ in
        state.selectedStatusIndex = index
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
  SDGRadioDemoView()
}
