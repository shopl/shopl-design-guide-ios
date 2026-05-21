//
//  SDGCustomForm.swift
//  ShoplDesignGuide
//
//  Created by dino on 3/5/26.
//

import SwiftUI

public struct SDGCustomForm<Body: View>: View {
  
  private let title: String
  private let type: FormType
  private let isRequired: Bool
  private let icon: FormIconModel?
  private let onRefresh: (() -> Void)?
  private let bodyArea: Body
  private var status: Status
  
  public enum Status {
    case `default`
    case completed
    case disabled
    case error
  }
  
  public init(
    title: String,
    type: FormType,
    isRequiered: Bool,
    icon: FormIconModel? = nil,
    onRefresh: (() -> Void)?,
    @ViewBuilder bodyArea: @escaping () -> Body,
    status: Status
  ) {
    self.title = title
    self.type = type
    self.isRequired = isRequiered
    self.icon = icon
    self.onRefresh = onRefresh
    self.bodyArea = bodyArea()
    self.status = status
  }
  
  public var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 0) {
        titleLabel
        
        if let icon = icon {
          titleIcon(icon)
        }
        
        Spacer(minLength: 8)
        
        refreshIcon
      }
      
      bodyArea
    }
  }
}

extension SDGCustomForm {
  var titleLabel: some View {
    Text("")
      .attributeText(
        fullText: isRequired ? "\(title)*" : title,
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
  }
  
  func titleIcon(_ icon : FormIconModel) -> some View {
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
  
  @ViewBuilder
  var refreshIcon: some View {
    if let onRefresh,
       !isRequired,
       self.status == .completed {
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
}

struct SDGCustomForm_Wrapper: View {
  @State var simpleInputText: String = ""
  @State var inputState: SDGSimpleInput.InputState = .default

  var body: some View {
    VStack {
      SDGCustomForm(
        title: "커스텀 폼 타이틀 1",
        type: .normal,
        isRequiered: false,
        icon: .init(image: SDG.Image.icAligndown.image,
                    tintColor: .neutral700),
        onRefresh: {
          simpleInputText = ""
          inputState = .default
        },
        bodyArea: {
          SDGSimpleInput(
            type: .solid,
            state: $inputState,
            text: $simpleInputText,
            hint: "입력"
          )
          .onChange(of: simpleInputText) { newValue in
            inputState = newValue.isEmpty ? .default : .completed
          }
        },
        status: inputState == .default ? .default : .completed
      )

      SDGCustomForm(
        title: "커스텀 폼 타이틀 2",
        type: .empha,
        isRequiered: false,
        onRefresh: {
        },
        bodyArea: {
          ZStack {
            Text("body area")
          }
          .frame(maxWidth: .infinity, maxHeight: 150)
          .background(.neutral150)
        },
        status: .default
      )
      
      SDGCustomForm(
        title: "커스텀 폼 타이틀 3",
        type: .empha,
        isRequiered: true,
        onRefresh: {
        },
        bodyArea: {
          ZStack {
            Text("body area")
          }
          .frame(maxWidth: .infinity, maxHeight: 150)
          .background(.neutral150)
        },
        status: .default
      )
      
      SDGCustomForm(
        title: "타이틀이 긴 경우 타이틀이 긴 경우 타이틀이 긴 경우 타이틀이 긴 경우 타이틀이 긴 경우 타이틀이 긴 경우",
        type: .normal,
        isRequiered: false,
        icon: .init(image: SDG.Image.icAligndown.image,
                    tintColor: .neutral700),
        onRefresh: {
        },
        bodyArea: {
          ZStack {
            Text("body area")
          }
          .frame(maxWidth: .infinity, maxHeight: 150)
          .background(.neutral150)
        },
        status: .default
      )
    }
    .padding(20)
  }
}


struct SDGCustomForm_Preview: PreviewProvider {
  static var previews: some View {
    SDGCustomForm_Wrapper()
  }
}
