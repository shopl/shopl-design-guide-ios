//
//  SDGMiniListPopup.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/30/26.
//

import SwiftUI
import UIKit

/// 메뉴 콘텐츠를 렌더링한다. 버튼 기준 팝업 표시에는 `miniListPopup`을 사용한다.
public struct SDGMiniListPopup: View {
  public struct Item: Identifiable {
    public let id: String
    public let title: String
    public let color: SDG.Color
    public let isEnabled: Bool

    public init(
      id: String,
      title: String,
      color: SDG.Color = .neutral700,
      isEnabled: Bool = true
    ) {
      self.id = id
      self.title = title
      self.color = color
      self.isEnabled = isEnabled
    }
  }

  public struct PresentationOptions: Equatable {
    /// 호출 버튼과 메뉴 사이의 간격(pt).
    public var sourceSpacing: CGFloat
    /// 소유 화면의 Safe Area 안쪽에 추가할 메뉴 경계 여백.
    public var screenInsets: UIEdgeInsets

    public init(
      sourceSpacing: CGFloat,
      screenInsets: UIEdgeInsets
    ) {
      self.sourceSpacing = sourceSpacing
      self.screenInsets = screenInsets
    }
  }

  private let items: [Item]
  private let onSelect: (String) -> Void

  public init(
    items: [Item],
    onSelect: @escaping (String) -> Void
  ) {
    self.items = items
    self.onSelect = onSelect
  }

  public var body: some View {
    GeometryReader { geometry in
      ScrollView(showsIndicators: false) {
        VStack(spacing: 0) {
          ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
            row(item)
            if index < items.count - 1 {
              SDG.Color.neutral200.color
                .frame(height: SDGMiniListPopupStyle.dividerHeight)
            }
          }
        }
      }
      .scrollDisabled(
        geometry.size.height >= SDGMiniListPopupStyle.height(itemCount: items.count)
      )
    }
    .frame(width: SDGMiniListPopupStyle.width)
    .background(SDG.Color.neutral0.color)
    .clipShape(RoundedRectangle(cornerRadius: SDGMiniListPopupStyle.cornerRadius))
    .ignoresSafeArea()
  }
}

extension SDGMiniListPopup {
  private func row(_ item: Item) -> some View {
    Button {
      onSelect(item.id)
    } label: {
      Text(item.title)
        .typo(.body1_R, item.color)
        .lineLimit(2)
        .truncationMode(.tail)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .frame(height: SDGMiniListPopupStyle.rowHeight)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .disabled(!item.isEnabled)
  }
}

extension View {
  /// 호출 버튼에 적용하며 표시 상태는 호출부에서 관리한다.
  /// 선택 시 닫힘 완료 후 `onDismiss`, `onSelect` 순서로 통지한다.
  public func miniListPopup(
    isPresented: Bool,
    items: [SDGMiniListPopup.Item],
    options: SDGMiniListPopup.PresentationOptions,
    onSelect: @escaping (String) -> Void,
    onDismiss: @escaping () -> Void
  ) -> some View {
    background {
      SDGMiniListPopupPresenter(
        isPresented: isPresented,
        items: items,
        options: options,
        onSelect: onSelect,
        onDismiss: onDismiss
      )
    }
  }
}

enum SDGMiniListPopupStyle {
  static let width: CGFloat = 200
  static let rowHeight: CGFloat = 48
  static let dividerHeight: CGFloat = 1
  static let cornerRadius: CGFloat = 12
  static let shadowRadius: CGFloat = 8

  static func height(itemCount: Int) -> CGFloat {
    CGFloat(itemCount) * rowHeight + CGFloat(max(0, itemCount - 1)) * dividerHeight
  }
}
