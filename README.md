# Shopl Design Guide iOS

A comprehensive SwiftUI design system library for iOS and macOS applications.

---

### 개요

**Shopl Design Guide iOS**는 iOS와 macOS 애플리케이션을 위한 프로덕션 준비가 완료된 SwiftUI 디자인 시스템입니다. 40개 이상의 UI 컴포넌트, 커스텀 타이포그래피 시스템, 그리고 포괄적인 테마 지원을 제공합니다.

### 주요 기능

- **40개 이상의 UI 컴포넌트** - 원자 컴포넌트부터 복잡한 템플릿까지
- **타입 안전 디자인 토큰** - Spacing, Corner Radius, Color를 위한 Enum
- **포괄적인 컬러 팔레트** - 30개 이상의 시맨틱 컬러
- **프로덕션 준비 완료** - Loading, Error, Disabled 상태 지원
- **고급 컴포넌트** - 스마트 툴팁, 모달, 네비게이션 템플릿
- **Swift Package Manager** - 최소 의존성으로 쉬운 통합

### 요구사항

- iOS 16.0+ / macOS 12.0+
- Swift 6.0+
- Xcode 15.0+

### 설치

#### Swift Package Manager

`Package.swift`에 다음을 추가하세요:

```swift
dependencies: [
    .package(
        url: "https://github.com/shopl/shopl-design-guide-ios",
        from: "\(version)"
    )
]
```

또는 Xcode에서 직접 추가:
1. File > Add Package Dependencies
2. 저장소 URL 입력
3. 버전 또는 브랜치 선택

### 빠른 시작

```swift
import SwiftUI
import ShoplDesignGuide

struct ContentView: View {
    @State private var isSelected = false
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: .spacing20) {
            // 타이포그래피
            Text("안녕하세요, Shopl!")
                .typo(.title1_SB, .neutral700)

            // 버튼
            SDGBoxButton(
                option: .init(
                    size: .medium,
                    title: "확인",
                    color: .init(
                        backgroundColor: .primary400,
                        textColor: .neutral0
                    ),
                    selectedColor: .init(
                        backgroundColor: .primary300,
                        textColor: .neutral0
                    )
                ),
                isSelected: $isSelected,
                isLoading: $isLoading,
                action: {
                    print("버튼 탭됨")
                }
            )
        }
        .padding(.spacing16)
    }
}
```

### 아키텍처

라이브러리는 4개의 주요 레이어로 구성되어 있습니다:

```
ShoplDesignGuide/
├── Foundation/          # 디자인 토큰 & 핵심 시스템
│   ├── SDGFont/        # 타이포그래피 시스템
│   ├── SDGSpacing/     # Spacing 토큰
│   ├── SDGCornerRadius/ # Corner Radius 토큰
│   └── SDGLocalization/ # 다국어 시스템
├── Component/           # 26개 이상의 원자 UI 컴포넌트
├── Template/            # 15개 이상의 복잡한 복합 컴포넌트
└── Util/                # 유틸리티 & 익스텐션
```

### 컴포넌트

#### 버튼
- **SDGBoxButton** - 사각형 버튼 (solid/outline, 3가지 사이즈)
- **SDGCapsuleButton** - 캡슐형 버튼
- **SDGGhostButton** - 투명 버튼
- **SDGFloatingButton** - 플로팅 액션 버튼
- **SDGIconButton** - 아이콘 전용 버튼

```swift
SDGBoxButton(
    option: .init(
        size: .medium,
        icon: .left(image: Image(systemName: "star.fill"), color: .primary400),
        title: "버튼",
        color: .init(backgroundColor: .neutral200, textColor: .neutral700),
        selectedColor: .init(backgroundColor: .primary400, textColor: .neutral0)
    ),
    isSelected: $isSelected,
    isLoading: $isLoading,
    action: { }
)
```

#### 텍스트 입력
- **SDGSimpleInput** - 기본 텍스트 필드 (solid/line 변형)
- **SDGFixedTextInput** - 고정 포맷 입력
- **SDGLoginInput** - 로그인 전용 입력
- **SDGUnderlineInput** - 언더라인 스타일 입력
- **SDGTextEditor** - 멀티라인 텍스트 에디터

```swift
SDGSimpleInput(
    placeholder: "텍스트 입력",
    text: $text,
    state: .default,
    variant: .solid
)
```

#### 검색 바
- **SDGBoxSearch** - 박스 스타일 검색
- **SDGCapsuleSearch** - 캡슐형 검색
- **SDGCategorySearch** - 카테고리 필터 검색
- **SDGFocusableTextField** - 자동 포커스 텍스트 필드

#### 선택 컨트롤
- **SDGCheckBox** - 표준 체크박스
- **SDGCheckOption** - 옵션이 있는 체크박스
- **SDGRadio** - 라디오 버튼
- **SDGToggle** - 토글 스위치 (M/S 사이즈)
- **SDGSegment** - 세그먼트 컨트롤

```swift
SDGCheckBox(
    isChecked: $isChecked,
    size: .medium,
    action: { }
)
```

