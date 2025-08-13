//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import Foundation

struct TempStringProvider: SDGStringProvider {
  func getString(key: String) -> String? {
    return key
  }
}
