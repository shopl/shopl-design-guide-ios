// MCP 서버를 의존성까지 포함한 단일 파일로 번들해 플러그인 폴더에 둔다.
// 플러그인은 설치 시 npm install을 하지 않으므로 런타임 의존성이 모두 번들 안에 있어야 한다.
// 생성 데이터(JSON)는 번들에 넣지 않고 server/data/에서 읽는다. 데이터만 바뀌면 번들은 그대로라 PR diff가 데이터에만 남는다.

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { build } from 'esbuild';

const pkg = JSON.parse(readFileSync(new URL('../package.json', import.meta.url), 'utf8'));

await build({
  // URL.pathname은 공백·한글을 퍼센트 인코딩하고 Windows에서 `/C:/...`가 되므로 파일 경로로 변환한다.
  entryPoints: [fileURLToPath(new URL('../src/index.ts', import.meta.url))],
  outfile: fileURLToPath(new URL('../../plugins/sdg-ios/server/index.mjs', import.meta.url)),
  bundle: true,
  platform: 'node',
  format: 'esm',
  target: 'node18',
  minify: true,
  legalComments: 'eof',
  define: { __SDG_MCP_VERSION__: JSON.stringify(pkg.version) },
  // 번들에 섞인 CommonJS 의존성이 require를 쓸 수 있게 한다.
  banner: {
    js: "#!/usr/bin/env node\nimport { createRequire as __sdgCreateRequire } from 'node:module';\nconst require = __sdgCreateRequire(import.meta.url);",
  },
  logLevel: 'info',
});
