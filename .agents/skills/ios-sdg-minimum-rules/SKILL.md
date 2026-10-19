---
name: ios-sdg-minimum-rules
description: Apply repository-specific minimum rules when changing SwiftUI SDG components and SampleApp sources in this repository.
---

# iOS SDG 최소 공통 규칙

이 문서는 기존 코드와 PR을 검토해 만든 **최소 공통 기준**이다. 회사의 확정 컨벤션이나 모든 기존 코드가 준수하는 규칙으로 해석하지 않는다. 작업 경로의 지침과 최신 합의 요구사항을 먼저 확인한다.

## 구현 시 적용

- 컴포넌트는 `Sources/ShoplDesignGuide/Component`, 복합 UI는 기존 `Template` 구조, 샘플은 `SampleApp/Sources`의 가까운 구현을 따른다. 기존 경로의 오타까지 이번 요청 없이 일괄 정리하지 않는다.
- 수정한 Swift 코드는 인접 코드의 2칸 들여쓰기와 이름을 따른다. `SDG` 접두사를 유지하고 공개 API는 필요한 범위로 제한한다. 내부 도우미는 가능한 `private` 또는 `fileprivate`로 둔다.
- 기존 `SDG.Color`, `.typo`, `Image(sdg:)`, spacing/corner-radius 토큰을 같은 의미일 때 재사용한다. 디자인 규격의 고정 치수와 레이아웃 수치는 기존 컴포넌트 방식으로 표현한다. 없는 토큰을 만들거나 무관한 상수를 치환하지 않는다.
- 컴포넌트의 선택값·입력값·진행률과 이벤트는 기존 호출 계약을 보존한다. 호출부가 소유하는 값은 입력과 콜백으로 받는다. 기존 Binding 계약은 임의로 변경하지 않는다. SampleApp의 상호작용 상태는 기존 `@State` 또는 `@StateObject` 패턴 중 규모에 맞게 선택한다. 모든 샘플에 별도 상태 클래스를 강제하지 않는다.
- 공개 타입·초기화 함수·파라미터를 바꿀 때 기존 호출부와 함수 참조를 검색한다. 호환 초기화 함수·alias 또는 단계적 deprecated가 필요한지 확인한다. deprecated 안내는 실제 존재하는 대체 API를 가리키고, 보존하는 기존 동작을 설명한다. 디자인에 없는 API 개편은 추측하지 않는다.
- 문서 주석에는 역할과 호출자가 알아야 할 제약·단위·상태 소유·이벤트를 적는다. `static let version`은 컴포넌트 디자인 버전이다. 요청된 버전만 반영하며 Package/배포 버전은 바꾸지 않는다.
- 기존 `#Preview`와 SampleApp에서 변경한 변형·상태·긴 텍스트·아이콘 유무를 확인할 수 있도록 필요한 예시를 유지한다. 정적 예시에 불필요한 상태나 앱 구조를 추가하지 않는다.
- 샘플 연결 시 `SDGCatalog`·`SDGViewConfig`·`SDGGuideDetailView`의 기존 등록과 버전 표시를 확인한다. 공용 등록 파일을 다른 컴포넌트 구현으로 덮어쓰지 않는다.
- 지원하지 않는 입력을 다룰 때 기존 계약을 확인한다. `assert`는 Release의 입력 방어를 보장하지 않는다. 새로운 crash·무시·보정 동작은 합의 없이 추가하지 않는다.
- 검증 결과에 소스 검토, 컴파일·원격 빌드, 산출물, 실제 앱 실행·시각 검수를 구분한다. 성공한 빌드만으로 실행 화면이 검증됐다고 보고하지 않는다.

자동화의 허용 소스 경로와 Generated·리소스·프로젝트 설정·인증·배포 버전 변경 제한은 이 문서로 확대하지 않는다. 파일을 읽었다는 사실과 모든 규칙을 지켰다는 판단을 구분한다.

## 검토 근거

2026-10-16 원본 main `070c800874a339f3c93afbd45e8a23b63f4eadb8`과 다음 PR을 읽고 추린 기준이다. 열린 PR은 확정 정책의 근거가 아니라 구현 사례이다.

- [main IconTab: 입력·콜백·공개 계약](https://github.com/shopl/shopl-design-guide-ios/blob/070c800874a339f3c93afbd45e8a23b63f4eadb8/Sources/ShoplDesignGuide/Component/Tab/SDGIconTab.swift)
- [PR #119: IconTab과 샘플 연결](https://github.com/shopl/shopl-design-guide-ios/pull/119)
- [PR #122: CheckOption 호환 초기화 함수](https://github.com/shopl/shopl-design-guide-ios/pull/122)
- [PR #123: MiniListPopup의 책임 분리와 Preview](https://github.com/shopl/shopl-design-guide-ios/pull/123)
- [PR #125: SelectInput의 기존 초기화 계약과 Preview](https://github.com/shopl/shopl-design-guide-ios/pull/125)
- [PR #134: LinearProgress의 실제 진행률과 호환 API](https://github.com/shopl/shopl-design-guide-ios/pull/134)
