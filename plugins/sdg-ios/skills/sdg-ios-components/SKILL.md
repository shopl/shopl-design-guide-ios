---
name: sdg-ios-components
description: SDG iOS(ShoplDesignGuide) SwiftUI 컴포넌트로 화면을 구현하는 방법. SDGBoxButton·SDGSimpleInput·SDGCheckBox 같은 SDG 뷰를 만들 때, 버튼·입력·체크박스·탭·내비게이션·팝업·툴팁을 SDG로 구현할 때, 기획서나 디자인 시안 화면을 SDG 컴포넌트로 옮길 때, SDG 컴포넌트의 init 인자나 팝업 띄우는 법을 모를 때 사용한다.
---

# SDG iOS 컴포넌트 사용

## 작업 순서

SDG API는 추측하지 않고 MCP로 확인한다. SDG 컴포넌트는 Option 구조체와 Binding을 쓰는 고유 구조라서, 일반적인 SwiftUI 관례로 추측한 인자(`variant:`, `size: .large` 등)는 대부분 컴파일되지 않는다.

1. `search_component`로 후보를 찾는다. 한국어 질의도 된다("하단 버튼", "체크박스").
   - 어떤 컴포넌트가 맞는지 애매하면 `get_design_guide`로 디자인 가이드의 용도 설명을 확인한다.
2. `get_component_api`로 실제 init 시그니처를 확인하고 인자 라벨과 순서를 그대로 쓴다.
3. 인자 구성이 복잡하면 `get_usage_example`의 실제 호출부를 참고한다.
4. 크기·상태·스타일 값은 응답의 `nestedTypes`, `relatedTypes`에 있는 enum case만 쓴다.

## 공통 패턴

- **Option/Model 구조체**: 외형 설정은 `option: .init(...)`이나 `model: .init(...)`로 묶어 넘기는 컴포넌트가 많다. 어떤 구조체를 받는지는 init 시그니처로 확인한다.
- **Binding**: 선택·로딩·입력 텍스트 같은 상태는 `Binding`으로 넘긴다(`isSelected: $isSelected`). 고정값이면 `.constant(false)`.
- **이벤트**: 탭 등은 클로저 인자(`action:`, `onSelect:` 등)로 받는다.
- **deprecated init**: `get_component_api`의 `deprecated` 메시지가 가리키는 init을 쓴다.
- **version**: 컴포넌트의 디자인 스펙 버전이다(`SDGBoxButton.version`). 시안의 스펙 버전과 다르면 사용자에게 알린다.

## 팝업은 모디파이어로 띄운다

`SDGConfirmPopup` 같은 팝업 뷰는 public init이 없다. `get_component_api` 응답의 `note`와 `presentedBy`에 나오는 View 모디파이어를 쓴다.

```swift
// 인자는 get_component_api("centerConfirmPopup")로 다시 확인한다.
content
  .centerConfirmPopup(
    isPresented: showPopup,
    title: "타이틀",
    bodyText: "내용",
    leftButtonOption: .init(title: "취소", action: { showPopup = false }),
    rightButtonOption: .init(title: "확인", action: { confirm() })
  )
```

## 토큰과 아이콘

색·텍스트·간격·라운드·아이콘은 **sdg-ios-foundation** 스킬 규칙을 따른다.

## SDG에 없을 때

- `search_component`에 없거나 `get_design_guide`에서 `implemented: false`면 iOS에 아직 구현되지 않은 것이다. 비슷한 컴포넌트를 임의로 만들어 SDG인 것처럼 쓰지 말고 사용자에게 알린다.
- 앱 화면에서 필요한 일회성 뷰는 SwiftUI로 만들되 토큰은 SDG 것을 쓴다.
