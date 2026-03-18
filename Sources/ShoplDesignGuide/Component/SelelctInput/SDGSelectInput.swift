//
//  SDGSelectInput.swift
//  ShoplDesignGuide
//
//  Created by dino on 3/5/26.
//

import SwiftUI

public struct SDGSelectInput<ImageArea: View>: View {
  
  private let model: SelectInputModel
  private let onTapped: (SelectInputModel.SelectInputItem) -> Void
  
  public struct SelectInputModel {
    let items: [SelectInputItem]
    let backgroundColor: BackgroundColor
    let status: Status
    
    public struct SelectInputItem: Hashable {
      public static func == (lhs: SelectInputItem, rhs: SelectInputItem) -> Bool {
        lhs.text == rhs.text
      }
      
      public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
      }
      
      let imageArea: ImageArea?
      let text: String?
      let placeholder: String
      
      public init(text: String?, placeholder: String, @ViewBuilder imageArea: () -> ImageArea) {
        self.imageArea = imageArea()
        self.text = text
        self.placeholder = placeholder
      }
    }
    
    public enum BackgroundColor {
      case neutral50
      case neutral0
      
      var sdgColor: SDG.Color {
        switch self {
        case .neutral50:
          SDG.Color.neutral50
        case .neutral0:
          SDG.Color.neutral0
        }
      }
    }
    
    public enum Status {
      case `default`
      case completed
      case disabled
      case error
    }
  }
  
  public init(
    model: SelectInputModel,
    onTapped: @escaping (SelectInputModel.SelectInputItem) -> Void
  ) {
    self.model = model
    self.onTapped = onTapped
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: 10) {
      VStack(spacing: 0) {
        ForEach(model.items, id: \.self) { item in
          HStack(alignment: .center, spacing: 10) {
            item.imageArea
            
            if let text = item.text,
               model.status != .default,
               model.status != .error {
              Text(text)
                .typo(.body1_R, model.status != .disabled ? .neutral700 : .neutral300)
                .frame(maxWidth: .infinity, alignment: .leading)
                .truncationMode(.middle)
            } else {
              Text(item.placeholder)
                .typo(.body1_R, .neutral300)
                .frame(maxWidth: .infinity, alignment: .leading)
                .truncationMode(.middle)
            }
          }
          .frame(height: 40)
          .contentShape(Rectangle())
          .onTapGesture {
            onTapped(item)
          }
        }
      }
      
      SDG.Image.icCommonNext.image
        .templateIcon(size: 24, color: model.status != .disabled ? SDG.Color.neutral700.color : SDG.Color.neutral300.color)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, model.items.count > 1 ? 2 : 0)
    .background(model.status == .error ? SDG.Color.red300_10.color : model.backgroundColor.sdgColor.color)
    .cornerRadius(12)
    .allowsHitTesting(model.status != .disabled)
  }
}

extension SDGSelectInput.SelectInputModel.SelectInputItem where ImageArea == EmptyView {
  public init(text: String?, placeholder: String) {
    self.imageArea = nil
    self.text = text
    self.placeholder = placeholder
  }
}

extension SDGSelectInput.SelectInputModel {
  public init(item: SelectInputItem, backgroundColor: BackgroundColor, status: Status) {
    self.init(items: [item], backgroundColor: backgroundColor, status: status)
  }
}

extension SDGSelectInput where ImageArea == EmptyView {
  public init(
    model: SelectInputModel,
    onTapped: @escaping (SelectInputModel.SelectInputItem) -> Void
  ) {
    self.model = model
    self.onTapped = onTapped
  }
}

#Preview {
  VStack {
    SDGSelectInput(
      model: .init(
        item: .init(text: "Default Input", placeholder: "placeholder"),
        backgroundColor: .neutral50,
        status: .default
      )
    ) { item in
      print(item.text)
    }
    
    SDGSelectInput(
      model: .init(
        item: .init(text: "Completed Input", placeholder: "placeholder"),
        backgroundColor: .neutral50,
        status: .completed
      )
    ) { item in
      print(item.text)
    }
    
    SDGSelectInput(
      model: .init(
        item: .init(text: "Disabled Input", placeholder: "placeholder"),
        backgroundColor: .neutral50,
        status: .disabled
      )
    ) { item in
      print(item.text)
    }
    
    SDGSelectInput(
      model: .init(
        item: .init(text: "Error Input", placeholder: "placeholder"),
        backgroundColor: .neutral50,
        status: .error
      )
    ) { item in
      print(item.text)
    }
    
    SDGSelectInput(
      model: .init(
        item: .init(text: "Input with Image", placeholder: "placeholder") {
          SDG.Image.icBarcode.image
            .templateIcon(size: 20, color: SDG.Color.neutral700.color)
        },
        backgroundColor: .neutral50,
        status: .completed
      )
    ) { item in
      print(item.text)
    }
    
    SDGSelectInput(
      model: .init(
        items: [
          .init(text: "A", placeholder: "placeholder") {
            SDG.Image.icBarcode.image
              .templateIcon(
                size: 20,
                color: SDG.Color.neutral700.color
              )
          },
          .init(text: "B", placeholder: "placeholder") {
            SDG.Image.icBarcode.image
              .templateIcon(
                size: 20,
                color: SDG.Color.neutral700.color
              )
          }
        ],
        backgroundColor: .neutral50,
        status: .completed
      )
    ) { item in
      print(item.text)
    }
  }
  .padding()
}
