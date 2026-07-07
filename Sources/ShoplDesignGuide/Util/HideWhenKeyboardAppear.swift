//
//  HideWhenKeyboardAppear.swift
//  ShoplDesignGuide
//
//  Created by Dino on 9/11/25.
//

import SwiftUI
import UIKit

extension View {
  public func hideWhenKeyboardAppear() -> some View {
    self.modifier(HideWhenKeyboardAppearModifier())
  }
}

struct HideWhenKeyboardAppearModifier: ViewModifier {
  @State private var isKeyboardAppeared: Bool = false
  @State private var viewControllerBox = WeakViewControllerBox()

  func body(content: Content) -> some View {
    content
      .background(
        TopScreenViewControllerReader(viewControllerBox: viewControllerBox)
      )
      .onReceive(
        NotificationCenter.default.publisher(
          for: UIResponder.keyboardWillShowNotification
        ),
        perform: { _ in
          guard isAttachedToTopViewController else {
            isKeyboardAppeared = false
            return
          }

          isKeyboardAppeared = true
        }
      )
      .onReceive(
        NotificationCenter.default.publisher(
          for: UIResponder.keyboardWillHideNotification
        ),
        perform: { _ in
          isKeyboardAppeared = false
        }
      )
      .isHidden(isKeyboardAppeared)
  }

  private var isAttachedToTopViewController: Bool {
    guard let viewController = viewControllerBox.viewController,
      let topViewController = UIApplication.sdgTopViewController()
    else {
      return false
    }

    return viewController.isDescendant(of: topViewController)
  }
}

private final class WeakViewControllerBox {
  weak var viewController: UIViewController?
}

private struct TopScreenViewControllerReader: UIViewControllerRepresentable {
  let viewControllerBox: WeakViewControllerBox

  func makeUIViewController(context: Context) -> ResolverViewController {
    let viewController = ResolverViewController(viewControllerBox: viewControllerBox)
    viewController.resolve()
    return viewController
  }

  func updateUIViewController(
    _ uiViewController: ResolverViewController,
    context: Context
  ) {
    uiViewController.viewControllerBox = viewControllerBox
    uiViewController.resolve()
  }

  static func dismantleUIViewController(
    _ uiViewController: ResolverViewController,
    coordinator: ()
  ) {
    uiViewController.clearResolvedViewController()
  }

  final class ResolverViewController: UIViewController {
    weak var viewControllerBox: WeakViewControllerBox?
    private weak var resolvedViewController: UIViewController?

    init(viewControllerBox: WeakViewControllerBox) {
      self.viewControllerBox = viewControllerBox
      super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func didMove(toParent parent: UIViewController?) {
      super.didMove(toParent: parent)
      resolve()
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      resolve()
    }

    func resolve() {
      let resolvedViewController = parent ?? self
      self.resolvedViewController = resolvedViewController
      viewControllerBox?.viewController = resolvedViewController
    }

    func clearResolvedViewController() {
      guard viewControllerBox?.viewController === resolvedViewController else {
        return
      }

      viewControllerBox?.viewController = nil
    }
  }
}

private extension UIApplication {
  static func sdgTopViewController(
    base: UIViewController? = UIApplication.sdgKeyWindow?.rootViewController
  ) -> UIViewController? {
    if let presentedViewController = base?.presentedViewController {
      return sdgTopViewController(base: presentedViewController)
    }

    if let navigationController = base as? UINavigationController {
      return sdgTopViewController(base: navigationController.visibleViewController)
    }

    if let tabBarController = base as? UITabBarController,
      let selectedViewController = tabBarController.selectedViewController {
      return sdgTopViewController(base: selectedViewController)
    }

    return base
  }

  private static var sdgKeyWindow: UIWindow? {
    UIApplication.shared
      .connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first { $0.isKeyWindow }
  }
}

private extension UIViewController {
  func isDescendant(of viewController: UIViewController) -> Bool {
    var currentViewController: UIViewController? = self

    while let candidate = currentViewController {
      if candidate === viewController {
        return true
      }

      currentViewController = candidate.parent
    }

    return false
  }
}
