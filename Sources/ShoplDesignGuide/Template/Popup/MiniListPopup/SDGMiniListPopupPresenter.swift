//
//  SDGMiniListPopupPresenter.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/30/26.
//

import SwiftUI
import UIKit

/// 호출 버튼에 투명한 UIKit 기준 뷰를 붙여 표시 요청과 화면 수명을 연결한다.
struct SDGMiniListPopupPresenter: UIViewControllerRepresentable {
  let isPresented: Bool
  let items: [SDGMiniListPopup.Item]
  let options: SDGMiniListPopup.PresentationOptions
  let onSelect: (String) -> Void
  let onDismiss: () -> Void

  func makeCoordinator() -> Coordinator {
    Coordinator(options: options)
  }

  func makeUIViewController(context: Context) -> SDGMiniListPopupAnchorController {
    let controller = SDGMiniListPopupAnchorController()
    let coordinator = context.coordinator
    coordinator.anchorController = controller
    controller.onLayout = { [weak coordinator] in
      coordinator?.anchorDidLayout()
    }
    controller.onRemoval = { [weak coordinator] in
      coordinator?.cancelPresentation()
    }
    return controller
  }

  func updateUIViewController(_ controller: SDGMiniListPopupAnchorController, context: Context) {
    context.coordinator.update(
      isPresented: isPresented,
      items: items,
      options: options,
      onSelect: onSelect,
      onDismiss: onDismiss
    )
  }

  static func dismantleUIViewController(
    _ controller: SDGMiniListPopupAnchorController,
    coordinator: Coordinator
  ) {
    controller.onLayout = nil
    controller.onRemoval = nil
    coordinator.cancelPresentation()
  }

  @MainActor
  final class Coordinator: NSObject {
    // 표시·닫힘 애니메이션이 겹치지 않도록 단계별로 요청을 처리한다.
    private enum Phase {
      case idle, presenting, presented, dismissing
    }

    private enum Dismissal {
      case external, selection(String)
    }

    weak var anchorController: SDGMiniListPopupAnchorController?

    private var isPresented = false
    private var items: [SDGMiniListPopup.Item] = []
    private var options: SDGMiniListPopup.PresentationOptions
    private var onSelect: ((String) -> Void)?
    private var onDismiss: (() -> Void)?
    private var popup: (UIView & UIContentView)?
    private var presentationController: SDGMiniListPopupPresentationController?
    // 표시 중 들어온 닫힘 요청은 표시 페이드가 끝난 뒤 처리한다.
    private var pendingDismissal = false
    private var waitingTransitionID: Int?
    private var phase: Phase = .idle
    private var dismissal: Dismissal = .external
    // 이전 표시의 비동기 콜백이 새 팝업을 변경하지 않도록 표시마다 ID를 구분한다.
    private var presentationID = 0
    // 표시 값의 변경 횟수(intentRevision)와 닫기 시작 시점의 값(dismissalRevision)을 비교한다.
    // 재호출 여부는 두 revision과 현재 표시 요청으로 판단한다.
    private var intentRevision = 0
    private var dismissalRevision = 0

    init(options: SDGMiniListPopup.PresentationOptions) {
      self.options = options
      super.init()
    }

    func update(
      isPresented: Bool,
      items: [SDGMiniListPopup.Item],
      options: SDGMiniListPopup.PresentationOptions,
      onSelect: @escaping (String) -> Void,
      onDismiss: @escaping () -> Void
    ) {
      if self.isPresented != isPresented {
        intentRevision += 1
      }
      self.isPresented = isPresented
      self.items = items
      self.options = options
      self.onSelect = onSelect
      self.onDismiss = onDismiss

      if let popup {
        popup.configuration = UIHostingConfiguration { menuView }.margins(.all, 0)
        presentationController?.update(contentSize: contentSize, options: options)
      }

      if isPresented && !items.isEmpty {
        presentIfNeeded()
      } else if phase == .presented || phase == .presenting {
        dismiss(reason: .external)
      } else if isPresented && items.isEmpty && phase == .idle {
        self.isPresented = false
        notifyDismissalOnNextRunLoop()
      }
    }

