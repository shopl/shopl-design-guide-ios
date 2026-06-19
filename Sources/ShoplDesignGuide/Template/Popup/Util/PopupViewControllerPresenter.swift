//
//  PopupViewControllerPresenter.swift
//  ShoplDesignGuide
//

import SwiftUI
import UIKit

struct PopupViewControllerPresenter<PopupContent: View>: UIViewControllerRepresentable {

  let isPresented: Bool
  let animation: PopupAnimation
  let tapOutsideAction: (() -> Void)?
  @ViewBuilder let popupContent: () -> PopupContent

  init(
    isPresented: Bool,
    animation: PopupAnimation,
    tapOutsideAction: (() -> Void)?,
    @ViewBuilder popupContent: @escaping () -> PopupContent
  ) {
    self.isPresented = isPresented
    self.animation = animation
    self.tapOutsideAction = tapOutsideAction
    self.popupContent = popupContent
  }

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeUIViewController(context: Context) -> PopupPresentationHostController {
    let viewController = PopupPresentationHostController()
    let coordinator = context.coordinator
    viewController.onViewDidAppear = { [weak coordinator] in
      coordinator?.presentIfNeeded()
    }
    context.coordinator.hostViewController = viewController
    return viewController
  }

  func updateUIViewController(_ uiViewController: PopupPresentationHostController, context: Context) {
    context.coordinator.update(
      isPresented: isPresented,
      animation: animation,
      tapOutsideAction: tapOutsideAction,
      popupContent: popupContent
    )
  }

  static func dismantleUIViewController(_ uiViewController: PopupPresentationHostController, coordinator: Coordinator) {
    coordinator.dismissImmediately()
  }

  final class Coordinator {
    fileprivate weak var hostViewController: UIViewController?

    private var isPresented = false
    private var animation: PopupAnimation = .slideBottomTop
    private var tapOutsideAction: (() -> Void)?
    private var popupContent: (() -> PopupContent)?
    private var presentedViewController: PopupHostingViewController<PopupContent>?
    private var isPresenting = false
    private var isDismissing = false

    func update(
      isPresented: Bool,
      animation: PopupAnimation,
      tapOutsideAction: (() -> Void)?,
      popupContent: @escaping () -> PopupContent
    ) {
      self.isPresented = isPresented
      self.animation = animation
      self.tapOutsideAction = tapOutsideAction
      self.popupContent = popupContent

      presentedViewController?.updatePopup(
        tapOutsideAction: tapOutsideAction,
        popup: popupContent
      )

      if isPresented {
        presentIfNeeded()
      } else {
        dismissIfNeeded()
      }
    }

    fileprivate func presentIfNeeded() {
      guard
        isPresented,
        !isPresenting,
        !isDismissing,
        presentedViewController == nil,
        let hostViewController,
        hostViewController.view.window != nil,
        hostViewController.presentedViewController == nil,
        let popupContent
      else {
        return
      }

      isPresenting = true
      let popupViewController = PopupHostingViewController(
        animation: animation,
        tapOutsideAction: tapOutsideAction,
        popup: popupContent
      )
      presentedViewController = popupViewController

      hostViewController.present(popupViewController, animated: true) { [weak self] in
        guard let self else { return }

        self.isPresenting = false
        if !self.isPresented {
          self.dismissIfNeeded()
        }
      }
    }

    private func dismissIfNeeded() {
      guard
        !isPresenting,
        !isDismissing,
        let presentedViewController
      else {
        return
      }

      isDismissing = true
      presentedViewController.dismiss(animated: true) { [weak self] in
        guard let self else { return }

        self.presentedViewController = nil
        self.isDismissing = false
        if self.isPresented {
          self.presentIfNeeded()
        }
      }
    }

    fileprivate func dismissImmediately() {
      isPresented = false
      presentedViewController?.dismiss(animated: false)
      presentedViewController = nil
      isPresenting = false
      isDismissing = false
    }
  }
}

final class PopupPresentationHostController: UIViewController {
  var onViewDidAppear: (() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    onViewDidAppear?()
  }
}
