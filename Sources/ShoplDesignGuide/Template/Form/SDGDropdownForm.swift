//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

public struct SDGDropdownForm: View {

  private let title: String
  private let icon: FormIconModel?
  private let type: FormType
  private let selectedText: String?
  private let placeHolder: String
  private let isRequiered: Bool
  @Binding private var disabled: Bool

  private let onRefresh: () -> Void
  private let onSelect: () -> Void

  private var isSelected: Bool {
    return !(selectedText?.isBlank ?? true)
  }

  private var dropdownStatus: SDGDropdown.Status {
    if disabled {
      return .disabled
    }

    return isSelected ? .selected : .default
  }

  public init(
    title: String,
    icon: FormIconModel? = nil,
    type: FormType,
    selectedText: String?,
    placeHolder: String,
    isRequiered: Bool = false,
    disabled: Binding<Bool> = .constant(false),
    onRefresh: @escaping () -> Void,
    onSelect: @escaping () -> Void
  ) {
    self.title = title
    self.icon = icon
    self.type = type
    self.selectedText = selectedText
    self.placeHolder = placeHolder
    self.isRequiered = isRequiered
    self._disabled = disabled
    self.onRefresh = onRefresh
    self.onSelect = onSelect
  }

  public var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 0) {
        Text("")
          .attributeText(
            fullText: isRequiered ? "\(title)*" : title,
            defaultFont: self.type == .empha ? .system(size: 16, weight: .semibold) : .system(size: 16),
            defaultColor: .neutral700,
            highlights: [
              .init(
                word: "*",
                font: .system(size: 16),
                color: .red300,
                underline: false
              )
            ]
          )
          .typo(self.type == .empha ? .body1_SB : .body1_R, .neutral700)
          .frame(minHeight: 28, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)

        if let icon = icon {

          Button {
            icon.onImageTap?()
          } label: {
            ZStack {
              icon.image
                .resizable()
                .foregroundStyle(icon.tintColor)
                .frame(width: 14, height: 14)
                .padding(.vertical, 3)
                .padding(.leading, 4)
                .padding(.trailing, 8)
            }
          }
          .buttonStyle(NoTapAnimationButtonStyle())
        }

        Spacer(minLength: 8)

        if isSelected && !isRequiered {

          Button {

            onRefresh()

          } label: {
            ZStack {

              Image(sdg: .icCommonRefresh)
                .resizable()
                .foregroundStyle(.neutral400)
                .frame(width: 24, height: 24)
                .padding(2)

            }
            .background(.neutral50)
            .cornerRadius(14)
          }
        }
      }

      SDGDropdown(
        model: .init(
          placeHolder: placeHolder,
          text: selectedText ?? "",
          status: dropdownStatus,
          backgroundColor: .neutral50
        ),
        onTap: onSelect
      )
    }
  }
}

#Preview {
  VStack {
    SDGDropdownForm(
      title: "타이틀",
      type: .empha,
      selectedText: nil,
      placeHolder: "입력",
      disabled: .constant(true),
      onRefresh: { },
      onSelect: { }
    )

    SDGDropdownForm(
      title: "타이틀",
      icon: FormIconModel(image: Image(sdg: .icCommonEdit), tintColor: .neutral600),
      type: .empha,
      selectedText: nil,
      placeHolder: "입력",
      isRequiered: true,
      disabled: .constant(false),
      onRefresh: { },
      onSelect: { }
    )

    SDGDropdownForm(
      title: "타이틀",
      icon: FormIconModel(image: Image(sdg: .icCommonEdit), tintColor: .neutral600),
      type: .empha,
      selectedText: "누구누구",
      placeHolder: "입력",
      isRequiered: true,
      disabled: .constant(false),
      onRefresh: { },
      onSelect: { }
    )

    SDGDropdownForm(
      title: "타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 ",
      type: .empha,
      selectedText: "입력했음",
      placeHolder: "입력",
      disabled: .constant(false),
      onRefresh: { },
      onSelect: { }
    )

    SDGDropdownForm(
      title: "타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 ",
      icon: FormIconModel(image: Image(sdg: .icCommonEdit), tintColor: .neutral600),
      type: .empha,
      selectedText: "입력했음",
      placeHolder: "입력",
      disabled: .constant(false),
      onRefresh: { },
      onSelect: { }
    )
  }
  .padding(20)
}
