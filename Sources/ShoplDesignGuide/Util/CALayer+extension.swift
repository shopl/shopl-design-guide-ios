//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import UIKit

public extension CALayer {
  func shadow(
    color: UIColor = .black,
    alpha: Float,
    offset: CGSize,
    blur: CGFloat,
    spread: CGFloat,
    cornerRadius: CGFloat = 0
  ) {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = offset
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      
      shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
      
    }
  }
  
  func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
    for edge in arr_edge {
      let border = CALayer()
      switch edge {
        case UIRectEdge.top:
          border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
          break
        case UIRectEdge.bottom:
          border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
          break
        case UIRectEdge.left:
          border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
          break
        case UIRectEdge.right:
          border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
          break
        default:
          break
      }
      border.backgroundColor = color.cgColor;
      self.addSublayer(border)
    }
  }
}
