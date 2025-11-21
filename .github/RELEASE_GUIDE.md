# Release 가이드

## 자동 Release Draft 프로세스

main 브랜치에 merge하면 GitHub Actions가 자동으로 Draft Release를 생성합니다.

### 1. 변경사항을 main 브랜치에 merge

```bash
git checkout main
git pull origin main
git merge your-feature-branch
git push origin main
```

👉 **이 순간 자동으로 Draft Release가 생성됩니다!**

### 2. GitHub에서 Draft Release 확인

1. GitHub 저장소 페이지로 이동
2. 오른쪽 사이드바에서 **"Releases"** 클릭
3. **"Draft"** 라벨이 붙은 릴리즈 확인

### 3. Release Notes 편집

자동 생성된 Release Notes를 편집:

1. Draft Release의 **"Edit"** 버튼 클릭
2. `[version]`을 실제 버전으로 변경 (예: `v1.0.0`)
3. **"Added"**와 **"Documentation"** 섹션에 내용 추가
4. 하단의 **"Recent Commits"** 참고하여 작성
5. 제목을 버전 번호로 변경 (예: `v1.0.0`)

### 4. 태그 설정 및 Publish

1. **"Choose a tag"** 드롭다운 클릭
2. 새 태그 입력 (예: `v1.0.0`)
3. **"Create new tag: v1.0.0 on publish"** 선택
4. **"Publish release"** 버튼 클릭

## 버전 관리 규칙

[Semantic Versioning](https://semver.org/) 사용:

- **Major (v1.0.0 → v2.0.0)**: Breaking changes
- **Minor (v1.0.0 → v1.1.0)**: 새로운 기능 추가 (하위 호환)
- **Patch (v1.0.0 → v1.0.1)**: 버그 수정

## Release Notes 작성 예시

### 자동 생성된 템플릿

```markdown
# Changelog

## [version] - 2025-01-21

### Added

### Documentation

---

**Recent Commits:**

- OS에서 제공하는 DatePicker를 사용하는 SDGTimePicker로 교체 (1b3c42c)
- SDGNumberPicker 추가 (6df94fd)
```

### 편집 후 최종 버전

```markdown
# Changelog

## [v1.2.0] - 2025-01-21

### Added
- SDGNumberPicker 컴포넌트 추가
- SDGTimePicker에 네이티브 DatePicker 지원 추가

### Documentation
- README에 상세한 사용 예제 추가
- 컴포넌트 API 문서 업데이트

---

**Recent Commits:**

- OS에서 제공하는 DatePicker를 사용하는 SDGTimePicker로 교체 (1b3c42c)
- SDGNumberPicker 추가 (6df94fd)
```

## 주의사항

- main에 push할 때마다 새로운 Draft Release가 생성됩니다
- 이전 Draft Release는 자동으로 삭제됩니다
- Draft 상태의 Release는 태그를 생성하지 않습니다
- Publish 시점에 태그가 생성됩니다

## 문제 해결

### GitHub Actions가 실행되지 않는 경우

1. 저장소 **Settings** → **Actions** → **General**
2. **Workflow permissions**에서 **"Read and write permissions"** 활성화
3. **"Allow GitHub Actions to create and approve pull requests"** 체크
