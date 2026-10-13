import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

// Tools/SDGMetadataExtractor가 생성하는 JSON의 형태. 필드를 바꾸면 추출기의 Encodable 모델도 함께 바꾼다.

export interface SourceLocation {
  file: string;
  layer: string;
  group: string;
}

export interface Parameter {
  label?: string;
  name: string;
  type: string;
  defaultValue?: string;
}

export interface Member {
  name: string;
  kind: 'initializer' | 'method' | 'property';
  signature: string;
  file: string;
  parameters?: Parameter[];
  returnType?: string;
  isStatic?: boolean;
  doc?: string;
  deprecated?: string;
  owner?: string;
  whereClause?: string;
}

export interface EnumCase {
  name: string;
  associatedValues?: string;
  rawValue?: string;
  doc?: string;
}

export interface TypeCard {
  name: string;
  kind: string;
  declaration: string;
  isView: boolean;
  location: SourceLocation;
  doc?: string;
  deprecated?: string;
  version?: string;
  aliasOf?: string;
  inherits: string[];
  initializers: Member[];
  methods: Member[];
  properties: Member[];
  cases: EnumCase[];
  nestedTypes: string[];
}

export interface ApiFile {
  sources: string[];
  excluded: string[];
  counts: Record<string, number>;
  views: TypeCard[];
  types: TypeCard[];
  modifiers: Member[];
  extensions: Member[];
}

export type TokenType = 'color' | 'typography' | 'spacing' | 'cornerRadius';

export interface TokenRecord {
  name: string;
  type: TokenType;
  group?: string;
  swift: string;
  swiftType: string;
  source: string;
  doc?: string;
  hex?: string;
  opacity?: number;
  baseToken?: string;
  assetName?: string;
  colorSpace?: string;
  size?: number;
  weight?: number;
  lineHeight?: number;
  points?: number;
}

export interface TokenFile {
  sources: string[];
  count: number;
  countsByType: Record<string, number>;
  tokens: TokenRecord[];
}

export interface IconRecord {
  name: string;
  assetName: string;
  kind: 'icon' | 'image';
  renderingMode?: string;
  formats: string[];
  keywords: string[];
  source: string;
}

export interface IconFile {
  sources: string[];
  count: number;
  countsByKind: Record<string, number>;
  icons: IconRecord[];
}

export interface ExampleRecord {
  source: 'preview' | 'sample-app';
  file: string;
  code: string;
  truncated?: boolean;
}

export interface ExampleFile {
  sources: string[];
  count: number;
  examples: Record<string, ExampleRecord[]>;
}

export interface CatalogItem {
  id: string;
  title: string;
  description?: string;
  subDescription?: string;
  implementationNames: string[];
  implementedSymbols: string[];
  implemented: boolean;
  children?: CatalogItem[];
}

export interface CatalogSection {
  id: string;
  title: string;
  description: string;
  items: CatalogItem[];
}

export interface CatalogFile {
  sources: string[];
  counts: Record<string, number>;
  sections: CatalogSection[];
}

export interface SetupFile {
  sources: string[];
  swiftToolsVersion?: string;
  products: string[];
  platforms: Array<{ name: string; version: string }>;
  dependencies: Array<{ url: string; requirement?: string }>;
  localizedSymbols: string[];
}

export interface SDGData {
  tokens: TokenFile;
  icons: IconFile;
  api: ApiFile;
  examples: ExampleFile;
  catalog: CatalogFile;
  setup: SetupFile;
}

/** 번들(`plugins/sdg-ios/server/index.mjs`) 옆의 `data/` 폴더. 플러그인 캐시로 복사될 때 함께 따라간다. */
export function defaultDataDirectory(): string {
  return fileURLToPath(new URL('./data/', import.meta.url));
}

export function loadData(directory: string = defaultDataDirectory()): SDGData {
  const read = <T>(file: string): T => JSON.parse(readFileSync(join(directory, file), 'utf8')) as T;
  return {
    tokens: read<TokenFile>('tokens.generated.json'),
    icons: read<IconFile>('icons.generated.json'),
    api: read<ApiFile>('api.generated.json'),
    examples: read<ExampleFile>('examples.generated.json'),
    catalog: read<CatalogFile>('catalog.generated.json'),
    setup: read<SetupFile>('setup.generated.json'),
  };
}
