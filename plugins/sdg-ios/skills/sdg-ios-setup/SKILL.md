---
name: sdg-ios-setup
description: ShoplDesignGuide(SDG iOS) 패키지 설치와 앱 시작 시 필수 설정. iOS 앱에 SDG를 추가할 때, import ShoplDesignGuide가 안 될 때, SDG 컴포넌트를 띄우자마자 "SDGString provider is not set" fatalError로 크래시가 날 때, SDG 폰트(Pretendard)나 한국어 줄바꿈이 기대와 다를 때 사용한다.
---

# SDG iOS 셋업

패키지 URL·지원 플랫폼·의존성·Provider 예시 코드는 MCP `get_setup_guide`로 확인한다. 코드에서 추출한 값이라 이 문서보다 정확하다.

## 설치

1. Swift Package Manager로 `https://github.com/shopl/shopl-design-guide-ios`를 추가하고 `ShoplDesignGuide` 제품을 앱 타깃에 연결한다. 버전은 GitHub Releases의 최신 태그를 확인한다.
2. 사용하는 파일에서 `import ShoplDesignGuide` 한다.
3. 최소 지원 버전은 `get_setup_guide`의 `package.platforms`를 따른다.

## 앱 시작 시 다국어 Provider 등록

일부 컴포넌트는 내장 문구를 `SDGLocalizationKey`로 가져온다. Provider가 없으면 그 컴포넌트가 화면에 그려지는 순간 `fatalError("SDGString provider is not set...")`로 앱이 종료된다.

- 대상 컴포넌트: `get_setup_guide` → `localization.affectedSymbols`
- 대상 컴포넌트를 하나라도 쓰면 앱 시작 시 한 번 등록한다.

```swift
import Foundation  // NSLocalizedString. ShoplDesignGuide를 import해도 Foundation이 따라오지 않는다.
import ShoplDesignGuide

final class AppStringProvider: SDGStringProvider {
  func getString(key: String) -> String? {
    NSLocalizedString(key, comment: "")
  }
}

// 메인 액터에서 한 번: AppDelegate의 didFinishLaunching 또는 App의 init
SDGString.shared.setProvider(provider: AppStringProvider())
```

- Provider가 `nil`을 돌려주는 키를 조회하면 역시 `fatalError`다. `NSLocalizedString`은 없는 키에 키 문자열을 그대로 돌려주므로 크래시 대신 키가 화면에 보인다.
- 필요한 키 목록은 `get_type("SDGLocalizationKey")`의 `cases`다. 앱의 Localizable 리소스에 같은 키를 둔다.

## 폰트와 텍스트

- Pretendard 폰트는 `.typo(...)`를 처음 쓸 때 자동 등록된다. 별도 등록 코드를 추가하지 않는다.
- `UserDefaults.standard.string(forKey: "language")`가 `"ja"`이면 Pretendard JP가 쓰인다.
- 한국어 문장은 `Text(sdg: "…")`로 만들면 기기 언어가 한국어일 때 어절 단위로 줄바꿈된다.

## MCP 연결 확인

"SDG에서 neutral700 값이 뭐야?"라고 물었을 때 `get_token` 호출 결과로 `#333333`이 나오면 연결된 것이다. 툴 호출 없이 답하면 MCP가 연결되지 않은 상태다.
