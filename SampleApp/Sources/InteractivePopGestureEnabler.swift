//
//  InteractivePopGestureEnabler.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/23/26.
//

import SwiftUI
import UIKit

extension View {
  func enableInteractivePopGesture(isEnabled: Bool = true) -> some View {
    background(InteractivePopGestureEnabler(isEnabled: isEnabled))
  }
}

private struct InteractivePopGestureEnabler: UIViewControllerRepresentable {
  let isEnabled: Bool

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeUIViewController(context: Context) -> NavigationControllerObserverViewController {
    NavigationControllerObserverViewController(coordinator: context.coordinator)
  }

  func updateUIViewController(_ uiViewController: NavigationControllerObserverViewController, context: Context) {
    context.coordinator.isEnabled = isEnabled
    uiViewController.coordinator = context.coordinator
    uiViewController.updateGestureRecognizer()
  }

  static func dismantleUIViewController(
    _ uiViewController: NavigationControllerObserverViewController,
    coordinator: Coordinator
  ) {
    uiViewController.restoreGestureRecognizer()
  }
}

private final class NavigationControllerObserverViewController: UIViewController {
  var coordinator: Coordinator

  init(coordinator: Coordinator) {
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)

    if parent == nil {
      restoreGestureRecognizer()
    } else {
      updateGestureRecognizer()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateGestureRecognizer()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateGestureRecognizer()
  }

  func updateGestureRecognizer() {
    guard let navigationController = findNavigationController() else { return }
    coordinator.configure(with: navigationController)
  }

  func restoreGestureRecognizer() {
    coordinator.restoreGestureRecognizer()
  }
}

private final class Coordinator: NSObject, UIGestureRecognizerDelegate {
  weak var navigationController: UINavigationController?
  weak var originalDelegate: UIGestureRecognizerDelegate?
  private var originalIsEnabled: Bool?
  private var hasStoredOriginalState = false
  var isEnabled = true

  func configure(with navigationController: UINavigationController) {
    if self.navigationController !== navigationController {
      restoreGestureRecognizer()
      self.navigationController = navigationController
    }

    guard let gesture = navigationController.interactivePopGestureRecognizer else { return }

    storeOriginalStateIfNeeded(for: gesture)
    gesture.isEnabled = isEnabled

    if gesture.delegate !== self {
      gesture.delegate = self
    }
  }

  func restoreGestureRecognizer() {
    defer {
      navigationController = nil
      originalDelegate = nil
      originalIsEnabled = nil
      hasStoredOriginalState = false
    }

    guard
      let gesture = navigationController?.interactivePopGestureRecognizer,
      gesture.delegate === self
    else {
      return
    }

    gesture.delegate = originalDelegate

    if let originalIsEnabled {
      gesture.isEnabled = originalIsEnabled
    }
  }

  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard isEnabled else { return false }
    guard let navigationController else { return false }
    guard navigationController.viewControllers.count > 1 else { return false }
    guard navigationController.transitionCoordinator == nil else { return false }

    return true
  }

  private func storeOriginalStateIfNeeded(for gesture: UIGestureRecognizer) {
    guard !hasStoredOriginalState else { return }

    originalDelegate = gesture.delegate
    originalIsEnabled = gesture.isEnabled
    hasStoredOriginalState = true
  }
}

private extension UIViewController {
  func findNavigationController() -> UINavigationController? {
    if let navigationController = self as? UINavigationController {
      return navigationController
    }

    if let navigationController {
      return navigationController
    }

    var parentViewController = parent
    while let viewController = parentViewController {
      if let navigationController = viewController as? UINavigationController {
        return navigationController
      }

      if let navigationController = viewController.navigationController {
        return navigationController
      }

      parentViewController = viewController.parent
    }

    return view.window?.rootViewController?.findNavigationControllerInHierarchy()
  }

  private func findNavigationControllerInHierarchy() -> UINavigationController? {
    if let navigationController = self as? UINavigationController {
      return navigationController
    }

    for child in children {
      if let navigationController = child.findNavigationControllerInHierarchy() {
        return navigationController
      }
    }

    return presentedViewController?.findNavigationControllerInHierarchy()
  }
}
