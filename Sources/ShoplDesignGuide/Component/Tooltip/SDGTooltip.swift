//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

struct TooltipModifier: ViewModifier {
  let text: String
  let direction: SDGTooltipDirection
  let spec: SDGTooltipSpec
  let textColor: Color
  let backgroundColor: Color
  let maxWidth: CGFloat
  
  @Binding var isPresented: Bool
  @State private var targetFrame: CGRect = .zero
  
  private let arrowSize = CGSize(width: 7, height: 5)
  private let cornerRadius: CGFloat = 4
  private let spacing: CGFloat = 8
  private let screenPadding: CGFloat = 8
  private let arrowHorizontalInset: CGFloat = 10
  
  func body(content: Content) -> some View {
    content
      .background(frameReader)
      .overlay(alignment: .center) {
        if isPresented {
          tooltipView
            .allowsHitTesting(false)
            .zIndex(1000)
        }
      }
  }
  
  private var frameReader: some View {
    GeometryReader { geometry in
      Color.clear
        .preference(key: FramePreferenceKey.self,
                    value: geometry.frame(in: .global))
    }
    .onPreferenceChange(FramePreferenceKey.self) { frame in
      DispatchQueue.main.async {
        targetFrame = frame
      }
    }
  }
  
  private var tooltipView: some View {
    TooltipContent(
      text: text,
      textColor: textColor,
      textSize: tooltipTextSize,
      backgroundColor: backgroundColor,
      fontSize: spec.fontSize,
      padding: EdgeInsets(
        top: spec.verticalPadding,
        leading: spec.horizontalPadding,
        bottom: spec.verticalPadding,
        trailing: spec.horizontalPadding
      ),
      cornerRadius: cornerRadius,
      arrow: arrowConfig
    )
    .fixedSize()
    .offset(tooltipOffset)
  }
  
  private var arrowConfig: SDGArrowConfig {
    SDGArrowConfig(
      position: arrowPosition,
      size: arrowSize,
      offset: arrowOffset
    )
  }
  
  private var arrowPosition: SDGArrowPosition {
    switch resolvedDirection {
    case .top, .topLeading, .topTrailing: return .bottom
    case .bottom, .bottomLeading, .bottomTrailing: return .top
    case .leading: return .trailing
    case .trailing: return .leading
    }
  }
  
  private var arrowOffset: CGFloat {
    switch resolvedDirection {
    case .topLeading, .bottomLeading:
      return clampedArrowOffset(-tooltipSize.width / 2 + arrowHorizontalInset)
    case .topTrailing, .bottomTrailing:
      return clampedArrowOffset(tooltipSize.width / 2 - arrowHorizontalInset)
    case .top, .bottom:
      return 0
    default:
      return 0
    }
  }
  
  private func clampedArrowOffset(_ value: CGFloat) -> CGFloat {
    let limit = max(0, tooltipSize.width / 2 - arrowHorizontalInset)
    return min(max(value, -limit), limit)
  }

  private var screenBounds: CGRect {
    UIScreen.main.bounds
  }

  private var tooltipPaddingWidth: CGFloat {
    spec.horizontalPadding * 2
  }

  private var tooltipTextSize: CGSize {
    textSize(for: effectiveMaxWidth)
  }
  
  private var tooltipSize: CGSize {
    tooltipContainerSize(for: tooltipTextSize)
  }

  private var preferredTooltipSize: CGSize {
    tooltipContainerSize(for: textSize(for: maxWidth))
  }

  // resolvedDirection에서도 넘칠 때만 width를 줄인다.
  private var effectiveMaxWidth: CGFloat {
    guard shouldLimitTooltipWidth else {
      return maxWidth
    }

    let availableTextWidth = availableTextWidth(for: resolvedDirection)

    guard availableTextWidth > 0 else {
      return maxWidth
    }

    return min(maxWidth, availableTextWidth)
  }

  private var shouldLimitTooltipWidth: Bool {
    !placementFitsHorizontally(
      direction: resolvedDirection,
      tooltipSize: preferredTooltipSize
    )
  }
  
