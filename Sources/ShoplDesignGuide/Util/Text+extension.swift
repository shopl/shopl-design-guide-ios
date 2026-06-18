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
  init(sdg content: String) {
    if Locale.current.language.languageCode?.identifier == "ko" {
      self.init(content.koreanWordWrapped)   // 한국어일 때만 가공(임시) 더 좋은 방법이 있다면 수정 가능.
    } else {
      /*
       첫째, 이건 이 이니셜라이저가 해당 언어 텍스트에도 실제로 적용될 때만 발생하는 문제입니다. 코드가 한국어 문자열에만 호출된다면 CJK/동남아 시나리오는 애초에 발생하지 않습니다. 그래서 "심각한 문제"는 무조건이 아니라 "다국어를 같은 경로로 통과시킨다면"이라는 전제가 붙습니다.
       둘째, 오히려 원래 주장보다 상황이 한 단계 더 나쁩니다. 이 코드는 char == " "로 ASCII 공백(U+0020)만 공백으로 인정합니다. 일본어 등에서 쓰는 전각 공백(U+3000)이나 다른 유니코드 공백류는 비공백으로 취급되어 그 주위에도 WJ가 박힙니다. 즉 CJK 문장 안에 들어간 공백류마저 끊기지 않게 잠겨, 줄바꿈이 더 철저히 막힙니다.
       셋째, 한국어에서도 완전히 무해하진 않습니다. 컨테이너 폭보다 긴 단일 어절(예: 아주 긴 합성어, URL 비슷한 토큰)이 있으면 그 어절 내부에 탈출용 줄바꿈 지점이 전혀 없어 그대로 넘칠 수 있습니다. 네이티브 lineBreakStrategy = .hangulWordPriority는 이런 경우 최후의 수단으로 강제 분할을 허용하지만, 수동 WJ 방식엔 그 폴백이 없습니다(다만 최종 동작은 lineBreakMode/오버플로 설정에 따라 엔진마다 다를 수 있습니다).
       
       이러한 이유로 위 코드는 한국어에만 적용 되어야 한다.
       */
      
      self.init(content)                     // 그 외 언어는 그대로
    }
  }
}


fileprivate extension String {
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
