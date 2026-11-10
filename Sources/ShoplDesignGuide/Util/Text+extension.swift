//
//  Text+extension.swift
//  ShoplDesignGuide
//
//  Created by jerry on 6/16/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI
import UIKit

public extension Text {
  //시간 복잡도 O(n)
  init(sdg content: String) {
    // 한국어가 포함되어 있을 때만 가공
    if content.containsHangul {
      self.init(content.koreanWordWrapped)
    } else {
      /*
       중국어·일본어·태국어처럼 단어 사이에 공백이 없는 언어는 split(separator: " ")를 하면 문장 전체가 한 덩어리로 잡히고, 거기에 글자마다 word joiner가 박히면 문장 전체가 절대 안 끊기는 한 줄이 돼서 화면 밖으로 터집니다. 지금 한글에서 고치려던 것보다 훨씬 큰 사고가 다른 언어에서 납니다.
       
       영어·독일어 등은 긴 단어/URL이 끊을 자리를 잃어 오버플로우 위험이 생기고, 모든 언어에 보이지 않는 문자가 섞입니다.
       
       이러한 이유로 위 코드는 한국어에만 적용 되어야 한다.
       */
      
      // 그 외 언어는 그대로
      self.init(content)
    }
  }
}


fileprivate extension String {
  var containsHangul: Bool {
    unicodeScalars.contains {
      (0xAC00...0xD7A3).contains($0.value)    // 완성형 음절
      || (0x1100...0x11FF).contains($0.value) // 자모
      || (0x3130...0x318F).contains($0.value) // 호환 자모
    }
  }
  
  /// 어절 내부에서 줄바꿈이 일어나지 않도록 음절 사이에 Word Joiner(U+2060)를 삽입한다.
  var koreanWordWrapped: String {
    var result = ""
    result.reserveCapacity(utf8.count * 2)
    var previousWasSpace = true            // 첫 글자 앞에는 WJ를 넣지 않기 위해 true로 시작
    for char in self {
      let isSpace = (char == " ")
      if !isSpace && !previousWasSpace {
        result.append("\u{2060}")
      }
      result.append(char)
      previousWasSpace = isSpace
    }
    return result
  }
}
