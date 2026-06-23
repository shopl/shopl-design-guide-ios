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

  func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    context.coordinator.isEnabled = isEnabled

    let coordinator = context.coordinator
    DispatchQueue.main.async { [weak uiViewController] in
      guard let navigationController = uiViewController?.findNavigationController() else { return }

      coordinator.navigationController = navigationController
      navigationController.interactivePopGestureRecognizer?.isEnabled = isEnabled
      navigationController.interactivePopGestureRecognizer?.delegate = coordinator
    }
  }

  static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: Coordinator) {
    guard
      let gesture = coordinator.navigationController?.interactivePopGestureRecognizer,
      gesture.delegate === coordinator
    else {
      return
    }

    gesture.delegate = nil
  }
}

private final class Coordinator: NSObject, UIGestureRecognizerDelegate {
  weak var navigationController: UINavigationController?
  var isEnabled = true

  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard isEnabled else { return false }
    guard let navigationController else { return false }
    guard navigationController.viewControllers.count > 1 else { return false }
    guard navigationController.transitionCoordinator == nil else { return false }

    return true
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
