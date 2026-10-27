# SDG iOS MCP 서버 (유지보수 가이드)

SDG iOS 라이브러리 소스에서 메타데이터를 추출해, AI 코딩 에이전트가 조회할 수 있는 MCP 서버로 제공합니다. 설치·사용법은 [plugins/sdg-ios/README.md](../plugins/sdg-ios/README.md)를 참고하세요. 이 문서는 구조와 유지보수 방법을 다룹니다.

설계는 shoplflow의 `@shoplflow/mcp`를 따릅니다. 메타데이터는 사람이 쓰지 않고 빌드 시 라이브러리 소스에서 추출하며, 생성 결과를 커밋하고 CI가 최신 상태를 검사합니다.

## 구조

```
Sources/ShoplDesignGuide/**        ─┐
  Resources/Assets (*.xcassets)     │
  Generated (Tuist 에셋 심볼)        ├─► Tools/SDGMetadataExtractor ─► plugins/sdg-ios/server/data/*.generated.json ─┐
SampleApp/Sources (#Preview·카탈로그) │    (swift-syntax, 빌드 타임)                                                 │
Package.swift                      ─┘                                                                             ├─► MCP 서버 (stdio)
                                                                                                                  │
mcp/src (TypeScript) ─────────────────── esbuild ──► plugins/sdg-ios/server/index.mjs ─────────────────────────────┘
```

```
Tools/SDGMetadataExtractor/      추출기 (별도 SwiftPM 패키지 — 루트 Package.swift에 swift-syntax 의존성을 만들지 않기 위해 분리)
  Sources/SDGMetadataExtractor/  토큰·아이콘·공개 API·사용 예제·카탈로그·셋업 추출
  CatalogDump/main.swift         SampleApp 카탈로그를 컴파일·실행해 JSON으로 출력하는 덤프 프로그램
mcp/                             MCP 서버 소스
  src/server.ts                  툴·리소스 등록, 검색·응답 구성
  src/data.ts                    생성 데이터 타입과 로더 (번들 옆의 data/ 폴더에서 읽음)
  src/setup.curated.json         ★ 사람이 관리하는 유일한 데이터 (설치 절차·주의사항·연결 시 instructions)
  scripts/bundle.mjs             의존성 포함 단일 ESM 번들 생성
  scripts/smoke.mjs              번들을 실제 MCP 클라이언트로 띄워 모든 툴 검증
plugins/sdg-ios/                 배포 단위 (Claude Code·Cursor·Codex가 같은 폴더를 설치)
  .claude-plugin/plugin.json     Claude Code 매니페스트: node ${CLAUDE_PLUGIN_ROOT}/server/index.mjs
  .cursor-plugin/plugin.json     Cursor 매니페스트: node ${CURSOR_PLUGIN_ROOT}/server/index.mjs
  .codex-plugin/plugin.json      Codex 매니페스트: MCP 선언은 .codex.mcp.json
  .codex.mcp.json                Codex용 MCP 선언: node ./server/index.mjs, "cwd": "."
  server/index.mjs               번들 (생성물, 커밋 대상)
  server/data/*.generated.json   메타데이터 (생성물, 커밋 대상, 직접 수정 금지)
  skills/                        에이전트 스킬 (사람이 작성)
.claude-plugin/marketplace.json  SDG 전용 마켓플레이스 (sdg-marketplace). Codex도 이 파일을 읽는다
.cursor-plugin/marketplace.json  같은 마켓플레이스의 Cursor용 카탈로그
```

## 생성 데이터

| 파일 | 원천 | 내용 |
| --- | --- | --- |
| `tokens.generated.json` | `Colors.xcassets`, Tuist 생성 심볼, `SDG+Typography.swift`, `SDGSpacing.swift`, `SDGCornerRadius.swift` | 컬러(hex·불투명도·기본 토큰), 타이포(크기·굵기·줄 높이), 간격·라운드(pt, MARK 그룹) |
| `icons.generated.json` | `Images.xcassets`, Tuist 생성 심볼 | Swift 심볼, 에셋 이름, 렌더링 모드, 포맷, 검색 키워드 |
| `api.generated.json` | `Sources/ShoplDesignGuide/**` (Generated 제외) | 공개 View·타입·중첩 타입·typealias, init/메서드/프로퍼티 시그니처, enum 케이스, deprecated, 문서 주석, 디자인 스펙 버전, View 모디파이어 |
| `examples.generated.json` | 라이브러리 `#Preview`와 프리뷰 헬퍼, SampleApp | 호출과 그 안의 중첩 SDG 생성 호출(`.init(...)`)이 공개 init과 맞는 실제 호출부 |
| `catalog.generated.json` | `SampleApp/Sources/DesignSystem/SDGCatalog.swift` | 디자인 가이드 섹션·항목·설명, 실제 공개 심볼로 계산한 iOS 구현 여부 |
| `setup.generated.json` | `Package.swift`, 다국어 키 사용 파일 | 플랫폼·제품·의존성, 다국어 Provider가 필요한 심볼 |

