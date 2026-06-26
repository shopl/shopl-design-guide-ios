//
//  SDGToggleDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/26/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGToggleDemoView: View {
  @ObservedObject private var state = SDGToggleDemoState.shared

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
      togglePreview
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
          statusOption(.default)
            .frame(width: 144)

          statusOption(.defaultDisabled)
            .frame(width: 144)
        }

        HStack(spacing: 8) {
          statusOption(.active)
            .frame(width: 144)

          statusOption(.selectedDisabled)
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

  private var togglePreview: some View {
    SDGToggle(
      size: state.selectedSpec.toggleSize,
      isEnabled: state.selectedStatus.isEnabled,
      onColorType: .primary,
      isOn: Binding(
        get: { state.selectedStatus.isOn },
        set: { state.setPreviewIsOn($0) }
      )
    )
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
  }

  private var specTabModels: [SDGScrollTab.Model] {
    state.specs.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }

  private func statusOption(_ status: SDGToggleDemoStatus) -> some View {
    Button {
      state.select(status)
    } label: {
      HStack(alignment: .top, spacing: 8) {
        SDGRadio(
          model: SDGRadio.Model(
            status: state.selectedStatus == status ? .selected : .default,
            spec: .medim,
            isPrimaryColor: false
          ),
          selected: { }
        )
        .padding(.top, 2)

        HStack(alignment: .lastTextBaseline, spacing: 0) {
          Text(status.title)
            .typo(.body1_R, .neutral700)

          if let suffix = status.suffix {
            Text(suffix)
              .typo(.body3_R, .neutral700)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .buttonStyle(NoTapAnimationButtonStyle())
  }

  private func sectionTitle(_ title: String) -> some View {
    Text(sdg: title)
      .typo(.body3_SB, .neutral350)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGToggleDemoView()
}
