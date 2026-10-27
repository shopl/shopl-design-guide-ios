"""PR 버튼의 원격 생성 결과를 묶는다. 소스·실행 번들 변경은 반환하지 않는다."""
import hashlib
import json
import os
from pathlib import Path
import subprocess


def git(*args):
    return subprocess.check_output(['git', *args])


def require(condition, message):
    if not condition:
        raise SystemExit(message)


names = ('api', 'catalog', 'examples', 'icons', 'setup', 'tokens')
files = [f'plugins/sdg-ios/server/data/{name}.generated.json' for name in names]
sha = os.environ['SOURCE_SHA']
require(git('rev-parse', 'HEAD').decode().strip() == sha, 'Source changed during generation.')
changed = set(filter(None, git('diff', '--name-only', '--no-renames', '-z', sha).decode().split('\0')))
require(changed <= set(files), 'Generator changed source, tools or runtime bundle.')
require(not git('ls-files', '--others', '--exclude-standard'), 'Generator created unexpected untracked files.')
output = Path(os.environ['RUNNER_TEMP']) / 'sdg-mcp-output'
output.mkdir(exist_ok=False)
entries = []
for name in files:
    source = Path(name)
    require(source.is_file() and not source.is_symlink() and source.resolve() == Path.cwd() / source,
            f'Metadata must be a regular file: {name}')
    require(not source.stat().st_mode & 0o111 and source.stat().st_size <= 20 * 1024 * 1024,
            f'Invalid metadata mode or size: {name}')
    data = source.read_bytes()
    require(isinstance(json.loads(data), dict), f'Metadata must be a JSON object: {name}')
    (output / source.name).write_bytes(data)
    entries.append({'file': name, 'sha256': hashlib.sha256(data).hexdigest()})
receipt = {'version': 1, 'sourceSha': sha, 'base': os.environ['SOURCE_BASE'],
           'branch': os.environ['SOURCE_BRANCH'], 'requestId': os.environ['REQUEST_ID'],
           'workflowSha': os.environ['GITHUB_SHA'], 'runId': os.environ['GITHUB_RUN_ID'],
           'runAttempt': os.environ['GITHUB_RUN_ATTEMPT'], 'files': entries}
(output / 'receipt.json').write_text(json.dumps(receipt, ensure_ascii=False, indent=2))
