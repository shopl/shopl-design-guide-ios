//
//  SDGBoxBadge.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGBoxBadge: View {
  
  public enum `Type`: Equatable {
    case solid(SolidColor)
    case line(LineColor)
  }
  
  public enum ImageDirection: Equatable {
    case left(Image)
    case right(Image)
    
    public var isLeft: Bool {
      switch self {
      case .left: return true
      case .right: return false
      }
    }
  }
  
  public struct Spec {
    let height: CGFloat
    let cornerRadius: CGFloat
    let typo: SDG.Typography
    let horizontalPadding: CGFloat
    let gap: CGFloat
    
    public init(
      height: CGFloat,
      cornerRadius: CGFloat,
      typo: SDG.Typography,
      horizontalPadding: CGFloat,
      gap: CGFloat
    ) {
      self.height = height
      self.cornerRadius = cornerRadius
      self.typo = typo
      self.horizontalPadding = horizontalPadding
      self.gap = gap
    }
    
    public static let XSmall: Self = .init(
      height: 20,
      cornerRadius: 6,
      typo: .body3_R,
      horizontalPadding: 4,
      gap: 4
    )
  }
  
  public struct SolidColor: Equatable {
    let backgroundColor: Color?
    let textColor: Color
    
    public init(
      backgroundColor: Color? = nil,
      textColor: Color
    ) {
      self.backgroundColor = backgroundColor
      self.textColor = textColor
    }
  }
  
  public struct LineColor: Equatable {
    let backgroundColor: Color?
    let textColor: Color
    let borderColor: Color
    
    public init(
      backgroundColor: Color? = nil,
      textColor: Color,
      borderColor: Color
    ) {
      self.backgroundColor = backgroundColor
      self.textColor = textColor
      self.borderColor = borderColor
    }
  }
  
  public let text: String
  public let type: `Type`
  public let spec: Spec
  public let imageDirection: ImageDirection?
  
  public init(
    text: String,
    type: `Type`,
    spec: Spec = .XSmall,
    imageDirection: ImageDirection? = nil
  ) {
    self.text = text
    self.type = type
    self.spec = spec
    self.imageDirection = imageDirection
  }
  
  public var body: some View {
    content
      .frame(height: spec.height)
      .padding(.horizontal, spec.horizontalPadding)
      .background(backgroundView)
      .overlay(borderView)
      .clipShape(RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous))
      .fixedSize(horizontal: true, vertical: true)
  }

  private var textColor: Color {
    switch type {
    case .solid(let solid): return solid.textColor
    case .line(let line): return line.textColor
    }
  }
}

private extension SDGBoxBadge {
  
  @ViewBuilder
  private var content: some View {
    HStack(spacing: spec.gap) {
      if let imageDirection, imageDirection.isLeft {
        iconView(imageDirection)
      }
      
      Text(text)
        .typo(spec.typo)
        .foregroundStyle(textColor)
        .lineLimit(1)
      
      if let imageDirection, !imageDirection.isLeft {
        iconView(imageDirection)
      }
    }
  }
  
  @ViewBuilder
  private func iconView(_ direction: ImageDirection) -> some View {
    let image: Image = {
      switch direction {
      case .left(let image), .right(let image):
        return image
      }
    }()
    
    image
      .renderingMode(.template)
      .resizable()
      .scaledToFit()
      .frame(width: 14, height: 14)
      .foregroundStyle(textColor)
  }
  
  @ViewBuilder
  private var backgroundView: some View {
    Group {
      switch type {
      case .solid(let solid):
        (solid.backgroundColor ?? .clear)
      case .line(let line):
        (line.backgroundColor ?? .clear)
      }
    }
  }
  
  @ViewBuilder
  private var borderView: some View {
    switch type {
    case .solid:
      EmptyView()
    case .line(let line):
      RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous)
        .stroke(line.borderColor, lineWidth: 1)
    }
  }
}

#Preview("SDGBoxBadge / Solid") {
  VStack(alignment: .leading, spacing: 12) {
    SDGBoxBadge(
      text: "Solid / Text only",
      type: .solid(.init(backgroundColor: .primary300, textColor: .neutral0)),
      imageDirection: nil
    )
    
    SDGBoxBadge(
      text: "Solid / Icon Left",
      type: .solid(.init(backgroundColor: .primary300, textColor: .neutral0)),
      imageDirection: .left(.init(sdg: .emptyMember))
    )
    
    SDGBoxBadge(
      text: "Solid / Icon Right",
      type: .solid(.init(backgroundColor: .primary300, textColor: .neutral0)),
      imageDirection: .right(.init(sdg: .emptyMember))
    )
    
    SDGBoxBadge(
      text: "Solid / Background Clear",
      type: .solid(.init(backgroundColor: nil, textColor: .primary300)),
      imageDirection: nil
    )
    
    SDGBoxBadge(
      text: "Solid / Long label long label",
      type: .solid(.init(backgroundColor: .primary300, textColor: .neutral0)),
      imageDirection: .left(.init(sdg: .emptyMember))
    )
  }
  .padding()
}

#Preview("SDGBoxBadge / Line") {
  VStack(alignment: .leading, spacing: 12) {
    SDGBoxBadge(
      text: "Line / Text only",
      type: .line(.init(backgroundColor: .neutral0, textColor: .primary300, borderColor: .primary300)),
      imageDirection: nil
    )
    
    SDGBoxBadge(
      text: "Line / Icon Left",
      type: .line(.init(backgroundColor: .neutral0, textColor: .primary300, borderColor: .primary300)),
      imageDirection: .left(.init(sdg: .emptyMember))
    )
    
    SDGBoxBadge(
      text: "Line / Icon Right",
      type: .line(.init(backgroundColor: .neutral0, textColor: .primary300, borderColor: .primary300)),
      imageDirection: .right(.init(sdg: .emptyMember))
    )
    
    SDGBoxBadge(
      text: "Line / Background Clear",
      type: .line(.init(backgroundColor: nil, textColor: .primary300, borderColor: .primary300)),
      imageDirection: nil
    )
  }
  .padding()
}
