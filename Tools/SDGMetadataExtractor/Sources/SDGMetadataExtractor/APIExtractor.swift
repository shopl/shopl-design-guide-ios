import Foundation
import SwiftSyntax

// MARK: - Output

/// 공개 타입 한 개. View를 따르는 타입은 `views`, 나머지는 `types`에 들어간다.
/// 중첩 타입(`SDGBoxButton.Option`)도 별도 카드로 펼치고 `nestedTypes`에 이름만 남긴다.
struct TypeCard: Encodable {
  let name: String
  let kind: String
  let declaration: String
  /// 선언부 또는 `extension X: View`로 View를 따르면 true
  var isView: Bool
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
    collector.removeTypesNestedInNonPublicTypes()
    // 2차: 익스텐션 멤버를 기존 타입에 합치거나 View 모디파이어·외부 타입 확장으로 분류한다.
    for file in files {
      for decl in topLevelDecls(of: file.tree) {
        if let extensionDecl = decl.as(ExtensionDeclSyntax.self) {
          collector.collectExtensionMembers(of: extensionDecl, file: file)
        }
      }
    }
    collector.linkNestedTypes()

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
      // DEBUG에서만 컴파일되는 선언은 앱의 릴리스 빌드에서 쓸 수 없으므로 뺀다.
      if let condition = clause.condition, requiresDebug(SyntaxText.compact(condition)) { return [] }
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

  /// `DEBUG`, `DEBUG && X`처럼 DEBUG일 때만 참인 조건. `!DEBUG`, `DEBUG || X`는 릴리스에서도 컴파일될 수 있다.
  static func requiresDebug(_ condition: String) -> Bool {
    let flattened = condition.replacingOccurrences(of: "(", with: " ").replacingOccurrences(of: ")", with: " ")
    return flattened.components(separatedBy: "||").allSatisfy { disjunct in
      disjunct.components(separatedBy: "&&").map { $0.trimmingCharacters(in: .whitespaces) }.contains("DEBUG")
    }
  }
}

// MARK: - Collector

private struct Collector {
  var cards: [String: TypeCard] = [:]
  var modifiers: [MemberCard] = []
  var extensions: [MemberCard] = []
  /// 접근 수준과 무관하게 라이브러리에 선언된 모든 타입 이름. 내부 타입의 익스텐션을 걸러내는 데 쓴다.
  var declaredTypes: Set<String> = []

  // MARK: Types

