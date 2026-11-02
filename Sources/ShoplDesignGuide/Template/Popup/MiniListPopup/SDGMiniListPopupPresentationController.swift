//
//  SDGMiniListPopupPresentationController.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/30/26.
//

import UIKit

// 버튼의 window에 메뉴를 올리고 배치·입력·관찰 수명을 관리한다.
@MainActor
final class SDGMiniListPopupPresentationController: NSObject {
  var onDismissRequested: (() -> Void)?
  var onInvalidAnchor: (() -> Void)?

  private weak var anchorController: UIViewController?
  private weak var anchorWindow: UIWindow?
  private weak var hostController: UIViewController?
  private weak var interactionView: UIView?
  private let contentView: UIView
  private let overlayView = SDGMiniListPopupOverlayView()
  // 닫힘 중에도 입력 영역은 유지하고 메뉴의 시각 영역(shadowView)만 페이드한다.
  private let menuInputView = UIView()
  private let shadowView: SDGMiniListPopupShadowView
  private var contentSize: CGSize
  private var options: SDGMiniListPopup.PresentationOptions
  private var previousAnchorFrame: CGRect?
  private var containerFrame: CGRect?
  private var safeAreaInsets: UIEdgeInsets?
  private var invalidated = false
  private var isClosing = false
  private var displayLink: CADisplayLink?
  private let scrollGestures = NSHashTable<UIPanGestureRecognizer>.weakObjects()
  private lazy var outsideTap = UITapGestureRecognizer(
    target: self,
    action: #selector(outsideTapped)
  )

  var view: UIView { overlayView }
  var animationView: UIView { shadowView }

  init(
    contentView: UIView,
    contentSize: CGSize,
    anchorController: UIViewController?,
    options: SDGMiniListPopup.PresentationOptions
  ) {
    self.contentView = contentView
    self.contentSize = contentSize
    self.anchorController = anchorController
    anchorWindow = anchorController?.view.window
    self.options = options
    shadowView = SDGMiniListPopupShadowView(content: contentView)
    super.init()
    overlayView.backgroundColor = .clear
    overlayView.menuView = menuInputView
    overlayView.onLayout = { [weak self] in self?.updateLayout() }
    overlayView.addSubview(menuInputView)
    menuInputView.addSubview(shadowView)
  }

  func install(in host: UIViewController) -> Bool {
    guard let window = anchorWindow, host.view.window === window else { return false }
    hostController = host
    view.frame = host.view.convert(host.view.bounds, to: window)
    // 실제 window의 hit-test가 메뉴를 받도록 설치하되, 영역은 소유 화면으로 제한한다.
    window.addSubview(view)
    updateLayout()
    guard !invalidated else {
      removeOverlay()
      return false
    }
    outsideTap.delegate = self
    outsideTap.cancelsTouchesInView = true
    outsideTap.delaysTouchesBegan = false
    var interactionOwner = host
    while let parent = interactionOwner.parent { interactionOwner = parent }
    interactionView = interactionOwner.view
    interactionOwner.view.addGestureRecognizer(outsideTap)
    registerScrollViews(in: interactionOwner.view)
    startObserving()
    return true
  }

  func update(contentSize: CGSize, options: SDGMiniListPopup.PresentationOptions) {
    self.contentSize = contentSize
    self.options = options
    view.setNeedsLayout()
  }

  func anchorDidLayout() {
    refreshScrollObservers()
    view.setNeedsLayout()
  }

  func presentationDidFinish() {
    // SwiftUI가 버튼보다 늦게 생성한 형제 ScrollView도 관찰한다.
    refreshScrollObservers()
  }

  func beginDismissal() {
    isClosing = true
    stopObserving()
    contentView.isUserInteractionEnabled = false
  }

