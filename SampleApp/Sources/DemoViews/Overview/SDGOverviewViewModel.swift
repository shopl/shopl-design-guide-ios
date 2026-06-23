//
//  SDGOverviewViewModel.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/22/26.
//

import Combine
import Foundation

struct SDGOverviewSectionViewState: Identifiable, Hashable {
  let id: String
  let title: String
  let description: String
  let badges: [SDGOverviewBadgeViewState]
}

struct SDGOverviewBadgeViewState: Identifiable, Hashable {
  let id: String
  let title: String
  let isImplemented: Bool
  let isDemoAvailable: Bool
  let viewID: String?
}

protocol SDGDemoRegistryResolving {
  func contains(id: String) -> Bool
}

extension SDGViewRegistry: SDGDemoRegistryResolving {}

final class SDGOverviewViewModel: ObservableObject {
  @Published private(set) var sections: [SDGOverviewSectionViewState] = []
  
  let footerText = "Shopl App Design System 2.0.0\n(2026.01)"
  
  private let catalogRepository: SDGCatalogRepository
  private let availabilityResolver: SDGAvailabilityResolving
  private let demoRegistry: SDGDemoRegistryResolving
  
  init(
    catalogRepository: SDGCatalogRepository = DefaultSDGCatalogRepository(),
    availabilityResolver: SDGAvailabilityResolving = SDGAvailabilityResolver(),
    demoRegistry: SDGDemoRegistryResolving = SDGViewRegistry.shared
  ) {
    self.catalogRepository = catalogRepository
    self.availabilityResolver = availabilityResolver
    self.demoRegistry = demoRegistry
    
    load()
  }
}

private extension SDGOverviewViewModel {
  func load() {
    sections = catalogRepository.overviewSections().map { section in
      SDGOverviewSectionViewState(
        id: section.id,
        title: section.title,
        description: section.description,
        badges: section.items.map { item in
          let availability = availabilityResolver.availability(for: item)
          let isDemoAvailable = item.viewID.map { demoRegistry.contains(id: $0) } ?? false
          
          return SDGOverviewBadgeViewState(
            id: item.id,
            title: item.title,
            isImplemented: availability.isImplemented,
            isDemoAvailable: isDemoAvailable,
            viewID: item.viewID
          )
        }
      )
    }
  }
}
