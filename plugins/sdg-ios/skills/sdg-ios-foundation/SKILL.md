---
name: sdg-ios-foundation
description: SDG iOS 디자인 토큰(컬러·타이포그래피·간격·코너 라운드)과 아이콘을 SwiftUI에 적용하는 규칙. 색상 hex·폰트 크기·padding 숫자를 SDG 토큰으로 바꿀 때, 텍스트 스타일(.typo)이나 아이콘(Image(sdg:))을 쓸 때, 디자인 시안의 색·간격 값에 맞는 SDG 토큰 이름을 찾을 때 사용한다.
---

# SDG iOS 파운데이션 (토큰·아이콘)

토큰 이름과 값은 MCP `list_tokens`·`get_token`, 아이콘은 `search_icon`으로 확인한다. 아래는 적용 규칙이다.

## 원시 값 대신 토큰

| 대상 | 쓰지 않는다 | 쓴다 |
| --- | --- | --- |
| 색 | `Color(red:green:blue:)`, hex 확장, `.gray` | `.neutral700`, `.primary300` |
| 텍스트 | `.font(.system(size: 16))` | `.typo(.body1_R, .neutral700)` |
| 간격 | `.padding(16)`, `VStack(spacing: 12)` | `.padding(.spacing16)`, `VStack(spacing: .spacing12)` |
| 라운드 | `.cornerRadius(8)` | `.cornerRadius(.radius8)` |
| 아이콘 | `Image(systemName:)`, 추측한 에셋 이름 | `Image(sdg: .icCommonTrash)` |

토큰을 쓰면 디자인 변경이 SDG 업데이트만으로 반영된다. `.typo`는 폰트 등록과 줄 높이 보정까지 처리한다.

## 컬러

- SwiftUI `Color`, `SDG.Color`, `ShapeStyle`에 같은 이름의 static 멤버가 있어서 `.foregroundStyle(.neutral700)`, `.background(.neutral0)`처럼 쓴다. `SDG.Color`를 받는 파라미터(`.typo`의 두 번째 인자 등)에도 같은 이름을 쓴다.
- 이름 끝의 `_10`, `_40`, `_80`은 불투명도 10/40/80%를 뜻한다(`neutral700_10`). 같은 색의 불투명 토큰은 `baseToken`에 표시되며, `sdgBlack_40`처럼 불투명 토큰이 없는 색도 있다.
- 시안의 hex를 토큰으로 바꿀 때는 `list_tokens`에 `type: "color"`, `query: "#333333"`을 넘긴다.
- 컬러 에셋은 display-p3 색 공간으로 저장되어 있다. 토큰의 hex는 에셋에 저장된 값이다.

## 타이포그래피

- `Text("…").typo(.body1_R, .neutral700)`. 색을 바꾸지 않으려면 `.typo(.body1_R)`.
- 이름은 `<그룹><단계>_<굵기>` 형식이다. `_SB`는 semibold(600), `_R`은 regular(400). 크기와 줄 높이는 `list_tokens`로 확인한다.
- 한국어 문장은 `Text(sdg: "…")`로 만든다(어절 단위 줄바꿈).

## 간격과 라운드

- `.padding(.spacing16)`, `.padding(.horizontal, .spacing20)`, `.padding(top: .spacing8, leading: .spacing16)`
- `VStack(spacing: .spacing12) { … }` (HStack, LazyVStack, LazyHStack도 같다)
- `.cornerRadius(.radius8)`, 일부 모서리만: `.cornerRadius(.radius12, corners: [.topLeft, .topRight])`
- 시안 값과 같은 토큰이 없으면(예: 15pt) 가까운 토큰을 임의로 고르지 말고 사용자에게 확인한다.

## 아이콘

- `search_icon`으로 찾은 이름만 쓴다: `Image(sdg: .icCommonTrash)`.
- `renderingMode`가 `template`인 아이콘은 색을 입힌다: `Image(sdg: .icCommonTrash).templateIcon(size: 20, color: .neutral700)`.
- `original` 아이콘(배지 등)은 색을 바꾸지 않고 `.resizable().frame(width:height:)`로 크기만 정한다.
