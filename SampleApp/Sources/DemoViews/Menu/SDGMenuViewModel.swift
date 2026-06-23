//
//  SDGMenuViewModel.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/22/26.
//

import Combine
import Foundation

enum SDGMenuRoute: Hashable {
  case overview
  case demo(itemID: String, viewID: String)
}

struct SDGMenuSectionViewState: Identifiable, Hashable {
  let id: String
  let title: String
  let rows: [SDGMenuRowViewState]
}

struct SDGMenuRowViewState: Identifiable, Hashable {
  let id: String
  let title: String
  let depth: Int
  let isSelected: Bool
  let isExpandable: Bool
  let isExpanded: Bool
  let isImplemented: Bool
  let isDemoAvailable: Bool
  let viewID: String?
}

final class SDGMenuViewModel: ObservableObject {
  static let overviewItemID = "overview"
  
  @Published private(set) var overviewRow: SDGMenuRowViewState
  @Published private(set) var sections: [SDGMenuSectionViewState] = []
  
  private let catalogSections: [SDGCatalogSection]
  private let availabilityResolver: SDGAvailabilityResolving
  private let demoRegistry: SDGDemoRegistryResolving
  private var expandedItemIDs: Set<String>
  private var selectedItemID: String?
  
  init(
    selectedItemID: String? = SDGMenuViewModel.overviewItemID,
    initialExpandedItemIDs: Set<String> = [],
    catalogRepository: SDGCatalogRepository = DefaultSDGCatalogRepository(),
    availabilityResolver: SDGAvailabilityResolving = SDGAvailabilityResolver(),
    demoRegistry: SDGDemoRegistryResolving = SDGViewRegistry.shared
  ) {
    let catalogSections = catalogRepository.catalogSections()
    self.catalogSections = catalogSections
    self.availabilityResolver = availabilityResolver
    self.demoRegistry = demoRegistry
    self.selectedItemID = selectedItemID
    self.expandedItemIDs = initialExpandedItemIDs.union(
      Self.expandedAncestorIDs(for: selectedItemID, in: catalogSections)
    )
    self.overviewRow = Self.makeOverviewRow(isSelected: selectedItemID == Self.overviewItemID)
    
    load()
  }
  
  func didTapOverview() -> SDGMenuRoute {
    selectedItemID = Self.overviewItemID
    load()
    return .overview
  }
  
  func didTapRow(id: String) -> SDGMenuRoute? {
    guard let item = Self.findItem(id: id, in: catalogSections) else {
      return nil
    }
    
    if item.children.isEmpty == false {
      toggleExpanded(id: id)
      return nil
    }
    
    guard let viewID = item.viewID, demoRegistry.contains(id: viewID) else {
      return nil
    }
    
    selectedItemID = id
    load()
    return .demo(itemID: id, viewID: viewID)
  }
}

private extension SDGMenuViewModel {
  func toggleExpanded(id: String) {
    if expandedItemIDs.contains(id) {
      expandedItemIDs.remove(id)
    } else {
      expandedItemIDs.insert(id)
    }
    
    load()
  }
  
  func load() {
    overviewRow = Self.makeOverviewRow(isSelected: selectedItemID == Self.overviewItemID)
    sections = catalogSections.map { section in
      SDGMenuSectionViewState(
        id: section.id,
        title: section.title,
        rows: section.items.flatMap { item in
          makeRows(item: item, depth: 0)
        }
      )
    }
  }
  
  func makeRows(item: SDGCatalogItem, depth: Int) -> [SDGMenuRowViewState] {
    let availability = availabilityResolver.availability(for: item)
    let isExpanded = expandedItemIDs.contains(item.id)
    let isDemoAvailable = item.viewID.map(demoRegistry.contains) ?? false
    
    let row = SDGMenuRowViewState(
      id: item.id,
      title: item.title,
      depth: depth,
      isSelected: item.id == selectedItemID,
      isExpandable: item.children.isEmpty == false,
      isExpanded: isExpanded,
      isImplemented: availability.isImplemented,
      isDemoAvailable: isDemoAvailable,
      viewID: item.viewID
    )
    
    guard isExpanded else {
      return [row]
    }
    
    return [row] + item.children.flatMap { child in
      makeRows(item: child, depth: depth + 1)
    }
  }
  
  static func makeOverviewRow(isSelected: Bool) -> SDGMenuRowViewState {
    SDGMenuRowViewState(
      id: overviewItemID,
      title: "Overview",
      depth: 0,
      isSelected: isSelected,
      isExpandable: false,
      isExpanded: false,
      isImplemented: true,
      isDemoAvailable: true,
      viewID: nil
    )
  }
  
  static func findItem(id: String, in sections: [SDGCatalogSection]) -> SDGCatalogItem? {
    for section in sections {
      if let item = findItem(id: id, in: section.items) {
        return item
      }
    }
    
    return nil
  }
  
  static func findItem(id: String, in items: [SDGCatalogItem]) -> SDGCatalogItem? {
    for item in items {
      if item.id == id {
        return item
      }
      
      if let childItem = findItem(id: id, in: item.children) {
        return childItem
      }
    }
    
    return nil
  }
  
  static func expandedAncestorIDs(
    for selectedItemID: String?,
    in sections: [SDGCatalogSection]
  ) -> Set<String> {
    guard let selectedItemID, selectedItemID != overviewItemID else {
      return []
    }
    
    for section in sections {
      if let ancestors = ancestorIDs(for: selectedItemID, in: section.items, path: []) {
        return Set(ancestors)
      }
    }
    
    return []
  }
  
  static func ancestorIDs(
    for selectedItemID: String,
    in items: [SDGCatalogItem],
    path: [String]
  ) -> [String]? {
    for item in items {
      if item.id == selectedItemID {
        return path
      }
      
      if let ancestors = ancestorIDs(
        for: selectedItemID,
        in: item.children,
        path: path + [item.id]
      ) {
        return ancestors
      }
    }
    
    return nil
  }
}
