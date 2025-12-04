//
//  SDGColorDemoView.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/28/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

private extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}

private struct PaletteItem: Identifiable, Hashable {
  let id = UUID()
  let color: Color
  let name: String
}

struct SDGColorDemoView: View {
  
  private let tabs = ["Brand", "Neutral", "Point", "Special"]
  
  var body: some View {
    DemoViewTabContainer(tabs: tabs) { selectedTab in
      switch selectedTab {
      case "Brand":
        BrandPaletteView()
      case "Neutral":
        NeutralPaletteView()
      case "Point":
        PointPaletteView()
      case "Special":
        SpecialPaletteView()
      default:
        UnimplementedTabPlaceholder(tabName: selectedTab)
      }
    }
  }
}

// MARK: - Brand Palette View
private struct BrandPaletteView: View {
  var body: some View {
    VStack(spacing: 40) {
      ColorSectionView(
        title: "Primary",
        items: [
          PaletteItem(color: .primary400, name: "400"),
          PaletteItem(color: .primary300, name: "300"),
          PaletteItem(color: .primary200, name: "200"),
          PaletteItem(color: .primary50, name: "50"),
          PaletteItem(color: .primary300.opacity(0.1), name: "300-10")
        ]
      )
      
      ColorSectionView(
        title: "Secondary",
        items: [
          PaletteItem(color: .secondary400, name: "400"),
          PaletteItem(color: .secondary300, name: "300"),
          PaletteItem(color: .secondary200, name: "200"),
          PaletteItem(color: .secondary50, name: "50"),
          PaletteItem(color: .secondary400.opacity(0.1), name: "400-10"),
          PaletteItem(color: .secondary300.opacity(0.1), name: "300-10")
        ]
      )
    }
  }
}

// MARK: - Neutral Palette View
private struct NeutralPaletteView: View {
  var body: some View {
    VStack(spacing: 20) {
      ColorSectionView(
        title: "Neutral",
        items: [
          PaletteItem(color: .neutral900, name: "900"),
          PaletteItem(color: .neutral700, name: "700"),
          PaletteItem(color: .neutral600, name: "600"),
          PaletteItem(color: .neutral500, name: "500"),
          PaletteItem(color: .neutral400, name: "400"),
          PaletteItem(color: .neutral350, name: "350"),
          PaletteItem(color: .neutral300, name: "300"),
          PaletteItem(color: .neutral250, name: "250"),
          PaletteItem(color: .neutral200, name: "200"),
          PaletteItem(color: .neutral150, name: "150"),
          PaletteItem(color: .neutral100, name: "100"),
          PaletteItem(color: .neutral50, name: "50"),
          PaletteItem(color: .neutral0, name: "0")
        ]
      )
      
      ColorSectionView(
        title: nil,
        items: [
          PaletteItem(color: .neutral900.opacity(0.1), name: "900-10"),
          PaletteItem(color: .neutral700.opacity(0.1), name: "700-10"),
          PaletteItem(color: .neutral600.opacity(0.1), name: "600-10"),
          PaletteItem(color: .neutral500.opacity(0.1), name: "500-10"),
          PaletteItem(color: .neutral400.opacity(0.1), name: "400-10"),
          PaletteItem(color: .neutral350.opacity(0.1), name: "350-10"),
          PaletteItem(color: .neutral300.opacity(0.1), name: "300-10"),
          PaletteItem(color: .neutral250.opacity(0.1), name: "250-10"),
          PaletteItem(color: .neutral200.opacity(0.1), name: "200-10"),
          PaletteItem(color: .neutral150.opacity(0.1), name: "150-10"),
          PaletteItem(color: .neutral100.opacity(0.1), name: "100-10"),
          PaletteItem(color: .neutral50.opacity(0.1), name: "50-10"),
          PaletteItem(color: .neutral0, name: "0")
        ]
      )
    }
  }
}

// MARK: - Point Palette View
private struct PointPaletteView: View {
  var body: some View {
    VStack(spacing: 40) {
      ColorSectionView(
        title: "Red",
        items: [
          PaletteItem(color: .red400, name: "400"),
          PaletteItem(color: .red350, name: "350"),
          PaletteItem(color: .red300, name: "300"),
          PaletteItem(color: .red50, name: "50"),
          PaletteItem(color: .red300.opacity(0.1), name: "300-10")
        ]
      )
      ColorSectionView(
        title: "Yellow",
        items: [
          PaletteItem(color: .sdgYellow, name: "Y"),
          PaletteItem(color: .sdgYellow.opacity(0.1), name: "Y-10")
        ]
      )
      ColorSectionView(
        title: "Purple",
        items: [
          PaletteItem(color: .sdgPurple, name: "P"),
          PaletteItem(color: .sdgPurple.opacity(0.1), name: "P-10")
        ]
      )
      ColorSectionView(
        title: "Green",
        items: [
          PaletteItem(color: .sdgGreen, name: "G"),
          PaletteItem(color: .sdgGreen.opacity(0.1), name: "G-10")
        ]
      )
    }
  }
}

// MARK: - Special Palette View
private struct SpecialPaletteView: View {
  var body: some View {
    VStack(spacing: 40) {
      ColorSectionView(
        title: "Orange",
        items: [PaletteItem(color: .sdgOrange, name: "Orange")]
      )
      ColorSectionView(
        title: "Pink",
        items: [PaletteItem(color: .sdgSpecialPink, name: "Pink")]
      )
      ColorSectionView(
        title: "Lemon",
        items: [PaletteItem(color: .sdgLemon, name: "Lemon")]
      )
    }
  }
}

// MARK: - Reusable Subviews
private struct ColorSectionView: View {
  let title: String?
  let items: [PaletteItem]
  
  private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 10), count: 5)
  private let columnSpacing: CGFloat = 10
  private let rowSpacing: CGFloat = 20
  
  var body: some View {
    VStack(spacing: 20) {
      if let title = title {
        Text(title)
          .typo(.body3_SB, .neutral500)
      }
      
      if items.count <= 4 {
        HStack(spacing: columnSpacing) {
          ForEach(items) { item in
            ColorCell(color: item.color, name: item.name)
          }
        }
      } else {
        LazyVGrid(columns: columns, spacing: rowSpacing) {
          ForEach(items) { item in
            ColorCell(color: item.color, name: item.name)
          }
        }
      }
    }
  }
}

private struct ColorCell: View {
  let color: Color
  let name: String
  
  var body: some View {
    VStack(spacing: 10) {
      Circle()
        .fill(color)
        .frame(width: 40, height: 40)
        .overlay {
          if name == "0" {
            Circle().stroke(Color.neutral100, lineWidth: 1)
          }
        }
      Text(name)
        .typo(.body3_R, .neutral500)
    }
    .frame(width: 52)
  }
}

#Preview {
  SDGColorDemoView()
}
