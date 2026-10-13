//
//  SDGMiniListPopupPreview.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/30/26.
//

import SwiftUI
import UIKit

#Preview("Mini List · 3×3 호출 위치 · 호출부 8 / 16") {
  SDGMiniListPopupPreview(variant: .grid)
}

#Preview("Mini List · 스크롤 내부") {
  SDGMiniListPopupPreview(variant: .scroll)
}

#Preview("Mini List · 중첩·clipping 경계") {
  SDGMiniListPopupPreview(variant: .nested)
}

#Preview("Mini List · sheet 내부") {
  SDGMiniListPopupPreview(variant: .sheet)
}

#Preview("Mini List · 간격·경계 여백 변경") {
  SDGMiniListPopupPreview(variant: .spacing)
}

#Preview("Mini List · 긴 제목·비활성·높이 제한") {
  SDGMiniListPopupPreview(variant: .overflow)
}

#Preview("Mini List · 호출부 0 / 0") {
  SDGMiniListPopupPreview(variant: .zeroInsets)
}

#Preview("Mini List · 호출부 비대칭 여백") {
  SDGMiniListPopupPreview(variant: .asymmetric)
}

#Preview("Mini List · 버튼 이동 시 재배치") {
  SDGMiniListPopupPreview(variant: .movingAnchor)
}

#Preview("Mini List · 배경 스크롤·외부 탭·메뉴 터치 경계") {
  SDGMiniListPopupPreview(variant: .fixedBackgroundScroll)
}

#Preview("Mini List · 버튼 제거 시 닫힘") {
  SDGMiniListPopupPreview(variant: .removedAnchor)
}

#Preview("Mini List · sheet 배경 스크롤") {
  SDGMiniListPopupPreview(variant: .sheetScroll)
}

private enum SDGMiniListPopupPreviewVariant {
  case grid, scroll, nested, sheet, spacing, overflow, zeroInsets, asymmetric, movingAnchor
  case fixedBackgroundScroll, removedAnchor, sheetScroll
}

private enum SDGMiniListPopupPreviewSpacing {
  case zero, regular, wide, asymmetric

  var options: SDGMiniListPopup.PresentationOptions {
    switch self {
    case .zero:
      .init(sourceSpacing: 0, screenInsets: .zero)
    case .regular:
      .init(sourceSpacing: 8, screenInsets: .init(top: 16, left: 16, bottom: 16, right: 16))
    case .wide:
      .init(sourceSpacing: 24, screenInsets: .init(top: 32, left: 32, bottom: 32, right: 32))
    case .asymmetric:
      .init(sourceSpacing: 12, screenInsets: .init(top: 20, left: 28, bottom: 36, right: 40))
    }
  }
}

private struct SDGMiniListPopupPreviewState {
  var presentedAnchorID: String?
  var showsSheet = false
  var spacing = SDGMiniListPopupPreviewSpacing.regular
  var anchorOffset: CGFloat = 0
  var selectionCount = 0
  var dismissalCount = 0
  var backgroundActionCount = 0
  var showsAnchor = true

  var options: SDGMiniListPopup.PresentationOptions { spacing.options }
}

private struct SDGMiniListPopupPreview: View {
  let variant: SDGMiniListPopupPreviewVariant
  @State private var state = SDGMiniListPopupPreviewState()

  init(variant: SDGMiniListPopupPreviewVariant) {
    self.variant = variant
    var initialState = SDGMiniListPopupPreviewState()
    if variant == .zeroInsets { initialState.spacing = .zero }
    if variant == .asymmetric { initialState.spacing = .asymmetric }
    state = initialState
  }

  var body: some View {
    previewContent
      .sheet(
        isPresented: sheetBinding,
        onDismiss: { setSheet(false) },
        content: { sheetContent }
      )
  }
}

extension SDGMiniListPopupPreview {
  private var previewContent: some View {
    VStack(spacing: 16) {
      Text(
        "선택 \(state.selectionCount) / 닫힘 \(state.dismissalCount)"
          + " / 배경 실행 \(state.backgroundActionCount)"
      )
        .typo(.body2_R, .neutral700)
      content
    }
    .padding(16)
    .background(SDG.Color.neutral100.color)
  }

  private var sheetBinding: Binding<Bool> {
    Binding(
      get: { state.showsSheet },
      set: { setSheet($0) }
    )
  }

  private var sheetContent: some View {
    VStack {
      Button("닫기") { setSheet(false) }
      if variant == .sheetScroll {
        backgroundScrollContent(prefix: "sheet-scroll")
      } else {
        positionGrid(prefix: "sheet")
      }
    }
    .padding(16)
    .background(SDG.Color.neutral100.color)
  }

