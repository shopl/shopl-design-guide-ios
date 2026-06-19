//
//  PopupHostingView.swift
//  DesignSystem
//
//  Created by Dino on 7/24/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI
import Combine

private class PopupState: ObservableObject {
  let dismissSubject = PassthroughSubject<Void, Never>()
  var onDismissCompleted: (() -> Void)?
}

private class PopupConfiguration<Content: View>: ObservableObject {
  var tapOutsideAction: (() -> Void)?
  var content: () -> Content

  init(
    tapOutsideAction: (() -> Void)?,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.tapOutsideAction = tapOutsideAction
    self.content = content
  }

  func update(
    tapOutsideAction: (() -> Void)?,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.tapOutsideAction = tapOutsideAction
    self.content = content
    objectWillChange.send()
  }
}

public class PopupHostingViewController<PopupView: View>: UIHostingController<AnyView>, UIViewControllerTransitioningDelegate {
  private let popupState = PopupState()
  private let popupConfiguration: PopupConfiguration<PopupView>
  private let animation: PopupAnimation
  private let presentationAnimator = PopupPresentationAnimator()
  private let dismissalAnimator: PopupDismissalAnimator<PopupView>

  public init(
    animation: PopupAnimation,
    tapOutsideAction: (() -> Void)? = nil,
    @ViewBuilder popup: @escaping () -> PopupView
  ) {
    let popupConfiguration = PopupConfiguration(
      tapOutsideAction: tapOutsideAction,
      content: popup
    )
    self.popupConfiguration = popupConfiguration
    self.animation = animation
    self.dismissalAnimator = PopupDismissalAnimator(animation: animation)

    let wrapper = ModifierWrapperView(
      popupState: self.popupState,
      popupConfiguration: popupConfiguration,
      animation: animation
    )
    super.init(rootView: AnyView(wrapper))

    if animation == .fadeInOut {
      self.modalTransitionStyle = .crossDissolve
    }
    self.modalPresentationStyle = .overFullScreen
    self.view.backgroundColor = .clear
    self.transitioningDelegate = self
  }

  required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  fileprivate func dismissWithPopupAnimation(completion: @escaping () -> Void) {
    self.popupState.onDismissCompleted = completion
    self.popupState.dismissSubject.send()
  }

  func updatePopup(
    tapOutsideAction: (() -> Void)?,
    @ViewBuilder popup: @escaping () -> PopupView
  ) {
    popupConfiguration.update(
      tapOutsideAction: tapOutsideAction,
      content: popup
    )
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return dismissalAnimator
  }

  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    guard animation == .slideBottomTop else {
      return nil
    }

    return presentationAnimator
  }
}

private struct ModifierWrapperView<Content: View>: View {
  @ObservedObject var popupState: PopupState
  @ObservedObject var popupConfiguration: PopupConfiguration<Content>

  let animation: PopupAnimation

  @State private var isPresented = false

  var body: some View {
    Color.clear
      .modifier(
        PopupOverlayModifier(
          isPresented: isPresented,
          animation: animation,
          tapOutsideAction: popupConfiguration.tapOutsideAction,
          onDismiss: { popupState.onDismissCompleted?() },
          popupContent: popupConfiguration.content
        )
      )
      .onAppear {
        self.isPresented = true
      }
      .onReceive(popupState.dismissSubject) { _ in
        self.isPresented = false
      }
  }
}

private class PopupDismissalAnimator<PopupView: View>: NSObject, UIViewControllerAnimatedTransitioning {

  private let animation: PopupAnimation

  init(animation: PopupAnimation) {
    self.animation = animation
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    switch animation {
    case .fadeInOut:
      return animation.dismissDuration * 2
    case .slideBottomTop:
      return animation.dismissDuration
    }
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from) as? PopupHostingViewController<PopupView> else {
      transitionContext.completeTransition(true)
      return
    }

    fromVC.dismissWithPopupAnimation {
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}

private class PopupPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let toVC = transitionContext.viewController(forKey: .to),
      let toView = transitionContext.view(forKey: .to)
    else {
      transitionContext.completeTransition(true)
      return
    }

    toView.frame = transitionContext.finalFrame(for: toVC)
    transitionContext.containerView.addSubview(toView)
    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
  }
}

#Preview {
  UIKitPresentationPreview()
}

struct UIKitPresentationPreview: UIViewControllerRepresentable {

  func makeUIViewController(context: Context) -> UIViewController {
    return PresentingViewController()
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
  }
}

class PresentingViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 20

    stackView.translatesAutoresizingMaskIntoConstraints = false

    let button = UIButton(configuration: .plain())
    button.setTitle("fadeInOut 팝업", for: .normal)

    let fadeInOutPopupAction = UIAction { [weak self] _ in
      self?.presentPopup(with: .fadeInOut)
    }
    button.addAction(fadeInOutPopupAction, for: .touchUpInside)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 8
    button.setTitleColor(.white, for: .normal)

    let button2 = UIButton(configuration: .plain())
    button2.setTitle("slideBottomTop 팝업", for: .normal)
    let slideBottomTopPopupAction = UIAction { [weak self] _ in
      self?.presentPopup(with: .slideBottomTop)
    }
    button2.addAction(slideBottomTopPopupAction, for: .touchUpInside)
    button2.backgroundColor = .systemBlue
    button2.layer.cornerRadius = 8
    button2.setTitleColor(.white, for: .normal)

    view.addSubview(stackView)
    stackView.addArrangedSubview(button)
    stackView.addArrangedSubview(button2)

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  func presentPopup(with animation: PopupAnimation) {
    let popupVC = PopupHostingViewController(
      animation: animation,
      tapOutsideAction: {
        self.dismiss(animated: true)
      }
    ) {
      SDGBottomPopup(
        title: .init(title: "타이틀", color: .neutral400, alignment: .leading),
        bodyContent: {
          Text("내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 ")
            .frame(maxWidth: .infinity, alignment: .leading)
        },
        button: .init(
          button: .oneOption(
            option: .init(
              title: "확인", action: {
                self.dismiss(animated: true)
              }
            )
          )
        )
      )
    }

    self.present(popupVC, animated: true)
  }
}
