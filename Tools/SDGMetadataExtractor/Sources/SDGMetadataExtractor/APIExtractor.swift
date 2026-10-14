import Foundation
import SwiftSyntax

// MARK: - Output

/// 공개 타입 한 개. View를 따르는 타입은 `views`, 나머지는 `types`에 들어간다.
/// 중첩 타입(`SDGBoxButton.Option`)도 별도 카드로 펼치고 `nestedTypes`에 이름만 남긴다.
struct TypeCard: Encodable {
  let name: String
  let kind: String
  let declaration: String
  let isView: Bool
  let location: SourceLocation
  var doc: String?
  var deprecated: String?
  /// 컴포넌트 디자인 스펙 버전 (`public static let version = "2.3.34"`)
  var version: String?
  var aliasOf: String?
  var inherits: [String] = []
  var initializers: [MemberCard] = []
  var methods: [MemberCard] = []
  var properties: [MemberCard] = []
  var cases: [CaseCard] = []
  var nestedTypes: [String] = []
}

/// 이니셜라이저·메서드·프로퍼티·View 모디파이어.
struct MemberCard: Encodable {
  let name: String
  /// initializer, method, property
  let kind: String
  /// 주석·본문을 제외한 한 줄 선언. 예: `init(option: Option, isSelected: Binding<Bool>, ...)`
  let signature: String
  let location: SourceLocation
  var parameters: [ParameterCard]?
  var returnType: String?
  var isStatic: Bool?
  var doc: String?
  var deprecated: String?
  /// 익스텐션으로 추가된 멤버가 붙는 타입. 예: `View`, `Image`
  var owner: String?
  var whereClause: String?

  private enum CodingKeys: String, CodingKey {
    case name, kind, signature, parameters, returnType, isStatic, doc, deprecated, owner, whereClause
    case file
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(kind, forKey: .kind)
    try container.encode(signature, forKey: .signature)
    try container.encode(location.file, forKey: .file)
    try container.encodeIfPresent(parameters, forKey: .parameters)
    try container.encodeIfPresent(returnType, forKey: .returnType)
    try container.encodeIfPresent(isStatic, forKey: .isStatic)
    try container.encodeIfPresent(doc, forKey: .doc)
    try container.encodeIfPresent(deprecated, forKey: .deprecated)
    try container.encodeIfPresent(owner, forKey: .owner)
    try container.encodeIfPresent(whereClause, forKey: .whereClause)
  }
}

struct ParameterCard: Encodable {
  /// 호출 시 쓰는 라벨. `_`이면 nil
  let label: String?
  let name: String
  let type: String
  var defaultValue: String?
}

struct CaseCard: Encodable {
  let name: String
  var associatedValues: String?
  var rawValue: String?
  var doc: String?
}

struct APIFile: Encodable {
  let sources: [String]
  let excluded: [String]
  let counts: [String: Int]
  let views: [TypeCard]
  let types: [TypeCard]
  /// `extension View`로 추가된 공개 함수 (팝업·툴팁·padding(.spacing16) 등)
  let modifiers: [MemberCard]
  /// View 외 외부 타입(Image, Text, VStack …)에 추가된 공개 멤버
  let extensions: [MemberCard]
}

// MARK: - Extractor

/// 라이브러리의 공개 API를 수집한다. Tuist 생성 파일(Generated)은 토큰·아이콘 데이터가 대신 다룬다.
struct APIExtractor {
  let repository: Repository

  func extract() throws -> APIFile {
    let files = try repository.swiftFiles(in: repository.librarySources, excluding: [repository.generatedSources])
      .map { try ParsedFile(url: $0, repository: repository) }

    var collector = Collector()
    // 1차: 타입 선언 수집. 익스텐션 안에 선언된 타입(`extension SDG { enum Typography }`)도 포함한다.
    for file in files {
      for decl in topLevelDecls(of: file.tree) {
        collector.collectTypes(in: decl, file: file, defaultPublic: false)
      }
    }
    // 2차: 익스텐션 멤버를 기존 타입에 합치거나 View 모디파이어·외부 타입 확장으로 분류한다.
    for file in files {
      for decl in topLevelDecls(of: file.tree) {
        if let extensionDecl = decl.as(ExtensionDeclSyntax.self) {
          collector.collectExtensionMembers(of: extensionDecl, file: file)
        }
      }
    }

    let cards = collector.cards.values.sorted { $0.name < $1.name }
    let views = cards.filter(\.isView)
    let types = cards.filter { !$0.isView }
    let modifiers = collector.modifiers.sorted(by: Self.memberOrder)
    let extensions = collector.extensions.sorted(by: Self.memberOrder)

    return APIFile(
      sources: [repository.relativePath(of: repository.librarySources)],
      excluded: [repository.relativePath(of: repository.generatedSources)],
      counts: [
        "views": views.count,
        "types": types.count,
        "modifiers": modifiers.count,
        "extensions": extensions.count
      ],
      views: views,
      types: types,
      modifiers: modifiers,
      extensions: extensions
    )
  }