출력은 결정적입니다(정렬, 상대 경로, 타임스탬프 없음). 줄 번호는 정렬에만 쓰고 출력하지 않아, 코드 위치만 바뀌어서는 데이터가 바뀌지 않습니다.

## 개발 명령

```bash
cd mcp
npm ci
npm run generate:metadata   # 추출기 실행 → plugins/sdg-ios/server/data
npm run bundle              # TypeScript → plugins/sdg-ios/server/index.mjs
npm run build               # generate:metadata + bundle
npm run smoke               # 번들을 MCP 클라이언트로 검증 (끝에 "✓ smoke test passed")
npm run typecheck
```

추출기 요약 출력의 개수(`✓ api: 270 …`)가 갑자기 줄었다면 추출기의 소스 구조 가정이 깨진 것입니다. 결과가 0개면 추출기가 실패로 종료합니다.

`npm run smoke`는 세 호스트의 매니페스트에 적힌 MCP 선언대로도 서버를 띄워 봅니다.

수정본을 에이전트에서 바로 써 보려면 다음과 같이 합니다.

| 에이전트 | 방법 |
| --- | --- |
| Claude Code | 레포 루트에서 `claude --plugin-dir ./plugins/sdg-ios` |
| Cursor | `plugins/sdg-ios` 폴더를 `~/.cursor/plugins/local/sdg-ios`로 복사(심볼릭 링크는 로드되지 않음) |
| Codex | `codex plugin marketplace add <레포 경로>` 후 `codex plugin add sdg-ios@sdg-marketplace`. GitHub에서 같은 마켓플레이스를 추가해 둔 상태면 먼저 `codex plugin marketplace remove sdg-marketplace`. 설치할 때 복사한 사본을 쓰므로 고친 뒤에는 `codex plugin remove sdg-ios@sdg-marketplace` 후 다시 설치 |

## SDG 코드를 바꿨을 때

`Sources/`, `SampleApp/Sources/`, `Package.swift`를 바꾼 PR에서는 다음을 함께 커밋합니다.

```bash
cd mcp && npm run build
git add ../plugins/sdg-ios/server
```

CI(`.github/workflows/mcp-check.yml`)가 같은 명령으로 다시 생성해 커밋된 파일과 비교하고, 다르면 실패합니다. 이 검사가 없으면 커밋된 메타데이터가 조용히 오래된 상태로 남습니다.

| 바꾼 것 | 바뀌는 파일 |
| --- | --- |
| 컬러·이미지 에셋 (Tuist 생성 파일 포함) | `tokens` / `icons` |
| 공개 API(init·enum·모디파이어 등) | `api` (+ `examples`, `catalog`) |
| `#Preview`, SampleApp 데모 | `examples` |
| `SDGCatalog.swift` | `catalog` |
| `Package.swift`, 다국어 키 사용 | `setup` |
| `mcp/src/**` | `index.mjs` |

## 사람이 관리하는 것

- `mcp/src/setup.curated.json`: 설치 절차, 주의사항, MCP 연결 시 에이전트에게 항상 전달되는 `instructions`. 코드에서 확인되는 사실(플랫폼·Provider API 등)은 넣지 않습니다. `instructions`는 앞 512자 안에 규칙 요약을 둡니다(Codex 권장, 스모크 테스트가 검사). 수정 후 `npm run bundle`.
- `plugins/sdg-ios/skills/*/SKILL.md`: 사용 관례와 함정. 자주 바뀌는 값(컴포넌트 목록·enum 값)은 적지 않고 MCP 툴로 확인하도록 씁니다. SKILL.md의 `name`은 폴더 이름과 같아야 합니다.
- 컴포넌트 설명의 품질은 소스의 `///` 문서 주석과 SampleApp 카탈로그 설명에 달려 있습니다. 공개 init에 문서 주석을 추가하면 `get_component_api` 응답에 그대로 반영됩니다.

## 추출기가 가정하는 소스 구조

