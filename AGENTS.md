# SDG Builder 저장소 작업 지침

SDG 컴포넌트와 샘플 화면을 수정할 때 [.agents/skills/sdg-builder-rule/SKILL.md](.agents/skills/sdg-builder-rule/SKILL.md)를 읽고 적용한다. 저장소 지침은 허용된 소스 경로를 확대하지 않는다. 공개 API 호환성, 기존 사용자 변경, 리소스 담당자의 작업 경계를 유지한다.

새로 만들거나 수정하는 모든 SDG 컴포넌트·템플릿에는 Skill에서 정한 문서 주석을 추가·갱신하고, 컴포넌트 디자인 버전을 명시한다. 정확한 버전은 디자인 요구사항에서 확인하고, 임의로 만들거나 자동 증가시키지 않는다. 샘플의 버전 표시도 해당 컴포넌트와 일치시킨다.

`Sources/`, `SampleApp/Sources/`, `Package.swift`가 바뀌면(main 머지로 들어온 변경 포함) `cd mcp && npm run build`를 실행하고 바뀐 `plugins/sdg-ios/server/`를 같은 PR에 커밋한다. `*.generated.json`과 `server/index.mjs`는 손으로 고치지 않는다. 툴체인이 없어 실행할 수 없으면 생성 데이터를 갱신하지 않았다고 보고한다. 절차와 CI 검사: [mcp/README.md](mcp/README.md#sdg-코드를-바꿨을-때)
