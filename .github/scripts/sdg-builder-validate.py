"""Mac 빌드 전에 iOS SDG의 요청 커밋·브랜치·허용 파일 범위를 검사한다."""

import os
import re
import subprocess
import sys


def require(condition, message):
    if not condition:
        raise SystemExit(message)


def git(*args):
    return subprocess.check_output(['git', *args]).decode().strip()


repository = os.environ['GITHUB_REPOSITORY']
require(repository == 'shopl/shopl-design-guide-ios', 'Unexpected SDG repository.')
require(os.environ['GITHUB_REF'] == 'refs/heads/main', 'Dispatch the trusted main workflow.')
sha = os.environ['SOURCE_SHA']
base = os.environ['SOURCE_BASE']
branch = os.environ['SOURCE_BRANCH']
require(re.fullmatch(r'[a-f0-9]{40}', sha), 'Invalid source commit.')
require(re.fullmatch(r'[a-f0-9]{40}', base), 'Invalid base commit.')
# Jira는 이름 형식만 검사한다. 실제 이슈 조회와 브랜치 생성 전환은 연결 프로그램의 후속 작업이다.
# 팀 작업 브랜치를 허용하고, UUID 형식은 기존 자동화와의 이관 호환으로 남긴다.
work_branch = re.fullmatch(
    r'(add|update|document|roadmap)/[A-Za-z0-9][A-Za-z0-9._-]*/SH-[0-9]+'
    r'(?:-[A-Za-z0-9][A-Za-z0-9._-]*)?', branch,
)
legacy_branch = re.fullmatch(r'(add|update|automation)/figma-[a-f0-9-]{36}', branch)
require(work_branch or legacy_branch,
        'Use add|update|document|roadmap/author/SH-issue[-summary] for an SDG working branch.')
subprocess.run(['git', 'check-ref-format', f'refs/heads/{branch}'], check=True)
if legacy_branch:
    print('기존 UUID 브랜치 호환 형식입니다. 작업자·Jira 기반 브랜치 생성 전환은 별도 진행합니다.', file=sys.stderr)
require(re.fullmatch(r'[a-f0-9-]{36}', os.environ['BUILD_ID']), 'Invalid build ID.')
require(git('rev-parse', 'HEAD') == sha, 'Checkout does not match the requested commit.')
# Shopl QA처럼 러너의 기존 Git을 사용한다. 요청한 SHA는 유지하고 원격 브랜치 이동만 검사한다.
try:
    remote = subprocess.run(
        ['git', 'ls-remote', '--exit-code', 'origin', f'refs/heads/{branch}'],
        capture_output=True, text=True, timeout=30,
        env={**os.environ, 'GIT_TERMINAL_PROMPT': '0'},
    )
except subprocess.TimeoutExpired:
    raise SystemExit('Remote branch verification timed out. Check the network connection.') from None
require(remote.returncode == 0, 'Cannot verify the remote branch. Check branch, repository access and network.')
require(remote.stdout.strip() == f'{sha}\trefs/heads/{branch}',
        'The SDG branch changed after build submission.')
subprocess.run(['git', 'merge-base', '--is-ancestor', base, 'origin/main'], check=True)
subprocess.run(['git', 'merge-base', '--is-ancestor', base, sha], check=True)

# 기준 커밋 이후에는 SDG/SampleApp Swift 소스만 변경할 수 있다. 삭제·이름 변경도 검사한다.
changed = subprocess.check_output([
    'git', 'diff', '--name-only', '--no-renames', '-z', base, sha,
]).decode().split('\0')
for source in filter(None, changed):
    require(re.fullmatch(r'(Sources/ShoplDesignGuide|SampleApp/Sources)/[\w/+]+\.swift', source),
            f'Changes outside permitted Swift sources: {source}')
    require(not source.startswith('Sources/ShoplDesignGuide/Generated/'), 'Generated sources are protected.')
    entry = git('ls-tree', sha, '--', source) or git('ls-tree', base, '--', source)
    require(entry.startswith('100644 blob '), f'Unexpected source file mode: {source}')

# 오래된 작업 브랜치가 최신 main의 빌드 설정·지침을 되돌리지 않도록 검사한다.
main_changes = subprocess.check_output([
    'git', 'diff', '--name-only', '--no-renames', '-z', 'origin/main', sha,
]).decode().split('\0')
for source in filter(None, main_changes):
    require(re.fullmatch(r'(Sources/ShoplDesignGuide|SampleApp/Sources)/[\w/+]+\.swift', source),
            f'Update the working branch to current main before building: {source}')
    require(not source.startswith('Sources/ShoplDesignGuide/Generated/'), 'Update generated sources from main.')
print('Verified exact iOS SDG source and protected paths.')
