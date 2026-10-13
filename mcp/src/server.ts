import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { z } from 'zod';
import curated from './setup.curated.json' with { type: 'json' };
import type {
  CatalogItem,
  EnumCase,
  ExampleRecord,
  IconRecord,
  Member,
  SDGData,
  TokenRecord,
  TokenType,
  TypeCard,
} from './data.js';
import { parseQuery, scoreTerms, suggest, words } from './search.js';

const LAYERS = ['Component', 'Template', 'Foundation', 'Util'] as const;
const TOKEN_TYPES = ['color', 'typography', 'spacing', 'cornerRadius'] as const;
const READ_ONLY = { readOnlyHint: true, openWorldHint: false } as const;
const TYPE_NAME = /\b[A-Z][A-Za-z0-9_]*(?:\.`?[A-Z][A-Za-z0-9_]*`?)*/g;

interface DesignGuideEntry {
  title: string;
  path: string[];
  description?: string;
  subDescription?: string;
  implemented: boolean;
}

/** 조회용 색인. 이름 키는 대소문자·백틱을 무시한다. */
class SDGIndex {
  readonly cards = new Map<string, TypeCard>();
  readonly modifiers = new Map<string, Member[]>();
  readonly extensions = new Map<string, Member[]>();
  readonly designGuide = new Map<string, DesignGuideEntry>();
  readonly tokens = new Map<string, TokenRecord>();

  constructor(readonly data: SDGData) {
    for (const card of [...data.api.views, ...data.api.types]) this.cards.set(key(card.name), card);
    for (const modifier of data.api.modifiers) push(this.modifiers, key(modifier.name), modifier);
    for (const member of data.api.extensions) push(this.extensions, key(`${member.owner}.${member.name}`), member);
    for (const token of data.tokens.tokens) this.tokens.set(key(token.name), token);

    const visit = (item: CatalogItem, path: string[]) => {
      const nextPath = [...path, item.title];
      if (item.children?.length) {
        item.children.forEach((child) => visit(child, nextPath));
        return;
      }
      for (const symbol of item.implementedSymbols) {
        this.designGuide.set(key(symbol), {
          title: item.title,
          path: nextPath,
          description: item.description,
          subDescription: item.subDescription,
          implemented: item.implemented,
        });
      }
    };
    for (const section of data.catalog.sections) section.items.forEach((item) => visit(item, [section.title]));
  }

  card(name: string): TypeCard | undefined {
    return this.cards.get(key(name));
  }

  /** `View.typo`, `.typo`, `typo` 모두 같은 모디파이어로 본다. */
  modifierOverloads(name: string): Member[] | undefined {
    return this.modifiers.get(key(name.replace(/^(SwiftUI\.)?View\./i, '').replace(/^\./, '')));
  }

  extensionMembers(name: string): Member[] | undefined {
    return this.extensions.get(key(name));
  }

  hasModifier(name: string): boolean {
    return this.modifiers.has(key(name));
  }

  /** 시그니처에 등장한 타입 이름을 안쪽 스코프부터 바깥으로 찾아 카드로 바꾼다. */
  resolveType(name: string, owner: string): TypeCard | undefined {
    const scopes = owner ? owner.split('.') : [];
    for (let depth = scopes.length; depth >= 0; depth -= 1) {
      const card = this.card([...scopes.slice(0, depth), name].join('.'));
      if (card) return card;
    }
    return undefined;
  }

  /** 카드와 그 하위 중첩 타입 전부 (SDGCenterPopupButton → .Button → .Button.Option) */
  descendants(card: TypeCard): TypeCard[] {
    const result: TypeCard[] = [];
    const queue = [...card.nestedTypes];
    while (queue.length) {
      const nested = this.card(queue.shift()!);
      if (!nested) continue;
      result.push(nested);
      queue.push(...nested.nestedTypes);
    }
    return result;
  }

  /** 같은 파일에 선언된 모디파이어. 팝업처럼 View를 직접 만들지 않고 모디파이어로 띄우는 경우를 연결한다. */
  presentingModifiers(card: TypeCard): Member[] {
    return this.data.api.modifiers.filter((modifier) => modifier.file === card.location.file);
  }

