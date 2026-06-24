//
//  SDGGuideDetailView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/22/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGGuideDetailView: View {
  @Environment(\.dismiss) private var dismiss
  
  let itemID: String
  let viewID: String
  let onMenuTap: () -> Void
  
  private let catalogRepository: SDGCatalogRepository = DefaultSDGCatalogRepository()
  
  private var item: SDGCatalogItem? {
    catalogRepository.catalogItem(id: itemID)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      SDGBasicNavi(
        naviType: .pop(
          tintColor: .neutral700,
          onDismiss: {
            dismiss()
          }
        ),
        title: nil,
        backgroundColor: .neutral0,
        buttons: [
          TopNaviButtonOption(
            image: Image(sdg: .icNaviDrawer),
            tintColor: .neutral700,
            touchUpInside: onMenuTap
          )
        ]
      )

      ScrollView(showsIndicators: false) {
        VStack(spacing: 0) {
          SDGGuideHeaderView(
            title: item?.title ?? viewID,
            version: version,
            description: item?.subDescription
          )

          Divider(color: .neutral700, option: .init(direction: .horizental, thickness: 1))

          SDGViewRegistry.shared.build(id: viewID)
        }
      }
    }
    .background(Color.neutral0)
    .toolbar(.hidden, for: .navigationBar)
  }
  
  private var version: String? {
    switch itemID {
    case "foundation_color", "foundation_iconography":
      return "2.0.0"
    default:
      return nil
    }
  }
}

private struct SDGGuideHeaderView: View {
  let title: String
  let version: String?
  let description: String?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(alignment: .firstTextBaseline, spacing: 8) {
        Text(sdg: title)
          .typo(.point1_SB, .neutral700)
        
        if let version {
          Text(sdg: version)
            .typo(.body3_SB, .neutral700)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      if let description {
        Text(sdg: description)
          .typo(.body2_R, .neutral700)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 10)
    .padding(.bottom, 16)
  }
}

#Preview {
  SDGGuideDetailView(
    itemID: "foundation_color",
    viewID: "foundation_color",
    onMenuTap: { }
  )
}