  @ViewBuilder
  private var content: some View {
    switch variant {
    case .grid, .overflow, .zeroInsets, .asymmetric:
      positionGrid(prefix: "grid")
    case .scroll:
      ScrollView {
        LazyVStack(spacing: 80) {
          ForEach(0..<30) { index in
            HStack {
              Text("\(index + 1)").typo(.body1_R, .neutral700)
              Spacer()
              anchorButton(id: "scroll-\(index)")
            }
          }
        }
      }
    case .nested:
      VStack {
        Spacer()
        positionGrid(prefix: "nested")
          .frame(height: 240)
          .padding(16)
          .background(SDG.Color.neutral200.color)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        Spacer()
      }
    case .sheet, .sheetScroll:
      Button("sheet 열기") { setSheet(true) }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    case .spacing:
      VStack {
        HStack {
          Button("0 / 0") { state.spacing = .zero }
          Button("8 / 16") { state.spacing = .regular }
          Button("24 / 32") { state.spacing = .wide }
          Button("12 / 20·28·36·40") { state.spacing = .asymmetric }
        }
        positionGrid(prefix: "spacing")
      }
    case .fixedBackgroundScroll:
      backgroundScrollContent(prefix: "fixed")
    case .removedAnchor:
      VStack {
        if state.showsAnchor { anchorButton(id: "removed") }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .task(id: state.presentedAnchorID) {
        guard state.presentedAnchorID == "removed" else { return }
        do { try await Task.sleep(for: .milliseconds(600)) }
        catch { return }
        state.showsAnchor = false
      }
    case .movingAnchor:
      anchorButton(id: "moving")
        .offset(x: state.anchorOffset)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: state.presentedAnchorID) {
          guard state.presentedAnchorID == "moving" else { return }
          do { try await Task.sleep(for: .milliseconds(600)) }
          catch { return }
          state.anchorOffset = state.anchorOffset == 0 ? 40 : 0
        }
    }
  }

  private func backgroundScrollContent(prefix: String) -> some View {
    VStack(spacing: 16) {
      HStack {
        Button("닫기") { state.backgroundActionCount += 1 }
        Spacer()
        anchorButton(id: prefix)
      }
      ScrollView(.horizontal) {
        HStack {
          ForEach(0..<20) { index in
            Button(String(index + 1)) { state.backgroundActionCount += 1 }
              .frame(width: 100, height: 48)
              .background(SDG.Color.neutral0.color)
          }
        }
      }
      ScrollView {
        LazyVStack(spacing: 16) {
          ForEach(0..<30) { index in
            Button(String(index + 1)) { state.backgroundActionCount += 1 }
              .frame(maxWidth: .infinity, minHeight: 64)
              .background(SDG.Color.neutral0.color)
          }
        }
      }
    }
  }

  private func positionGrid(prefix: String) -> some View {
    VStack {
      ForEach(0..<3) { row in
        if row > 0 { Spacer() }
        HStack {
          ForEach(0..<3) { column in
            if column > 0 { Spacer() }
            anchorButton(id: "\(prefix)-\(row)-\(column)")
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func anchorButton(id: String) -> some View {
    Button {
      state.presentedAnchorID = state.presentedAnchorID == id ? nil : id
    } label: {
      SDG.Image.icCommonMore.image
        .resizable()
        .renderingMode(.template)
        .foregroundStyle(SDG.Color.neutral700.color)
        .frame(width: 14, height: 14)
        .frame(width: 36, height: 36)
        .background(SDG.Color.neutral0.color)
        .clipShape(Circle())
    }
    .buttonStyle(.plain)
    .miniListPopup(
      isPresented: state.presentedAnchorID == id,
      items: items,
      options: state.options,
      onSelect: { _ in state.selectionCount += 1 },
      onDismiss: { dismissAnchor(id) }
    )
  }

  private var items: [SDGMiniListPopup.Item] {
    var items: [SDGMiniListPopup.Item] = [
      .init(id: "select", title: "선택"),
      .init(id: "approve", title: "실행", color: .primary300),
      .init(
        id: "reject",
        title: "비활성 항목",
        color: .neutral350,
        isEnabled: false
      )
    ]
    if variant == .overflow {
      items[0] = .init(
        id: "long",
        title: String(repeating: "두 줄을 넘는 긴 메뉴 제목 ", count: 4)
      )
      items += (4...30).map { .init(id: "item-\($0)", title: String($0)) }
    }
    return items
  }
}

extension SDGMiniListPopupPreview {
  private func setSheet(_ presented: Bool) {
    state.showsSheet = presented
    if !presented { state.presentedAnchorID = nil }
  }

  private func dismissAnchor(_ id: String) {
    guard state.presentedAnchorID == id else { return }
    state.presentedAnchorID = nil
    state.dismissalCount += 1
  }
}
