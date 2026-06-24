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

  fileprivate func resolvedBodyHeight(
    in screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> CGFloat {
    switch self {
    case .min:
      return 54
    case .initial:
      return Swift.max(screenHeight * 0.2 - bottomSafeAreaInset, 0)
    case .max:
      return Swift.max(screenHeight * 0.5 - bottomSafeAreaInset, 0)
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
      let screenHeight = max(geometry.size.height, 0)
      let bottomSafeAreaInset = geometry.safeAreaInsets.bottom
      let maxBodyHeight = maxResolvedHeight(
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
      let selectedHeight = resolvedHeight(
        for: selectedDetent,
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
      let currentHeight = interactiveHeight ?? selectedHeight
      let renderedHeight = maxBodyHeight + bottomSafeAreaInset
      let offsetY = max(maxBodyHeight - currentHeight, 0)
      let isAtLargestDetent = isLargestDetent(
        selectedDetent,
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )

      VStack(spacing: 0) {
        Spacer(minLength: 0)

        VStack(spacing: 0) {
          touchBox(
            screenHeight: screenHeight,
            bottomSafeAreaInset: bottomSafeAreaInset
          )

          SDGSampleBottomSheetScrollView(
            isSheetAtLargestDetent: isAtLargestDetent,
            isSheetDragActive: interactiveHeight != nil,
            onSheetDragChanged: { translationY in
              updateDrag(
                translationY: translationY,
                screenHeight: screenHeight,
                bottomSafeAreaInset: bottomSafeAreaInset
              )
            },
            onSheetDragEnded: { translationY, velocityY in
              finishDrag(
                translationY: translationY,
                predictedTranslationY: nil,
                velocityY: velocityY,
                screenHeight: screenHeight,
                bottomSafeAreaInset: bottomSafeAreaInset
              )
            }
          ) {
            content
              .padding(.top, SDGSampleBottomSheetConstants.contentTopPadding)
              .padding(.bottom, SDGSampleBottomSheetConstants.contentBottomPadding)
          }
          .frame(height: max(maxBodyHeight - SDGSampleBottomSheetConstants.touchBoxHeight, 0))

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
        reportHeight(in: screenHeight, bottomSafeAreaInset: bottomSafeAreaInset)
      }
      .onChange(of: selectedDetent) { _ in
        reportHeight(in: screenHeight, bottomSafeAreaInset: bottomSafeAreaInset)
      }
      .onChange(of: geometry.size.height) { _ in
        reportHeight(in: screenHeight, bottomSafeAreaInset: bottomSafeAreaInset)
      }
      .onChange(of: bottomSafeAreaInset) { _ in
        reportHeight(in: screenHeight, bottomSafeAreaInset: bottomSafeAreaInset)
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }

  private func touchBox(
    screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> some View {
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
    .gesture(
      dragGesture(
        screenHeight: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
    )
  }

  private func dragGesture(
    screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> some Gesture {
    DragGesture(minimumDistance: 2)
      .onChanged { value in
        updateDrag(
          value,
          screenHeight: screenHeight,
          bottomSafeAreaInset: bottomSafeAreaInset
        )
      }
      .onEnded { value in
        finishDrag(
          value,
          screenHeight: screenHeight,
          bottomSafeAreaInset: bottomSafeAreaInset
        )
      }
  }

  private func updateDrag(
    _ value: DragGesture.Value,
    screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) {
    updateDrag(
      translationY: value.translation.height,
      screenHeight: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )
  }

  private func updateDrag(
    translationY: CGFloat,
    screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) {
    if dragStartHeight == nil {
      dragStartHeight = interactiveHeight ?? resolvedHeight(
        for: selectedDetent,
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
    }

    let startHeight = dragStartHeight ?? resolvedHeight(
      for: selectedDetent,
      in: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )
    let nextHeight = rubberBandedHeight(
      startHeight - translationY,
      in: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )
    var transaction = Transaction(animation: nil)
    transaction.disablesAnimations = true

    withTransaction(transaction) {
      interactiveHeight = nextHeight
    }
  }

  private func finishDrag(
    _ value: DragGesture.Value,
    screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) {
    finishDrag(
      translationY: value.translation.height,
      predictedTranslationY: value.predictedEndTranslation.height,
      velocityY: nil,
      screenHeight: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )
  }

  private func finishDrag(
    translationY: CGFloat,
    predictedTranslationY: CGFloat?,
    velocityY: CGFloat?,
    screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) {
    let startHeight = dragStartHeight
      ?? interactiveHeight
      ?? resolvedHeight(
        for: selectedDetent,
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
    let projectedTranslationY = predictedTranslationY
      ?? projectedTranslation(translationY: translationY, velocityY: velocityY ?? 0)
    let currentHeight = clampedHeight(
      startHeight - translationY,
      in: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )
    let predictedHeight = clampedHeight(
      startHeight - projectedTranslationY,
      in: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )
    let targetDetent = targetDetent(
      currentHeight: currentHeight,
      predictedHeight: predictedHeight,
      velocityY: velocityY,
      in: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )

    dragStartHeight = nil

    withAnimation(.interactiveSpring(response: 0.34, dampingFraction: 0.88, blendDuration: 0.08)) {
      selectedDetent = targetDetent
      interactiveHeight = nil
    }
  }

  private func reportHeight(
    in screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) {
    let selectedHeight = resolvedHeight(
      for: selectedDetent,
      in: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )
    onHeightChange(selectedHeight + bottomSafeAreaInset)
  }

  private func resolvedHeight(
    for detent: SDGSampleBottomSheetDetent,
    in screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> CGFloat {
    let fallbackDetent = detents.first ?? .initial
    let activeDetent = detents.contains(detent) ? detent : fallbackDetent
    return clampedHeight(
      activeDetent.resolvedBodyHeight(
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      ),
      in: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )
  }

  private func clampedHeight(
    _ height: CGFloat,
    in screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> CGFloat {
    let detentHeights = detents.map {
      $0.resolvedBodyHeight(
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
    }

    guard let minDetentHeight = detentHeights.min(),
          let maxDetentHeight = detentHeights.max() else {
      return height
    }

    return min(max(height, minDetentHeight), maxDetentHeight)
  }

  private func rubberBandedHeight(
    _ height: CGFloat,
    in screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> CGFloat {
    let detentHeights = detents.map {
      $0.resolvedBodyHeight(
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
    }

    guard let minDetentHeight = detentHeights.min(),
          let maxDetentHeight = detentHeights.max() else {
      return height
    }

    let resistance: CGFloat = 0.24

    if height < minDetentHeight {
      return minDetentHeight - (minDetentHeight - height) * resistance
    }

    if height > maxDetentHeight {
      return maxDetentHeight
    }

    return height
  }

  private func maxResolvedHeight(
    in screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> CGFloat {
    detents.map {
      $0.resolvedBodyHeight(
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
    }.max() ?? 0
  }

  private func isLargestDetent(
    _ detent: SDGSampleBottomSheetDetent,
    in screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> Bool {
    abs(
      resolvedHeight(
        for: detent,
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      ) - maxResolvedHeight(
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
    ) < 0.5
  }

  private func nearestDetent(
    to height: CGFloat,
    in screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> SDGSampleBottomSheetDetent {
    detents.min { lhs, rhs in
      let lhsDistance = abs(
        lhs.resolvedBodyHeight(
          in: screenHeight,
          bottomSafeAreaInset: bottomSafeAreaInset
        ) - height
      )
      let rhsDistance = abs(
        rhs.resolvedBodyHeight(
          in: screenHeight,
          bottomSafeAreaInset: bottomSafeAreaInset
        ) - height
      )
      return lhsDistance < rhsDistance
    } ?? .initial
  }

  private func targetDetent(
    currentHeight: CGFloat,
    predictedHeight: CGFloat,
    velocityY: CGFloat?,
    in screenHeight: CGFloat,
    bottomSafeAreaInset: CGFloat
  ) -> SDGSampleBottomSheetDetent {
    let sortedDetents = detents.sorted {
      $0.resolvedBodyHeight(
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      ) < $1.resolvedBodyHeight(
        in: screenHeight,
        bottomSafeAreaInset: bottomSafeAreaInset
      )
    }
    let flickVelocityThreshold: CGFloat = 700

    if let velocityY, abs(velocityY) > flickVelocityThreshold {
      if velocityY < 0 {
        return sortedDetents.first {
          $0.resolvedBodyHeight(
            in: screenHeight,
            bottomSafeAreaInset: bottomSafeAreaInset
          ) > currentHeight + 8
        } ?? sortedDetents.last ?? .max
      }

      return sortedDetents.reversed().first {
        $0.resolvedBodyHeight(
          in: screenHeight,
          bottomSafeAreaInset: bottomSafeAreaInset
        ) < currentHeight - 8
      } ?? sortedDetents.first ?? .min
    }

    return nearestDetent(
      to: predictedHeight,
      in: screenHeight,
      bottomSafeAreaInset: bottomSafeAreaInset
    )
  }

  private func projectedTranslation(
    translationY: CGFloat,
    velocityY: CGFloat
  ) -> CGFloat {
    translationY + velocityY * 0.16
  }
}

private struct SDGSampleBottomSheetScrollView<Content: View>: UIViewControllerRepresentable {
  let isSheetAtLargestDetent: Bool
  let isSheetDragActive: Bool
  let onSheetDragChanged: (CGFloat) -> Void
  let onSheetDragEnded: (CGFloat, CGFloat) -> Void
  let content: Content

  init(
    isSheetAtLargestDetent: Bool,
    isSheetDragActive: Bool,
    onSheetDragChanged: @escaping (CGFloat) -> Void,
    onSheetDragEnded: @escaping (CGFloat, CGFloat) -> Void,
    @ViewBuilder content: () -> Content
  ) {
    self.isSheetAtLargestDetent = isSheetAtLargestDetent
    self.isSheetDragActive = isSheetDragActive
    self.onSheetDragChanged = onSheetDragChanged
    self.onSheetDragEnded = onSheetDragEnded
    self.content = content()
  }

  func makeUIViewController(context: Context) -> SDGSampleBottomSheetScrollHostingController<Content> {
    SDGSampleBottomSheetScrollHostingController(parent: self)
  }

  func updateUIViewController(
    _ viewController: SDGSampleBottomSheetScrollHostingController<Content>,
    context: Context
  ) {
    viewController.update(parent: self)
  }
}

private final class SDGSampleBottomSheetScrollHostingController<Content: View>: UIViewController,
  UIScrollViewDelegate,
  UIGestureRecognizerDelegate {
  private var configuration: SDGSampleBottomSheetScrollView<Content>
  private let scrollView = UIScrollView()
  private let hostingController: UIHostingController<Content>

  private enum PanOwner {
    case undecided
    case scroll
    case sheet
  }

  private let topTolerance: CGFloat = 1
  private var panOwner: PanOwner = .undecided
  private var sheetPanStartTranslationY: CGFloat = 0

  private lazy var sheetPanGestureRecognizer: UIPanGestureRecognizer = {
    let gestureRecognizer = UIPanGestureRecognizer(
      target: self,
      action: #selector(handleSheetPan(_:))
    )
    gestureRecognizer.delegate = self
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delaysTouchesBegan = false
    gestureRecognizer.delaysTouchesEnded = false
    return gestureRecognizer
  }()

  init(parent: SDGSampleBottomSheetScrollView<Content>) {
    self.configuration = parent
    self.hostingController = UIHostingController(rootView: parent.content)
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureScrollView()
    installHostedContent()
    updateScrollBehavior()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateScrollBehavior()
  }

  func update(parent: SDGSampleBottomSheetScrollView<Content>) {
    self.configuration = parent
    hostingController.rootView = parent.content
    updateScrollBehavior()
  }

  private func configureScrollView() {
    view.backgroundColor = .clear

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .clear
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.delaysContentTouches = false
    scrollView.canCancelContentTouches = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.keyboardDismissMode = .interactive
    scrollView.delegate = self

    view.addSubview(scrollView)
    scrollView.addGestureRecognizer(sheetPanGestureRecognizer)

    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  private func installHostedContent() {
    addChild(hostingController)
    hostingController.view.backgroundColor = .clear
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(hostingController.view)

    NSLayoutConstraint.activate([
      hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      hostingController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
    ])

    hostingController.didMove(toParent: self)
  }

  private func updateScrollBehavior() {
    scrollView.bounces = false
    scrollView.alwaysBounceVertical = false

    if !configuration.isSheetAtLargestDetent || configuration.isSheetDragActive || panOwner == .sheet {
      pinToTopIfNeeded()
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if !configuration.isSheetAtLargestDetent || configuration.isSheetDragActive || panOwner == .sheet {
      pinToTopIfNeeded()
    }
  }

  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard gestureRecognizer === sheetPanGestureRecognizer,
          let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer,
          let view = panGestureRecognizer.view else {
      return true
    }

    let velocity = panGestureRecognizer.velocity(in: view)
    let translation = panGestureRecognizer.translation(in: view)
    let verticalMovement = max(abs(velocity.y), abs(translation.y))
    let horizontalMovement = max(abs(velocity.x), abs(translation.x))

    return verticalMovement > horizontalMovement
  }

  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    let isSheetAndScrollPan = gestureRecognizer === sheetPanGestureRecognizer
      && otherGestureRecognizer === scrollView.panGestureRecognizer
    let isScrollAndSheetPan = gestureRecognizer === scrollView.panGestureRecognizer
      && otherGestureRecognizer === sheetPanGestureRecognizer

    return isSheetAndScrollPan || isScrollAndSheetPan
  }

  @objc private func handleSheetPan(_ gestureRecognizer: UIPanGestureRecognizer) {
    let translationY = gestureRecognizer.translation(in: scrollView).y
    let velocityY = gestureRecognizer.velocity(in: scrollView).y

    switch gestureRecognizer.state {
    case .began:
      panOwner = .undecided
      sheetPanStartTranslationY = translationY
      updatePanOwnerIfNeeded(
        translationY: translationY,
        velocityY: velocityY
      )
    case .changed:
      updatePanOwnerIfNeeded(
        translationY: translationY,
        velocityY: velocityY
      )

      guard panOwner == .sheet else {
        return
      }

      pinToTopIfNeeded()
      configuration.onSheetDragChanged(translationY - sheetPanStartTranslationY)
    case .ended, .cancelled, .failed:
      let didDragSheet = panOwner == .sheet
      let sheetTranslationY = translationY - sheetPanStartTranslationY
      panOwner = .undecided
      sheetPanStartTranslationY = 0
      updateScrollBehavior()

      guard didDragSheet else {
        return
      }

      pinToTopIfNeeded()
      configuration.onSheetDragEnded(sheetTranslationY, velocityY)
    default:
      break
    }
  }

  private func updatePanOwnerIfNeeded(
    translationY: CGFloat,
    velocityY: CGFloat
  ) {
    guard panOwner != .sheet else {
      return
    }

    if shouldSheetOwnPan(
      translationY: translationY,
      velocityY: velocityY
    ) {
      panOwner = .sheet
      sheetPanStartTranslationY = translationY
      updateScrollBehavior()
      pinToTopIfNeeded()
      configuration.onSheetDragChanged(0)
    } else {
      panOwner = .scroll
    }
  }

  private func shouldSheetOwnPan(
    translationY: CGFloat,
    velocityY: CGFloat
  ) -> Bool {
    if configuration.isSheetDragActive || !configuration.isSheetAtLargestDetent {
      return true
    }

    let isDraggingDown = velocityY > 0 || translationY > 0

    return isDraggingDown && isContentOffsetAtTop()
  }

  private func isContentOffsetAtTop() -> Bool {
    scrollView.contentOffset.y <= -scrollView.adjustedContentInset.top + topTolerance
  }

  private func pinToTopIfNeeded() {
    let topOffsetY = -scrollView.adjustedContentInset.top

    if abs(scrollView.contentOffset.y - topOffsetY) > topTolerance {
      scrollView.setContentOffset(
        CGPoint(x: scrollView.contentOffset.x, y: topOffsetY),
        animated: false
      )
    }
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
