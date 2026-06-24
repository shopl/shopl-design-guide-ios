//
//  SDGSampleBottomSheet.swift
//  ShoplDesignGuide
//
//  Created by Codex on 6/24/26.
//

import SwiftUI
import UIKit
import ShoplDesignGuide

enum SDGSampleBottomSheetDetent: Hashable {
  case min
  case initial
  case max
  
  fileprivate func resolvedHeight(in containerHeight: CGFloat) -> CGFloat {
    switch self {
    case .min:
      return 54
    case .initial:
      return containerHeight * 0.2
    case .max:
      return containerHeight * 0.5
    }
  }
}

private enum SDGSampleBottomSheetConstants {
  static let handleWidth: CGFloat = 48
  static let handleHeight: CGFloat = 5
  static let handleCornerRadius: CGFloat = 3
  static let touchBoxTopPadding: CGFloat = 16
  static let touchBoxBottomPadding: CGFloat = 10
  static let contentTopPadding: CGFloat = 24
  static let contentBottomPadding: CGFloat = 40
  static let shadowRadius: CGFloat = 12
  static let shadowYOffset: CGFloat = -2
  
  static var touchBoxHeight: CGFloat {
    touchBoxTopPadding + handleHeight + touchBoxBottomPadding
  }
}

struct SDGSampleBottomSheet<Content: View>: View {
  private let detents: [SDGSampleBottomSheetDetent]
  private let onHeightChange: (CGFloat) -> Void
  private let content: Content
  
  @Binding private var selectedDetent: SDGSampleBottomSheetDetent
  @State private var interactiveHeight: CGFloat?
  @State private var dragStartHeight: CGFloat?
  
  init(
    selectedDetent: Binding<SDGSampleBottomSheetDetent>,
    detents: [SDGSampleBottomSheetDetent] = [.min, .initial, .max],
    onHeightChange: @escaping (CGFloat) -> Void = { _ in },
    @ViewBuilder content: () -> Content
  ) {
    self._selectedDetent = selectedDetent
    self.detents = detents
    self.onHeightChange = onHeightChange
    self.content = content()
  }
  
