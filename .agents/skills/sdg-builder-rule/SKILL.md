---
name: sdg-builder-rule
description: SwiftUI SDG 컴포넌트·템플릿과 SampleApp 연결을 새로 만들거나 수정할 때 최소 공통 컨벤션과 필수 문서 주석·컴포넌트 디자인 버전을 적용한다.
---

# iOS SDG 최소 공통 규칙

기존 코드와 관련 PR에서 확인한 공통 패턴을 바탕으로 한 작업 기준이다. 기존 코드 전체가 이 규칙을 준수한다고 해석하지 않는다. 주석·버전의 상시 작성은 2026-10-19 사용자 요청으로 추가한 규칙이며, 기존 코드에서 일관되게 지켜지던 관례와 구분한다.

새로 만들거나 이번 작업에서 수정하는 코드에 적용한다. 규칙 적용만을 이유로 무관한 컴포넌트·API·파일 구조를 일괄 변경하지 않는다. 작업 경로의 지침과 최신 합의 요구사항을 함께 확인한다.

## 항상 작성: 주석

- 새로 만들거나 수정하는 SDG 컴포넌트·템플릿의 주 선언에는 역할을 설명하는 한국어 Swift 문서 주석(`///`)을 항상 추가하거나 갱신한다. 파일 상단의 작성자·날짜 주석으로 대체하지 않는다.
- 새로 만들거나 변경하는 공개 초기화 함수·함수·모델에는 호출자가 알아야 할 계약을 문서화한다. 입력값의 의미·단위·허용 범위, 기본값의 동작, 상태 소유자와 이벤트 전달 시점을 해당하는 범위에서 적는다. 초기화 함수의 파라미터 설명은 기존 `- Parameters:` 형식을 따른다.
- 동작이 바뀌면 주석도 함께 갱신한다. 호환 API의 주석과 deprecated 안내는 실제 대체 API 및 보존하는 동작과 일치해야 한다.
- 내부 구현에는 이유나 제약이 코드만으로 드러나지 않을 때 설명을 추가한다. 단순 대입·렌더링을 반복 설명하거나 모든 private 도우미에 형식적인 주석을 붙이지 않는다.

## 항상 명시: 컴포넌트 디자인 버전

- 새로 만들거나 수정하는 SDG 컴포넌트·템플릿의 주 타입에는 적용한 디자인 가이드 버전을 공개 `version` 프로퍼티로 항상 명시한다. 기존 프로퍼티가 있으면 확인·유지하거나 확정된 디자인 버전으로 갱신하고, 없는 작업 대상에는 추가한다.
- 일반 타입은 기존의 `public static let version` 패턴을 따른다. 제네릭 타입 등에서 쓰는 계산 프로퍼티 `public static var version: String { ... }`는 그대로 유지할 수 있다. 버전 프로퍼티에도 컴포넌트 디자인 버전이라는 의미를 문서 주석으로 적는다.
- Figma 디자인 문서·합의된 작업 요구사항에서 해당 컴포넌트의 정확한 버전을 확인한다. 단순 코드 수정·주석 보완만으로 버전을 자동 증가시키지 않는다. 저장소의 최신 배포 버전을 모든 컴포넌트에 복사하지 않는다.
- 기존 버전이 있고 새 디자인 버전 지시가 없으면 기존 값을 유지한다. 신규 컴포넌트이거나 버전이 없는 대상에서 정확한 값을 확인할 수 없으면 확인을 요청하고 미확정 상태를 보고한다. 임의의 `0.0.0`·추측값을 넣거나 버전 명시가 완료됐다고 보고하지 않는다.
- 버전의 원본은 해당 컴포넌트의 `version` 프로퍼티로 둔다. SampleApp의 `SDGGuideDetailView`에 표시하는 대상은 같은 프로퍼티를 참조한다. 샘플 View·상태 모델·내부 도우미마다 별도 디자인 버전을 중복 선언하지 않는다.
- 패키지·앱·라이브러리 배포 버전과는 별개다. 이 규칙 때문에 배포 설정·태그를 변경하지 않는다.

## 최소 코드 컨벤션

