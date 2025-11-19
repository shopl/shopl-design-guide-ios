//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGIconLabel: View {
  
  public enum Size: Equatable {
    case large(isBold: Bool)
    case medium(isBold: Bool)
    case small(isBold: Bool)
    
    var typoSize: Typography {
      switch self {
      case let .large(isBold): return isBold ? .body1_SB : .body1_R
      case let .medium(isBold): return isBold ? .body2_SB : .body2_R
      case let .small(isBold): return isBold ? .body3_SB : .body3_R
      }
    }
    
    public static func == (lhs: SDGIconLabel.Size, rhs: SDGIconLabel.Size) -> Bool {
      switch (lhs, rhs) {
      case (.large(let lhsIsBold), .large(let rhsIsBold)):
        return lhsIsBold == rhsIsBold
      case (.medium(let lhsIsBold), .medium(let rhsIsBold)):
        return lhsIsBold == rhsIsBold
      case (.small(let lhsIsBold), .small(let rhsIsBold)):
        return lhsIsBold == rhsIsBold
      default: return false
      }
    }
  }
  
  public enum Spacing: CGFloat, Equatable {
    case two = 2
    case four = 4
  }
  
  private let size: Size
  private let spacing: Spacing
  private let leftImage: Image?
  private let rightImage: Image?
  private let title: String
  private let imageForegroundColor: Color
  private let titleColor: TypoColor
  private let lineLimit: Int?
  private let fullSize: Bool
  
  public init(
    size: Size,
    spacing: Spacing = .two,
    leftImage: Image? = nil,
    rightImage: Image? = nil,
    title: String,
    imageForegroundColor: Color,
    titleColor: TypoColor,
    lineLimit: Int? = nil,
    fullSize: Bool = false
  ) {
    self.size = size
    self.spacing = spacing
    self.leftImage = leftImage
    self.rightImage = rightImage
    self.title = title
    self.imageForegroundColor = imageForegroundColor
    self.titleColor = titleColor
    self.lineLimit = lineLimit
    self.fullSize = fullSize
  }
  
  public var body: some View {
    HStack(alignment: .top, spacing: self.spacing.rawValue) {
      if let image = leftImage {
        image
          .resizable()
          .frame(width: 14, height: 14)
          .foregroundStyle(self.imageForegroundColor)
          .padding(.top, 1)
      }
      
      Text(title)
        .typo(size.typoSize, titleColor)
        .applyIf(self.fullSize) {
          $0.frame(maxWidth: .infinity, alignment: .leading)
        }
        .multilineTextAlignment(.leading)
        .lineLimit(self.lineLimit)
        .fixedSize(horizontal: false, vertical: true)
      
      if let image = rightImage {
        image
          .resizable()
          .frame(width: 14, height: 14)
          .foregroundStyle(self.imageForegroundColor)
          .padding(.top, 1)
      }
    }
  }
}

#Preview {
  VStack {
    SDGIconLabel(
      size: .medium(isBold: false),
      leftImage: Image(.icCommonWarning),
      title: "이 직원에 대한 출퇴근 현황 조회 권한이 없습니다.",
      imageForegroundColor: .neutral400,
      titleColor: .neutral400,
      lineLimit: 1,
      fullSize: true
    )
    
    SDGIconLabel(
      size: .medium(isBold: false),
      leftImage: Image(.icCommonWarning),
      title: "선택한 항목 중, 스케줄 배정 규칙에 어긋난 스케줄 변경 신청 건이 있습니다.",
      imageForegroundColor: .red300,
      titleColor: .red300,
      fullSize: true
    )
    
    SDGIconLabel(
      size: .medium(isBold: false),
      rightImage: Image(.icView),
      title: "고정",
      imageForegroundColor: .neutral400,
      titleColor: .neutral400,
      lineLimit: 1
    )
    
    
    SDGIconLabel(
      size: .large(isBold: false),
      spacing: .four,
      leftImage: Image(.icCommonWarning),
      title: "텍스트가 길어질 경우 전체 노출이 필요한 경우는 줄바꿈이 될텐데 그랬을 때는 아이콘의 위치는 상단에 고정시킵니다.",
      imageForegroundColor: .red300,
      titleColor: .red300,
      fullSize: true
    )
  }
  .padding(20)
}
