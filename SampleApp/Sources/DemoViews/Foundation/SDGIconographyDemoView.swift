//
//  SDGIconographyDemoView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/23/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGIconographyDemoView: View {
  private let sizeItems: [SDGIconographySizeItem] = [
    .init(size: 14),
    .init(size: 18),
    .init(size: 20),
    .init(size: 24),
    .init(size: 36),
    .init(size: 40)
  ]
  
  var body: some View {
    VStack(alignment: .leading, spacing: .spacing12) {
      SDGIconographySizeCard(items: sizeItems)
      
      SDGIconographyUsageGuide()
    }
    .padding(.horizontal, .spacing16)
    .padding(.top, .spacing16)
    .padding(.bottom, .spacing40)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private struct SDGIconographySizeItem: Identifiable {
  let size: CGFloat
  
  var id: CGFloat {
    size
  }
  
  var title: String {
    "\(Int(size))*\(Int(size))"
  }
}

private struct SDGIconographySizeCard: View {
  let items: [SDGIconographySizeItem]
  
  var body: some View {
    VStack(spacing: .spacing40) {
      ForEach(items) { item in
        SDGIconographySizeSection(item: item)
      }
    }
    .padding(.spacing16)
    .frame(maxWidth: .infinity)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .stroke(Color.neutral200, lineWidth: 1)
    }
  }
}

private struct SDGIconographySizeSection: View {
  let item: SDGIconographySizeItem
  
  var body: some View {
    VStack(alignment: .leading, spacing: .spacing12) {
      Text(sdg: item.title)
        .typo(.body2_R, .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      SDGIconographySizePreview(size: item.size)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private struct SDGIconographySizePreview: View {
  let size: CGFloat
  
  var body: some View {
    Rectangle()
      .fill(Color.iconographyGuide.opacity(0.2))
      .frame(width: size, height: size)
      .padding(.horizontal, .spacing16)
      .padding(.vertical, .spacing32)
      .frame(maxWidth: .infinity)
      .background(Color.neutral50)
      .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
  }
}

private struct SDGIconographyUsageGuide: View {
  var body: some View {
    VStack(alignment: .leading, spacing: .spacing8) {
      Text(sdg: "Usage Guidelines")
        .typo(.body3_SB, .neutral350)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text(sdg: "# 2의 배수로 축소/확대하여 사용할 수 있습니다.")
        .typo(.body2_SB, .neutral500)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.vertical, .spacing16)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private extension Color {
  static let iconographyGuide = Color(red: 151.0 / 255.0, green: 71.0 / 255.0, blue: 255.0 / 255.0)
}

#Preview {
  SDGIconographyDemoView()
}
