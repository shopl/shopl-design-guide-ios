//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

extension View {
  func limitText(_ text: Binding<String>, to characterLimit: Int) -> some View {
    self
      .onChange(of: text.wrappedValue) { _ in
        text.wrappedValue = String(text.wrappedValue.prefix(characterLimit))
      }
  }
}
