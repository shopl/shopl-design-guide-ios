//
//  FontLoader.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/27/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI
import CoreText

public class FontLoader {
  public static func registerFonts() {
    let bundle = Bundle.module
    
    let fontExtensions = ["otf", "ttf"]
    
    let fontURLs = fontExtensions.flatMap { ext in
      bundle.urls(forResourcesWithExtension: ext, subdirectory: nil) ?? []
    }
    
    guard !fontURLs.isEmpty else {
      print("⚠️ [ShoplDesignGuide] 등록할 폰트 파일을 찾지 못했습니다.")
      return
    }
    
    for url in fontURLs {
      var error: Unmanaged<CFError>?
      if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
      } else {
        print("❌ 폰트 등록 실패: \(url.lastPathComponent) - \(String(describing: error))")
      }
    }
  }
}
