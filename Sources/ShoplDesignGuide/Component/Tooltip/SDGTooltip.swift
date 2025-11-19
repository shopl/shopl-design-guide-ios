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
      textSize: text.size(
        withFont: .systemFont(ofSize: spec.fontSize, weight: .semibold),
        maxWidth: maxWidth
      ),
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
    switch direction {
    case .top, .topLeading, .topTrailing: return .bottom
    case .bottom, .bottomLeading, .bottomTrailing: return .top
    case .leading: return .trailing
    case .trailing: return .leading
    }
  }
  
  private var arrowOffset: CGFloat {
    switch direction {
    case .topLeading, .bottomLeading:
      return -tooltipSize.width/2 + 10
    case .topTrailing, .bottomTrailing:
      return tooltipSize.width/2 - 10
    default:
      return 0
    }
  }
  
  private var tooltipSize: CGSize {
    let textSize = text.size(
      withFont: .systemFont(ofSize: spec.fontSize, weight: .semibold),
      maxWidth: maxWidth
    )
    
    return CGSize(
      width: textSize.width + spec.horizontalPadding * 2,
      height: textSize.height + spec.verticalPadding * 2
    )
  }
  
  private var tooltipOffset: CGSize {
    let baseOffset = calculateBaseOffset()
    return applyScreenBoundsAdjustment(to: baseOffset)
  }
  
  private func calculateBaseOffset() -> CGSize {
    let halfTargetHeight = targetFrame.height / 2
    let halfTargetWidth = targetFrame.width / 2
    let halfTooltipHeight = tooltipSize.height / 2
    let halfTooltipWidth = tooltipSize.width / 2
    
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
  
  private func applyScreenBoundsAdjustment(to offset: CGSize) -> CGSize {
    let screenBounds = UIScreen.main.bounds
    var adjustedOffset = offset
    
    let tooltipGlobalX = targetFrame.midX + offset.width
    let tooltipLeft = tooltipGlobalX - tooltipSize.width/2
    let tooltipRight = tooltipGlobalX + tooltipSize.width/2
    
    if tooltipLeft < screenPadding {
      adjustedOffset.width += (screenPadding - tooltipLeft)
    } else if tooltipRight > screenBounds.width - screenPadding {
      adjustedOffset.width -= (tooltipRight - (screenBounds.width - screenPadding))
    }
    
    return adjustedOffset
  }
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
