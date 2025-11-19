//
//  NoTapAnimationButtonStyle.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/19/25.
//

import SwiftUI

public struct NoTapAnimationButtonStyle: PrimitiveButtonStyle {
  
  public init() { }
  
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .contentShape(Rectangle())
      .onTapGesture(perform: configuration.trigger)
  }
}
