//
//  SDGImageBundle.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/29/25.
//

import Foundation

@objc
public class SDGImageBundle: NSObject {
  @objc public static let imagesBundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle.main
    #endif
  }()
}
