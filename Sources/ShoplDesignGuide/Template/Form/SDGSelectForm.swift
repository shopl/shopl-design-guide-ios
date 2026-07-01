//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

public struct SDGSelectForm: View {

  private let title: String
  private let iconList: [FormIconModel]?
  private let type: FormType
  private let isRequiered: Bool
  private let inputModel: SDGSelectInput.SelectInputModel

  private let onRefresh: () -> Void
  private let onSelect: () -> Void

  public init(
    title: String,
    iconList: [FormIconModel]? = nil,
    type: FormType,
    isRequiered: Bool = false,
    inputModel: SDGSelectInput.SelectInputModel,
    onRefresh: @escaping () -> Void,
    onSelect: @escaping () -> Void
  ) {
    self.title = title
    self.iconList = iconList
    self.type = type
    self.isRequiered = isRequiered
    self.inputModel = inputModel
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

        if let iconList = iconList,
           !iconList.isEmpty {

          HStack(spacing: 0) {
            ForEach(iconList.indices, id: \.self) { index in
              let icon = iconList[index]

              Button {
                icon.onImageTap?()
              } label: {
                ZStack {
                  icon.image
                    .resizable()
                    .foregroundStyle(icon.tintColor)
                    .frame(width: 14, height: 14)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 4)
                }
              }
              .buttonStyle(NoTapAnimationButtonStyle())
            }
          }
        }

        Spacer(minLength: 8)

        if inputModel.status == .completed && !isRequiered {
          Button {
            onRefresh()
          } label: {
            ZStack {
              Image(sdg: .icCommonRefresh)
                .renderingMode(.template)
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

      SDGSelectInput(model: inputModel) { item in
        onSelect()
      }
    }
  }
}

#Preview {
  VStack {
    SDGSelectForm(
      title: "타이틀",
      type: .empha,
      inputModel: .init(
        item: .init(text: nil, placeholder: "입력"),
        backgroundColor: .neutral50,
        status: .default
      ),
      onRefresh: { },
      onSelect: { }
    )

    SDGSelectForm(
      title: "타이틀",
      iconList: [FormIconModel(image: Image(sdg: .icCommonEdit), tintColor: .neutral400)],
      type: .empha,
      isRequiered: true,
      inputModel: .init(
        item: .init(text: nil, placeholder: "입력"),
        backgroundColor: .neutral50,
        status: .default
      ),
      onRefresh: { },
      onSelect: { }
    )

    SDGSelectForm(
      title: "타이틀",
      iconList: [FormIconModel(image: Image(sdg: .icCommonEdit), tintColor: .neutral600)],
      type: .empha,
      isRequiered: true,
      inputModel: .init(
        item: .init(text: "입력했음", placeholder: "입력"),
        backgroundColor: .neutral50,
        status: .completed
      ),
      onRefresh: { },
      onSelect: { }
    )

    SDGSelectForm(
      title: "타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 ",
      type: .empha,
      isRequiered: true,
      inputModel: .init(
        item: .init(text: "입력했음", placeholder: "입력"),
        backgroundColor: .neutral50,
        status: .completed
      ),
      onRefresh: { },
      onSelect: { }
    )

    SDGSelectForm(
      title: "타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 ",
      iconList: [
        FormIconModel(image: Image(sdg: .icCommonEdit), tintColor: .neutral600),
        FormIconModel(image: Image(sdg: .icClip), tintColor: .neutral600)
      ],
      type: .empha,
      inputModel: .init(
        item: .init(text: "입력했음", placeholder: "입력"),
        backgroundColor: .neutral50,
        status: .completed
      ),
      onRefresh: { },
      onSelect: { }
    )

    SDGSelectForm(
      title: "imageArea 있는 케이스",
      type: .empha,
      inputModel: .init(
        item: .init(text: "입력했음", placeholder: "입력") {
          SDG.Image.icBarcode.image
            .templateIcon(size: 20, color: SDG.Color.neutral700.color)
        },
        backgroundColor: .neutral50,
        status: .completed
      ),
      onRefresh: { },
      onSelect: { }
    )
  }
  .padding(20)
}
