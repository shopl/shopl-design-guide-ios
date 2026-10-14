/**
 * 검색 보조 함수. shoplflow MCP와 같은 규칙을 따른다.
 * - 여러 단어 질의는 모든 단어가 맞아야 한다(AND). 단어를 늘리면 결과가 좁아진다.
 * - 정확 일치 > 단어 일치 > 부분 문자열 순으로 점수를 준다.
 */

/** 한국어로 물어도 영문 컴포넌트 이름에 닿도록 하는 최소한의 별칭. */
const KOREAN_ALIASES: Record<string, string[]> = {
  버튼: ['button'],
  팝업: ['popup'],
  모달: ['popup'],
  다이얼로그: ['popup'],
  입력: ['input', 'textfield'],
  텍스트필드: ['input', 'textfield'],
  검색: ['search'],
  탭: ['tab'],
  토글: ['toggle'],
  스위치: ['toggle'],
  체크박스: ['checkbox'],
  체크: ['check'],
  라디오: ['radio'],
  드롭다운: ['dropdown'],
  아바타: ['avatar'],
  프로필: ['profile', 'avatar'],
  뱃지: ['badge'],
  배지: ['badge'],
  프로그레스: ['progress'],
  로딩: ['progress', 'loading'],
  툴팁: ['tooltip'],
  네비: ['navi'],
  내비: ['navi'],
  네비게이션: ['navi'],
  썸네일: ['thumbnail'],
  사진: ['photo', 'thumbnail'],
  첨부: ['attachment'],
  시간: ['time'],
  날짜: ['date', 'calendar'],
  캘린더: ['calendar'],
  폼: ['form'],
  헤더: ['header'],
  칩: ['chip'],
  필터: ['filter'],
  인디케이터: ['indicator'],
  세그먼트: ['segment'],
  피커: ['picker'],
  하단: ['bottom'],
  플로팅: ['floating'],
  리스트: ['list'],
  목록: ['list'],
  아이콘: ['icon'],
  라벨: ['label'],
  레이블: ['label'],
  삭제: ['delete', 'trash'],
  휴지통: ['trash', 'delete'],
  추가: ['add', 'plus'],
  닫기: ['close'],
  설정: ['setting'],
  알림: ['alarm', 'notification'],
  화살표: ['arrow'],
  뒤로: ['back'],
  더보기: ['more'],
  편집: ['edit'],
  공유: ['share'],
  카메라: ['camera'],
  위치: ['location', 'pin', 'map'],
  지도: ['map'],
  색: ['color'],
  색상: ['color'],
  컬러: ['color'],
  여백: ['spacing'],
  간격: ['spacing'],
  글꼴: ['typography'],
  폰트: ['typography'],
  타이포: ['typography'],
  라운드: ['radius'],
  모서리: ['radius'],
};

/** 질의를 소문자 단어로 나누고, 단어마다 한국어 별칭을 붙인다. */
export function parseQuery(query: string): string[][] {
  return query
    .toLowerCase()
    .split(/[\s,./_\-()]+/)
    .filter(Boolean)
    .map((term) => [term, ...(KOREAN_ALIASES[term] ?? [])]);
}

/** `SDGBoxButton` → `["sdg", "box", "button"]`, `ic_add_plus` → `["ic", "add", "plus"]` */
export function words(name: string): string[] {
  return name
    .replace(/([a-z0-9])([A-Z])/g, '$1 $2')
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1 $2')
    .toLowerCase()
    .split(/[\s_.\-`]+/)
    .filter(Boolean);
}

/** 단어(별칭 포함) 중 하나라도 맞으면 그 점수, 모든 단어가 맞아야 합산. 하나라도 0이면 0. */
export function scoreTerms(terms: string[][], score: (term: string) => number): number {
  let total = 0;
  for (const variants of terms) {
    const best = Math.max(...variants.map(score));
    if (best <= 0) return 0;
    total += best;
  }
  return total;
}

/** 오타 교정용 후보. 부분 문자열 일치를 먼저, 그다음 편집 거리 순. */
export function suggest(name: string, candidates: string[], limit = 5): string[] {
  const target = name.toLowerCase().replace(/^\./, '');
  const scored = candidates.map((candidate) => {
    const lower = candidate.toLowerCase();
    const containment = lower.includes(target) || target.includes(lower) ? 0 : 1;
    return { candidate, containment, distance: editDistance(target, lower) };
  });
  scored.sort((a, b) => a.containment - b.containment || a.distance - b.distance || a.candidate.localeCompare(b.candidate));
  return scored.slice(0, limit).map((entry) => entry.candidate);
}

function editDistance(a: string, b: string): number {
  const previous = Array.from({ length: b.length + 1 }, (_, index) => index);
  for (let i = 1; i <= a.length; i += 1) {
    let diagonal = previous[0]!;
    previous[0] = i;
    for (let j = 1; j <= b.length; j += 1) {
      const above = previous[j]!;
      previous[j] = Math.min(above + 1, previous[j - 1]! + 1, diagonal + (a[i - 1] === b[j - 1] ? 0 : 1));
      diagonal = above;
    }
  }
  return previous[b.length]!;
}
