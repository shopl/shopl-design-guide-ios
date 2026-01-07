module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // 기능 추가
        'fix',      // 버그 수정
        'design',   // 디자인 변경
        'docs',     // 문서 수정
        'style',    // 코드 포맷팅
        'refactor', // 리팩토링
        'perf',     // 성능 개선
        'test',     // 테스트
        'chore',    // 설정/빌드 등 잡일
        'build',    // 빌드 관련
        'ci',       // CI 관련
        'wip',      // 진행 중인 작업
        'revert'    // 커밋 되돌리기
      ]
    ],
    'type-case': [2, 'always', 'lower-case'],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.']
  }
};
