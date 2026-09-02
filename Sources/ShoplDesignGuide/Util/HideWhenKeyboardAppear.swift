//
//  HideWhenKeyboardAppear.swift
//  ShoplDesignGuide
//
//  Created by Dino on 9/11/25.
//

import Combine
import SwiftUI
import UIKit

extension View {
  public func hideWhenKeyboardAppear() -> some View {
    self.modifier(HideWhenKeyboardAppearModifier())
  }
}

struct HideWhenKeyboardAppearModifier: ViewModifier {
  @State private var isKeyboardAppeared: Bool = false
  @State private var markerViewBox = WeakViewBox()

  func body(content: Content) -> some View {
    content
      .isHidden(isKeyboardAppeared)
      .background(
        ScreenMarkerViewReader(
          viewBox: markerViewBox,
          hierarchyDidChange: scheduleKeyboardVisibilityRefresh
        )
        .allowsHitTesting(false)
      )
      .onReceive(KeyboardFrameMonitor.shared.publisher) { _ in
        scheduleKeyboardVisibilityRefresh()
      }
      .onReceive(
        NotificationCenter.default.publisher(for: UIWindow.didBecomeKeyNotification)
      ) { notification in
        guard let window = notification.object as? UIWindow,
          window === markerViewBox.view?.window
        else {
          return
        }

        scheduleKeyboardVisibilityRefresh()
      }
      .onAppear {
        scheduleKeyboardVisibilityRefresh()
      }
  }

  private func scheduleKeyboardVisibilityRefresh() {
    DispatchQueue.main.async {
      updateKeyboardVisibility(using: KeyboardFrameMonitor.shared.currentState)
    }
  }

  private func updateKeyboardVisibility(
    using keyboardFrameState: KeyboardFrameState
  ) {
    guard let markerView = markerViewBox.view,
      let window = markerView.window
    else {
      return
    }

    let isKeyboardVisible: Bool
    switch keyboardFrameState.geometry(for: window.screen) {
    case .unknown:
      let keyboardFrame = window.keyboardLayoutGuide.layoutFrame
      let keyboardIntersection = window.bounds.intersection(keyboardFrame)
      let safeAreaBottom = window.safeAreaLayoutGuide.layoutFrame.maxY

      isKeyboardVisible = !keyboardIntersection.isNull
        && keyboardIntersection.height > 0
        && keyboardFrame.minY < safeAreaBottom - 0.5

    case .frame(let screenKeyboardFrame):
      let keyboardFrame = window.convert(
        screenKeyboardFrame,
        from: window.screen.coordinateSpace
      )
      let keyboardIntersection = window.bounds.intersection(keyboardFrame)

      isKeyboardVisible = !keyboardIntersection.isNull
        && keyboardIntersection.height > 0.5
    }

    guard window.isKeyWindow,
      isKeyboardVisible,
      let activeViewController = UIViewController.sdgActiveViewController(
        from: window.rootViewController,
        in: window
      ),
      let activeView = activeViewController.viewIfLoaded
    else {
      setKeyboardAppeared(false)
      return
    }

    setKeyboardAppeared(markerView.isDescendant(of: activeView))
  }

  private func setKeyboardAppeared(_ isKeyboardAppeared: Bool) {
    guard self.isKeyboardAppeared != isKeyboardAppeared else {
      return
    }

    self.isKeyboardAppeared = isKeyboardAppeared
  }
}

private enum KeyboardGeometry {
  case unknown
  case frame(CGRect)
}

private enum KeyboardStandardTransition {
  case show
  case hide
}

private struct KeyboardFrameState {
  private var geometryByScreen: [ObjectIdentifier: KeyboardGeometry] = [:]

  mutating func update(
    _ geometry: KeyboardGeometry,
    for screen: UIScreen
  ) {
    geometryByScreen[ObjectIdentifier(screen)] = geometry
  }

  func geometry(for screen: UIScreen) -> KeyboardGeometry {
    geometryByScreen[ObjectIdentifier(screen)] ?? .unknown
  }
}

@MainActor
private final class KeyboardFrameMonitor: NSObject {
  static let shared = KeyboardFrameMonitor()

  private let stateSubject = CurrentValueSubject<KeyboardFrameState, Never>(
    KeyboardFrameState()
  )
  private var pendingFrameByScreen: [ObjectIdentifier: CGRect] = [:]
  private var pendingTransitionByScreen: [ObjectIdentifier: KeyboardStandardTransition] = [:]
  private var lastKeyboardScreen: UIScreen?

  var publisher: AnyPublisher<KeyboardFrameState, Never> {
    stateSubject.eraseToAnyPublisher()
  }

  var currentState: KeyboardFrameState {
    stateSubject.value
  }

