//
//  SDGTypoGraphyDemoView.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/28/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

import ShoplDesignGuide

struct SDGTypographyDemoView: View {
  
  private let typographyItems: [(style: Typography, name: String, weight: String)] = [
    (.naviTitle, "Navi Title", "Regular 400"),
    (.title1_SB, "Title 1 - SB", "Semi Bold 600"),
    (.title1_R, "Title 1 - R", "Regular 400"),
    (.title2_SB, "Title 2 - SB", "Semi Bold 600"),
    (.title2_R, "Title 2 - R", "Regular 400"),
    (.body1_SB, "Body 1 - SB", "Semi Bold 600"),
    (.body1_R, "Body 1 - R", "Regular 400"),
    (.body2_SB, "Body 2 - SB", "Semi Bold 600"),
    (.body2_R, "Body 2 - R", "Regular 400"),
    (.body3_SB, "Body 3 - SB", "Semi Bold 600"),
    (.body3_R, "Body 3 - R", "Regular 400")
  ]
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {
        Text("Pretendard")
          .typo(.body1_SB, .neutral700)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical, 32)
        
        HStack(spacing: 10) {
          Text("Style")
            .frame(maxWidth: .infinity, alignment: .leading)
          Text("Size")
            .frame(maxWidth: .infinity, alignment: .leading)
          Text("Weight")
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .typo(.body3_SB, .neutral400)
        .padding(.vertical, 10)
        
        ForEach(typographyItems, id: \.name) { item in
          TypographyRow(
            style: item.style,
            name: item.name,
            size: "\(Int(item.style.size))",
            weight: item.weight
          )
          
          Divider(color: .neutral200, option: .init(direction: .horizental, thickness: 1))
        }
      }
      .padding(.horizontal, 16)
    }
  }
}

private struct TypographyRow: View {
  let style: Typography
  let name: String
  let size: String
  let weight: String
  
  var body: some View {
    HStack(spacing: 10) {
      Text(name)
        .frame(maxWidth: .infinity, alignment: .leading)
      Text(size)
        .frame(maxWidth: .infinity, alignment: .leading)
      Text(weight)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .typo(style, .neutral700)
    .padding(.vertical, 20)
  }
}


#Preview {
  SDGTypographyDemoView()
}