    func anchorDidLayout() {
      presentationController?.anchorDidLayout()
      presentIfNeeded()
    }

    func cancelPresentation() {
      guard isPresented || popup != nil else { return }
      presentationID += 1
      isPresented = false
      presentationController?.removeOverlay()
      popup = nil
      presentationController = nil
      pendingDismissal = false
      waitingTransitionID = nil
      phase = .idle
      notifyDismissalOnNextRunLoop()
    }

    private var contentSize: CGSize {
      .init(
        width: SDGMiniListPopupStyle.width,
        height: SDGMiniListPopupStyle.height(itemCount: items.count)
      )
    }

    private var menuView: SDGMiniListPopup {
      SDGMiniListPopup(items: items) { [weak self] id in
        guard let self,
          self.items.contains(where: { $0.id == id && $0.isEnabled })
        else { return }
        self.dismiss(reason: .selection(id))
      }
    }

    private func presentIfNeeded() {
      guard isPresented, !items.isEmpty, phase == .idle,
        let anchorController,
        anchorController.view.window != nil,
        !anchorController.view.bounds.isEmpty
      else { return }

      // 네비게이션·탭 컨테이너를 넘지 않고 버튼이 속한 화면을 찾는다.
      var presenter: UIViewController = anchorController
      while let parent = presenter.parent,
        !(parent is UINavigationController), !(parent is UITabBarController) {
        presenter = parent
      }
      guard presenter.view.window === anchorController.view.window else { return }
      guard !presenter.isBeingDismissed else {
        isPresented = false
        notifyDismissalOnNextRunLoop()
        return
      }
      guard !presenter.isBeingPresented, presenter.transitionCoordinator == nil else {
        waitForTransition(of: presenter)
        return
      }
      guard !hasPresentedModal(from: presenter) else {
        isPresented = false
        notifyDismissalOnNextRunLoop()
        return
      }

      waitingTransitionID = nil
      presentationID += 1
      let popup = UIHostingConfiguration { menuView }.margins(.all, 0).makeContentView()
      self.popup = popup
      pendingDismissal = false
      dismissal = .external
      dismissalRevision = intentRevision
      phase = .presenting
      let id = presentationID
      let controller = SDGMiniListPopupPresentationController(
        contentView: popup,
        contentSize: contentSize,
        anchorController: anchorController,
        options: options
      )
      controller.onDismissRequested = { [weak self] in
        guard let self, self.presentationID == id else { return }
        self.dismiss(reason: .external)
      }
      controller.onInvalidAnchor = { [weak self] in
        guard let self, self.presentationID == id else { return }
        self.dismiss(reason: .external)
      }
      presentationController = controller
      controller.animationView.alpha = 0
      guard controller.install(in: presenter) else {
        presentationCompleted(false, presentationID: id)
        return
      }
      SDGMiniListPopupTransition.fade(
        controller.animationView,
        isPresenting: true,
        completion: { [weak self] in self?.presentationCompleted(true, presentationID: id) }
      )
    }

    private func hasPresentedModal(from presenter: UIViewController) -> Bool {
      var owner: UIViewController? = presenter
      while let controller = owner {
        if controller.presentedViewController != nil { return true }
        owner = controller.parent
      }
      return false
    }

    // sheet·화면 전환이 끝난 뒤 재시도하며, 그사이 취소된 요청은 ID로 걸러낸다.
    private func waitForTransition(of presenter: UIViewController) {
      guard waitingTransitionID == nil, let transition = presenter.transitionCoordinator
      else { return }
      let id = presentationID
      waitingTransitionID = id
      transition.animate(alongsideTransition: nil) { [weak self] _ in
        DispatchQueue.main.async { [weak self] in
          guard let self, self.presentationID == id, self.waitingTransitionID == id else { return }
          self.waitingTransitionID = nil
          self.presentIfNeeded()
        }
      }
    }