#### 뱃지 & 라벨
- **SDGBoxBadge** - 사각형 뱃지 (solid/line)
- **SDGCapsuleBadge** - 캡슐형 뱃지
- **SDGIconLabel** - 아이콘과 라벨

#### 프로그레스 인디케이터
- **SDGCircularProgress** - 원형 스피너 (4가지 사이즈)
- **SDGLinearProgress** - 선형 프로그레스 바
- **SDGDotProgress** - 점 기반 프로그레스
- **SDGSystemProgress** - 네이티브 시스템 프로그레스

#### 기타 컴포넌트
- **SDGAvatar** - 사용자 아바타 (6가지 사이즈: XXS ~ XL)
- **SDGThumbnail** - 이미지 썸네일
- **SDGDropdown** - 드롭다운 선택기
- **SDGTooltip** - 스마트 툴팁 (8가지 위치)
- **Calendar** - 캘린더 피커
- **SDGTimePicker** - 네이티브 시간 피커
- **SDGNumberPicker** - 숫자 피커

### 템플릿

#### 네비게이션
```swift
SDGBasicNavi(
    title: "제목",
    popAction: { },
    rightButtons: [
        .init(icon: Image(systemName: "gear"), action: { })
    ]
)
```

#### 팝업

라이브러리는 다양한 변형을 가진 강력한 팝업 시스템을 포함합니다:

```swift
.centerConfirmPopup(
    isPresented: showPopup,
    title: "작업 확인",
    bodyText: "진행하시겠습니까?",
    leftButtonOption: .init(title: "취소", action: { }),
    rightButtonOption: .init(title: "확인", action: { })
)
```

**팝업 변형:**
- **SDGCenterPopup** - 중앙 모달 팝업
  - SDGConfirmPopup - 확인 다이얼로그
  - SDGDeletePopup - 삭제 확인
  - SDGInfoPopup - 정보 다이얼로그
  - SDGInputPopup - 입력 다이얼로그
  - SDGCenterCustomPopup - 커스텀 콘텐츠
- **SDGBottomPopup** - 하단 시트 모달
- **SDGIconPopup** - 아이콘 중심 팝업
- **SDGListPopup** - 리스트 선택 팝업

#### 폼 템플릿
- **SDGSimpleTextForm** - 기본 텍스트 폼
- **SDGFixedTextForm** - 고정 포맷 폼
- **SDGDropdownForm** - 드롭다운 폼
- **SDGSelectForm** - 선택 폼
- **SDGTimeSelectForm** - 시간 선택 폼

### 디자인 토큰

#### Spacing

```swift
// 사용법
.padding(.spacing16)
.padding(.horizontal, .spacing20)
VStack(spacing: .spacing12) { }

// 사용 가능한 값
.spacing2, .spacing4, .spacing6, .spacing8, .spacing10,
.spacing12, .spacing16, .spacing20, .spacing24, .spacing28,
.spacing32, .spacing40, .spacing60, .spacing100, .spacing104
```

#### Corner Radius

```swift
// 사용법
.cornerRadius(.radius12)
.cornerRadius(.radius8, corners: [.topLeft, .topRight])

// 사용 가능한 값
.radius2, .radius4, .radius6, .radius8, .radius10,
.radius12, .radius14, .radius16, .radius18, .radius20, .radius25
```

#### 컬러

**중립 컬러:**
- `neutral0` (흰색) ~ `neutral900` (검은색)
- 13가지 음영 사용 가능

**브랜드 컬러:**
- Primary: `primary50`, `primary200`, `primary300`, `primary400`
- Secondary: `secondary50`, `secondary200`, `secondary300`, `secondary400`

**포인트 컬러:**
- Red: `red50`, `red300`, `red350`, `red400`
- Others: `sdgGreen`, `sdgYellow`, `sdgPurple`, `sdgLemon`, `sdgPink`, `sdgOrange`

```swift
// 사용법
.background(.neutral0)
.foregroundColor(.primary400)
```

### 타이포그래피

라이브러리는 다국어를 지원하는 **Pretendard** 폰트 패밀리를 사용합니다:

```swift
// 타이포그래피 스케일
Text("제목")
    .typo(.title1_SB, .neutral700)  // 20pt, semibold

Text("본문")
    .typo(.body1_R, .neutral600)    // 16pt, regular

// 사용 가능한 타입
.naviTitle        // 19pt
.title1_SB/R      // 20pt, semi-bold/regular
.title2_SB/R      // 18pt
.body1_SB/R       // 16pt
.body2_SB/R       // 14pt
.body3_SB/R       // 12pt
.body4_SB/R       // 10pt
```

### 예제

각 컴포넌트 파일의 `#Preview` 블록에서 자세한 사용 예제를 확인하세요. 모든 컴포넌트는 다양한 상태와 구성을 보여주는 포괄적인 프리뷰를 포함합니다.

### 의존성

- [Kingfisher](https://github.com/onevcat/Kingfisher) (7.10.0) - 이미지 다운로드 및 캐싱

### 라이선스

Shopl Design Guide iOS는 Apache 2.0 라이센스에 따라 제공됩니다. 자세한 내용은 라이센스 파일을 참조하세요.