  var body: some View {
    GeometryReader { geometry in
      let bottomSafeAreaInset = geometry.safeAreaInsets.bottom
      let availableHeight = max(geometry.size.height - bottomSafeAreaInset, 0)
      let maxVisibleHeight = maxResolvedHeight(in: availableHeight)
      let selectedHeight = resolvedHeight(for: selectedDetent, in: availableHeight)
      let currentHeight = clampedHeight(interactiveHeight ?? selectedHeight, in: availableHeight)
      let renderedHeight = maxVisibleHeight + bottomSafeAreaInset
      let offsetY = maxVisibleHeight - currentHeight
      let isAtLargestDetent = isLargestDetent(selectedDetent, in: availableHeight)
      let isInnerScrollEnabled = isAtLargestDetent && interactiveHeight == nil
      
      VStack(spacing: 0) {
        Spacer(minLength: 0)
        
        VStack(spacing: 0) {
          touchBox(availableHeight: availableHeight)
          
          ScrollView(showsIndicators: false) {
            content
              .padding(.top, SDGSampleBottomSheetConstants.contentTopPadding)
              .padding(.bottom, SDGSampleBottomSheetConstants.contentBottomPadding)
          }
          .scrollDisabled(!isInnerScrollEnabled)
          .frame(height: max(maxVisibleHeight - SDGSampleBottomSheetConstants.touchBoxHeight, 0))
          .overlay {
            if !isInnerScrollEnabled {
              Color.clear
                .contentShape(Rectangle())
                .gesture(dragGesture(availableHeight: availableHeight))
            }
          }
          
          Color.neutral0
            .frame(height: bottomSafeAreaInset)
        }
        .frame(maxWidth: .infinity)
        .frame(height: renderedHeight)
        .background(Color.neutral0)
        .cornerRadius(.radius20, corners: [.topLeft, .topRight])
        .shadow(
          color: Color.black.opacity(0.1),
          radius: SDGSampleBottomSheetConstants.shadowRadius,
          x: 0,
          y: SDGSampleBottomSheetConstants.shadowYOffset
        )
        .offset(y: offsetY)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .onAppear {
        reportHeight(in: availableHeight, bottomSafeAreaInset: bottomSafeAreaInset)
      }
      .onChange(of: selectedDetent) { _ in
        reportHeight(in: availableHeight, bottomSafeAreaInset: bottomSafeAreaInset)
      }
      .onChange(of: geometry.size.height) { _ in
        reportHeight(in: availableHeight, bottomSafeAreaInset: bottomSafeAreaInset)
      }
      .onChange(of: bottomSafeAreaInset) { _ in
        reportHeight(in: availableHeight, bottomSafeAreaInset: bottomSafeAreaInset)
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }
  
  private func touchBox(availableHeight: CGFloat) -> some View {
    VStack(spacing: 0) {
      RoundedRectangle(cornerRadius: SDGSampleBottomSheetConstants.handleCornerRadius)
        .fill(Color.neutral250)
        .frame(
          width: SDGSampleBottomSheetConstants.handleWidth,
          height: SDGSampleBottomSheetConstants.handleHeight
        )
    }
    .frame(maxWidth: .infinity)
    .padding(.top, SDGSampleBottomSheetConstants.touchBoxTopPadding)
    .padding(.bottom, SDGSampleBottomSheetConstants.touchBoxBottomPadding)
    .background(Color.neutral0)
    .contentShape(Rectangle())
    .gesture(dragGesture(availableHeight: availableHeight))
  }
  
  private func dragGesture(
    availableHeight: CGFloat
  ) -> some Gesture {
    DragGesture(minimumDistance: 2)
      .onChanged { value in
        updateDrag(value, availableHeight: availableHeight)
      }
      .onEnded { value in
        finishDrag(value, availableHeight: availableHeight)
      }
  }
  
  private func updateDrag(
    _ value: DragGesture.Value,
    availableHeight: CGFloat
  ) {
    if dragStartHeight == nil {
      dragStartHeight = interactiveHeight ?? resolvedHeight(
        for: selectedDetent,
        in: availableHeight
      )
    }
    
    let startHeight = dragStartHeight ?? resolvedHeight(for: selectedDetent, in: availableHeight)
    let nextHeight = clampedHeight(startHeight - value.translation.height, in: availableHeight)
    var transaction = Transaction(animation: nil)
    transaction.disablesAnimations = true
    
    withTransaction(transaction) {
      interactiveHeight = nextHeight
    }
  }
  
  private func finishDrag(
    _ value: DragGesture.Value,
    availableHeight: CGFloat
  ) {
    let startHeight = dragStartHeight
      ?? interactiveHeight
      ?? resolvedHeight(for: selectedDetent, in: availableHeight)
    let predictedHeight = clampedHeight(
      startHeight - value.predictedEndTranslation.height,
      in: availableHeight
    )
    let targetDetent = nearestDetent(to: predictedHeight, in: availableHeight)
    
    dragStartHeight = nil
    
    withAnimation(.interactiveSpring(response: 0.32, dampingFraction: 0.86)) {
      selectedDetent = targetDetent
      interactiveHeight = nil
    }
  }
  
  private func reportHeight(
    in availableHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) {
    let selectedHeight = resolvedHeight(for: selectedDetent, in: availableHeight)
    onHeightChange(selectedHeight + bottomSafeAreaInset)
  }
  
  private func resolvedHeight(
    for detent: SDGSampleBottomSheetDetent,
    in availableHeight: CGFloat
  ) -> CGFloat {
    let fallbackDetent = detents.first ?? .initial
    let activeDetent = detents.contains(detent) ? detent : fallbackDetent
    return clampedHeight(activeDetent.resolvedHeight(in: availableHeight), in: availableHeight)
  }
  
  private func clampedHeight(_ height: CGFloat, in availableHeight: CGFloat) -> CGFloat {
    guard let minDetentHeight = detents.map({ $0.resolvedHeight(in: availableHeight) }).min(),
          let maxDetentHeight = detents.map({ $0.resolvedHeight(in: availableHeight) }).max() else {
      return height
    }
    
    return min(max(height, minDetentHeight), maxDetentHeight)
  }
  
  private func maxResolvedHeight(in availableHeight: CGFloat) -> CGFloat {
    detents.map { $0.resolvedHeight(in: availableHeight) }.max() ?? 0
  }
  
  private func isLargestDetent(
    _ detent: SDGSampleBottomSheetDetent,
    in availableHeight: CGFloat
  ) -> Bool {
    abs(resolvedHeight(for: detent, in: availableHeight) - maxResolvedHeight(in: availableHeight)) < 0.5
  }
  
  private func nearestDetent(
    to height: CGFloat,
    in availableHeight: CGFloat
  ) -> SDGSampleBottomSheetDetent {
    detents.min { lhs, rhs in
      let lhsDistance = abs(lhs.resolvedHeight(in: availableHeight) - height)
      let rhsDistance = abs(rhs.resolvedHeight(in: availableHeight) - height)
      return lhsDistance < rhsDistance
    } ?? .initial
  }
}

#Preview {
  SDGSampleBottomSheetPreview()
}

private struct SDGSampleBottomSheetPreview: View {
  @State private var selectedDetent: SDGSampleBottomSheetDetent = .initial
  
  var body: some View {
    ZStack {
      Color.neutral50
        .ignoresSafeArea()
      
      VStack(spacing: 12) {
        Text(sdg: "Sample Content")
          .typo(.point2_SB, .neutral700)
        
        Text(sdg: "Drag the handle to preview min, initial, and max states.")
          .typo(.body2_R, .neutral500)
          .multilineTextAlignment(.center)
      }
      .padding(.horizontal, 24)
      
      SDGSampleBottomSheet(selectedDetent: $selectedDetent) {
        VStack(spacing: 28) {
          SDGSampleBottomSheetControlSection {
            SDGSampleBottomSheetControlRow(title: "Label") {
              SDGToggle(size: .m, isOn: .constant(true))
            }
          }
          
          SDGSampleBottomSheetDivider()
          
          SDGSampleBottomSheetControlSection {
            Text(sdg: "Label")
              .typo(.body1_SB, .neutral700)
            
            SDGSegment(
              selectedSegmentIndex: .constant(0),
              textLine: .one,
              items: ["Label", "Label"]
            )
          }
        }
      }
    }
  }
}
