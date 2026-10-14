//
//  SDGSelectInputPreview.swift
//  ShoplDesignGuide
//
//  Created by kai on 10/14/26.
//

import SwiftUI

#Preview("01 · 상태") {
  SelectInputPreviewGallery {
    ForEach(SelectInputPreviewState.allCases) { state in
      SelectInputPreviewRow(
        state.rawValue,
        model: SelectInputPreviewSamples.model(
          state: state.value,
          showClearIcon: state == .selected || state == .error
        )
      )
    }
  }
}

#Preview("02 · 선택 요소") {
  SelectInputPreviewGallery {
    SelectInputPreviewRow("Text · 40pt", model: SelectInputPreviewSamples.model())
    SelectInputPreviewRow(
      "Avatar · 30pt / 필드 40pt",
      model: SelectInputPreviewSamples.model(elements: [
        .init(text: "Selected Text") {
          SDGAvatar(
            type: .round,
            model: .init(userId: "preview", imageURL: nil, roleType: .worker),
            size: .s,
            action: { _ in }
          )
        }
      ])
    )
    SelectInputPreviewRow(
      "1 Image · 40pt",
      model: SelectInputPreviewSamples.model(elements: [SelectInputPreviewSamples.image()])
    )
    SelectInputPreviewRow(
      "2 Image · 80pt",
      model: SelectInputPreviewSamples.model(
        elements: [SelectInputPreviewSamples.image(), SelectInputPreviewSamples.image()],
        isMultipleSelection: false
      )
    )
  }
}

#Preview("03 · 이미지 규격") {
  SelectInputPreviewGallery {
    SelectInputPreviewRow(
      "With Circular · 배경 30×30 / 아이콘 14×14",
      model: SelectInputPreviewSamples.model(elements: [SelectInputPreviewSamples.image(.withCircular)])
    )
    SelectInputPreviewRow(
      "Square · 24×24",
      model: SelectInputPreviewSamples.model(elements: [SelectInputPreviewSamples.image(.square)])
    )
    SelectInputPreviewRow(
      "Rectangle · 52×20 영역 / 이미지 비율 유지",
      model: SelectInputPreviewSamples.model(elements: [SelectInputPreviewSamples.image(.rectangle)])
    )
  }
}

#Preview("04 · 배경") {
  SelectInputPreviewGallery {
    SelectInputPreviewRow("Gray · Neutral50", model: SelectInputPreviewSamples.model(inputField: .gray))
    SelectInputPreviewRow("White · Neutral0", model: SelectInputPreviewSamples.model(inputField: .white))
    SelectInputPreviewRow(
      "Error · Gray 설정보다 오류 배경 우선",
      model: SelectInputPreviewSamples.model(state: .error, inputField: .gray)
    )
    SelectInputPreviewRow(
      "Error · White 설정보다 오류 배경 우선",
      model: SelectInputPreviewSamples.model(state: .error, inputField: .white)
    )
  }
  .background(SDG.Color.neutral100.color)
}

#Preview("05 · Clear 노출 제어") {
  SelectInputPreviewGallery {
    ForEach(SelectInputPreviewState.allCases) { state in
      SelectInputPreviewRow(
        "\(state.rawValue) · Clear 노출",
        model: SelectInputPreviewSamples.model(state: state.value, showClearIcon: true)
      )
      SelectInputPreviewRow(
        "\(state.rawValue) · Clear 미노출",
        model: SelectInputPreviewSamples.model(state: state.value, showClearIcon: false)
      )
    }
    SelectInputPreviewRow(
      "Selected · 콜백 없이 아이콘만 노출",
      model: SelectInputPreviewSamples.model(showClearIcon: true),
      connectsClearAction: false
    )
    SelectInputPreviewRow(
      "Selected · 선택값이 없어도 외부 설정대로 노출",
      model: SelectInputPreviewSamples.model(elements: [], showClearIcon: true)
    )
  }
}

#Preview("06 · 긴 텍스트와 다중 선택") {
  SelectInputPreviewGallery {
    SelectInputPreviewRow(
      "Default · 긴 Placeholder",
      model: .init(
        placeholder: SelectInputPreviewSamples.longText,
        inputField: .gray,
        state: .default
      )
    )
    ForEach([SelectInputPreviewState.selected, .error]) { state in
      SelectInputPreviewRow(
        "\(state.rawValue) · 단일 선택 / 끝 말줄임",
        model: SelectInputPreviewSamples.model(
          state: state.value,
          elements: [.init(text: SelectInputPreviewSamples.longText)],
          showClearIcon: true,
          isMultipleSelection: false
        )
      )
      SelectInputPreviewRow(
        "\(state.rawValue) · 다중 선택 / 중간 말줄임",
        model: SelectInputPreviewSamples.model(
          state: state.value,
          elements: [.init(text: SelectInputPreviewSamples.longText + "+3")],
          showClearIcon: true,
          isMultipleSelection: true
        )
      )
    }
    SelectInputPreviewRow(
      "좁은 필드 · 220pt / 2 Image / 다중 선택",
      model: SelectInputPreviewSamples.model(
        elements: [
          SelectInputPreviewSamples.image(text: SelectInputPreviewSamples.longText + "+3"),
          SelectInputPreviewSamples.image(text: SelectInputPreviewSamples.longText + "+2")
        ],
        showClearIcon: true,
        isMultipleSelection: true
      ),
      width: 220
    )
  }
}

