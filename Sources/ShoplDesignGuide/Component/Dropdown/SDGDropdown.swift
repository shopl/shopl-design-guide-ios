//
//  SDGDropdown.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGDropdown: View {
  public static let version = "2.0.8"

  public enum Status: Equatable {
    case `default`
    case selected
    case disabled
    case error
  }

  public enum BackgroundColor: Equatable {
    case neutral50
    case neutral0

    fileprivate var color: Color {
      switch self {
      case .neutral50: return .neutral50
      case .neutral0: return .neutral0
      }
    }
  }

  public struct Model: Equatable {
    public let placeHolder: String
    public let text: String
    public let status: Status
    public let backgroundColor: BackgroundColor

    public init(
      placeHolder: String,
      text: String = "",
      status: Status = .default,
      backgroundColor: BackgroundColor = .neutral50
    ) {
      self.placeHolder = placeHolder
      self.text = text
      self.status = status
      self.backgroundColor = backgroundColor
    }

    fileprivate var displayText: String {
      text.isEmpty ? placeHolder : text
    }
  }

  private let model: Model
  private let onTap: () -> Void

  private var textColor: SDG.Color {
    switch model.status {
    case .default, .disabled: return .neutral300
    case .selected, .error: return .neutral700
    }
  }

  private var iconColor: Color {
    model.status == .disabled ? .neutral300 : .neutral700
  }

  private var backgroundColor: Color {
    switch model.status {
    case .error: return .red300_10
    default: return model.backgroundColor.color
    }
  }

  private var isDisabled: Bool {
    model.status == .disabled
  }

  public init(
    model: Model,
    onTap: @escaping () -> Void
  ) {
    self.model = model
    self.onTap = onTap
  }

  public var body: some View {

    Button {
      guard !isDisabled else { return }
      onTap()
    } label: {
      HStack(spacing: 10) {
        Text(model.displayText)
          .typo(.body1_R, textColor)
          .lineLimit(1)
          .truncationMode(.tail)
          .frame(maxWidth: .infinity, alignment: .leading)

        Image(sdg: .icCommonDropdown)
          .resizable()
          .frame(width: 20, height: 20)
          .foregroundColor(iconColor)
      }
      .padding(.horizontal, 12)
      .frame(height: 40)
      .background(backgroundColor)
      .cornerRadius(12)
    }
    .buttonStyle(NoTapAnimationButtonStyle())
    .disabled(isDisabled)
  }

}

struct BasicDropdown_Preview: PreviewProvider {
  static var previews: some View {

    VStack {
      Spacer()

      HStack(spacing: 8) {
        SDGDropdown(
          model: .init(
            placeHolder: "Hint",
            text: "2023.08.04(금)",
            status: .selected,
            backgroundColor: .neutral50
          ),
          onTap: { }
        )

        SDGDropdown(
          model: .init(
            placeHolder: "Hint",
            text: "16:00",
            status: .selected,
            backgroundColor: .neutral50
          ),
          onTap: { }
        )
        .frame(width: 112)
      }

      SDGDropdown(
        model: .init(
          placeHolder: "Hint",
          text: "Selected",
          status: .selected,
          backgroundColor: .neutral0
        ),
        onTap: { }
      )


      SDGDropdown(
        model: .init(
          placeHolder: "Hint",
          status: .default,
          backgroundColor: .neutral0
        ),
        onTap: { }
      )

      SDGDropdown(
        model: .init(
          placeHolder: "Hint",
          status: .disabled,
          backgroundColor: .neutral50
        ),
        onTap: { }
      )

      SDGDropdown(
        model: .init(
          placeHolder: "Hint",
          text: "Error",
          status: .error,
          backgroundColor: .neutral50
        ),
        onTap: { }
      )

      Spacer()
    }
    .padding()
    .background(
      Color.neutral700
        .ignoresSafeArea()
    )

  }
}
