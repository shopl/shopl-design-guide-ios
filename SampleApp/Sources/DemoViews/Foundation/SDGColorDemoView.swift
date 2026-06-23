//
//  SDGColorDemoView.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/28/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI
import ShoplDesignGuide

struct SDGColorDemoView: View {
  @StateObject private var viewModel = SDGColorDemoViewModel()
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(sdg: "Spec")
        .typo(.body3_SB, .neutral300)
        .padding(.horizontal, 16)
        .padding(.top, 16)
      
      SDGScrollTab(
        type: .text,
        list: viewModel.tabModels,
        selectedIndex: $viewModel.selectedTabIndex,
        horizontalPadding: 16
      )
      .padding(.top, 8)
      
      SDGColorPaletteCard(
        sections: viewModel.selectedTab.sections,
        cellWidth: viewModel.selectedTab.cellWidth,
        columnSpacing: viewModel.selectedTab.columnSpacing
      )
      .padding(.horizontal, 16)
      .padding(.top, 16)
      .padding(.bottom, 40)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private final class SDGColorDemoViewModel: ObservableObject {
  @Published var selectedTabIndex = 0
  
  private let tabs = SDGColorPaletteTab.allCases
  
  var selectedTab: SDGColorPaletteTab {
    tabs[safe: selectedTabIndex] ?? .neutral
  }
  
  var tabModels: [SDGScrollTab.Model] {
    tabs.map {
      SDGScrollTab.Model(id: $0.id, title: $0.title)
    }
  }
}

private enum SDGColorPaletteTab: String, CaseIterable, Identifiable {
  case neutral
  case brand
  case point
  case special
  
  var id: String {
    rawValue
  }
  
  var title: String {
    switch self {
    case .neutral: return "Neutral"
    case .brand: return "Brand"
    case .point: return "Point"
    case .special: return "Special"
    }
  }
  
  var cellWidth: CGFloat {
    switch self {
    case .special:
      return 40
    case .neutral, .brand, .point:
      return 52
    }
  }
  
  var columnSpacing: CGFloat {
    switch self {
    case .special:
      return 24
    case .neutral, .brand, .point:
      return 9
    }
  }
  
  var sections: [SDGColorPaletteSection] {
    switch self {
    case .neutral:
      return [
        SDGColorPaletteSection(
          id: "neutral_base",
          title: nil,
          items: [
            .init(name: "900", color: .neutral900),
            .init(name: "700", color: .neutral700),
            .init(name: "600", color: .neutral600),
            .init(name: "500", color: .neutral500),
            .init(name: "400", color: .neutral400),
            .init(name: "350", color: .neutral350),
            .init(name: "300", color: .neutral300),
            .init(name: "250", color: .neutral250),
            .init(name: "200", color: .neutral200),
            .init(name: "150", color: .neutral150),
            .init(name: "100", color: .neutral100),
            .init(name: "50", color: .neutral50),
            .init(name: "0", color: .neutral0, needsBorder: true)
          ]
        ),
        SDGColorPaletteSection(
          id: "neutral_opacity",
          title: nil,
          items: [
            .init(name: "900-10", color: .neutral900_10),
            .init(name: "700-10", color: .neutral700_10),
            .init(name: "600-10", color: .neutral600_10),
            .init(name: "500-10", color: .neutral500_10),
            .init(name: "400-10", color: .neutral400_10),
            .init(name: "350-10", color: .neutral350_10),
            .init(name: "300-10", color: .neutral300_10),
            .init(name: "250-10", color: .neutral250_10),
            .init(name: "200-10", color: .neutral200_10),
            .init(name: "150-10", color: .neutral150_10),
            .init(name: "100-10", color: .neutral100_10),
            .init(name: "50-10", color: .neutral50_10),
            .init(name: "0-10", color: .neutral0_10, needsBorder: true)
          ]
        )
      ]
      
    case .brand:
      return [
        SDGColorPaletteSection(
          id: "brand_primary",
          title: "Primary",
          items: [
            .init(name: "400", color: .primary400),
            .init(name: "300", color: .primary300),
            .init(name: "200", color: .primary200),
            .init(name: "50", color: .primary50),
            .init(name: "300-10", color: .primary300_10)
          ]
        ),
        SDGColorPaletteSection(
          id: "brand_secondary",
          title: "Secondary",
          items: [
            .init(name: "400", color: .secondary400),
            .init(name: "300", color: .secondary300),
            .init(name: "200", color: .secondary200),
            .init(name: "50", color: .secondary50),
            .init(name: "400-10", color: .sencondary400_10),
            .init(name: "300-10", color: .secondary300_10)
          ]
        )
      ]
      
    case .point:
      return [
        SDGColorPaletteSection(
          id: "point_red",
          title: "Red",
          items: [
            .init(name: "400", color: .red400),
            .init(name: "350", color: .red350),
            .init(name: "300", color: .red300),
            .init(name: "50", color: .red50),
            .init(name: "300-10", color: .red300_10)
          ]
        ),
        SDGColorPaletteSection(
          id: "point_yellow",
          title: "Yellow",
          items: [
            .init(name: "Y", color: .sdgYellow),
            .init(name: "Y-10", color: .sdgYellow_10)
          ]
        ),
        SDGColorPaletteSection(
          id: "point_purple",
          title: "Purple",
          items: [
            .init(name: "P", color: .sdgPurple),
            .init(name: "P-10", color: .sdgPurple_10)
          ]
        ),
        SDGColorPaletteSection(
          id: "point_green",
          title: "Green",
          items: [
            .init(name: "G", color: .sdgGreen),
            .init(name: "G-10", color: .sdgGreen_10)
          ]
        )
      ]
      
    case .special:
      return [
        SDGColorPaletteSection(
          id: "special",
          title: nil,
          items: [
            .init(name: "OR", color: .sdgOrange),
            .init(name: "PK", color: .sdgSpecialPink),
            .init(name: "LE", color: .sdgLemon),
            .init(name: "CG", color: .sdgCoolGray),
            .init(name: "YG", color: .sdgYellowGreen),
            .init(name: "RP", color: .sdgRedPurple),
            .init(name: "MG", color: .sdgGreen_10),
            .init(name: "PG", color: .sdgGreen),
            .init(name: "BK-40", color: .sdgBlack_40),
            .init(name: "WH-40", color: .sdgWhite_40, needsBorder: true),
            .init(name: "WH-80", color: .sdgWhite_80, needsBorder: true)
          ]
        )
      ]
    }
  }
}

private struct SDGColorPaletteSection: Identifiable {
  let id: String
  let title: String?
  let items: [SDGColorPaletteItem]
  
