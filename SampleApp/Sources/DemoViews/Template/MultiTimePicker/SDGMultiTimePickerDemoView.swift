//
//  SDGMultiTimePickerDemoView.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/2/26.
//

import SwiftUI

import ShoplDesignGuide

struct SDGMultiTimePickerDemoView: View {
  @ObservedObject private var state = SDGMultiTimePickerDemoState.shared

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      pickerTypeSection

      if state.selectedType == .multi {
        initialSelectionSection
      }

      optionsSection
      confirmedValueSection
      presentButton
    }
    .padding(.horizontal, 16)
    .padding(.top, 16)
    .padding(.bottom, 40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var pickerTypeSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      sectionTitle("Type")

      SDGScrollTab(
        type: .text,
        list: state.pickerTypes.map {
          SDGScrollTab.Model(id: $0.id, title: $0.rawValue)
        },
        selectedIndex: $state.selectedTypeIndex
      )
    }
  }

  private var initialSelectionSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      sectionTitle("Initial selection")

      SDGScrollTab(
        type: .text,
        list: state.initialSelections.map {
          SDGScrollTab.Model(id: $0.id, title: $0.rawValue)
        },
        selectedIndex: $state.initialSelectionIndex
      )
    }
  }

  private var optionsSection: some View {
    VStack(spacing: 16) {
      optionRow(title: "Title", isOn: $state.showsTitle)
      optionRow(title: "24-hour format", isOn: $state.is24HourFormat)
    }
  }

  private var confirmedValueSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      sectionTitle("Confirmed value")

      Text(sdg: state.confirmedValue)
        .typo(.title2_SB, .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.neutral50)
        .clipShape(
          RoundedRectangle(
            cornerRadius: SDGCornerRadius.radius12.rawValue,
            style: .continuous
          )
        )
    }
  }

  private var presentButton: some View {
    Button {
      state.present()
    } label: {
      Text(sdg: "Open picker")
        .typo(.body1_SB, .neutral0)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Color.primary300)
        .clipShape(
          RoundedRectangle(
            cornerRadius: SDGCornerRadius.radius8.rawValue,
            style: .continuous
          )
        )
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .multiTimePicker(
      isPresented: state.isPresented,
      title: state.title,
      type: state.pickerType,
      is24HourFormat: state.is24HourFormat,
      cancelTitle: "Cancel",
      confirmTitle: "Confirm",
      cancelAction: {
        state.cancel()
      },
      confirmAction: {
        state.confirm($0)
      },
      tapOutsideAction: {
        state.cancel()
      }
    )
  }

  private func optionRow(
    title: String,
    isOn: Binding<Bool>
  ) -> some View {
    HStack(spacing: 12) {
      Text(sdg: title)
        .typo(.body1_R, .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)

      SDGToggle(
        size: .m,
        isOn: isOn
      )
    }
  }

  private func sectionTitle(_ title: String) -> some View {
    Text(sdg: title)
      .typo(.body3_SB, .neutral350)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  SDGMultiTimePickerDemoView()
}
