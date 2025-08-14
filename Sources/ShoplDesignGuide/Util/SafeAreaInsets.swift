//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import UIKit
import SwiftUI

@MainActor
private struct SafeAreaInsetsKey: @preconcurrency EnvironmentKey {
  static var defaultValue: EdgeInsets {
    let window = UIApplication.shared
      .connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    
    return window?.safeAreaInsets.swiftUiInsets ?? .init()
  }
}

extension EnvironmentValues {
  var safeAreaInsets: EdgeInsets {
    get { self[SafeAreaInsetsKey.self] }
    set { self[SafeAreaInsetsKey.self] = newValue }
  }
}

private extension UIEdgeInsets {
  var swiftUiInsets: EdgeInsets {
    EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
  }
}
