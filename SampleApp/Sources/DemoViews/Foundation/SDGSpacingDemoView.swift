//
//  SDGSpacingDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/23/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGSpacingDemoView: View {
  @StateObject private var viewModel = SDGSpacingDemoViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: .spacing12) {
      VStack(alignment: .leading, spacing: .spacing8) {
        Text(sdg: "Spec")
          .typo(.body3_SB, .neutral350)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        SDGScrollTab(
          type: .text,
          list: viewModel.tabModels,
          selectedIndex: $viewModel.selectedTabIndex
        )
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      SDGSpacingSpecCard(tab: viewModel.selectedTab)
    }
    .padding(.horizontal, .spacing16)
    .padding(.top, .spacing16)
    .padding(.bottom, .spacing40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private final class SDGSpacingDemoViewModel: ObservableObject {
  @Published var selectedTabIndex = 0
  
  private let tabs = SDGSpacingSpecTab.allCases
  
  var selectedTab: SDGSpacingSpecTab {
    tabs[safe: selectedTabIndex] ?? .common
  }
  
  var tabModels: [SDGScrollTab.Model] {
    tabs.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }
}

private enum SDGSpacingSpecTab: String, CaseIterable, Identifiable {
  case common
  case special
  
  var id: String {
    rawValue
  }
  
  var title: String {
    switch self {
    case .common: return "Common"
    case .special: return "Special"
    }
  }
  
  var sectionTitle: String {
    switch self {
    case .common:
      return "기본 2의 배수"
    case .special:
      return "추가적으로 화면 구성에 필요한 단위"
    }
  }
  
  var items: [SDGSpacingSpecItem] {
    switch self {
    case .common:
      return [
        .init(spacing: .spacing2),
        .init(spacing: .spacing4),
        .init(spacing: .spacing6),
        .init(spacing: .spacing8),
        .init(spacing: .spacing10),
        .init(spacing: .spacing12),
        .init(spacing: .spacing16),
        .init(spacing: .spacing20),
        .init(spacing: .spacing24),
        .init(spacing: .spacing28),
        .init(spacing: .spacing32),
        .init(spacing: .spacing40)
      ]
    case .special:
      return [
        .init(spacing: .spacing1),
        .init(spacing: .spacing3),
        .init(spacing: .spacing5),
        .init(spacing: .spacing7),
        .init(spacing: .spacing11),
        .init(spacing: .spacing18),
        .init(spacing: .spacing28),
        .init(spacing: .spacing32),
        .init(spacing: .spacing60),
        .init(spacing: .spacing100),
        .init(spacing: .spacing104)
      ]
    }
  }
}

private struct SDGSpacingSpecItem: Identifiable {
  let spacing: SDGSpacing
  
  var id: String {
    name
  }
  
  var name: String {
    "\(Int(spacing.rawValue))"
  }
  
  var size: CGFloat {
    spacing.rawValue
  }
}

private struct SDGSpacingSpecCard: View {
  let tab: SDGSpacingSpecTab
  
  var body: some View {
    VStack(alignment: .leading, spacing: .spacing12) {
      Text(sdg: tab.sectionTitle)
        .typo(.body2_R, .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      SDGSpacingPreviewPanel(items: tab.items)
    }
    .padding(.spacing16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }
}

private struct SDGSpacingPreviewPanel: View {
  let items: [SDGSpacingSpecItem]
  
  var body: some View {
    VStack(spacing: .spacing16) {
      ForEach(items) { item in
        SDGSpacingPreviewItem(item: item)
      }
    }
    .padding(.horizontal, .spacing16)
    .padding(.vertical, .spacing32)
    .frame(maxWidth: .infinity)
    .background(Color.neutral50)
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
  }
}

private struct SDGSpacingPreviewItem: View {
  let item: SDGSpacingSpecItem
  
  var body: some View {
    VStack(spacing: .spacing10) {
      Rectangle()
        .fill(Color.info.opacity(0.2))
        .frame(width: item.size, height: item.size)
      
      Text(sdg: item.name)
        .typo(.body3_R, .neutral400)
        .frame(height: 16)
    }
    .frame(width: 52)
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}

#Preview {
  SDGSpacingDemoView()
}
