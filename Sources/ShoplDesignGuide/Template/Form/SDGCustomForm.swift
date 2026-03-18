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
  private let isRequiered: Bool
  private let icon: FormIconModel?
  private let onRefresh: () -> Void
  private let bodyArea: Body
  @Binding private var state: SDGSimpleInput.InputState
  
  public init(
    title: String,
    type: FormType,
    isRequiered: Bool,
    icon: FormIconModel? = nil,
    onRefresh: @escaping () -> Void,
    @ViewBuilder bodyArea: @escaping () -> Body,
    state: Binding<SDGSimpleInput.InputState>
  ) {
    self.title = title
    self.type = type
    self.isRequiered = isRequiered
    self.icon = icon
    self.onRefresh = onRefresh
    self.bodyArea = bodyArea()
    self._state = state
  }
  
  public var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 0) {
        titleLabel
        
        if let icon = icon {
          titleIcon(icon)
        }
        
        Spacer(minLength: 8)
        
        if !isRequiered {
          refreshIcon
        }
      }
      
      bodyArea
    }
  }
}

extension SDGCustomForm {
  var titleLabel: some View {
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
  
  var refreshIcon: some View {
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

struct SDGCustomForm_Wrapper: View {
  
  @State var inputState: SDGSimpleInput.InputState = .default
  
  var body: some View {
    VStack {
      SDGCustomForm(
        title: "커스텀 폼 타이틀",
        type: .normal,
        isRequiered: false,
        icon: .init(image: SDG.Image.icAligndown.image,
                    tintColor: .neutral700),
        onRefresh: {
          inputState = .default
        },
        bodyArea: {
          ZStack {
            Text("body area")
          }
          .frame(maxWidth: .infinity, maxHeight: 150)
          .background(.neutral150)
        },
        state: $inputState
      )
      
      SDGCustomForm(
        title: "커스텀 폼 타이틀",
        type: .empha,
        isRequiered: false,
        onRefresh: {
          inputState = .default
        },
        bodyArea: {
          ZStack {
            Text("body area")
          }
          .frame(maxWidth: .infinity, maxHeight: 150)
          .background(.neutral150)
        },
        state: $inputState
      )
      
      SDGCustomForm(
        title: "커스텀 폼 타이틀",
        type: .empha,
        isRequiered: true,
        onRefresh: {
          inputState = .default
        },
        bodyArea: {
          ZStack {
            Text("body area")
          }
          .frame(maxWidth: .infinity, maxHeight: 150)
          .background(.neutral150)
        },
        state: $inputState
      )
      
      SDGCustomForm(
        title: "타이틀이 긴 경우 타이틀이 긴 경우 타이틀이 긴 경우 타이틀이 긴 경우 타이틀이 긴 경우 타이틀이 긴 경우",
        type: .normal,
        isRequiered: false,
        icon: .init(image: SDG.Image.icAligndown.image,
                    tintColor: .neutral700),
        onRefresh: {
          inputState = .default
        },
        bodyArea: {
          ZStack {
            Text("body area")
          }
          .frame(maxWidth: .infinity, maxHeight: 150)
          .background(.neutral150)
        },
        state: $inputState
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