이 가정이 깨지면 추출 결과가 비거나 실패합니다. 구조를 바꿀 때 함께 확인하세요.

| 위치 | 가정 |
| --- | --- |
| `SDG.Typography` | `extension SDG` 안의 enum, `size`/`weight`/`lineHeight`가 `switch self` 계산 프로퍼티 |
| `SDGSpacing`, `SDGCornerRadius` | 숫자 raw value enum, 그룹은 `// MARK: - 이름` 주석 |
| Tuist 생성 파일 | `static let x = SDG.Color(name: "...")`, `SDG.Image(name: "...")` 형식 |
| `SDGCatalog.swift` | Foundation만 import (swiftc로 단독 컴파일해 실행) |
| 디자인 스펙 버전 | `public static let version = "..."` 또는 문자열을 반환하는 `static var version` |
| 사용 예제 | `#Preview` 블록, 또는 이름에 `Preview`가 들어간 비공개 타입 |

## 설계 결정

| 결정 | 이유 |
| --- | --- |
| 추출기를 Swift(swift-syntax)로 작성 | Swift 소스를 정확히 파싱하고 iOS 팀이 유지보수하기 쉬움. 타입 체커 없이 AST만 읽어 iOS 빌드 없이 실행 |
| 서버는 TypeScript, 번들 커밋 | MCP SDK가 가장 성숙하고, 플러그인은 설치 시 npm install을 하지 않으므로 의존성 포함 번들이 필요 |
| 데이터는 번들 밖 JSON | 소스 변경이 PR diff에서 데이터 변경으로 보이게 하고, 데이터만 바뀔 때 번들이 바뀌지 않게 함 |
| Claude Code·Cursor 매니페스트 `version` 미지정 | 커밋 SHA 기준으로 업데이트되어 main 반영분이 별도 버전 올림 없이 전달됨 |
| 호스트별 매니페스트를 한 플러그인 폴더에 둠 | 번들·데이터·스킬은 하나로 두고, 플러그인 경로를 넘기는 방식만 호스트마다 다르게 선언한다. Claude Code는 `${CLAUDE_PLUGIN_ROOT}`, Cursor는 `${CURSOR_PLUGIN_ROOT}`를 치환한다. Codex는 MCP 선언의 변수를 치환하지 않고 상대 `cwd`를 플러그인 루트 기준으로 풀기 때문에 선언 하나로 통일할 수 없다 |
| Codex용 MCP 선언 파일을 `.mcp.json`으로 두지 않음 | Claude Code는 플러그인 루트에 `.mcp.json`이 있으면 `plugin.json`의 선언 대신 그 파일을 쓰고(2.1.303에서 확인), VS Code도 이 파일을 읽는다. 상대 경로로 쓴 Codex용 선언이 다른 호스트에 적용되지 않게 다른 이름을 쓴다 |
| Codex 매니페스트 `version`을 올리지 않음 | Codex 매니페스트 형식은 `version`이 필수라 고정값을 둔다. Codex는 시작할 때 Git 마켓플레이스를 갱신하고 새 커밋이 있으면 version과 상관없이 다시 설치하므로(0.144.1 이후 소스 확인), Claude Code와 같이 main 반영분이 전달된다 |
| Codex용 마켓플레이스 파일을 따로 두지 않음 | Codex가 `.claude-plugin/marketplace.json`을 호환 경로로 읽는다(Codex 문서). 같은 이름(`sdg-marketplace`)으로 설치된다 |
| 예제는 호출과 중첩 SDG 생성 호출을 공개 init과 대조 | 프리뷰는 모듈 안에서 컴파일되어 internal init을 쓸 수 있다. 앱에 복사하면 컴파일되지 않는 예제나 같은 이름의 SwiftUI 타입 호출을 내보내지 않기 위함 |
| 구현 여부는 실제 공개 심볼로 계산 | SampleApp의 수동 목록은 실제와 어긋날 수 있음 |

## 알려진 한계

- 데이터가 main 기준이라 앱이 고정한 SDG 버전에 없는 API가 포함될 수 있습니다.
- 플러그인 설치는 Claude Code, Cursor, Codex 앱·CLI, VS Code(GitHub Copilot)에서 됩니다. Codex IDE 확장처럼 플러그인을 지원하지 않는 환경은 클론한 번들 경로를 직접 지정하는 수동 연결만 되고 자동 업데이트가 없습니다.
- Swift 소스를 파싱할 뿐 타입 체크는 하지 않으므로, 복잡한 제네릭 제약은 원문 텍스트로만 보입니다.