  private var tooltipOffset: CGSize {
    calculateBaseOffset(for: resolvedDirection)
  }

  private var resolvedDirection: SDGTooltipDirection {
    switch direction {
    case .top:
      return resolvedVerticalDirection(
        centered: .top,
        leading: .topLeading,
        trailing: .topTrailing
      )
    case .bottom:
      return resolvedVerticalDirection(
        centered: .bottom,
        leading: .bottomLeading,
        trailing: .bottomTrailing
      )
    default:
      return direction
    }
  }

  private func resolvedVerticalDirection(
    centered: SDGTooltipDirection,
    leading: SDGTooltipDirection,
    trailing: SDGTooltipDirection
  ) -> SDGTooltipDirection {
    switch horizontalOverflow(for: centered, tooltipSize: preferredTooltipSize) {
    case .left:
      return leading
    case .right:
      return trailing
    case .none:
      return centered
    }
  }

  // direction / size 기준 가로 overflow 방향을 계산한다.
  private func horizontalOverflow(
    for direction: SDGTooltipDirection,
    tooltipSize: CGSize
  ) -> HorizontalOverflow {
    let horizontalRange = tooltipHorizontalRange(
      for: direction,
      tooltipSize: tooltipSize
    )

    if horizontalRange.lowerBound < screenPadding {
      return .left
    }

    if horizontalRange.upperBound > screenBounds.width - screenPadding {
      return .right
    }

    return .none
  }

  private func placementFitsHorizontally(
    direction: SDGTooltipDirection,
    tooltipSize: CGSize
  ) -> Bool {
    horizontalOverflow(for: direction, tooltipSize: tooltipSize) == .none
  }

  // offset 적용 후 tooltip의 실제 가로 범위를 계산한다.
  private func tooltipHorizontalRange(
    for direction: SDGTooltipDirection,
    tooltipSize: CGSize
  ) -> ClosedRange<CGFloat> {
    let offset = calculateBaseOffset(for: direction, tooltipSize: tooltipSize)
    let midX = targetFrame.midX + offset.width
    let halfWidth = tooltipSize.width / 2

    return (midX - halfWidth)...(midX + halfWidth)
  }

  // 현재 direction에서 사용할 수 있는 최대 텍스트 폭을 계산한다.
  private func availableTextWidth(for direction: SDGTooltipDirection) -> CGFloat {
    let availableTooltipWidth: CGFloat

    switch direction {
    case .top, .bottom:
      // centered는 좌우 공간을 모두 만족해야 한다.
      let leftSpace = max(targetFrame.midX - screenPadding, 0)
      let rightSpace = max(screenBounds.width - screenPadding - targetFrame.midX, 0)
      availableTooltipWidth = min(leftSpace, rightSpace) * 2
    case .topLeading, .bottomLeading, .trailing:
      // 왼쪽 edge 정렬이므로 오른쪽 공간만 본다.
      availableTooltipWidth = max(screenBounds.width - screenPadding - targetFrame.minX, 0)
    case .topTrailing, .bottomTrailing, .leading:
      // 오른쪽 edge 정렬이므로 왼쪽 공간만 본다.
      availableTooltipWidth = max(targetFrame.maxX - screenPadding, 0)
    }

    return max(availableTooltipWidth - tooltipPaddingWidth, 1)
  }
  
  private func calculateBaseOffset(for direction: SDGTooltipDirection) -> CGSize {
    calculateBaseOffset(for: direction, tooltipSize: tooltipSize)
  }