    private func presentationCompleted(_ completed: Bool, presentationID: Int) {
      guard self.presentationID == presentationID, popup != nil else { return }
      guard completed else {
        dismissal = .external
        finishDismissal(presentationID: presentationID, allowsReopen: false)
        return
      }
      phase = .presented
      presentationController?.presentationDidFinish()
      if pendingDismissal {
        performDismissal()
      } else if !isPresented || items.isEmpty {
        dismiss(reason: .external)
      }
    }

    private func dismiss(reason: Dismissal) {
      guard phase == .presenting || phase == .presented, !pendingDismissal else { return }
      dismissal = reason
      dismissalRevision = intentRevision
      if phase == .presenting {
        pendingDismissal = true
      } else {
        performDismissal()
      }
    }

    private func performDismissal() {
      guard phase == .presented, let presentationController else { return }
      pendingDismissal = false
      phase = .dismissing
      presentationController.beginDismissal()
      let currentPresentationID = presentationID
      SDGMiniListPopupTransition.fade(
        presentationController.animationView,
        isPresenting: false,
        completion: { [weak self] in
          self?.finishDismissal(presentationID: currentPresentationID)
        }
      )
    }

    private func finishDismissal(presentationID: Int, allowsReopen: Bool = true) {
      guard self.presentationID == presentationID, popup != nil else { return }
      let shouldReopen = allowsReopen && isPresented
        && intentRevision != dismissalRevision && !items.isEmpty
      var selectedID: String?
      if case .selection(let id) = dismissal, isPresented, !shouldReopen,
        items.contains(where: { $0.id == id && $0.isEnabled }) {
        selectedID = id
      }
      presentationController?.removeOverlay()
      popup = nil
      presentationController = nil
      pendingDismissal = false
      phase = .idle

      // 새 표시 요청이 있으면 이전 닫힘·선택 콜백 대신 다시 연다.
      if shouldReopen {
        DispatchQueue.main.async { [weak self] in
          guard let self, self.presentationID == presentationID else { return }
          self.presentIfNeeded()
        }
        return
      }

      isPresented = false
      let dismissAction = onDismiss
      let selectAction = onSelect
      dismissAction?()
      if let selectedID { selectAction?(selectedID) }
    }

    // 통지를 다음 run loop로 미루고, 그사이 새 표시 요청이 오면 이전 통지는 버린다.
    private func notifyDismissalOnNextRunLoop() {
      let currentPresentationID = presentationID
      let currentIntentRevision = intentRevision
      DispatchQueue.main.async { [self] in
        guard self.presentationID == currentPresentationID,
          self.intentRevision == currentIntentRevision,
          !self.isPresented
        else { return }
        self.onDismiss?()
      }
    }
  }
}

/// 호출 버튼의 좌표와 화면 이탈을 UIKit에서 관찰하는 투명 기준점.
final class SDGMiniListPopupAnchorController: UIViewController {
  var onLayout: (() -> Void)?
  var onRemoval: (() -> Void)?

  override func loadView() {
    let anchorView = SDGMiniListPopupAnchorView()
    anchorView.backgroundColor = .clear
    anchorView.isUserInteractionEnabled = false
    anchorView.onWindowChanged = { [weak self] in
      guard let self else { return }
      if self.view.window == nil { self.onRemoval?() }
      else { self.onLayout?() }
    }
    view = anchorView
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    onLayout?()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    onRemoval?()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    onLayout?()
  }
}

private final class SDGMiniListPopupAnchorView: UIView {
  var onWindowChanged: (() -> Void)?

  override func didMoveToWindow() {
    super.didMoveToWindow()
    onWindowChanged?()
  }
}
