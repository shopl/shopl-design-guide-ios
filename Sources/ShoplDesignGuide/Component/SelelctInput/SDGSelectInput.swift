//
//  SDGSelectInput.swift
//  ShoplDesignGuide
//

import SwiftUI

public struct SDGSelectInput: View {
  public static let version: String = "2.3.39"

  private let model: SelectInputModel
  private let onTapped: () -> Void

  public struct SelectInputModel {
    /// 선택된 데이터를 표현하는 요소입니다. Input Field는 최대 두 요소(높이 80pt)까지 지원합니다.
    public let selectedElements: [SelectedElement]
    public let placeholder: String
    public let inputField: InputField
    public let state: State

    public init(
      selectedElements: [SelectedElement] = [],
      placeholder: String,
      inputField: InputField,
      state: State
    ) {
      precondition(selectedElements.count <= 2, "SDGSelectInput supports up to two selected elements.")
      self.selectedElements = selectedElements
      self.placeholder = placeholder
      self.inputField = inputField
      self.state = state
    }

    public enum InputField {
      case gray
      case white

      fileprivate var color: SDG.Color {
        switch self {
        case .gray:
          .neutral50
        case .white:
          .neutral0
        }
      }
    }

    public enum State {
      case `default`
      case selected
      case disabled
      case error
    }

    public struct SelectedElement {
      public let text: String
      let content: AnyView?

      public init(text: String) {
        self.text = text
        self.content = nil
      }

      public init<Content: View>(
        text: String,
        @ViewBuilder content: () -> Content
      ) {
        self.text = text
        self.content = AnyView(content())
      }
    }
  }

  public init(
    model: SelectInputModel,
    onTapped: @escaping () -> Void
  ) {
    self.model = model
    self.onTapped = onTapped
  }

  public var body: some View {
    HStack(alignment: .center, spacing: 10) {
      VStack(spacing: 0) {
        if model.state == .default || model.selectedElements.isEmpty {
          SDGSelectInputElementView(
            element: nil,
            placeholder: model.placeholder,
            state: model.state
          )
        } else {
          ForEach(Array(model.selectedElements.enumerated()), id: \.offset) { _, element in
            SDGSelectInputElementView(
              element: element,
              placeholder: model.placeholder,
              state: model.state
            )
          }
        }
      }

      SDG.Image.icCommonNext.image
        .templateIcon(size: 24, color: textColor.color)
        .opacity(model.state == .disabled ? 0.3 : 1)
    }
    .padding(.horizontal, 12)
    .frame(height: model.state != .default && model.selectedElements.count == 2 ? 80 : 40)
    .background(backgroundColor)
    .cornerRadius(12)
    .onTapGesture(perform: onTapped)
    .allowsHitTesting(model.state != .disabled)
    .accessibilityElement(children: .combine)
    .accessibilityHint(model.state == .disabled ? "비활성화됨" : "선택")
  }

  private var textColor: SDG.Color {
    .neutral700
  }

  private var backgroundColor: Color {
    (model.state == .error ? SDG.Color.red300_10 : model.inputField.color).color
  }
}

private struct SDGSelectInputElementView: View {
  let element: SDGSelectInput.SelectInputModel.SelectedElement?
  let placeholder: String
  let state: SDGSelectInput.SelectInputModel.State

  var body: some View {
    HStack(alignment: .center, spacing: 10) {
      if state != .default,
         let content = element?.content {
        content
      }

      Text(state == .default ? placeholder : element?.text ?? placeholder)
        .typo(.body1_R, state == .default ? .neutral300 : .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(1)
    }
    .frame(height: 40)
    .contentShape(Rectangle())
    .opacity(state == .disabled ? 0.3 : 1)
  }
}

#Preview {
  VStack(spacing: 12) {
    SDGSelectInput(
      model: .init(placeholder: "Placeholder", inputField: .gray, state: .default)
    ) { }

    SDGSelectInput(
      model: .init(
        selectedElements: [.init(text: "Selected Text")],
        placeholder: "Placeholder",
        inputField: .gray,
        state: .selected
      )
    ) { }

    SDGSelectInput(
      model: .init(
        selectedElements: [.init(text: "Selected Text") {
          SDG.Image.icBarcode.image.templateIcon(size: 20, color: SDG.Color.neutral700.color)
        }],
        placeholder: "Placeholder",
        inputField: .white,
        state: .selected
      )
    ) { }

    SDGSelectInput(
      model: .init(
        selectedElements: [.init(text: "Selected Text")],
        placeholder: "Placeholder",
        inputField: .gray,
        state: .disabled
      )
    ) { }

    SDGSelectInput(
      model: .init(
        selectedElements: [.init(text: "Selected Text")],
        placeholder: "Placeholder",
        inputField: .gray,
        state: .error
      )
    ) { }
  }
  .padding()
}