  // 직접 추가한 관찰과 gesture target만 제거해 기존 화면의 입력 처리를 유지한다.
  func removeOverlay() {
    isClosing = true
    stopObserving()
    outsideTap.view?.removeGestureRecognizer(outsideTap)
    outsideTap.delegate = nil
    for gesture in scrollGestures.allObjects {
      gesture.removeTarget(self, action: #selector(backgroundPanned(_:)))
    }
    scrollGestures.removeAllObjects()
    shadowView.layer.removeAllAnimations()
    overlayView.onLayout = nil
    view.removeFromSuperview()
    hostController = nil
    interactionView = nil
  }

  private func stopObserving() {
    displayLink?.invalidate()
    displayLink = nil
  }

  private func updateLayout() {
    guard !isClosing else { return }
    guard let hostController, let window = anchorWindow,
      hostController.view.window === window
    else {
      invalidateAnchor()
      return
    }
    let screenFrame = hostController.view.convert(hostController.view.bounds, to: window)
    if view.frame != screenFrame { view.frame = screenFrame }
    guard let anchor = anchorFrame(), let frame = popupFrame(anchor: anchor) else {
      invalidateAnchor()
      return
    }
    menuInputView.frame = frame
    shadowView.frame = menuInputView.bounds
    shadowView.layoutIfNeeded()
    previousAnchorFrame = anchor
    containerFrame = screenFrame
    safeAreaInsets = hostController.view.safeAreaInsets
  }

  private func popupFrame(anchor: CGRect) -> CGRect? {
    guard let hostController else { return nil }
    return SDGMiniListPopupLayout.frame(
      anchor: anchor,
      container: view.bounds,
      safeAreaInsets: hostController.view.safeAreaInsets,
      contentSize: contentSize,
      options: options
    )
  }

  // 버튼을 오버레이 좌표로 변환하고 숨김·clipping 등 실제 비노출 여부를 확인한다.
  private func anchorFrame() -> CGRect? {
    guard let anchorController, let hostController,
      let source = anchorController.view, source.isDescendant(of: hostController.view),
      let window = source.window,
      window === anchorWindow, window === view.window, view.superview === window
    else { return nil }

    var owner: UIViewController? = anchorController
    while let controller = owner {
      guard !controller.isBeingDismissed, !controller.isMovingFromParent,
        controller.presentedViewController == nil
      else { return nil }
      owner = controller.parent
    }

    let rect = source.convert(source.bounds, to: view)
    var visible = rect.intersection(view.bounds)
      .intersection(window.convert(window.bounds, to: view))
    var ancestor: UIView? = source
    while let current = ancestor {
      guard !current.isHidden, current.alpha > 0 else { return nil }
      if current.clipsToBounds {
        visible = visible.intersection(current.convert(current.bounds, to: view))
      }
      ancestor = current.superview
    }
    guard !visible.isNull, !visible.isEmpty else { return nil }
    return SDGMiniListPopupLayout.normalized(rect, scale: window.screen.scale)
  }

  // 레이아웃 콜백 없이 바뀌는 위치도 감지하도록 표시 중에만 프레임을 확인한다.
  private func startObserving() {
    guard displayLink == nil else { return }
    let observer = SDGMiniListPopupDisplayLinkObserver(controller: self)
    let link = CADisplayLink(target: observer, selector: #selector(observer.tick))
    link.add(to: .main, forMode: .common)
    displayLink = link
  }

  fileprivate func checkAnchor() {
    guard !isClosing else { return }
    guard let current = anchorFrame(), let hostController, let window = anchorWindow else {
      invalidateAnchor()
      return
    }
    let screenFrame = hostController.view.convert(hostController.view.bounds, to: window)
    if previousAnchorFrame != current || containerFrame != screenFrame
      || safeAreaInsets != hostController.view.safeAreaInsets {
      view.setNeedsLayout()
    }
  }

  private func invalidateAnchor() {
    guard !invalidated, !isClosing else { return }
    invalidated = true
    stopObserving()
    DispatchQueue.main.async { [weak self] in self?.onInvalidAnchor?() }
  }

  // 고정 버튼 옆의 형제 ScrollView도 포함하도록 소유 화면의 계층에서 찾는다.
  private func registerScrollViews(in root: UIView) {
    guard root !== view else { return }
    if let scrollView = root as? UIScrollView { register(scrollView) }
    for child in root.subviews { registerScrollViews(in: child) }
  }

  private func refreshScrollObservers() {
    guard !isClosing, let interactionView else { return }
    registerScrollViews(in: interactionView)
  }

  // 기존 pan에 target만 추가한다. 메뉴 내부 스크롤은 닫힘 대상에서 제외한다.
  private func register(_ scrollView: UIScrollView) {
    guard !scrollView.isDescendant(of: view) else { return }
    let gesture = scrollView.panGestureRecognizer
    guard !scrollGestures.contains(gesture) else { return }
    scrollGestures.add(gesture)
    gesture.addTarget(self, action: #selector(backgroundPanned(_:)))
  }

  private func isBackgroundScroll(_ gesture: UIGestureRecognizer) -> Bool {
    guard let scrollView = gesture.view as? UIScrollView else { return false }
    return gesture === scrollView.panGestureRecognizer && !scrollView.isDescendant(of: view)
  }

  @objc private func backgroundPanned(_ gesture: UIPanGestureRecognizer) {
    guard !isClosing, gesture.state == .began else { return }
    onDismissRequested?()
  }

  @objc private func outsideTapped() {
    guard !isClosing else { return }
    onDismissRequested?()
  }
}

extension SDGMiniListPopupPresentationController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch)
    -> Bool {
    guard !isClosing, let touchedView = touch.view, !touchedView.isDescendant(of: view),
      !menuInputView.frame.contains(touch.location(in: view))
    else { return false }
    var ancestor: UIView? = touchedView
    while let current = ancestor {
      if let scrollView = current as? UIScrollView { register(scrollView) }
      if current === interactionView { break }
      ancestor = current.superview
    }
    return true
  }

  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    // 팝업 닫힘과 같은 드래그의 스크롤이 함께 진행되도록 배경 pan과 동시 인식한다.
    isBackgroundScroll(otherGestureRecognizer)
  }

  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    // 외부 탭이 뒤 화면의 선택 제스처보다 먼저 결정되도록 한다.
    // 배경 pan은 이 우선순위에서 제외해 첫 드래그를 막지 않는다.
    guard !isBackgroundScroll(otherGestureRecognizer), let target = otherGestureRecognizer.view,
      !target.isDescendant(of: view)
    else { return false }
    return true
  }
}

