//
//  View+extension.swift
//  DesignSystem
//
//  Created by Dino on 7/28/25.
//  Copyright © 2025 SHAPL AND COMPANY. All rights reserved.
//

import SwiftUI

extension View {
  var isEmpty: Bool {
    Mirror(reflecting: self).subjectType == EmptyView.self
  }
}