  relatedTypes(signatures: string[], owner: string, exclude: Set<string>): TypeCard[] {
    const found = new Map<string, TypeCard>();
    for (const signature of signatures) {
      for (const match of signature.matchAll(TYPE_NAME)) {
        const card = this.resolveType(match[0].replace(/`/g, ''), owner);
        if (card && !exclude.has(key(card.name))) found.set(card.name, card);
      }
    }
    return [...found.values()].slice(0, 15);
  }
}

export function createServer(data: SDGData, version: string): McpServer {
  const index = new SDGIndex(data);
  const product = data.setup.products[0] ?? 'ShoplDesignGuide';
  const server = new McpServer({ name: 'sdg-ios', version }, { instructions: curated.instructions });

  // MARK: Resources

  server.registerResource(
    'tokens',
    'sdg://tokens',
    {
      title: 'SDG iOS design tokens',
      description: 'All SDG iOS design tokens: colors (hex/opacity), typography, spacing, corner radius.',
      mimeType: 'application/json',
    },
    (uri) => ({ contents: [{ uri: uri.href, mimeType: 'application/json', text: JSON.stringify(data.tokens, null, 2) }] }),
  );

  server.registerResource(
    'components',
    'sdg://components',
    {
      title: 'SDG iOS component index',
      description: 'Compact index of every public SDG view and view modifier with layer, group, design version.',
      mimeType: 'application/json',
    },
    (uri) => ({
      contents: [
        {
          uri: uri.href,
          mimeType: 'application/json',
          text: JSON.stringify(
            {
              views: data.api.views.map((view) => viewSummary(index, view)),
              modifiers: data.api.modifiers.map((modifier) => modifierSummary(index, modifier)),
            },
            null,
            2,
          ),
        },
      ],
    }),
  );

  // MARK: Tokens

  server.registerTool(
    'list_tokens',
    {
      title: 'List SDG design tokens',
      description:
        'List SDG iOS design tokens (colors with hex/opacity, typography size/weight/lineHeight, spacing and corner-radius points) and how to apply them in SwiftUI. Call this before writing any color, font, padding or corner radius so the code uses `.neutral700`, `.typo(.body1_R, .neutral700)`, `.padding(.spacing16)`, `.cornerRadius(.radius8)` instead of raw values.',
      inputSchema: {
        type: z.enum(TOKEN_TYPES).optional().describe('Token type to list. Omit to list every type.'),
        group: z.string().optional().describe('Group filter, e.g. `Neutral`, `Brand`, `Point`, `body`, `Common`.'),
        query: z.string().optional().describe('Case-insensitive substring matched against name, group or value (e.g. `primary`, `#333333`, `16`).'),
      },
      annotations: READ_ONLY,
    },
    async ({ type, group, query }) => {
      const needle = query?.toLowerCase();
      const tokens = data.tokens.tokens.filter((token) => {
        if (type && token.type !== type) return false;
        if (group && token.group?.toLowerCase() !== group.toLowerCase()) return false;
        if (needle) {
          const haystack = [token.name, token.group, token.hex, token.size, token.points].filter((value) => value !== undefined).join(' ').toLowerCase();
          if (!haystack.includes(needle)) return false;
        }
        return true;
      });
      const types = [...new Set(tokens.map((token) => token.type))];
      return asText({
        count: tokens.length,
        usage: Object.fromEntries(types.map((tokenType) => [tokenType, tokenUsage(index, tokenType)])),
        tokens: tokens.map(tokenSummary),
      });
    },
  );

  server.registerTool(
    'get_token',
    {
      title: 'Get one SDG design token',
      description:
        'Get one SDG token by exact name, e.g. `neutral700`, `primary300_10`, `body1_R`, `spacing16`, `radius8` (a leading dot is fine). Returns usage snippets, or suggestions when the name does not exist.',
      inputSchema: {
        name: z.string().describe('Exact token name, e.g. `neutral700` or `.body1_R`.'),
      },
      annotations: READ_ONLY,
    },
    async ({ name }) => {
      const token = index.tokens.get(key(name.replace(/^\./, '')));
      if (!token) {
        return asText({ found: false, name, suggestions: suggest(name, data.tokens.tokens.map((t) => t.name)) });
      }
      return asText({ found: true, token: { ...tokenSummary(token), source: token.source, doc: token.doc }, usage: tokenUsage(index, token.type, token) });
    },
  );

  // MARK: Icons

  server.registerTool(
    'search_icon',
    {
      title: 'Search SDG icons and images',
      description:
        'Find SDG image assets (icons and illustrations) by name or meaning, in English or Korean, e.g. `trash`, `arrow left`, `calendar`, `휴지통`. Every word must match. Returns the Swift accessor `Image(sdg: .icXxx)` and whether the asset is a template (tintable) image. Never invent icon names.',
      inputSchema: {
        query: z.string().describe('Name or keywords, e.g. `add`, `arrow left`, `empty search`.'),
        kind: z.enum(['icon', 'image']).optional().describe('`icon` for ic_* glyphs, `image` for illustrations/badges.'),
        limit: z.number().int().min(1).max(50).optional().describe('Max results (default 15).'),
      },
      annotations: READ_ONLY,
    },
    async ({ query, kind, limit }) => {
      const terms = parseQuery(query);
      const results = data.icons.icons
        .filter((icon) => !kind || icon.kind === kind)
        .map((icon) => ({ icon, score: scoreTerms(terms, (term) => scoreIcon(icon, term)) }))
        .filter((entry) => entry.score > 0)
        .sort((a, b) => b.score - a.score || a.icon.name.localeCompare(b.icon.name))
        .slice(0, limit ?? 15)
        .map(({ icon }) => iconSummary(index, icon));
      return asText({ query, count: results.length, icons: results });
    },
  );

  // MARK: Components

  server.registerTool(
    'search_component',
    {
      title: 'Search SDG components',
      description:
        'Discover SDG iOS SwiftUI components (views), view modifiers (popups, tooltip, typo, padding) and supporting types by keyword, in English or Korean, e.g. `button`, `popup`, `체크박스`, `하단 버튼`. Matches names, folders, design-guide descriptions and parameter labels; every word must match. Returns summaries; call `get_component_api` for the exact API.',
      inputSchema: {
        query: z.string().describe('Keywords, e.g. `button`, `input`, `popup confirm`, `탭`.'),
        layer: z.enum(LAYERS).optional().describe('Restrict to one library layer.'),
        limit: z.number().int().min(1).max(50).optional().describe('Max results (default 15).'),
      },
      annotations: READ_ONLY,
    },
    async ({ query, layer, limit }) => {
      const terms = parseQuery(query);
      const candidates = [
        ...data.api.views.map((view) => ({ kind: 'view' as const, view })),
        ...data.api.modifiers.map((modifier) => ({ kind: 'modifier' as const, modifier })),
        ...data.api.types.filter((type) => !type.name.includes('.')).map((type) => ({ kind: 'type' as const, view: type })),
      ];
      const results = candidates
        .map((candidate) => {
          if (candidate.kind === 'modifier') {
            const location = locationOf(candidate.modifier.file);
            if (layer && location.layer !== layer) return undefined;
            const score = scoreTerms(terms, (term) => scoreModifier(index, candidate.modifier, term));
            const name = `View.${candidate.modifier.name}`;
            return score > 0 ? { score, name, summary: modifierSummary(index, candidate.modifier) } : undefined;
          }
          if (layer && candidate.view.location.layer !== layer) return undefined;
          // 컴포넌트를 찾는 도구이므로 보조 타입(enum·struct)은 같은 점수에서 뒤로 보낸다.
          const weight = candidate.kind === 'type' ? 0.5 : 1;
          const score = weight * scoreTerms(terms, (term) => scoreCard(index, candidate.view, term));
          const summary = candidate.kind === 'type' ? typeSummary(candidate.view) : viewSummary(index, candidate.view);
          return score > 0 ? { score, name: candidate.view.name, summary } : undefined;
        })
        .filter((entry): entry is NonNullable<typeof entry> => entry !== undefined)
        .sort((a, b) => b.score - a.score || a.name.localeCompare(b.name))
        .slice(0, limit ?? 15)
        .map((entry) => entry.summary);
      return asText({ query, count: results.length, results });
    },
  );

  server.registerTool(
    'get_component_api',
    {
      title: 'Get an SDG component API',
      description:
        'Exact public API of one SDG component or view modifier: initializer signatures with labels and defaults, nested Option/Model types, enum cases (sizes, styles, states), related types, deprecations, the modifier that presents it, and its design-guide entry. Always call this before writing code that constructs an SDG view; SDG components are configured through `Option`/`Model` structs and `Binding`s, not ad-hoc parameters.',
      inputSchema: {
        name: z.string().describe('Component, modifier or type name, e.g. `SDGBoxButton`, `centerConfirmPopup`, `View.typo`, `SDGBoxButton.Option`.'),
      },
      annotations: READ_ONLY,
    },
    async ({ name }) => asText(describeSymbol(index, name)),
  );

  server.registerTool(
    'get_type',
    {
      title: 'Get an SDG type',
      description:
        'Look up any SDG public type by name, including nested ones such as `SDGBoxButton.Option`, `SDGButtonSize`, `SDGCenterPopupButton.Button.Option`: kind, enum cases, initializers, properties and related types.',
      inputSchema: {
        name: z.string().describe('Type name, optionally qualified, e.g. `SDGButtonSize` or `SDGToggle.Size`.'),
      },
      annotations: READ_ONLY,
    },
    async ({ name }) => {
      const card = index.card(name.replace(/`/g, ''));
      if (!card) return asText(notFound(index, name));
      return asText(describeType(index, card));
    },
  );

  server.registerTool(
    'get_usage_example',
    {
      title: 'Get SDG usage examples',
      description:
        'Real call sites of an SDG component or view modifier, taken from the library #Preview blocks and the SDG SampleApp. The code compiles against the public API, so copy its argument labels and nesting.',
      inputSchema: {
        name: z.string().describe('Component or modifier name, e.g. `SDGBoxButton`, `centerConfirmPopup`.'),
        limit: z.number().int().min(1).max(10).optional().describe('Max examples (default 5).'),
      },
      annotations: READ_ONLY,
    },
    async ({ name, limit }) => {
      const max = limit ?? 5;
      const card = index.card(name);
      if (card) {
        const own = data.examples.examples[card.name] ?? [];
        const viaModifiers = index
          .presentingModifiers(card)
          .flatMap((modifier) => (data.examples.examples[`View.${modifier.name}`] ?? []).map((example) => ({ ...example, via: `View.${modifier.name}` })));
        const examples = [...own, ...viaModifiers].slice(0, max);
        return asText({
          found: examples.length > 0,
          name: card.name,
          examples: examples.map(exampleView),
          ...(examples.length === 0 ? { note: 'No call sites found in #Preview or SampleApp. Build the call from get_component_api signatures.' } : {}),
        });
      }
      const overloads = index.modifierOverloads(name);
      if (overloads?.length) {
        const modifierKey = `View.${overloads[0]!.name}`;
        const examples = (data.examples.examples[modifierKey] ?? []).slice(0, max);
        return asText({
          found: examples.length > 0,
          name: modifierKey,
          examples: examples.map(exampleView),
          ...(examples.length === 0 ? { note: 'No call sites found. Build the call from get_component_api signatures.' } : {}),
        });
      }
      return asText(notFound(index, name));
    },
  );

  // MARK: Setup & design guide

  server.registerTool(
    'get_setup_guide',
    {
      title: 'Get SDG setup guide',
      description:
        'How to add ShoplDesignGuide to an iOS app (Swift Package Manager URL, platforms, dependencies) and the mandatory app-launch setup such as the localization provider. Call before scaffolding a new app or screen, or when an SDG component crashes with fatalError at runtime.',
      inputSchema: {},
      annotations: READ_ONLY,
    },
    async () => asText(setupGuide(index, product)),
  );

  server.registerTool(
    'get_design_guide',
    {
      title: 'Get SDG design guide',
      description:
        'SDG design-guide catalog (Foundation / Component / Template): what each component is for (Korean usage descriptions from the design guide) and whether it is implemented in SDG iOS, with the Swift symbols that implement it. Use it to pick the right component for a UI need or to check whether a design-guide component exists in iOS yet.',
      inputSchema: {
        query: z.string().optional().describe('Keywords in English or Korean, e.g. `button`, `하단`, `calendar`. Omit for the whole catalog.'),
      },
      annotations: READ_ONLY,
    },
    async ({ query }) => asText(designGuide(index, query)),
  );

  return server;
}

// MARK: - Rendering

function asText(payload: unknown) {
  return { content: [{ type: 'text' as const, text: JSON.stringify(payload, null, 2) }] };
}

/** undefined와 빈 배열을 빼서 응답을 짧게 만든다. */
function compact<T extends Record<string, unknown>>(value: T): Partial<T> {
  return Object.fromEntries(
    Object.entries(value).filter(([, entry]) => entry !== undefined && !(Array.isArray(entry) && entry.length === 0)),
  ) as Partial<T>;
}

function key(name: string): string {
  return name.replace(/`/g, '').toLowerCase();
}

function push<K, V>(map: Map<K, V[]>, mapKey: K, value: V) {
  const list = map.get(mapKey);
  if (list) list.push(value);
  else map.set(mapKey, [value]);
}

function locationOf(file: string) {
  const parts = file.split('/');
  const layer = parts[2] ?? '';
  return { file, layer, group: parts.length > 4 ? parts[3]! : layer };
}

function memberView(member: Member) {
  return compact({ signature: member.signature, doc: member.doc, deprecated: member.deprecated });
}

function caseView(enumCase: EnumCase) {
  return compact({ case: `.${enumCase.name.replace(/`/g, '')}${enumCase.associatedValues ?? ''}`, rawValue: enumCase.rawValue, doc: enumCase.doc });
}

function typeSummary(card: TypeCard) {
  return compact({
    name: card.name,
    kind: 'type',
    declaration: card.declaration,
    layer: card.location.layer,
    group: card.location.group,
    deprecated: card.deprecated,
  });
}

function guideLine(guide: DesignGuideEntry | undefined): string | undefined {
  if (!guide) return undefined;
  const description = guide.subDescription ?? guide.description;
  return description ? `${guide.path.join(' > ')} — ${description}` : guide.path.join(' > ');
}

function viewSummary(index: SDGIndex, card: TypeCard) {
  const presentedBy = index.presentingModifiers(card).map((modifier) => `View.${modifier.name}`);
  return compact({
    name: card.name,
    kind: 'view',
    layer: card.location.layer,
    group: card.location.group,
    version: card.version,
    designGuide: guideLine(index.designGuide.get(key(card.name))),
    initializers: card.initializers.length,
    presentedBy: card.initializers.length === 0 ? [...new Set(presentedBy)] : undefined,
    deprecated: card.deprecated,
  });
}

function modifierSummary(index: SDGIndex, modifier: Member) {
  const location = locationOf(modifier.file);
  return compact({
    name: `View.${modifier.name}`,
    kind: 'modifier',
    layer: location.layer,
    group: location.group,
    signature: modifier.signature,
    designGuide: guideLine(index.designGuide.get(key(`View.${modifier.name}`))),
    deprecated: modifier.deprecated,
  });
}

function tokenSummary(token: TokenRecord) {
  return compact({
    name: token.name,
    type: token.type,
    group: token.group,
    swift: token.swift,
    hex: token.hex,
    opacity: token.opacity,
    baseToken: token.baseToken,
    size: token.size,
    weight: token.weight,
    lineHeight: token.lineHeight,
    points: token.points,
  });
}

/** 토큰 적용 방법. 실제로 존재하는 모디파이어·이니셜라이저만 안내한다. */
function tokenUsage(index: SDGIndex, type: TokenType, token?: TokenRecord): string[] {
  const name = token?.name;
  switch (type) {
    case 'color': {
      const color = name ?? 'neutral700';
      const usage = [
        `.foregroundStyle(.${color})`,
        `.background(.${color})`,
        `Color.${color} / SDG.Color.${color} — SwiftUI Color and SDG.Color expose the same static names`,
      ];
      if (index.hasModifier('typo')) usage.push(`Text("…").typo(.body2_R, .${color})`);
      usage.push(
        'Names ending in `_10`, `_40`, `_80` are 10/40/80% opacity colors. `baseToken` names the opaque token of the same color when one exists (some, like `sdgBlack_40`, have none).',
      );
      return usage;
    }
    case 'typography': {
      if (!index.hasModifier('typo')) return [];
      const style = name ?? 'body1_R';
      return [
        `Text("…").typo(.${style}, .neutral700)`,
        `Text("…").typo(.${style})  // keeps the current foreground color`,
        'Apply text styles with .typo — it registers the Pretendard font and fixes the line height; do not replace it with .font(.system(...)).',
      ];
    }
    case 'spacing': {
      const spacing = name ?? 'spacing16';
      const usage: string[] = [];
      if (index.hasModifier('padding')) {
        usage.push(`.padding(.${spacing})`, `.padding(.horizontal, .${spacing})`, `.padding(top: .${spacing}, leading: .${spacing})`);
      }
      if (index.extensionMembers('VStack.init')) usage.push(`VStack(spacing: .${spacing}) { … }  // also HStack, LazyVStack, LazyHStack`);
      return usage;
    }
    case 'cornerRadius': {
      if (!index.hasModifier('cornerRadius')) return [];
      const radius = name ?? 'radius8';
      return [`.cornerRadius(.${radius})`, `.cornerRadius(.${radius}, corners: [.topLeft, .topRight])`];
    }
  }
}

function iconSummary(index: SDGIndex, icon: IconRecord) {
  const usage = [`Image(sdg: .${icon.name})`];
  if (icon.renderingMode === 'template' && index.extensionMembers('Image.templateIcon')) {
    usage.push(`Image(sdg: .${icon.name}).templateIcon(size: 20, color: .neutral700)`);
  } else {
    usage.push(`Image(sdg: .${icon.name}).resizable().frame(width: 20, height: 20)`);
  }
  return compact({ name: icon.name, assetName: icon.assetName, kind: icon.kind, renderingMode: icon.renderingMode, usage });
}

function exampleView(example: ExampleRecord & { via?: string }) {
  return compact({ source: example.source, file: example.file, via: example.via, code: example.code, truncated: example.truncated });
}

// MARK: - Scoring

function scoreIcon(icon: IconRecord, term: string): number {
  const name = icon.name.toLowerCase();
  if (name === term || icon.assetName === term) return 100;
  if (icon.keywords.includes(term)) return 80;
  if (name.includes(term) || icon.assetName.includes(term)) return 60;
  if (icon.keywords.some((keyword) => keyword.includes(term))) return 40;
  return 0;
}

function scoreCard(index: SDGIndex, card: TypeCard, term: string): number {
  const name = card.name.toLowerCase();
  const shortName = name.replace(/^sdg/, '');
  if (name === term || shortName === term) return 100;
  if (words(card.name).includes(term)) return 80;
  if (name.includes(term)) return 60;
  if (card.location.group.toLowerCase().includes(term)) return 40;
  const guide = index.designGuide.get(key(card.name));
  if (guide && [guide.title, guide.description, guide.subDescription, ...guide.path].join(' ').toLowerCase().includes(term)) return 35;
  if (card.initializers.some((initializer) => initializer.parameters?.some((parameter) => parameter.name.toLowerCase().includes(term)))) return 20;
  if (card.nestedTypes.some((nested) => nested.toLowerCase().includes(term))) return 15;
  if (card.cases.some((enumCase) => enumCase.name.toLowerCase().includes(term))) return 15;
  return 0;
}

function scoreModifier(index: SDGIndex, modifier: Member, term: string): number {
  const name = modifier.name.toLowerCase();
  if (name === term) return 100;
  if (words(modifier.name).includes(term)) return 80;
  if (name.includes(term)) return 60;
  if (locationOf(modifier.file).group.toLowerCase().includes(term)) return 40;
  const guide = index.designGuide.get(key(`View.${modifier.name}`));
  if (guide && guide.path.join(' ').toLowerCase().includes(term)) return 35;
  if (modifier.parameters?.some((parameter) => parameter.name.toLowerCase().includes(term))) return 20;
  return 0;
}

// MARK: - Symbol detail

function describeSymbol(index: SDGIndex, name: string) {
  const card = index.card(name.replace(/`/g, ''));
  if (card) return describeType(index, card);

  const overloads = index.modifierOverloads(name);
  if (overloads?.length) {
    const modifierName = `View.${overloads[0]!.name}`;
    const related = index.relatedTypes(overloads.map((overload) => overload.signature), '', new Set());
    const guide = index.designGuide.get(key(modifierName));
    return compact({
      found: true,
      kind: 'modifier',
      name: modifierName,
      import: `import ShoplDesignGuide`,
      usage: `Chain on any view: someView.${overloads[0]!.name}(…)`,
      overloads: overloads.map((overload) => compact({ ...memberView(overload), file: overload.file })),
      relatedTypes: related.map((type) => briefType(type)),
      designGuide: guide,
      examples: index.data.examples.examples[modifierName]?.length ?? 0,
    });
  }

  const members = index.extensionMembers(name);
  if (members?.length) {
    return { found: true, kind: 'extension', name: `${members[0]!.owner}.${members[0]!.name}`, overloads: members.map(memberView) };
  }

  return notFound(index, name);
}

function describeType(index: SDGIndex, card: TypeCard) {
  const nested = index.descendants(card);
  const exclude = new Set([card, ...nested].map((type) => key(type.name)));
  const signatures = [card, ...nested].flatMap((type) => [
    ...type.initializers.map((member) => member.signature),
    ...type.properties.map((member) => member.signature),
    ...type.cases.map((enumCase) => enumCase.associatedValues ?? ''),
    type.aliasOf ?? '',
  ]);
  const presentedBy = index.presentingModifiers(card);
  const guide = index.designGuide.get(key(card.name));

  return compact({
    found: true,
    kind: card.isView ? 'view' : card.kind,
    name: card.name,
    import: 'import ShoplDesignGuide',
    declaration: card.declaration,
    location: card.location,
    version: card.version,
    doc: card.doc,
    deprecated: card.deprecated,
    aliasOf: card.aliasOf,
    designGuide: guide,
    initializers: card.initializers.map(memberView),
    note:
      card.isView && card.initializers.length === 0 && presentedBy.length
        ? `${card.name} has no public initializer. Present it with ${presentedBy.map((modifier) => `.${modifier.name}(…)`).join(' or ')}.`
        : undefined,
    presentedBy: presentedBy.map(memberView),
    methods: card.methods.map(memberView),
    properties: card.properties.map(memberView),
    cases: card.cases.map(caseView),
    nestedTypes: nested.map((type) => briefType(type)),
    relatedTypes: index.relatedTypes(signatures, card.name, exclude).map((type) => briefType(type)),
    examples: card.isView ? (index.data.examples.examples[card.name]?.length ?? 0) : undefined,
  });
}

/** 관련 타입은 한 단계만 펼친다(케이스·이니셜라이저·프로퍼티 시그니처). */
function briefType(card: TypeCard) {
  return compact({
    name: card.name,
    declaration: card.declaration,
    deprecated: card.deprecated,
    aliasOf: card.aliasOf,
    cases: card.cases.map(caseView),
    initializers: card.initializers.map(memberView),
    properties: card.properties.map((member) => member.signature),
    methods: card.methods.map((member) => member.signature),
  });
}

function notFound(index: SDGIndex, name: string) {
  const candidates = [
    ...index.data.api.views.map((view) => view.name),
    ...index.data.api.types.map((type) => type.name),
    ...index.data.api.modifiers.map((modifier) => `View.${modifier.name}`),
  ];
  return { found: false, name, suggestions: suggest(name, [...new Set(candidates)]) };
}

// MARK: - Setup

function setupGuide(index: SDGIndex, product: string) {
  const { setup } = index.data;
  const stringType = index.card('SDGString');
  const providerType = index.card('SDGStringProvider');
  const setProvider = stringType?.methods.find((method) => method.name === 'setProvider');
  const getString = providerType?.methods.find((method) => method.name === 'getString');
  const keys = index.card('SDGLocalizationKey')?.cases.map((enumCase) => enumCase.name) ?? [];

  // 실제 공개 API가 있을 때만 예시 코드를 만든다. 이름이 바뀌면 예시도 사라져 잘못된 코드를 안내하지 않는다.
  const providerSnippet =
    setProvider && getString && stringType?.properties.some((property) => property.name === 'shared')
      ? [
          `import ${product}`,
          '',
          'final class AppStringProvider: SDGStringProvider {',
          `  ${getString.signature} {`,
          '    NSLocalizedString(key, comment: "")',
          '  }',
          '}',
          '',
          '// 앱 시작 시 한 번 (메인 액터: AppDelegate의 didFinishLaunching 또는 App의 init)',
          'SDGString.shared.setProvider(provider: AppStringProvider())',
        ].join('\n')
      : undefined;

  return compact({
    package: {
      url: curated.packageURL,
      product,
      import: `import ${product}`,
      packageSwift: [
        `.package(url: "${curated.packageURL}", from: "<GitHub Releases 최신 태그>")`,
        `.product(name: "${product}", package: "${curated.packageName}")`,
      ],
      platforms: setup.platforms.map((platform) => `${platform.name} ${platform.version}+`),
      swiftToolsVersion: setup.swiftToolsVersion,
      dependencies: setup.dependencies.map((dependency) => `${dependency.url}${dependency.requirement ? ` (${dependency.requirement})` : ''}`),
    },
    steps: curated.installSteps,
    localization: compact({
      required: setup.localizedSymbols.length > 0,
      affectedSymbols: setup.localizedSymbols,
      providerProtocol: providerType ? [providerType.declaration, ...providerType.methods.map((method) => `  ${method.signature}`)].join('\n') : undefined,
      setProvider: setProvider ? `SDGString.shared.${setProvider.signature.replace(/^func /, '')}` : undefined,
      keys,
      snippet: providerSnippet,
    }),
    notes: curated.notes,
  });
}

// MARK: - Design guide

function designGuide(index: SDGIndex, query: string | undefined) {
  const { catalog } = index.data;
  if (!query) {
    const tree = (item: CatalogItem): unknown =>
      compact({
        title: item.title,
        description: item.subDescription ?? item.description,
        implemented: item.implemented,
        symbols: item.children?.length ? undefined : item.implementedSymbols,
        children: item.children?.map(tree),
      });
    return { counts: catalog.counts, sections: catalog.sections.map((section) => ({ title: section.title, description: section.description, items: section.items.map(tree) })) };
  }

  const terms = parseQuery(query);
  const matches: Array<{ score: number; entry: Record<string, unknown> }> = [];
  const visit = (item: CatalogItem, path: string[]) => {
    const text = [item.title, item.description, item.subDescription, ...path, ...item.implementationNames].join(' ').toLowerCase();
    const score = scoreTerms(terms, (term) => (item.title.toLowerCase() === term ? 100 : text.includes(term) ? 50 : 0));
    if (score > 0) {
      matches.push({
        score,
        entry: compact({
          path: [...path, item.title].join(' > '),
          description: item.description,
          subDescription: item.subDescription,
          implemented: item.implemented,
          symbols: item.implemented ? item.implementedSymbols : undefined,
          // 미구현 항목은 카탈로그가 예정한 구현 이름을 보여준다(iOS에 아직 없음).
          plannedSymbols: item.implemented ? undefined : item.implementationNames,
        }),
      });
    }
    item.children?.forEach((child) => visit(child, [...path, item.title]));
  };
  catalog.sections.forEach((section) => section.items.forEach((item) => visit(item, [section.title])));
  matches.sort((a, b) => b.score - a.score);
  return { query, count: matches.length, items: matches.map((match) => match.entry) };
}