  init(id: String, title: String?, items: [SDGColorPaletteItem]) {
    self.id = id
    self.title = title
    self.items = items
  }
}

private struct SDGColorPaletteItem: Identifiable {
  let id: String
  let name: String
  let color: Color
  let needsBorder: Bool
  
  init(
    name: String,
    color: Color,
    needsBorder: Bool = false
  ) {
    self.id = name
    self.name = name
    self.color = color
    self.needsBorder = needsBorder
  }
}

private struct SDGColorPaletteCard: View {
  let sections: [SDGColorPaletteSection]
  let cellWidth: CGFloat
  let columnSpacing: CGFloat
  
  private let rowSpacing: CGFloat = 40
  
  var body: some View {
    VStack(alignment: .leading, spacing: 40) {
      ForEach(sections) { section in
        SDGColorPaletteSectionView(
          section: section,
          horizontalSpacing: columnSpacing,
          rowSpacing: rowSpacing,
          cellWidth: cellWidth
        )
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }
}

private struct SDGColorPaletteSectionView: View {
  let section: SDGColorPaletteSection
  let horizontalSpacing: CGFloat
  let rowSpacing: CGFloat
  let cellWidth: CGFloat
  
  var body: some View {
    VStack(alignment: .leading, spacing: section.title == nil ? 0 : 12) {
      if let title = section.title {
        Text(sdg: title)
          .typo(.body2_R, .neutral700)
      }
      
      SDGColorPaletteFlowLayout(
        horizontalSpacing: horizontalSpacing,
        verticalSpacing: rowSpacing
      ) {
        ForEach(section.items) { item in
          SDGColorPaletteCell(item: item, width: cellWidth)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private struct SDGColorPaletteFlowLayout: Layout {
  let horizontalSpacing: CGFloat
  let verticalSpacing: CGFloat
  
  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    guard subviews.isEmpty == false else {
      return .zero
    }
    
    let maxWidth = proposal.width ?? idealWidth(subviews: subviews)
    let rows = rows(maxWidth: maxWidth, subviews: subviews)
    let height = rows.reduce(CGFloat.zero) { partialHeight, row in
      partialHeight + row.height
    } + verticalSpacing * CGFloat(max(rows.count - 1, 0))
    
    return CGSize(width: maxWidth, height: height)
  }
  
  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    var origin = bounds.origin
    var rowHeight: CGFloat = 0
    
    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      
      if origin.x > bounds.minX, origin.x + size.width > bounds.maxX {
        origin.x = bounds.minX
        origin.y += rowHeight + verticalSpacing
        rowHeight = 0
      }
      
      subview.place(
        at: origin,
        anchor: .topLeading,
        proposal: ProposedViewSize(width: size.width, height: size.height)
      )
      
      origin.x += size.width + horizontalSpacing
      rowHeight = max(rowHeight, size.height)
    }
  }
  
  private func rows(maxWidth: CGFloat, subviews: Subviews) -> [SDGColorPaletteFlowRow] {
    var rows: [SDGColorPaletteFlowRow] = []
    var currentWidth: CGFloat = 0
    var currentHeight: CGFloat = 0
    var currentCount = 0
    
    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      let nextWidth = currentCount == 0 ? size.width : currentWidth + horizontalSpacing + size.width
      
      if currentCount > 0, nextWidth > maxWidth {
        rows.append(SDGColorPaletteFlowRow(width: currentWidth, height: currentHeight))
        currentWidth = size.width
        currentHeight = size.height
        currentCount = 1
      } else {
        currentWidth = nextWidth
        currentHeight = max(currentHeight, size.height)
        currentCount += 1
      }
    }
    
    if currentCount > 0 {
      rows.append(SDGColorPaletteFlowRow(width: currentWidth, height: currentHeight))
    }
    
    return rows
  }
  
  private func idealWidth(subviews: Subviews) -> CGFloat {
    let itemWidths = subviews.map { $0.sizeThatFits(.unspecified).width }
    let totalSpacing = horizontalSpacing * CGFloat(max(itemWidths.count - 1, 0))
    
    return itemWidths.reduce(0, +) + totalSpacing
  }
}

private struct SDGColorPaletteFlowRow {
  let width: CGFloat
  let height: CGFloat
}

private struct SDGColorPaletteCell: View {
  let item: SDGColorPaletteItem
  let width: CGFloat
  
  var body: some View {
    VStack(spacing: 10) {
      Circle()
        .fill(item.color)
        .frame(width: 40, height: 40)
        .overlay {
          if item.needsBorder {
            Circle()
              .stroke(Color.neutral200, lineWidth: 1)
          }
        }
      
      Text(sdg: item.name)
        .typo(.body3_R, .neutral300)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .frame(height: 16)
    }
    .frame(width: width, height: 66)
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}

#Preview {
  SDGColorDemoView()
}