private final class SDGMiniListPopupOverlayView: UIView {
  weak var menuView: UIView?
  var onLayout: (() -> Void)?

  override func layoutSubviews() {
    super.layoutSubviews()
    onLayout?()
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard isUserInteractionEnabled, !isHidden, alpha > 0.01, let menuView,
      menuView.frame.contains(point)
    else { return nil }
    // 비활성 행이나 닫힘 중 하위 뷰가 받지 못한 터치도 입력 컨테이너가 소비한다.
    return menuView.hitTest(convert(point, to: menuView), with: event) ?? menuView
  }
}

// CADisplayLink가 표시 컨트롤러를 강하게 유지하지 않도록 약한 참조로 중계한다.
@MainActor
private final class SDGMiniListPopupDisplayLinkObserver: NSObject {
  private weak var controller: SDGMiniListPopupPresentationController?

  init(controller: SDGMiniListPopupPresentationController) {
    self.controller = controller
  }

  @objc func tick() {
    controller?.checkAnchor()
  }
}

// 콘텐츠의 clipping과 분리해 가이드 그림자를 한 레이어에서 그린다.
private final class SDGMiniListPopupShadowView: UIView {
  private let content: UIView

  init(content: UIView) {
    self.content = content
    super.init(frame: .zero)
    backgroundColor = SDG.Color.neutral0.uiColor
    clipsToBounds = false
    layer.cornerRadius = SDGMiniListPopupStyle.cornerRadius
    layer.shadowColor = SDG.Color.neutral900.uiColor.cgColor
    layer.shadowOpacity = 0.12
    layer.shadowRadius = SDGMiniListPopupStyle.shadowRadius
    layer.shadowOffset = .zero
    content.backgroundColor = .clear
    addSubview(content)
  }

  required init?(coder: NSCoder) { nil }

  override func layoutSubviews() {
    super.layoutSubviews()
    content.frame = bounds
    layer.shadowPath = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: SDGMiniListPopupStyle.cornerRadius
    ).cgPath
  }
}
