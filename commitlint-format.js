const ALLOWED_TYPES = {
  'feat': '기능 추가',
  'fix': '버그 수정',
  'design': '디자인 변경',
  'docs': '문서 수정',
  'style': '코드 포맷팅 (로직 변경 없음)',
  'refactor': '리팩토링',
  'perf': '성능 개선',
  'test': '테스트 코드',
  'chore': '설정/빌드 등 잡일',
  'build': '빌드 관련',
  'ci': 'CI 관련',
  'wip': '진행 중인 작업',
  'revert': '커밋 되돌리기'
};

const ERROR_MESSAGES = {
  'type-enum': '허용되지 않는 타입입니다. 아래 목록을 참고하세요.',
  'type-case': '타입(prefix)은 소문자여야 합니다.',
  'type-empty': '타입(prefix)이 누락되었습니다.',
  'subject-empty': '커밋 내용이 비어있습니다.',
  'subject-full-stop': '제목 끝에 마침표(.)를 찍지 마세요.',
  'header-max-length': '커밋 제목이 너무 깁니다. (100자 제한)',
  'subject-case': '커밋 내용의 대소문자 규칙 위반입니다.'
};

module.exports = function (report) {
  
  let errors = report.errors || [];
  let warnings = report.warnings || [];
  
  if (report.results && Array.isArray(report.results)) {
    report.results.forEach(result => {
      if (result.errors) errors = errors.concat(result.errors);
      if (result.warnings) warnings = warnings.concat(result.warnings);
    });
  }
  
  if (errors.length === 0 && warnings.length === 0) {
    return '';
  }
  
  const lines = [];
  
  lines.push('\n🛑  커밋 메시지 규칙 위반!  🛑');
  lines.push('----------------------------------------------------');
  
  errors.forEach((err) => {
    const icon = '✖';
    const msg = ERROR_MESSAGES[err.name] || err.message;
    lines.push(` ${icon}  ${msg}  [${err.name}]`);
  });
  
  lines.push('----------------------------------------------------');
  
  lines.push('ℹ️  사용 가능한 타입 (Type) 목록:');
  
  Object.entries(ALLOWED_TYPES).forEach(([type, desc]) => {
    const paddedType = type.padEnd(10, ' ');
    lines.push(`    ${paddedType} : ${desc}`);
  });
  
  lines.push('');
  
  lines.push('✅  올바른 작성 예시:');
  lines.push('    feat: 로그인 기능 추가');
  lines.push('    fix: 홈 화면 크래시 수정');
  lines.push('    design: 버튼 컬러 변경');
  lines.push('\n');
  
  return lines.join('\n');
};