  private override init() {
    super.init()

    let frameNotificationNames: [Notification.Name] = [
      UIResponder.keyboardWillChangeFrameNotification,
      UIResponder.keyboardDidChangeFrameNotification
    ]

    frameNotificationNames.forEach { notificationName in
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardFrameNotificationReceived(_:)),
        name: notificationName,
        object: nil
      )
    }

    let standardNotificationNames: [Notification.Name] = [
      UIResponder.keyboardWillShowNotification,
      UIResponder.keyboardDidShowNotification,
      UIResponder.keyboardWillHideNotification,
      UIResponder.keyboardDidHideNotification
    ]

    standardNotificationNames.forEach { notificationName in
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(standardKeyboardNotificationReceived(_:)),
        name: notificationName,
        object: nil
      )
    }
  }

  @objc private func keyboardFrameNotificationReceived(
    _ notification: Notification
  ) {
    guard let keyboardEndFrame = notification.sdgKeyboardEndFrame else {
      return
    }

    guard let lastKeyboardScreen else {
      stateSubject.send(stateSubject.value)
      return
    }

    let screenIdentifier = ObjectIdentifier(lastKeyboardScreen)
    if notification.name == UIResponder.keyboardWillChangeFrameNotification {
      pendingFrameByScreen[screenIdentifier] = keyboardEndFrame
    } else {
      guard pendingFrameByScreen[screenIdentifier] == keyboardEndFrame
      else {
        if case .unknown = stateSubject.value.geometry(for: lastKeyboardScreen) {
          updateState(
            keyboardEndFrame: keyboardEndFrame,
            screen: lastKeyboardScreen
          )
        }
        return
      }

      pendingFrameByScreen[screenIdentifier] = nil

      if case .frame(let currentFrame) = stateSubject.value.geometry(
        for: lastKeyboardScreen
      ),
        currentFrame != keyboardEndFrame {
        return
      }
    }

    var state = stateSubject.value
    state.update(
      .frame(keyboardEndFrame),
      for: lastKeyboardScreen
    )
    stateSubject.send(state)
  }

  @objc private func standardKeyboardNotificationReceived(
    _ notification: Notification
  ) {
    guard let screen = notification.object as? UIScreen,
      let keyboardEndFrame = notification.sdgKeyboardEndFrame,
      let transition = notification.sdgStandardKeyboardTransition
    else {
      return
    }

    lastKeyboardScreen = screen

    let screenIdentifier = ObjectIdentifier(screen)
    if notification.sdgIsKeyboardWillNotification {
      pendingTransitionByScreen[screenIdentifier] = transition
    } else {
      guard let pendingTransition = pendingTransitionByScreen[screenIdentifier]
      else {
        if case .unknown = stateSubject.value.geometry(for: screen) {
          updateState(
            keyboardEndFrame: keyboardEndFrame,
            screen: screen
          )
        }
        return
      }

      guard pendingTransition == transition else {
        return
      }

      pendingTransitionByScreen[screenIdentifier] = nil

      if case .frame(let currentFrame) = stateSubject.value.geometry(for: screen),
        currentFrame != keyboardEndFrame {
        return
      }
    }

    updateState(
      keyboardEndFrame: keyboardEndFrame,
      screen: screen
    )
  }

  private func updateState(
    keyboardEndFrame: CGRect,
    screen: UIScreen
  ) {
    var state = stateSubject.value
    state.update(
      .frame(keyboardEndFrame),
      for: screen
    )
    stateSubject.send(state)
  }
}

private final class MarkerOwnership {}

private final class WeakViewBox {
  private(set) weak var view: ScreenMarkerView?
  private weak var ownership: MarkerOwnership?

  @discardableResult
  func replace(
    view: ScreenMarkerView,
    ownership: MarkerOwnership
  ) -> ScreenMarkerView? {
    let previousView = self.view
    self.view = view
    self.ownership = ownership
    return previousView
  }

  func owns(
    view: ScreenMarkerView,
    ownership: MarkerOwnership
  ) -> Bool {
    self.view === view && self.ownership === ownership
  }

  func adoptIfAvailable(
    view: ScreenMarkerView,
    ownership: MarkerOwnership
  ) -> Bool {
    guard self.view == nil else {
      return false
    }

    self.view = view
    self.ownership = ownership
    return true
  }

  func release(
    view: ScreenMarkerView,
    ownership: MarkerOwnership
  ) {
    guard owns(view: view, ownership: ownership) else {
      return
    }

    self.view = nil
    self.ownership = nil
  }
}

private struct ScreenMarkerViewReader: UIViewRepresentable {
  final class Coordinator {
    let ownership = MarkerOwnership()
  }

  let viewBox: WeakViewBox
  let hierarchyDidChange: () -> Void

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeUIView(context: Context) -> ScreenMarkerView {
    let view = ScreenMarkerView(frame: .zero)
    view.backgroundColor = .clear
    view.isUserInteractionEnabled = false
    view.install(
      in: viewBox,
      ownership: context.coordinator.ownership,
      hierarchyDidChange: hierarchyDidChange
    )
    return view
  }