  private static func memberOrder(_ lhs: MemberCard, _ rhs: MemberCard) -> Bool {
    (lhs.owner ?? "", lhs.name, lhs.location.file, lhs.location.line)
      < (rhs.owner ?? "", rhs.name, rhs.location.file, rhs.location.line)
  }

  /// 최상위 선언. `#if` 블록 안의 선언도 펼친다.
  private func topLevelDecls(of tree: SourceFileSyntax) -> [DeclSyntax] {
    tree.statements.flatMap { statement -> [DeclSyntax] in
      guard let decl = Syntax(statement.item).as(DeclSyntax.self) else { return [] }
      return Members.flatten(decl)
    }
  }
}

private enum Members {
  /// `#if` 절 안의 선언을 꺼내 평평하게 만든다.
  static func flatten(_ decl: DeclSyntax) -> [DeclSyntax] {
    guard let ifConfig = decl.as(IfConfigDeclSyntax.self) else { return [decl] }
    return ifConfig.clauses.flatMap { clause -> [DeclSyntax] in
      switch clause.elements {
      case .statements(let statements):
        return statements.compactMap { Syntax($0.item).as(DeclSyntax.self) }.flatMap(flatten)
      case .decls(let members):
        return members.map(\.decl).flatMap(flatten)
      default:
        return []
      }
    }
  }

  static func of(_ memberBlock: MemberBlockSyntax) -> [DeclSyntax] {
    memberBlock.members.map(\.decl).flatMap(flatten)
  }
}

// MARK: - Collector

private struct Collector {
  var cards: [String: TypeCard] = [:]
  var modifiers: [MemberCard] = []
  var extensions: [MemberCard] = []

  // MARK: Types

  mutating func collectTypes(in decl: DeclSyntax, file: ParsedFile, defaultPublic: Bool) {
    if let extensionDecl = decl.as(ExtensionDeclSyntax.self) {
      let isPublicExtension = Visibility.isPublic(extensionDecl.modifiers, default: false)
      for member in Members.of(extensionDecl.memberBlock) {
        collectTypes(in: member, file: file, defaultPublic: isPublicExtension)
      }
      return
    }

    guard let header = TypeHeader(decl), Visibility.isPublic(header.modifiers, default: defaultPublic) else { return }

    let name = DeclNames.qualifiedName(of: decl)
    var card = TypeCard(
      name: name,
      kind: header.kind,
      declaration: header.declaration,
      isView: header.inherits.contains { $0 == "View" || $0 == "SwiftUI.View" },
      location: file.location(of: decl),
      doc: Comments.documentation(of: decl),
      deprecated: Attributes.deprecation(in: header.attributes),
      aliasOf: header.aliasOf,
      inherits: header.inherits
    )

    if let memberBlock = header.memberBlock {
      let membersArePublic = header.kind == "protocol"
      for member in Members.of(memberBlock) {
        if let caseDecl = member.as(EnumCaseDeclSyntax.self) {
          card.cases += cases(of: caseDecl)
        } else if TypeHeader(member) != nil {
          let before = Set(cards.keys)
          collectTypes(in: member, file: file, defaultPublic: membersArePublic)
          card.nestedTypes += Set(cards.keys).subtracting(before).filter { $0.hasPrefix(name + ".") && !$0.dropFirst(name.count + 1).contains(".") }.sorted()
        } else if let version = versionValue(of: member) {
          card.version = version
        } else {
          add(member, to: &card, file: file, defaultPublic: membersArePublic, owner: nil)
        }
      }
    }

    cards[name] = card
  }

  // MARK: Extensions

  mutating func collectExtensionMembers(of extensionDecl: ExtensionDeclSyntax, file: ParsedFile) {
    let extendedType = SyntaxText.compact(extensionDecl.extendedType)
    let isPublicExtension = Visibility.isPublic(extensionDecl.modifiers, default: false)
    let whereClause = extensionDecl.genericWhereClause.map(SyntaxText.compact)

    for member in Members.of(extensionDecl.memberBlock) where TypeHeader(member) == nil {
      if var card = cards[extendedType] {
        add(member, to: &card, file: file, defaultPublic: isPublicExtension, owner: nil)
        cards[extendedType] = card
        continue
      }

      guard var memberCard = Self.memberCard(of: member, file: file, defaultPublic: isPublicExtension) else { continue }
      memberCard.owner = extendedType
      memberCard.whereClause = whereClause
      if extendedType == "View" || extendedType == "SwiftUI.View" {
        modifiers.append(memberCard)
      } else {
        extensions.append(memberCard)
      }
    }
  }

