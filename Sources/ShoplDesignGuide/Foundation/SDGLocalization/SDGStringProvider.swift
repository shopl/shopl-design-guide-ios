//
//  SDGStringProvider.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/12/25.
//

import Foundation

public protocol SDGStringProvider {
  func getString(key: String) -> String?
}