  func updateUIView(
    _ uiView: ScreenMarkerView,
    context: Context
  ) {
    uiView.refreshRegistration(
      in: viewBox,
      ownership: context.coordinator.ownership,
      hierarchyDidChange: hierarchyDidChange
    )
  }

  static func dismantleUIView(
    _ uiView: ScreenMarkerView,
    coordinator: Coordinator
  ) {
    uiView.unregister(ownership: coordinator.ownership)
  }
}

private final class ScreenMarkerView: UIView {
  private weak var viewBox: WeakViewBox?
  private var ownership: MarkerOwnership?
  private weak var observedActiveViewController: UIViewController?
  private var hierarchyDidChange: (() -> Void)?

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    hierarchyDidChange?()
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    observedActiveViewController = nil
    hierarchyDidChange?()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let activeViewController: UIViewController?
    if let window {
      activeViewController = UIViewController.sdgActiveViewController(
        from: window.rootViewController,
        in: window
      )
    } else {
      activeViewController = nil
    }

    guard activeViewController !== observedActiveViewController else {
      return
    }

    observedActiveViewController = activeViewController
    hierarchyDidChange?()
  }

  func install(
    in viewBox: WeakViewBox,
    ownership: MarkerOwnership,
    hierarchyDidChange: @escaping () -> Void
  ) {
    releaseRegistration()

    let previousView = viewBox.replace(
      view: self,
      ownership: ownership
    )
    if previousView !== self {
      previousView?.invalidateRegistration(in: viewBox)
    }

    self.viewBox = viewBox
    self.ownership = ownership
    self.hierarchyDidChange = hierarchyDidChange
    hierarchyDidChange()
  }

  func refreshRegistration(
    in viewBox: WeakViewBox,
    ownership: MarkerOwnership,
    hierarchyDidChange: @escaping () -> Void
  ) {
    if viewBox.owns(view: self, ownership: ownership) {
      self.viewBox = viewBox
      self.ownership = ownership
      self.hierarchyDidChange = hierarchyDidChange
      return
    }

    if self.viewBox === viewBox {
      invalidateRegistration(in: viewBox)
    } else {
      releaseRegistration()
    }

    guard viewBox.adoptIfAvailable(
      view: self,
      ownership: ownership
    ) else {
      return
    }

    self.viewBox = viewBox
    self.ownership = ownership
    self.hierarchyDidChange = hierarchyDidChange
    hierarchyDidChange()
  }

  func unregister(ownership: MarkerOwnership) {
    guard self.ownership === ownership else {
      return
    }

    releaseRegistration()
  }

  private func releaseRegistration() {
    if let viewBox,
      let ownership {
      viewBox.release(
        view: self,
        ownership: ownership
      )
    }

    hierarchyDidChange = nil
    viewBox = nil
    ownership = nil
  }

  private func invalidateRegistration(in viewBox: WeakViewBox) {
    guard self.viewBox === viewBox else {
      return
    }

    hierarchyDidChange = nil
    self.viewBox = nil
    ownership = nil
  }
}

private extension Notification {
  var sdgIsKeyboardWillNotification: Bool {
    name == UIResponder.keyboardWillShowNotification
      || name == UIResponder.keyboardWillHideNotification
  }

  var sdgStandardKeyboardTransition: KeyboardStandardTransition? {
    switch name {
    case UIResponder.keyboardWillShowNotification,
      UIResponder.keyboardDidShowNotification:
      return .show

    case UIResponder.keyboardWillHideNotification,
      UIResponder.keyboardDidHideNotification:
      return .hide

    default:
      return nil
    }
  }

  var sdgKeyboardEndFrame: CGRect? {
    if let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
      as? CGRect {
      return keyboardFrame
    }

    return (
      userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    )?.cgRectValue
  }
}

private extension UIViewController {
  static func sdgActiveViewController(
    from baseViewController: UIViewController?,
    in window: UIWindow
  ) -> UIViewController? {
    guard let baseViewController else {
      return nil
    }

    if let presentedViewController = baseViewController.presentedViewController,
      !presentedViewController.isBeingDismissed,
      presentedViewController.presentingViewController != nil,
      presentedViewController.viewIfLoaded?.window === window {
      return sdgActiveViewController(
        from: presentedViewController,
        in: window
      )
    }

    if let navigationController = baseViewController as? UINavigationController,
      let visibleViewController = navigationController.visibleViewController {
      return sdgActiveViewController(
        from: visibleViewController,
        in: window
      )
    }

    if let tabBarController = baseViewController as? UITabBarController,
      let selectedViewController = tabBarController.selectedViewController {
      return sdgActiveViewController(
        from: selectedViewController,
        in: window
      )
    }

    return baseViewController
  }
}
