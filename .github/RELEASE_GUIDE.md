# Release 가이드

## Release 생성 방법

### 1. 변경사항을 main 브랜치에 merge

```bash
git checkout main
git pull origin main
git merge your-feature-branch
git push origin main
```

### 2. GitHub에서 Release 생성

1. GitHub 저장소 페이지로 이동
2. 오른쪽 사이드바에서 **"Releases"** 클릭
3. **"Draft a new release"** 버튼 클릭
4. **"Choose a tag"** 클릭 후 새 태그 입력 (예: `v1.0.0`)
5. **"Create new tag on publish"** 선택
6. Release 제목 입력 (예: `v1.0.0`)

### 3. Release Notes 작성

아래 템플릿을 복사하여 사용:

```markdown
# Changelog

## [v1.0.0] - 2025-01-21

### Added
- 추가된 기능 설명

### Documentation
- 문서 변경사항
```

### 4. Publish release

- **"Publish release"** 버튼 클릭하여 릴리즈 발행

## 버전 관리 규칙

[Semantic Versioning](https://semver.org/) 사용:

- **Major (v1.0.0 → v2.0.0)**: Breaking changes
- **Minor (v1.0.0 → v1.1.0)**: 새로운 기능 추가 (하위 호환)
- **Patch (v1.0.0 → v1.0.1)**: 버그 수정

## 예시

### Release v1.2.0 예시

```markdown
# Changelog

## [v1.2.0] - 2025-01-21

### Added
- SDGNumberPicker 컴포넌트 추가
- SDGTimePicker에 네이티브 DatePicker 지원 추가
- Calendar에 커스텀 날짜 포맷 지원

### Documentation
- README에 상세한 사용 예제 추가
- 컴포넌트 API 문서 업데이트
```
