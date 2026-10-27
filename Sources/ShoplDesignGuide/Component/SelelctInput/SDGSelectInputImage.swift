//
//  SDGSelectInputImage.swift
//  ShoplDesignGuide
//
//  Created by kai on 10/14/26.
//

import SwiftUI

extension SDGSelectInput {
  /// SelectInput의 1 Image / 2 Image 요소에 사용하는 이미지입니다.
  public struct SelectedElementImage: View {
    public enum ImageType: CaseIterable, Sendable {
      /// 30×30pt Neutral200 배경, Radius15, 중앙 14×14pt 아이콘.
      case withCircular
      /// 24×24pt 이미지.
      case square
      /// 52×20pt 이미지 영역.
      case rectangle
    }

    private let image: Image
    private let type: ImageType

    public nonisolated init(image: Image, type: ImageType) {
      self.image = image
      self.type = type
    }

    public var body: some View {
      if type == .withCircular {
        resizedImage
          .frame(width: 30, height: 30)
          .background(SDG.Color.neutral200.color)
          .clipShape(RoundedRectangle(cornerRadius: 15))
      } else {
        resizedImage
      }
    }

    private var resizedImage: some View {
      image
        .resizable()
        .scaledToFit()
        .frame(width: imageSize.width, height: imageSize.height)
    }

    private var imageSize: CGSize {
      switch type {
      case .withCircular: CGSize(width: 14, height: 14)
      case .square: CGSize(width: 24, height: 24)
      case .rectangle: CGSize(width: 52, height: 20)
      }
    }
  }
}
