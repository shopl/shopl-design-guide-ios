// 플러그인에 실제로 들어가는 번들(plugins/sdg-ios/server/index.mjs)을 MCP 클라이언트로 띄워 모든 툴을 호출해 본다.
// 사용: npm run bundle && npm run smoke   (서버·추출기·데이터를 바꾼 뒤 실행)

import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';

const serverPath = fileURLToPath(new URL('../../plugins/sdg-ios/server/index.mjs', import.meta.url));
const transport = new StdioClientTransport({ command: process.execPath, args: [serverPath], stderr: 'pipe' });
const client = new Client({ name: 'sdg-ios-smoke', version: '0.0.0' });
await client.connect(transport);

async function call(name, args = {}) {
  const result = await client.callTool({ name, arguments: args });
  assert.ok(!result.isError, `${name} returned an error: ${JSON.stringify(result.content)}`);
  return JSON.parse(result.content[0].text);
}

const step = (label) => console.log(`  · ${label}`);

// 연결 시 지침과 툴 목록
const { tools } = await client.listTools();
assert.deepEqual(
  tools.map((tool) => tool.name).sort(),
  [
    'get_component_api',
    'get_design_guide',
    'get_setup_guide',
    'get_token',
    'get_type',
    'get_usage_example',
    'list_tokens',
    'search_component',
    'search_icon',
  ],
);
assert.match(client.getInstructions() ?? '', /setProvider/);
// SDG.Color는 ShapeStyle이 아니어서 SwiftUI API에 넘기면 컴파일되지 않는다. 바꿔 써도 되는 것처럼 안내하지 않되, 공개 변환(.color)은 알려 준다.
assert.match(client.getInstructions() ?? '', /`SDG\.Color` is not a ShapeStyle/);
assert.match(client.getInstructions() ?? '', /sdgColor\.color/);
// Codex는 instructions의 앞 512자만으로도 핵심이 전달되게 쓰라고 권장한다. 규칙 5개의 요약이 그 안에 있어야 한다.
const instructionsHead = (client.getInstructions() ?? '').slice(0, 512);
for (const anchor of ['search_component', 'get_component_api', 'list_tokens', 'search_icon', 'centerConfirmPopup', 'setProvider', 'get_setup_guide']) {
  assert.ok(instructionsHead.includes(anchor), `the first 512 characters of instructions must mention ${anchor}`);
}
step(`tools: ${tools.length}, instructions ok`);

// 토큰
const colors = await call('list_tokens', { type: 'color', query: 'neutral700' });
const neutral700 = colors.tokens.find((token) => token.name === 'neutral700');
assert.equal(neutral700?.hex, '#333333');
assert.ok(colors.tokens.some((token) => token.name === 'neutral700_10' && token.opacity === 10 && token.baseToken === 'neutral700'));
const black40 = await call('get_token', { name: 'sdgBlack_40' });
assert.equal(black40.token.opacity, 40);
assert.equal(black40.token.baseToken, undefined, 'baseToken must not point to a token that does not exist');
assert.ok(colors.usage.color.some((line) => line.includes('.foregroundStyle(.neutral700)')));
assert.ok(colors.usage.color.some((line) => line.startsWith('SDG.Color.neutral700') && line.includes('not a ShapeStyle')));
assert.ok(colors.usage.color.some((line) => line.includes('sdgColor.color')));
assert.ok(!colors.usage.color.some((line) => line.includes('cannot be converted')));

const body = await call('get_token', { name: '.body1_R' });
assert.deepEqual([body.token.size, body.token.weight, body.token.lineHeight], [16, 400, 20]);
assert.ok(body.usage.some((line) => line.includes('.typo(.body1_R')));

const spacing = await call('list_tokens', { type: 'spacing' });
assert.ok(spacing.tokens.some((token) => token.name === 'spacing16' && token.points === 16));

const dotted = await call('list_tokens', { query: '.neutral700' });
assert.ok(dotted.count > 0, 'a leading dot in the query must be ignored');

