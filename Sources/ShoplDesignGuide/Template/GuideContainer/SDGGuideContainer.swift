//
//  SDGGuideContainer.swift
//  ShoplDesignGuide
//
//  Created by dino on 3/16/26.
//

import SwiftUI

public struct SDGGuideContainer<Body: View>: View {
  public static var version: String { "2.3.27" }

  private let model: Model
  private let contentArea: Body
  
  public enum TextAlignment {
    case left
    case right

    var frameAlignment: Alignment {
      switch self {
      case .left: return .leading
      case .right: return .trailing
      }
    }

    var multilineTextAlignment: SwiftUI.TextAlignment {
      switch self {
      case .left: return .leading
      case .right: return .trailing
      }
    }
  }

  public struct Model {
    let text: String?
    let textColor: SDG.Color
    let textAlignment: TextAlignment
    
    public init(
      text: String?,
      textColor: SDG.Color = .neutral700,
      textAlignment: TextAlignment = .left
    ) {
      self.text = text
      self.textColor = textColor
      self.textAlignment = textAlignment
    }

    // 기존 message/messageColor API를 사용하는 호출부 호환용입니다.
    @available(*, deprecated, message: "Use init(text:textColor:textAlignment:) instead.")
    public init(
      message: String?,
      messageColor: SDG.Color
    ) {
      self.init(
        text: message,
        textColor: messageColor,
        textAlignment: .left
      )
    }
  }
  
  public init(
    model: Model,
    @ViewBuilder contentArea: @escaping () -> Body,
  ) {
    self.model = model
    self.contentArea = contentArea()
  }

  public init(
    text: String?,
    textColor: SDG.Color = .neutral700,
    textAlignment: TextAlignment = .left,
    @ViewBuilder contentArea: @escaping () -> Body,
  ) {
    self.init(
      model: .init(
        text: text,
        textColor: textColor,
        textAlignment: textAlignment
      ),
      contentArea: contentArea
    )
  }
  
  public var body: some View {
    VStack(spacing: 10) {
      contentArea
      
      guideText
    }
  }
  
  @ViewBuilder
  private var guideText: some View {
    if let text = model.text {
      Text(text)
        .typo(.body3_R, model.textColor)
        .frame(maxWidth: .infinity, alignment: model.textAlignment.frameAlignment)
        .multilineTextAlignment(model.textAlignment.multilineTextAlignment)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    SDGGuideContainer(
      model: .init(
        text: "text area",
        textColor: .red300,
        textAlignment: .left
      )
    ) {
      SDGSelectForm(
        title: "Select Form",
        type: .normal,
        inputModel: .init(
          placeholder: "입력",
          inputField: .white,
          state: .default
        ),
        onRefresh: {},
        onSelect: {}
      )
    }
    
    SDGGuideContainer(
      model: .init(
        text: "right aligned text area",
        textColor: .neutral700,
        textAlignment: .right
      )
    ) {
      SDGSelectForm(
        title: "Select Form",
        type: .normal,
        inputModel: .init(
          placeholder: "입력",
          inputField: .white,
          state: .default
        ),
        onRefresh: {},
        onSelect: {}
      )
    }
  }
  .padding()
}