- 컴포넌트는 `Sources/ShoplDesignGuide/Component`, 복합 UI는 기존 `Template`, 샘플은 `SampleApp/Sources`의 가까운 구현을 따른다. 인접 코드의 2칸 들여쓰기·이름을 유지하고, 기존 경로·공개 이름의 오타를 이번 요청 없이 정리하지 않는다. 새 SDG 컴포넌트는 기존 `SDG` 접두사를 따른다.
- 공개 API는 호출에 필요한 범위로 제한하고 내부 도우미는 가능한 `private` 또는 `fileprivate`로 둔다. 기존 공개 타입·초기화 함수·파라미터를 변경할 때 호출부와 함수 참조를 검색해 호환 유지·단계적 deprecated가 필요한지 확인한다. 디자인에 없는 API 개편을 추측하지 않는다.
- 선택값·입력값·진행률과 이벤트는 기존 호출 계약을 보존한다. 호출부가 소유하는 값은 기존 입력·콜백 또는 Binding 계약을 따른다. SampleApp은 가까운 `@State`·ObservableObject 패턴에 맞추며, 모든 샘플에 별도 상태 클래스를 강제하지 않는다.
- 기존 `SDG.Color`, `.typo`, `Image(sdg:)`, 간격·모서리 반경 토큰을 의미가 같을 때 재사용한다. 컴포넌트의 고정 규격 수치는 기존 구현을 따르며, 없는 토큰을 만들거나 무관한 상수를 일괄 치환하지 않는다.
- 컴포넌트가 커질 때에는 가까운 구현처럼 모델·도우미·미리보기를 분리한다. 모든 컴포넌트에 동일한 파일 수·Model/State 구조·MARK 순서를 강제하지 않는다.
- 기존 `#Preview`·PreviewProvider와 SampleApp에서 수정한 변형·상태·긴 텍스트·아이콘 유무를 확인할 수 있는 예시를 유지·보완한다. 정적 예시에 불필요한 상태나 앱 구조를 추가하지 않는다.
- 샘플 연결 시 `SDGCatalog`·`SDGViewConfig`·`SDGGuideDetailView`의 기존 등록과 버전 표시를 확인한다. 공용 등록 파일을 다른 컴포넌트의 구현으로 덮어쓰지 않는다.
- 입력 처리와 접근성·애니메이션의 기존 동작을 확인하고 작업 요구사항에 맞게 유지한다. 새로운 강제 종료·무시·보정 정책을 추측해서 추가하지 않는다.

## 작업 마무리

- 이번 작업 대상의 주 선언·변경한 공개 API 주석과 정확한 컴포넌트 버전 명시를 확인한다. 문서를 읽었다는 사실만으로 준수를 완료했다고 판단하지 않는다.
- 실제 변경 범위, 공개 호출 계약·샘플 연결을 검토한다. 소스 검토, 컴파일·원격 빌드, 산출물, 실제 앱 실행·시각 검수를 구분해서 보고한다.
- 자동화의 허용 소스 경로와 자동 생성 파일·리소스·프로젝트 설정·인증·게시 권한의 제한은 이 문서로 확대하지 않는다.

## 검토 근거

2026-10-19 main `070c800874a339f3c93afbd45e8a23b63f4eadb8`의 IconTab·IconLabel·Dropdown·BoxButton·Thumbnails·TimeSelectInput·Popup 및 SampleApp 등록·상태 코드를 검토했다. 아래 열린 PR은 구현 사례이며 확정된 회사 정책으로 일반화하지 않는다.

- [main IconTab: 문서 주석·버전·입력/콜백 계약](https://github.com/shopl/shopl-design-guide-ios/blob/070c800874a339f3c93afbd45e8a23b63f4eadb8/Sources/ShoplDesignGuide/Component/Tab/SDGIconTab.swift)
- [main Thumbnails: 토큰 재사용·호환 초기화 함수](https://github.com/shopl/shopl-design-guide-ios/blob/070c800874a339f3c93afbd45e8a23b63f4eadb8/Sources/ShoplDesignGuide/Component/Thumbnails/SDGThumbnails.swift)
- [main GuideDetailView: 컴포넌트 version 참조](https://github.com/shopl/shopl-design-guide-ios/blob/070c800874a339f3c93afbd45e8a23b63f4eadb8/SampleApp/Sources/DemoViews/Guide/SDGGuideDetailView.swift)
- [PR #119: IconTab·샘플 연결, 병합됨](https://github.com/shopl/shopl-design-guide-ios/pull/119)
- [PR #122: CheckOption의 API·상태 변경, 검토 커밋 afa31c4](https://github.com/shopl/shopl-design-guide-ios/pull/122)
- [PR #123: MiniListPopup의 역할 분리·공개 함수 주석, 검토 커밋 ddcd863](https://github.com/shopl/shopl-design-guide-ios/pull/123)
- [PR #125: SelectInput의 초기화 계약·주석·별도 미리보기, 검토 커밋 0e21db7](https://github.com/shopl/shopl-design-guide-ios/pull/125)
- [PR #134: 실제 진행률·버전·문서 주석·로컬 샘플 상태, 검토 커밋 c73ea25](https://github.com/shopl/shopl-design-guide-ios/pull/134)
