//
//  BoxBadge.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct BoxBadge: View {
  
  public enum `Type`: Equatable {
    case solid, line
  }
  
  public enum ImageDirection: Equatable {
    case left(Image)
    case right(Image)
    
    public var isLeft: Bool {
      switch self {
        case .left: return true
        case .right: return false
      }
    }
  }
  
  public let type: `Type`
  public let text: String
  public let imageDirection: ImageDirection?
  public let baseColor: Color
  
  public init(
    type: `Type` = .solid,
    text: String,
    imageDirecton: ImageDirection? = nil,
    baseColor: Color? = nil
  ) {
    self.type = type
    self.text = text
    self.imageDirection = imageDirecton
    
    if let baseColor = baseColor {
      self.baseColor = baseColor
    } else {
      self.baseColor = .primary300
    }
  }
  
  public var body: some View {
    ZStack {
      if let imageDirection = imageDirection {
        switch imageDirection {
          case .left(let image):
            image.resizable()
              .frame(width: 14, height: 14)
              .padding(.leading, 6)
            
            self.textView
            
          case .right(let image):
            
            self.textView
            
            image.resizable()
              .frame(width: 14, height: 14)
              .padding(.trailing, 6)
            
        }
      } else {
        self.textView
      }
    }
    .background(type == .line ? .neutral0 : self.baseColor)
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(lineWidth: 1)
        .foregroundColor(self.baseColor)
    )
    .cornerRadius(6)
  }
  
  private var textView: some View {
    Text(text)
      .font(.system(size: 12))
      .foregroundStyle(self.textColor)
      .padding(.vertical, 2)
      .padding(.leading, (self.imageDirection?.isLeft ?? false) ? 4 : 6)
      .padding(.trailing, (self.imageDirection?.isLeft ?? true) ? 6 : 4)
  }
  
  
  private var backgroundColor: Color {
    switch self.type {
      case .solid:
        return self.baseColor
        
      case .line:
        return .neutral0
    }
  }
  
  private var textColor: Color {
    switch self.type {
      case .solid:
        return .neutral0
        
      case .line:
        return self.baseColor
    }
  }
}