  private func calculateBaseOffset(
    for direction: SDGTooltipDirection,
    tooltipSize: CGSize
  ) -> CGSize {
    let halfTargetHeight = targetFrame.height / 2
    let halfTargetWidth = targetFrame.width / 2
    let halfTooltipHeight = tooltipSize.height / 2
    let halfTooltipWidth = tooltipSize.width / 2
    
    // overlay 기준점이 target center라서 offset도 center 기준으로 계산한다.
    // leading/trailing은 bubble edge를 target edge에 맞춘다.
    switch direction {
    case .top:
      return CGSize(width: 0, height: -(halfTargetHeight + halfTooltipHeight + spacing))
    case .bottom:
      return CGSize(width: 0, height: halfTargetHeight + halfTooltipHeight + spacing)
    case .leading:
      return CGSize(width: -(halfTargetWidth + halfTooltipWidth + spacing), height: 0)
    case .trailing:
      return CGSize(width: halfTargetWidth + halfTooltipWidth + spacing, height: 0)
    case .topLeading:
      return CGSize(
        width: -halfTargetWidth + halfTooltipWidth,
        height: -(halfTargetHeight + halfTooltipHeight + spacing)
      )
    case .topTrailing:
      return CGSize(
        width: halfTargetWidth - halfTooltipWidth,
        height: -(halfTargetHeight + halfTooltipHeight + spacing)
      )
    case .bottomLeading:
      return CGSize(
        width: -halfTargetWidth + halfTooltipWidth,
        height: halfTargetHeight + halfTooltipHeight + spacing
      )
    case .bottomTrailing:
      return CGSize(
        width: halfTargetWidth - halfTooltipWidth,
        height: halfTargetHeight + halfTooltipHeight + spacing
      )
    }
  }

  private func textSize(for maxWidth: CGFloat) -> CGSize {
    text.size(
      withFont: .systemFont(ofSize: spec.fontSize, weight: .semibold),
      maxWidth: maxWidth
    )
  }

  private func tooltipContainerSize(for textSize: CGSize) -> CGSize {
    CGSize(
      width: textSize.width + tooltipPaddingWidth,
      height: textSize.height + spec.verticalPadding * 2
    )
  }
  
}

private enum HorizontalOverflow {
  case left
  case right
  case none
}

struct TooltipContent: View {
  let text: String
  let textColor: Color
  let textSize: CGSize
  let backgroundColor: Color
  let fontSize: CGFloat
  let padding: EdgeInsets
  let cornerRadius: CGFloat
  let arrow: SDGArrowConfig
  
  var body: some View {
    VStack(spacing: 0) {
      if arrow.position == .top {
        SDGArrowView(config: arrow, color: backgroundColor)
      }
      
      HStack(spacing: -1) {
        if arrow.position == .leading {
          SDGArrowView(config: arrow, color: backgroundColor)
        }
        
        Text(text)
          .foregroundColor(textColor)
          .font(.system(size: fontSize, weight: .semibold))
          .multilineTextAlignment(.center)
          .frame(width: textSize.width, height: textSize.height)
          .padding(padding)
          .background(backgroundColor)
          .cornerRadius(cornerRadius)
        
        if arrow.position == .trailing {
          SDGArrowView(config: arrow, color: backgroundColor)
        }
      }
      
      if arrow.position == .bottom {
        SDGArrowView(config: arrow, color: backgroundColor)
      }
    }
  }
}

struct FramePreferenceKey: PreferenceKey {
  static let defaultValue: CGRect = .zero
  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

struct TooltipView_Wrapped: View {
  @State private var showTooltip = false
  @State private var currentDirection: SDGTooltipDirection = .top
  
  var body: some View {
    VStack(spacing: 30) {
      Text("Tooltip Demo")
        .font(.title)
        .padding(.bottom, 100)
      
      Button("Show") {
        showTooltip.toggle()
      }
      .padding()
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(8)
      .tooltip(
        "tooltip",
        direction: currentDirection,
        spec: .medium,
        maxWidth: 150,
        isPresented: $showTooltip
      )
      
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
        ForEach(SDGTooltipDirection.allCases, id: \.self) { direction in
          Button("\(String(describing: direction))") {
            currentDirection = direction
            showTooltip = true
          }
          .padding(8)
          .background(Color.gray.opacity(0.2))
          .cornerRadius(4)
          .font(.caption)
        }
      }
      .padding()
      
      Spacer()
    }
    .padding()
  }
}

struct TooltipView_Previews: PreviewProvider {
  static var previews: some View {
    TooltipView_Wrapped()
  }
}
