//
//  DemoViewTabContainer.swift
//  ShoplDesignGuide
//
//  Created by Dino on 12/1/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

import ShoplDesignGuide

struct DemoViewTabContainer<Content: View>: View {
  
  private let tabs: [String]
  @State private var selectedTab: String
  let content: (String) -> Content
  
  init(
    tabs: [String],
    @ViewBuilder content: @escaping (String) -> Content
  ) {
    self.tabs = tabs
    _selectedTab = State(initialValue: tabs.first ?? "")
    self.content = content
  }
  
  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        HStack(spacing: 16) {
          ForEach(tabs, id: \.self) { tab in
            Button(action: { selectedTab = tab }) {
              Text(tab)
                .typo(.body1_SB, selectedTab == tab ? .neutral900 : .neutral300)
                .padding(.vertical, 2)
            }
          }
        }
        
        VStack {
          content(selectedTab)
        }
        .padding(.vertical, 40)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .border(Color.neutral100, width: 1)
        
        Spacer()
      }
    }
    .padding(.horizontal, 16)
  }
}

struct UnimplementedTabPlaceholder: View {
  let tabName: String
  
  var body: some View {
    Text("\(tabName) is not implemented yet.")
      .typo(.body1_R, .neutral400)
      .padding()
  }
}
