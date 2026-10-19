//
//  SDGSelectInput.swift
//  ShoplDesignGuide
//
//  Created by dino on 3/18/26.
//

import SwiftUI

public struct SDGSelectInput: View {
  public static let version: String = "2.3.51"

  private let model: SelectInputModel
  private let onClearTapped: (() -> Void)?
  private let onTapped: () -> Void

  /// 기존 초기화 함수 참조와 호출 방식을 유지합니다.
  public init(
    model: SelectInputModel,
    onTapped: @escaping () -> Void
  ) {
    self.init(model: model, onClearTapped: nil, onTapped: onTapped)
  }

  /// onClearTapped에서 호출부의 선택값을 비우고 state를 .default로 갱신합니다.
  /// Clear 노출은 model.showClearIcon으로 제어하며, 초기화 액션은 Selected 상태에서만 실행합니다.
  public init(
    model: SelectInputModel,
    onClearTapped: (() -> Void)?,
    onTapped: @escaping () -> Void
  ) {
    self.model = model
    self.onClearTapped = onClearTapped
    self.onTapped = onTapped
  }

  public var body: some View {
    ZStack {
      // 형제 뷰로 분리하여 Clear 탭이 필드 선택 액션으로 전파되지 않게 합니다.
      selectionButton
      content
    }
    .frame(height: fieldHeight)
    .background(backgroundColor, in: RoundedRectangle(cornerRadius: 12))
    .disabled(isDisabled)
    .allowsHitTesting(!isDisabled)
    .accessibilityElement(children: .contain)
  }
}

private extension SDGSelectInput {
  var isDisabled: Bool {
    model.state == .disabled
  }

  var showsPlaceholder: Bool {
    model.state == .default || model.selectedElements.isEmpty
  }

  var fieldHeight: CGFloat {
    model.state != .default && model.selectedElements.count == 2 ? 80 : 40
  }

  var backgroundColor: Color {
    (model.state == .error ? SDG.Color.red300_10 : model.inputField.color).color
  }

  var selectionLabel: String {
    showsPlaceholder ? model.placeholder : model.selectedElements.map(\.text).joined(separator: ", ")
  }

  var selectionButton: some View {
    Button(action: onTapped) {
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.clear)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .accessibilityLabel(selectionLabel)
    .accessibilityHint(isDisabled ? "비활성화됨" : "선택")
  }

  var content: some View {
    HStack(alignment: .center, spacing: 10) {
      selectedElements
        .allowsHitTesting(false)
        .accessibilityHidden(true)

      if model.showClearIcon {
        clearControl
      }

      if !isDisabled {
        chevronIcon
      }
    }
    .padding(.horizontal, 12)
  }

  var selectedElements: some View {
    VStack(spacing: 0) {
      if showsPlaceholder {
        elementView(nil)
      } else {
        ForEach(Array(model.selectedElements.enumerated()), id: \.offset) { _, element in
          elementView(element)
        }
      }
    }
  }

  func elementView(_ element: SelectInputModel.SelectedElement?) -> some View {
    SDGSelectInputElementView(
      element: element,
      placeholder: model.placeholder,
      state: model.state,
      isMultipleSelection: element != nil && model.isMultipleSelection
    )
  }

  @ViewBuilder
  var clearControl: some View {
    if model.state == .selected, let onClearTapped {
      Button(action: onClearTapped) {
        clearIcon
          .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .accessibilityLabel("선택 초기화")
    } else {
      // 별도 초기화 액션이 없으면 필드의 터치 정책을 따릅니다.
      clearIcon
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
  }

  var clearIcon: some View {
    SDG.Image.icInputDelete.image
      .resizable()
      .frame(width: 18, height: 18)
      .frame(width: 24, height: 28)
  }

  var chevronIcon: some View {
    SDG.Image.icCommonNext.image
      .templateIcon(size: 24, color: SDG.Color.neutral700.color)
      .frame(width: 24, height: 28)
      .allowsHitTesting(false)
      .accessibilityHidden(true)
  }
}

private struct SDGSelectInputElementView: View {
  let element: SDGSelectInput.SelectInputModel.SelectedElement?
  let placeholder: String
  let state: SDGSelectInput.SelectInputModel.State
  let isMultipleSelection: Bool

  var body: some View {
    HStack(alignment: .center, spacing: 10) {
      if state != .default,
         let content = element?.content {
        content
      }

      Text(state == .default ? placeholder : element?.text ?? placeholder)
        .typo(.body1_R, state == .default ? .neutral350 : .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
        .truncationMode(isMultipleSelection ? .middle : .tail)
    }
    .frame(height: 40)
    .contentShape(Rectangle())
    .opacity(state == .disabled ? 0.3 : 1)
  }
}
