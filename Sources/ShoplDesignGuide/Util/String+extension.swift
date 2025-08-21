//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import Foundation

extension String {
  var isBlank: Bool {
    return allSatisfy { $0.isWhitespace }
  }
}
