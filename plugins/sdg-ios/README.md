# sdg-ios 플러그인

AI 코딩 에이전트(Claude Code)가 SDG iOS(ShoplDesignGuide)로 SwiftUI 코드를 작성할 때, 토큰 이름·컴포넌트 init·아이콘 이름을 추측하지 않고 실제 라이브러리에서 조회하도록 돕는 플러그인입니다. MCP 서버 1개와 스킬 3개로 구성됩니다.

```swift
// 플러그인 없이 에이전트가 흔히 만드는 코드 (존재하지 않는 API)
SDGButton(title: "확인", style: .primary, size: .large) { }
Text("제목").font(.system(size: 20, weight: .semibold)).foregroundColor(Color(hex: "#333333"))

// 플러그인 사용 시 (get_component_api·list_tokens로 확인한 실제 API)
SDGBoxButton(
  option: .init(
    size: .medium,
    title: "확인",
    color: .init(backgroundColor: .primary300, textColor: .neutral0),
    selectedColor: .init(backgroundColor: .primary400, textColor: .neutral0)
  ),
  isSelected: $isSelected,
  isLoading: $isLoading,
  action: { }
)
Text("제목").typo(.title1_SB, .neutral700)
```

## 설치 (Claude Code)

```
/plugin marketplace add shopl/shopl-design-guide-ios
/plugin install sdg-ios@sdg-marketplace
```

Claude Code 2.1.275 이상에서는 한 줄로도 설치할 수 있습니다.

```
/plugin install sdg-ios --marketplace shopl/shopl-design-guide-ios
```

요구 사항: PATH에 Node.js 18 이상이 있어야 합니다(MCP 서버를 `node`로 실행합니다).

### 팀 레포에 미리 설정하기

앱 레포의 `.claude/settings.json`에 넣어 두면 팀원이 레포를 열 때 설치를 안내받습니다. 폴더를 신뢰(trust)한 뒤에 적용되고, MCP 서버는 처음 한 번 승인이 필요합니다.

```json
{
  "extraKnownMarketplaces": {
    "sdg-marketplace": {
      "source": { "source": "github", "repo": "shopl/shopl-design-guide-ios" }
    }
  },
  "enabledPlugins": {
    "sdg-ios@sdg-marketplace": true
  }
}
```

### 연결 확인

에이전트에게 "SDG에서 neutral700 값이 뭐야?"라고 물어보세요. `get_token` 툴 호출 결과로 `#333333`이 나오면 정상입니다. 툴 호출 없이 답하면 연결되지 않은 것이니 `/mcp`에서 `sdg-ios` 서버 상태를 확인하세요.

### 업데이트

플러그인에 `version`을 지정하지 않아 main 브랜치의 커밋이 그대로 업데이트가 됩니다. 서드파티 마켓플레이스는 자동 업데이트가 기본으로 꺼져 있으니 아래 명령으로 갱신하거나 `/plugin` 메뉴에서 자동 업데이트를 켜세요.

```
claude plugin marketplace update sdg-marketplace
claude plugin update sdg-ios@sdg-marketplace
```

### 다른 에이전트(수동 연결)

Cursor·Codex 등은 이 레포를 클론한 뒤 MCP 설정에 번들 경로를 직접 지정합니다. 스킬은 포함되지 않습니다.

```json
{
  "mcpServers": {
    "sdg-ios": {
      "command": "node",
      "args": ["/path/to/shopl-design-guide-ios/plugins/sdg-ios/server/index.mjs"]
    }
  }
}
```

## MCP 툴

| 툴 | 용도 |
| --- | --- |
| `list_tokens` / `get_token` | 컬러(hex·불투명도)·타이포그래피(크기·굵기·줄 높이)·간격·라운드 토큰과 SwiftUI 적용법 |
| `search_icon` | 아이콘·이미지 에셋 검색, `Image(sdg: .icXxx)` 접근자와 template 여부 |
| `search_component` | 컴포넌트·View 모디파이어(팝업 등)·보조 타입 검색 (한국어 질의 가능) |
| `get_component_api` | init 시그니처, 중첩 Option/Model, 관련 enum 케이스, deprecated, 팝업을 띄우는 모디파이어 |
| `get_type` | `SDGBoxButton.Option`, `SDGButtonSize` 같은 타입 상세 |
| `get_usage_example` | `#Preview`·SampleApp의 실제 호출부 |
| `get_setup_guide` | SPM 설치 정보와 앱 시작 시 필수 설정(다국어 Provider) |
| `get_design_guide` | 디자인 가이드 카탈로그의 용도 설명과 iOS 구현 여부 |

리소스: `sdg://tokens`(전체 토큰), `sdg://components`(컴포넌트·모디파이어 색인)

## 스킬

| 스킬 | 다루는 내용 |
| --- | --- |
| `sdg-ios-setup` | 패키지 설치, 다국어 Provider 등록(미설정 시 fatalError), 폰트·한국어 줄바꿈 |
| `sdg-ios-components` | 컴포넌트 조회 순서, Option/Model·Binding 패턴, 팝업 모디파이어, 미구현 컴포넌트 대응 |
| `sdg-ios-foundation` | 원시 값 대신 토큰 쓰기, 불투명도 변형(`_10`), 아이콘 렌더링 모드 |

## 잘 쓰는 질문 예시

| 하고 싶은 것 | 질문 |
| --- | --- |
| 화면 구현 | "SDG로 로그인 화면 만들어줘. 하단에 확인 버튼" |
| 정확한 인자 | "SDGToggle init 인자 알려줘" |
| 팝업 | "삭제 확인 팝업 띄우는 코드 SDG로 짜줘" |
| 토큰 변환 | "이 뷰의 색·여백을 SDG 토큰으로 바꿔줘" |
| 아이콘 | "휴지통 아이콘 SDG에 있어?" |
| 구현 여부 | "SDG iOS에 캘린더 컴포넌트 구현돼 있어?" |

## 알아둘 점

- 데이터는 main 브랜치 기준입니다. 앱이 사용하는 SDG 버전에 아직 없는 API가 포함될 수 있으니, 컴파일 오류가 나면 앱의 SDG 버전을 확인하세요.
- 컴포넌트 설명(용도)은 SampleApp 디자인 가이드 카탈로그와 소스의 문서 주석에서 가져옵니다. 설명이 없는 컴포넌트는 시그니처 정보만 제공됩니다.
- 구조와 유지보수 방법은 [mcp/README.md](../../mcp/README.md)를 참고하세요.