  mutating func collectTypes(in decl: DeclSyntax, file: ParsedFile, defaultPublic: Bool) {
    if let extensionDecl = decl.as(ExtensionDeclSyntax.self) {
      let isPublicExtension = Visibility.isPublic(extensionDecl.modifiers, default: false)
      for member in Members.of(extensionDecl.memberBlock) {
        collectTypes(in: member, file: file, defaultPublic: isPublicExtension)
      }
      return
    }

    guard let header = TypeHeader(decl) else { return }
    let name = DeclNames.qualifiedName(of: decl)
    declaredTypes.insert(name)

    let availability = Attributes.availability(in: header.attributes)
    guard Visibility.isPublic(header.modifiers, default: defaultPublic), !availability.isUnavailable else { return }

    var card = TypeCard(
      name: name,
      kind: header.kind,
      declaration: header.declaration,
      isView: header.inherits.contains(where: Self.isViewType),
      location: file.location(of: decl),
      doc: Comments.documentation(of: decl),
      deprecated: availability.deprecated,
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

  /// `extension InternalType { public struct X }`처럼 부모 타입이 public이 아니면 중첩 타입도 모듈 밖에서 보이지 않는다.
  mutating func removeTypesNestedInNonPublicTypes() {
    for name in cards.keys.sorted() {
      var ancestor = ""
      for component in name.split(separator: ".").dropLast() {
        ancestor = ancestor.isEmpty ? String(component) : ancestor + "." + component
        if declaredTypes.contains(ancestor) && cards[ancestor] == nil {
          cards[name] = nil
          break
        }
      }
    }
  }

  /// 익스텐션에서 선언된 중첩 타입(`extension SDGBoxButton { public enum X }`)도 부모의 `nestedTypes`에 연결한다.
  mutating func linkNestedTypes() {
    for name in cards.keys.sorted() {
      guard let dot = name.lastIndex(of: ".") else { continue }
      let parent = String(name[..<dot])
      guard var parentCard = cards[parent], !parentCard.nestedTypes.contains(name) else { continue }
      parentCard.nestedTypes.append(name)
      cards[parent] = parentCard
    }
  }

  private static func isViewType(_ name: String) -> Bool {
    name == "View" || name == "SwiftUI.View"
  }

  // MARK: Extensions

  mutating func collectExtensionMembers(of extensionDecl: ExtensionDeclSyntax, file: ParsedFile) {
    let extendedType = SyntaxText.compact(extensionDecl.extendedType)
    // 모듈 내부(internal) 타입의 익스텐션 멤버는 public으로 표시돼 있어도 모듈 밖에서 쓸 수 없다.
    if declaredTypes.contains(extendedType) && cards[extendedType] == nil { return }

    let isPublicExtension = Visibility.isPublic(extensionDecl.modifiers, default: false)
    let whereClause = extensionDecl.genericWhereClause.map(SyntaxText.compact)
    let members = Members.of(extensionDecl.memberBlock).filter { TypeHeader($0) == nil }

    if var card = cards[extendedType] {
      let conformances = extensionDecl.inheritanceClause?.inheritedTypes.map { SyntaxText.compact($0.type) } ?? []
      card.inherits += conformances.filter { !card.inherits.contains($0) }
      if conformances.contains(where: Self.isViewType) {
        // `extension X: View`로 View를 따르는 경우. body는 모든 View에 있는 노이즈라 뺀다.
        card.isView = true
        card.properties.removeAll { $0.name == "body" }
      }
      for member in members {
        add(member, to: &card, file: file, defaultPublic: isPublicExtension, owner: nil)
      }
      cards[extendedType] = card
      return
    }

    for member in members {
      for var memberCard in Self.memberCards(of: member, file: file, defaultPublic: isPublicExtension) {
        memberCard.owner = extendedType
        memberCard.whereClause = memberCard.whereClause ?? whereClause
        if Self.isViewType(extendedType) {
          modifiers.append(memberCard)
        } else {
          extensions.append(memberCard)
        }
      }
    }
  }

  // MARK: Members

  private func add(_ member: DeclSyntax, to card: inout TypeCard, file: ParsedFile, defaultPublic: Bool, owner: String?) {
    for var memberCard in Self.memberCards(of: member, file: file, defaultPublic: defaultPublic) {
      memberCard.owner = owner
      switch memberCard.kind {
      case "initializer":
        card.initializers.append(memberCard)
      case "method":
        card.methods.append(memberCard)
      case "property":
        // View의 body는 모든 View에 있으므로 노이즈다.
        if card.isView && memberCard.name == "body" { continue }
        card.properties.append(memberCard)
      default:
        break
      }
    }
  }

  /// 공개 멤버 카드. `@available(*, unavailable)` 멤버는 쓸 수 없으므로 뺀다.
  /// `public let a, b: Int`처럼 한 선언에 바인딩이 여럿이면 바인딩마다 카드를 만든다.
  static func memberCards(of member: DeclSyntax, file: ParsedFile, defaultPublic: Bool) -> [MemberCard] {
    if let initDecl = member.as(InitializerDeclSyntax.self) {
      let availability = Attributes.availability(in: initDecl.attributes)
      guard Visibility.isPublic(initDecl.modifiers, default: defaultPublic), !availability.isUnavailable else { return [] }
      let generics = initDecl.genericParameterClause.map(SyntaxText.compact) ?? ""
      var signature = "init" + (initDecl.optionalMark?.text ?? "") + generics + SyntaxText.compact(initDecl.signature)
      let whereClause = initDecl.genericWhereClause.map(SyntaxText.compact)
      if let whereClause { signature += " " + whereClause }
      return [MemberCard(
        name: "init",
        kind: "initializer",
        signature: signature,
        location: file.location(of: initDecl),
        parameters: parameters(of: initDecl.signature.parameterClause),
        doc: Comments.documentation(of: initDecl),
        deprecated: availability.deprecated,
        whereClause: whereClause
      )]
    }

    if let funcDecl = member.as(FunctionDeclSyntax.self) {
      let availability = Attributes.availability(in: funcDecl.attributes)
      // 연산자(==) 구현은 사용법 정보가 아니므로 제외한다.
      guard Visibility.isPublic(funcDecl.modifiers, default: defaultPublic),
            !availability.isUnavailable,
            case .identifier = funcDecl.name.tokenKind
      else { return [] }
      let isStatic = Visibility.isStatic(funcDecl.modifiers)
      let generics = funcDecl.genericParameterClause.map(SyntaxText.compact) ?? ""
      var signature = (isStatic ? "static " : "") + "func " + funcDecl.name.text + generics + SyntaxText.compact(funcDecl.signature)
      let whereClause = funcDecl.genericWhereClause.map(SyntaxText.compact)
      if let whereClause { signature += " " + whereClause }
      return [MemberCard(
        name: funcDecl.name.text,
        kind: "method",
        signature: signature,
        location: file.location(of: funcDecl),
        parameters: parameters(of: funcDecl.signature.parameterClause),
        returnType: funcDecl.signature.returnClause.map { SyntaxText.compact($0.type) },
        isStatic: isStatic ? true : nil,
        doc: Comments.documentation(of: funcDecl),
        deprecated: availability.deprecated,
        whereClause: whereClause
      )]
    }

    if let variable = member.as(VariableDeclSyntax.self) {
      let availability = Attributes.availability(in: variable.attributes)
      guard Visibility.isPublic(variable.modifiers, default: defaultPublic), !availability.isUnavailable else { return [] }
      let isStatic = Visibility.isStatic(variable.modifiers)
      let bindings = Array(variable.bindings)

      return bindings.indices.compactMap { index -> MemberCard? in
        let binding = bindings[index]
        guard let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else { return nil }
        // `let a, b: Int`는 타입 표기를 뒤쪽 바인딩과 공유한다(초기값이 없는 바인딩만).
        let type = binding.typeAnnotation?.type
          ?? (binding.initializer == nil ? bindings[index...].lazy.compactMap(\.typeAnnotation?.type).first : nil)
        var signature = (isStatic ? "static " : "") + variable.bindingSpecifier.text + " " + name
        if let type {
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
          deprecated: availability.deprecated
        )
      }
    }

    return []
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
