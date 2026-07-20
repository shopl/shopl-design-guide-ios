//
//  SDGDropdownDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/26/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGDropdownDemoView: View {
  @ObservedObject private var state = SDGDropdownDemoState.shared

  var body: some View {
    previewCard
      .padding(.horizontal, 16)
      .padding(.top, 16)
      .padding(.bottom, 40)
      .frame(maxWidth: .infinity, alignment: .leading)
      .listPopup(
        isPresented: state.isListPopupPresented,
        list: state.listPopupItems,
        selectAction: { id in
          state.selectOption(id: id)
        },
        tapOutsideAction: {
          state.hideListPopup()
        }
      )
  }

  private var previewCard: some View {
    VStack(spacing: 0) {
      statusSelector
      dropdownPreview
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

          statusOption(.selected)
            .frame(width: 144)
        }

        HStack(spacing: 8) {
          statusOption(.disabled)
            .frame(width: 144)

          statusOption(.error)
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

  private var dropdownPreview: some View {
    SDGDropdown(
      model: state.dropdownModel,
      onTap: {
        state.showListPopup()
      }
    )
    .padding(.horizontal, 16)
    .padding(.vertical, 40)
    .frame(maxWidth: .infinity)
    .background(Color.neutral150)
  }

  private func statusOption(_ status: SDGDropdownDemoStatus) -> some View {
    SDGRadioLabel(
      model: RadioLabelModel(
        id: status.id,
        isSelected: state.selectedStatus == status,
        isSelectedColorNeturel: true,
        title: status.title
      ),
      onTap: { _ in
        state.selectStatus(status)
      }
    )
  }
}

#Preview {
  SDGDropdownDemoView()
}
