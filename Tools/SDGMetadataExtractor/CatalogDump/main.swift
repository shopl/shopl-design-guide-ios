// SampleApp의 디자인 가이드 카탈로그(SDGCatalog.swift)를 JSON으로 출력하는 덤프 프로그램.
//
// 카탈로그는 switch 기반 Swift 코드라 파싱보다 실행이 정확하다. 추출기가 이 파일을
// `SampleApp/Sources/DesignSystem/SDGCatalog.swift`와 함께 swiftc로 컴파일해 실행한다.
// SDGCatalog.swift가 Foundation 외의 모듈에 의존하게 되면 이 방식도 함께 고쳐야 한다.

import Foundation

func dictionary(of item: SDGCatalogItem) -> [String: Any] {
  var result: [String: Any] = [
    "id": item.id,
    "title": item.title,
    "implementationNames": item.implementationNames
  ]
  if let description = item.description { result["description"] = description }
  if let subDescription = item.subDescription { result["subDescription"] = subDescription }
  if !item.children.isEmpty { result["children"] = item.children.map(dictionary(of:)) }
  return result
}

let sections = DefaultSDGCatalogRepository().catalogSections().map { section -> [String: Any] in
  [
    "id": section.id,
    "title": section.title,
    "description": section.description,
    "items": section.items.map(dictionary(of:))
  ]
}

let data = try JSONSerialization.data(withJSONObject: ["sections": sections], options: [.sortedKeys])
FileHandle.standardOutput.write(data)
