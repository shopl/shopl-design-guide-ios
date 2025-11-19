//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/18/25.
//

import SwiftUI

struct SDGProgressView: View {
  
  private let _showMessage: Bool
  private let _color: Color
  
  init(showMessage: Bool, color: Color? = nil) {
    _showMessage = showMessage
    
    if let color = color {
      _color = color
    } else {
      _color = .primary300
    }
  }
  
  var body: some View {
    if #available(iOS 16.0, *) {
      if _showMessage {
        SwiftUI.ProgressView(SDGLocalizationKey.loading_message.string)
          .tint(_color)
      } else {
        SwiftUI.ProgressView()
          .tint(_color)
      }
    } else {
      if _showMessage {
        SwiftUI.ProgressView(SDGLocalizationKey.loading_message.string)
          .progressViewStyle(CircularProgressViewStyle(tint: _color))
      } else {
        SwiftUI.ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: _color))
      }
    }
  }
}