  // MARK: Members

  private func add(_ member: DeclSyntax, to card: inout TypeCard, file: ParsedFile, defaultPublic: Bool, owner: String?) {
    guard var memberCard = Self.memberCard(of: member, file: file, defaultPublic: defaultPublic) else { return }
    memberCard.owner = owner
    switch memberCard.kind {
    case "initializer":
      card.initializers.append(memberCard)
    case "method":
      card.methods.append(memberCard)
    case "property":
      // View의 body는 모든 View에 있으므로 노이즈다.
      if card.isView && memberCard.name == "body" { return }
      card.properties.append(memberCard)
    default:
      break
    }
  }

  static func memberCard(of member: DeclSyntax, file: ParsedFile, defaultPublic: Bool) -> MemberCard? {
    if let initDecl = member.as(InitializerDeclSyntax.self) {
      guard Visibility.isPublic(initDecl.modifiers, default: defaultPublic) else { return nil }
      let generics = initDecl.genericParameterClause.map(SyntaxText.compact) ?? ""
      var signature = "init" + (initDecl.optionalMark?.text ?? "") + generics + SyntaxText.compact(initDecl.signature)
      let whereClause = initDecl.genericWhereClause.map(SyntaxText.compact)
      if let whereClause { signature += " " + whereClause }
      return MemberCard(
        name: "init",
        kind: "initializer",
        signature: signature,
        location: file.location(of: initDecl),
        parameters: parameters(of: initDecl.signature.parameterClause),
        doc: Comments.documentation(of: initDecl),
        deprecated: Attributes.deprecation(in: initDecl.attributes),
        whereClause: whereClause
      )
    }

    if let funcDecl = member.as(FunctionDeclSyntax.self) {
      // 연산자(==) 구현은 사용법 정보가 아니므로 제외한다.
      guard Visibility.isPublic(funcDecl.modifiers, default: defaultPublic),
            case .identifier = funcDecl.name.tokenKind
      else { return nil }
      let isStatic = Visibility.isStatic(funcDecl.modifiers)
      let generics = funcDecl.genericParameterClause.map(SyntaxText.compact) ?? ""
      var signature = (isStatic ? "static " : "") + "func " + funcDecl.name.text + generics + SyntaxText.compact(funcDecl.signature)
      let whereClause = funcDecl.genericWhereClause.map(SyntaxText.compact)
      if let whereClause { signature += " " + whereClause }
      return MemberCard(
        name: funcDecl.name.text,
        kind: "method",
        signature: signature,
        location: file.location(of: funcDecl),
        parameters: parameters(of: funcDecl.signature.parameterClause),
        returnType: funcDecl.signature.returnClause.map { SyntaxText.compact($0.type) },
        isStatic: isStatic ? true : nil,
        doc: Comments.documentation(of: funcDecl),
        deprecated: Attributes.deprecation(in: funcDecl.attributes),
        whereClause: whereClause
      )
    }

    if let variable = member.as(VariableDeclSyntax.self) {
      guard Visibility.isPublic(variable.modifiers, default: defaultPublic),
            let binding = variable.bindings.first,
            let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
      else { return nil }
      let isStatic = Visibility.isStatic(variable.modifiers)
      var signature = (isStatic ? "static " : "") + variable.bindingSpecifier.text + " " + name
      if let type = binding.typeAnnotation?.type {
        signature += ": " + SyntaxText.compact(type)
      } else if let value = binding.initializer?.value {
        let text = SyntaxText.compact(value)
        signature += " = " + (text.count > 80 ? String(text.prefix(80)) + "…" : text)
      }
      return MemberCard(
        name: name,
        kind: "property",
        signature: signature,
        location: file.location(of: variable),
        isStatic: isStatic ? true : nil,
        doc: Comments.documentation(of: variable),
        deprecated: Attributes.deprecation(in: variable.attributes)
      )
    }

    return nil
  }

