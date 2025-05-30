//
//  isHidden.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public extension View {
  @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
    if isHidden {
      self.hidden()
    } else {
      self
    }
  }
}
