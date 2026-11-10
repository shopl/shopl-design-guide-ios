import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { loadData } from './data.js';
import { createServer } from './server.js';

// 번들 시 esbuild가 package.json 버전으로 치환한다.
declare const __SDG_MCP_VERSION__: string;
const version = typeof __SDG_MCP_VERSION__ === 'string' ? __SDG_MCP_VERSION__ : '0.0.0-dev';

async function main() {
  const server = createServer(loadData(), version);
  await server.connect(new StdioServerTransport());
  // stdout은 JSON-RPC 전용이므로 로그는 반드시 stderr로 보낸다.
  console.error(`[sdg-ios-mcp] ready (stdio, v${version})`);
}

main().catch((error: unknown) => {
  console.error('[sdg-ios-mcp] fatal:', error);
  process.exit(1);
});
