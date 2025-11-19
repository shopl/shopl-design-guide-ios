//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import UIKit

extension String {
  var isBlank: Bool {
    return allSatisfy { $0.isWhitespace }
  }
}

extension String {
  func size(withFont font: UIFont, maxWidth: CGFloat) -> CGSize {
    let attributes = [NSAttributedString.Key.font: font]
    let attributedText = NSAttributedString(string: self, attributes: attributes)
    let boundingRect = attributedText.boundingRect(
      with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      context: nil
    )
    return CGSize(
      width: ceil(boundingRect.width),
      height: ceil(boundingRect.height)
    )
  }
}
