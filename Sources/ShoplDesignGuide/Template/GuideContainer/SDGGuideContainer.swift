//
//  SDGGuideContainer.swift
//  ShoplDesignGuide
//
//  Created by dino on 3/16/26.
//

import SwiftUI

public struct SDGGuideContainer<Body: View>: View {
  
  private let model: Model
  private let contentArea: Body
  
  public struct Model {
    let message: String?
    let messageColor: SDG.Color
    
    public init(message: String?, messageColor: SDG.Color) {
      self.message = message
      self.messageColor = messageColor
    }
  }
  
  public init(
    model: Model,
    @ViewBuilder contentArea: @escaping () -> Body,
  ) {
    self.model = model
    self.contentArea = contentArea()
  }
  
  public var body: some View {
    VStack(spacing: 10) {
      contentArea
      
      message
    }
  }
  
  @ViewBuilder
  private var message: some View {
    if let message = model.message {
      Text(message)
        .typo(.body3_R, model.messageColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    SDGGuideContainer(
      model: .init(
        message: "meassage area",
        messageColor: .red300
      )
    ) {
      SDGSelectForm(
        title: "Select Form",
        type: .normal,
        selectedText: nil,
        placeHolder: "입력",
        onRefresh: {},
        onSelect: {}
      )
    }
    
    SDGGuideContainer(
      model: .init(
        message: nil,
        messageColor: .red300
      )
    ) {
      SDGSelectForm(
        title: "Select Form",
        type: .normal,
        selectedText: nil,
        placeHolder: "입력",
        onRefresh: {},
        onSelect: {}
      )
    }
  }
  .padding()
}