#Preview("07 · 터치와 초기화") {
  SelectInputInteractionPreview()
}

// MARK: - Preview Support

private enum SelectInputPreviewState: String, CaseIterable, Identifiable {
  case `default` = "Default"
  case selected = "Selected"
  case disabled = "Disabled"
  case error = "Error"

  var id: String { rawValue }

  var value: SDGSelectInput.SelectInputModel.State {
    switch self {
    case .default: .default
    case .selected: .selected
    case .disabled: .disabled
    case .error: .error
    }
  }
}

private enum SelectInputPreviewSamples {
  typealias Model = SDGSelectInput.SelectInputModel

  static let longText = "아주 긴 이름을 가진 선택 항목의 마지막 텍스트"

  static func model(
    state: Model.State = .selected,
    elements: [Model.SelectedElement]? = nil,
    inputField: Model.InputField = .gray,
    showClearIcon: Bool = false,
    isMultipleSelection: Bool = false
  ) -> Model {
    .init(
      selectedElements: elements ?? (state == .default ? [] : [.init(text: "Selected Text")]),
      placeholder: "Placeholder",
      inputField: inputField,
      state: state,
      showClearIcon: showClearIcon,
      isMultipleSelection: isMultipleSelection
    )
  }

  static func image(
    _ type: SDGSelectInput.SelectedElementImage.ImageType = .withCircular,
    text: String = "Selected Text"
  ) -> Model.SelectedElement {
    .init(text: text, image: SDG.Image.icBarcode.image, imageType: type)
  }
}

private struct SelectInputPreviewGallery<Content: View>: View {
  @ViewBuilder let content: Content

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        content
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(20)
    }
    .foregroundStyle(SDG.Color.neutral700.color)
  }
}

private struct SelectInputPreviewRow: View {
  let title: String
  let model: SDGSelectInput.SelectInputModel
  let connectsClearAction: Bool
  let width: CGFloat?

  init(
    _ title: String,
    model: SDGSelectInput.SelectInputModel,
    connectsClearAction: Bool = true,
    width: CGFloat? = nil
  ) {
    self.title = title
    self.model = model
    self.connectsClearAction = connectsClearAction
    self.width = width
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.caption)
        .foregroundStyle(SDG.Color.neutral500.color)
      SDGSelectInput(model: model, onClearTapped: connectsClearAction ? {} : nil) { }
        .frame(width: width)
    }
  }
}

private struct SelectInputInteractionPreview: View {
  @State private var state: SelectInputPreviewState = .selected
  @State private var showClearIcon = true
  @State private var hasSelection = true
  @State private var selectionTapCount = 0
  @State private var clearTapCount = 0

  var body: some View {
    SelectInputPreviewGallery {
      Picker("상태", selection: $state) {
        ForEach(SelectInputPreviewState.allCases) { state in
          Text(state.rawValue).tag(state)
        }
      }
      .pickerStyle(.segmented)
      .onChange(of: state) { state in
        hasSelection = state != .default
      }

      Toggle("Clear 노출", isOn: $showClearIcon)

      SDGSelectInput(
        model: SelectInputPreviewSamples.model(
          state: state.value,
          elements: hasSelection ? [.init(text: "Selected Text")] : [],
          showClearIcon: showClearIcon
        ),
        onClearTapped: {
          hasSelection = false
          state = .default
          clearTapCount += 1
        }
      ) {
        hasSelection = true
        state = .selected
        selectionTapCount += 1
      }

      Text("선택 \(selectionTapCount) · 초기화 \(clearTapCount)")
        .font(.callout.monospacedDigit())

      Text("Selected: Clear만 초기화\nDefault / Error: 필드 전체 선택\nDisabled: 모든 터치 차단\n초기화 후에도 Clear 노출 설정은 유지")
        .font(.caption)
        .foregroundStyle(SDG.Color.neutral500.color)

      Button("카운터 초기화") {
        selectionTapCount = 0
        clearTapCount = 0
      }
    }
  }
}