  private static func parameters(of clause: FunctionParameterClauseSyntax) -> [ParameterCard] {
    clause.parameters.map { parameter in
      let firstName = parameter.firstName.text
      var type = SyntaxText.compact(parameter.type) + (parameter.ellipsis?.text ?? "")
      // `@ViewBuilder` 같은 파라미터 속성은 호출 방식(후행 클로저 빌더)을 바꾸므로 타입 앞에 남긴다.
      if !parameter.attributes.isEmpty {
        type = SyntaxText.compact(parameter.attributes) + " " + type
      }
      return ParameterCard(
        label: firstName == "_" ? nil : firstName,
        name: parameter.secondName?.text ?? firstName,
        type: type,
        defaultValue: parameter.defaultValue.map { SyntaxText.compact($0.value) }
      )
    }
  }

  private func cases(of caseDecl: EnumCaseDeclSyntax) -> [CaseCard] {
    caseDecl.elements.map { element in
      CaseCard(
        name: element.name.text,
        associatedValues: element.parameterClause.map(SyntaxText.compact),
        rawValue: element.rawValue.map { SyntaxText.compact($0.value) },
        doc: Comments.documentation(of: caseDecl)
      )
    }
  }

  /// `static let version = "2.3.34"` 또는 `static var version: String { "2.3.27" }`
  private func versionValue(of member: DeclSyntax) -> String? {
    guard let variable = member.as(VariableDeclSyntax.self),
          Visibility.isStatic(variable.modifiers),
          let binding = variable.bindings.first,
          binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text == "version"
    else { return nil }
    if let value = Literals.string(binding.initializer?.value) { return value }
    if let literal = binding.accessorBlock?.firstDescendant(ofType: StringLiteralExprSyntax.self) {
      return Literals.string(ExprSyntax(literal))
    }
    return nil
  }
}

// MARK: - Type header

/// struct/enum/class/actor/protocol/typealias 선언의 공통 정보.
private struct TypeHeader {
  let kind: String
  let modifiers: DeclModifierListSyntax
  let attributes: AttributeListSyntax
  let inherits: [String]
  let memberBlock: MemberBlockSyntax?
  let declaration: String
  let aliasOf: String?

  init?(_ decl: DeclSyntax) {
    func inherited(_ clause: InheritanceClauseSyntax?) -> [String] {
      clause?.inheritedTypes.map { SyntaxText.compact($0.type) } ?? []
    }
    func header(_ keyword: String, _ name: TokenSyntax, _ generics: GenericParameterClauseSyntax?, _ clause: InheritanceClauseSyntax?) -> String {
      var text = "public \(keyword) \(name.text)" + (generics.map(SyntaxText.compact) ?? "")
      let parents = inherited(clause)
      if !parents.isEmpty { text += ": " + parents.joined(separator: ", ") }
      return text
    }

    if let node = decl.as(StructDeclSyntax.self) {
      kind = "struct"; modifiers = node.modifiers; attributes = node.attributes
      inherits = inherited(node.inheritanceClause); memberBlock = node.memberBlock
      declaration = header("struct", node.name, node.genericParameterClause, node.inheritanceClause); aliasOf = nil
    } else if let node = decl.as(EnumDeclSyntax.self) {
      kind = "enum"; modifiers = node.modifiers; attributes = node.attributes
      inherits = inherited(node.inheritanceClause); memberBlock = node.memberBlock
      declaration = header("enum", node.name, node.genericParameterClause, node.inheritanceClause); aliasOf = nil
    } else if let node = decl.as(ClassDeclSyntax.self) {
      kind = "class"; modifiers = node.modifiers; attributes = node.attributes
      inherits = inherited(node.inheritanceClause); memberBlock = node.memberBlock
      declaration = header("class", node.name, node.genericParameterClause, node.inheritanceClause); aliasOf = nil
    } else if let node = decl.as(ActorDeclSyntax.self) {
      kind = "actor"; modifiers = node.modifiers; attributes = node.attributes
      inherits = inherited(node.inheritanceClause); memberBlock = node.memberBlock
      declaration = header("actor", node.name, node.genericParameterClause, node.inheritanceClause); aliasOf = nil
    } else if let node = decl.as(ProtocolDeclSyntax.self) {
      kind = "protocol"; modifiers = node.modifiers; attributes = node.attributes
      inherits = inherited(node.inheritanceClause); memberBlock = node.memberBlock
      declaration = header("protocol", node.name, nil, node.inheritanceClause); aliasOf = nil
    } else if let node = decl.as(TypeAliasDeclSyntax.self) {
      kind = "typealias"; modifiers = node.modifiers; attributes = node.attributes
      inherits = []; memberBlock = nil
      let target = SyntaxText.compact(node.initializer.value)
      declaration = "public typealias \(node.name.text) = \(target)"; aliasOf = target
    } else {
      return nil
    }
  }
}
