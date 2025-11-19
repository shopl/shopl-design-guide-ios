//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 9/3/25.
//

import SwiftUI

public extension View {
  func padding(_ spacing: SDGSpacing) -> some View {
    self.padding(spacing.rawValue)
  }
  
  func padding(_ edges: Edge.Set, _ spacing: SDGSpacing) -> some View {
    self.padding(edges, spacing.rawValue)
  }
  
  func padding(
    top: SDGSpacing? = nil,
    leading: SDGSpacing? = nil,
    bottom: SDGSpacing? = nil,
    trailing: SDGSpacing? = nil
  ) -> some View {
    self.padding(
      EdgeInsets(
        top: top?.rawValue ?? 0,
        leading: leading?.rawValue ?? 0,
        bottom: bottom?.rawValue ?? 0,
        trailing: trailing?.rawValue ?? 0
      )
    )
  }
}

public extension VStack {
  init(alignment: HorizontalAlignment = .center,
       spacing: SDGSpacing,
       @ViewBuilder content: () -> Content) {
    self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
  }
}

public extension HStack {
  init(alignment: VerticalAlignment = .center,
       spacing: SDGSpacing,
       @ViewBuilder content: () -> Content) {
    self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
  }
}

public extension LazyVStack {
  init(alignment: HorizontalAlignment = .center,
       spacing: SDGSpacing,
       pinnedViews: PinnedScrollableViews = .init(),
       @ViewBuilder content: () -> Content) {
    self.init(alignment: alignment, spacing: spacing.rawValue, pinnedViews: pinnedViews, content: content)
  }
}

public extension LazyHStack {
  init(alignment: VerticalAlignment = .center,
       spacing: SDGSpacing,
       pinnedViews: PinnedScrollableViews = .init(),
       @ViewBuilder content: () -> Content) {
    self.init(alignment: alignment, spacing: spacing.rawValue, pinnedViews: pinnedViews, content: content)
  }
}