const tokenMiss = await call('get_token', { name: 'neutral701' });
assert.equal(tokenMiss.found, false);
assert.ok(tokenMiss.suggestions.includes('neutral700'));
step('list_tokens / get_token');

// 아이콘
const trash = await call('search_icon', { query: 'trash' });
const trashIcon = trash.icons.find((icon) => icon.name === 'icCommonTrash');
assert.equal(trashIcon?.usage[0], 'Image(sdg: .icCommonTrash)');
// templateIcon은 Color·SDG.Color 오버로드가 모두 있어 `.neutral700`은 모호하다. 타입을 명시해야 컴파일된다.
assert.ok(trashIcon.usage.some((line) => line.includes('templateIcon(size: 20, color: Color.neutral700)')));
const templateIcon = await call('get_component_api', { name: 'Image.templateIcon' });
assert.ok(templateIcon.notes?.some((note) => note.includes('Color.neutral700')));
const plus = await call('search_icon', { query: '추가' });
assert.ok(plus.icons.some((icon) => icon.name === 'icAddPlus'));
step('search_icon');

// 컴포넌트 검색
const buttons = await call('search_component', { query: 'button' });
assert.ok(buttons.results.some((result) => result.name === 'SDGBoxButton'));
const bottom = await call('search_component', { query: '하단 버튼' });
assert.equal(bottom.results[0]?.name, 'SDGBottomButton');
const confirm = await call('search_component', { query: 'confirm popup' });
assert.ok(confirm.results.some((result) => result.name === 'View.centerConfirmPopup'));
// 오버로드가 여럿인 모디파이어는 한 항목으로 묶인다.
const typo = await call('search_component', { query: 'typo' });
const typoEntries = typo.results.filter((result) => result.name === 'View.typo');
assert.equal(typoEntries.length, 1);
assert.equal(typoEntries[0].signatures.length, 2);
// 묶인 모디파이어는 오버로드 중 하나라도 해당 레이어면 레이어 필터에 걸린다(cornerRadius: Foundation·Util).
const utilRadius = await call('search_component', { query: 'cornerRadius', layer: 'Util' });
assert.ok(utilRadius.results.some((result) => result.name === 'View.cornerRadius'));
// UIViewRepresentable로 만든 컴포넌트도 뷰로 분류한다.
const focusable = await call('search_component', { query: 'focusable' });
assert.equal(focusable.results.find((result) => result.name === 'SDGFocusableTextField')?.kind, 'view');
// Object.prototype 속성과 같은 질의어도 오류 없이 처리한다.
await call('search_component', { query: 'constructor' });
await call('search_icon', { query: 'constructor' });
await call('get_design_guide', { query: 'constructor' });
step('search_component');

