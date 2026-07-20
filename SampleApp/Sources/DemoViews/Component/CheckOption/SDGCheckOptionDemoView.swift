//
//  SDGCheckOptionDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/25/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGCheckOptionDemoView: View {
  @StateObject private var state = SDGCheckOptionDemoState()

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
      statusSelector
      checkOptionPreview
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

  private var checkOptionPreview: some View {
    VStack(spacing: 40) {
      ForEach(state.previewItems) { item in
        SDGCheckOptionPreviewItemView(item: item)
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

  private func radioLabel(for status: SDGCheckOptionDemoStatus) -> some View {
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

private struct SDGCheckOptionPreviewItemView: View {
  let item: SDGCheckOptionDemoPreviewItem

  var body: some View {
    if item.selectedColor == .neutral, item.model.status == .selected {
      neutralSelectedPreview
    } else {
      SDGCheckOption(model: item.model, selected: { })
    }
  }

  @ViewBuilder
  private var neutralSelectedPreview: some View {
    switch item.type {
    case .solid:
      Image(sdg: .icCommonCheckS)
        .resizable()
        .renderingMode(.template)
        .frame(width: item.spec.iconSize, height: item.spec.iconSize, alignment: .center)
        .padding(.all, 1)
        .background(Color.neutral700)
        .foregroundStyle(Color.neutral0)
        .clipShape(Circle())
    case .line:
      Image(sdg: .icCommonCheckS)
        .resizable()
        .renderingMode(.template)
        .frame(width: item.spec.iconSize, height: item.spec.iconSize)
        .foregroundStyle(Color.neutral700)
        .padding(.all, 1)
        .overlay {
          Circle()
            .strokeBorder(Color.neutral700, lineWidth: 1)
        }
    }
  }
}

#Preview {
  SDGCheckOptionDemoView()
}