// 컴포넌트 API
const box = await call('get_component_api', { name: 'SDGBoxButton' });
assert.equal(box.kind, 'view');
assert.match(box.initializers[0].signature, /^init\(option: Option, isSelected: Binding<Bool>/);
assert.ok(box.nestedTypes.some((type) => type.name === 'SDGBoxButton.Option'));
assert.ok(box.relatedTypes.some((type) => type.name === 'SDGButtonSize' && type.cases.some((entry) => entry.case === '.medium')));
assert.ok(box.version);

const confirmApi = await call('get_component_api', { name: 'centerConfirmPopup' });
assert.equal(confirmApi.kind, 'modifier');
assert.ok(confirmApi.relatedTypes.some((type) => type.name === 'SDGCenterPopupButton.Button.Option'));

const confirmView = await call('get_component_api', { name: 'SDGConfirmPopup' });
assert.ok(confirmView.notes?.some((note) => note.includes('centerConfirmPopup')));

const apiMiss = await call('get_component_api', { name: 'SDGBoxButon' });
assert.equal(apiMiss.found, false);
assert.ok(apiMiss.suggestions.includes('SDGBoxButton'));

const size = await call('get_type', { name: 'SDGButtonSize' });
assert.ok(size.cases.some((entry) => entry.case === '.medium'));

// 익스텐션 멤버는 소유 타입 없이 이름만으로도 찾고, 오타 제안에도 포함한다.
const bareTemplateIcon = await call('get_component_api', { name: 'templateIcon' });
assert.equal(bareTemplateIcon.kind, 'extension');
const templateTypo = await call('get_component_api', { name: 'Image.templateIcn' });
assert.ok(templateTypo.suggestions.includes('Image.templateIcon'));
// 이름만으로 찾아 여러 타입의 멤버가 섞이면 오버로드마다 소유 타입을 표시한다.
const bareInit = await call('get_component_api', { name: 'init' });
assert.ok(bareInit.owners.length > 1 && bareInit.overloads.every((overload) => typeof overload.owner === 'string'));

// public init이 없는 타입과, 그런 타입을 필수로 받아 모듈 밖에서 호출할 수 없는 init을 알린다.
const loginInput = await call('get_component_api', { name: 'SDGLoginInput' });
assert.ok(loginInput.notes?.some((note) => note.includes('SDGLoginInput.Icon')));
const loginIcon = await call('get_type', { name: 'SDGLoginInput.Icon' });
assert.ok(loginIcon.notes?.some((note) => note.includes('no public initializer')));
const sdgString = await call('get_type', { name: 'SDGString' });
assert.ok(sdgString.notes?.some((note) => note.includes('SDGString.shared')));
step('get_component_api / get_type');

// 사용 예제
const examples = await call('get_usage_example', { name: 'SDGBoxButton' });
assert.ok(examples.examples.length > 0 && examples.examples.every((example) => example.code.startsWith('SDGBoxButton(')));
const popupExamples = await call('get_usage_example', { name: 'SDGConfirmPopup' });
assert.ok(popupExamples.examples.some((example) => example.code.startsWith('.centerConfirmPopup(')));
// 모듈 밖에서 컴파일된 SampleApp 예제가 프리뷰 예제보다 먼저 온다.
for (const name of ['SDGBoxButton', 'SDGToggle', 'listPopup', 'SDGDropdown']) {
  const { examples: list } = await call('get_usage_example', { name, limit: 10 });
  const firstPreview = list.findIndex((example) => example.source === 'preview');
  assert.ok(firstPreview === -1 || list.slice(firstPreview).every((example) => example.source === 'preview'), `${name}: sample-app examples must come first`);
}
step('get_usage_example');

// 셋업·디자인 가이드
const setup = await call('get_setup_guide');
assert.equal(setup.package.import, 'import ShoplDesignGuide');
assert.ok(setup.package.platforms.includes('iOS 16.0+'));
assert.equal(setup.localization.required, true);
assert.match(setup.localization.snippet, /SDGString\.shared\.setProvider\(provider:/);
// NSLocalizedString을 쓰므로 단독 파일로 붙여 넣어도 컴파일되게 Foundation을 import해야 한다.
assert.match(setup.localization.snippet, /^import Foundation$/m);

const guide = await call('get_design_guide', { query: '하단' });
assert.ok(guide.items.some((item) => item.path.endsWith('Bottom Button') && item.implemented));
const catalog = await call('get_design_guide');
assert.ok(catalog.counts.items > 0 && catalog.sections.length === 3);
step('get_setup_guide / get_design_guide');

// 리소스
const tokenResource = await client.readResource({ uri: 'sdg://tokens' });
assert.ok(JSON.parse(tokenResource.contents[0].text).count > 0);
const componentResource = await client.readResource({ uri: 'sdg://components' });
assert.ok(JSON.parse(componentResource.contents[0].text).views.length > 0);
step('resources');

await client.close();

// 마켓플레이스 카탈로그가 가리키는 폴더에 그 호스트의 매니페스트가 같은 이름으로 있어야 설치된다.
// Codex는 Claude Code용 카탈로그를 읽고, 가리킨 폴더에서 .codex-plugin을 먼저 찾는다.
const repoRoot = fileURLToPath(new URL('../..', import.meta.url));
const readJson = (...path) => JSON.parse(readFileSync(join(...path), 'utf8'));
for (const [catalog, hosts] of [['.claude-plugin', ['claude', 'codex']], ['.cursor-plugin', ['cursor']]]) {
  const marketplace = readJson(repoRoot, catalog, 'marketplace.json');
  assert.equal(marketplace.name, 'sdg-marketplace', `${catalog}: marketplace name`);
  for (const entry of marketplace.plugins) {
    for (const host of hosts) {
      assert.equal(readJson(repoRoot, entry.source, `.${host}-plugin`, 'plugin.json').name, entry.name, `${catalog} → ${host}: plugin name`);
    }
  }
}

// 호스트별 매니페스트의 MCP 선언대로 서버를 띄워 본다. 플러그인 경로를 넘기는 방식이 호스트마다 달라 선언을 따로 둔다.
// Claude Code·Cursor는 경로 변수를 치환하고, Codex는 변수를 치환하지 않는 대신 상대 cwd를 플러그인 루트 기준으로 푼다.
const pluginRoot = fileURLToPath(new URL('../../plugins/sdg-ios', import.meta.url));
const codexServers = readJson(pluginRoot, '.codex-plugin', 'plugin.json').mcpServers;
const declarations = [
  { host: 'claude', server: readJson(pluginRoot, '.claude-plugin', 'plugin.json').mcpServers['sdg-ios'], rootVariable: '${CLAUDE_PLUGIN_ROOT}' },
  { host: 'cursor', server: readJson(pluginRoot, '.cursor-plugin', 'plugin.json').mcpServers['sdg-ios'], rootVariable: '${CURSOR_PLUGIN_ROOT}' },
  {
    host: 'codex',
    // mcpServers는 MCP 설정 파일 경로이거나 인라인 객체다.
    server: (typeof codexServers === 'string' ? readJson(pluginRoot, codexServers).mcpServers : codexServers)['sdg-ios'],
    relativeCwdBase: pluginRoot,
  },
];
// cwd를 선언하지 않으면 클라이언트는 사용자의 프로젝트 폴더에서 서버를 띄운다. 플러그인과 무관한 폴더로 흉내 낸다.
const projectDirectory = tmpdir();
for (const { host, server, rootVariable, relativeCwdBase = projectDirectory } of declarations) {
  assert.equal(server.command, 'node', `${host}: the server must be launched with node`);
  const expand = (value) => (rootVariable ? value.replaceAll(rootVariable, () => pluginRoot) : value);
  const hostTransport = new StdioClientTransport({
    // CI의 Node 18 단계에서도 그 런타임으로 확인하도록 PATH의 node 대신 지금 실행 중인 node를 쓴다.
    command: process.execPath,
    args: server.args.map(expand),
    cwd: server.cwd ? resolve(relativeCwdBase, expand(server.cwd)) : projectDirectory,
    // 경로가 틀려 서버가 바로 종료되면 원인이 CI 로그에 남도록 서버의 stderr를 그대로 보여 준다.
    stderr: 'inherit',
  });
  const hostClient = new Client({ name: `sdg-ios-smoke-${host}`, version: '0.0.0' });
  await hostClient.connect(hostTransport);
  assert.equal((await hostClient.listTools()).tools.length, tools.length, `${host}: tools must load`);
  await hostClient.close();
}
// Claude Code는 플러그인 루트에 .mcp.json이 있으면 plugin.json의 선언 대신 그 파일을 쓴다.
assert.ok(!existsSync(join(pluginRoot, '.mcp.json')), 'a plugin-root .mcp.json would replace the Claude Code declaration');
step('plugin manifests: claude / cursor / codex');

console.log('✓ smoke test passed');
