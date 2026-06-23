//
//  SDGMenuView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/22/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGMenuView: View {
  private let titleTopInset: CGFloat = 10
  private let scrollOffsetMarkerHeight: CGFloat = 1
  
  private let topInset: CGFloat?
  
  @ObservedObject var viewModel: SDGMenuViewModel
  @State private var isNavigationDividerVisible = false
  
  let onClose: () -> Void
  let onRoute: (SDGMenuRoute) -> Void
  
  init(
    viewModel: SDGMenuViewModel,
    topInset: CGFloat? = nil,
    onClose: @escaping () -> Void,
    onRoute: @escaping (SDGMenuRoute) -> Void = { _ in }
  ) {
    self.viewModel = viewModel
    self.topInset = topInset
    self.onClose = onClose
    self.onRoute = onRoute
  }
  
  var body: some View {
    GeometryReader { geometry in
      let topInset = topInset ?? geometry.safeAreaInsets.top
      
      VStack(spacing: 0) {
        Color.clear
          .frame(height: topInset)
        
        SDGBasicNavi(
          naviType: .dismiss(
            tintColor: .neutral700,
            onDismiss: onClose
          ),
          title: nil,
          backgroundColor: .neutral0
        )
        .overlay(alignment: .bottom) {
          if isNavigationDividerVisible {
            Rectangle()
              .fill(Color.neutral200)
              .frame(height: 1)
              .transition(.opacity)
          }
        }
        
        ScrollView(showsIndicators: false) {
          VStack(spacing: 0) {
            SDGMenuScrollOffsetMarker()
              .frame(height: scrollOffsetMarkerHeight)
            
            SDGMenuTitleView()
              .padding(.top, titleTopInset - scrollOffsetMarkerHeight)
            
            VStack(alignment: .leading, spacing: 28) {
              SDGMenuRowView(row: viewModel.overviewRow) {
                onRoute(viewModel.didTapOverview())
              }
              
              ForEach(viewModel.sections) { section in
                SDGMenuSectionView(
                  section: section,
                  onTapRow: { rowID in
                    let route = withAnimation(.easeInOut(duration: 0.2)) {
                      viewModel.didTapRow(id: rowID)
                    }
                    
                    if let route {
                      onRoute(route)
                    }
                  }
                )
              }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 40)
          }
        }
        .background {
          GeometryReader { proxy in
            Color.clear.preference(
              key: SDGMenuScrollMetricsPreferenceKey.self,
              value: SDGMenuScrollMetrics(
                scrollViewMinY: proxy.frame(in: .global).minY
              )
            )
          }
        }
        .onPreferenceChange(SDGMenuScrollMetricsPreferenceKey.self) { metrics in
          guard let scrollViewMinY = metrics.scrollViewMinY,
                let contentMinY = metrics.contentMinY else {
            return
          }
          
          withAnimation(.easeInOut(duration: 0.16)) {
            isNavigationDividerVisible = contentMinY < scrollViewMinY - 0.5
          }
        }
      }
      .background(Color.neutral0)
      .ignoresSafeArea(edges: .top)
      .toolbar(.hidden, for: .navigationBar)
    }
  }
}

private struct SDGMenuScrollMetrics: Equatable {
  var scrollViewMinY: CGFloat?
  var contentMinY: CGFloat?
  
  init(scrollViewMinY: CGFloat? = nil, contentMinY: CGFloat? = nil) {
    self.scrollViewMinY = scrollViewMinY
    self.contentMinY = contentMinY
  }
}

private struct SDGMenuScrollMetricsPreferenceKey: PreferenceKey {
  static var defaultValue = SDGMenuScrollMetrics()
  
  static func reduce(value: inout SDGMenuScrollMetrics, nextValue: () -> SDGMenuScrollMetrics) {
    let nextValue = nextValue()
    
    value.scrollViewMinY = nextValue.scrollViewMinY ?? value.scrollViewMinY
    value.contentMinY = nextValue.contentMinY ?? value.contentMinY
  }
}

private struct SDGMenuScrollOffsetMarker: View {
  var body: some View {
    GeometryReader { proxy in
      Color.clear.preference(
        key: SDGMenuScrollMetricsPreferenceKey.self,
        value: SDGMenuScrollMetrics(
          contentMinY: proxy.frame(in: .global).minY
        )
      )
    }
  }
}

private struct SDGMenuTitleView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(sdg: "Sdg")
        .typo(.point1_SB, .neutral700)
      
      Text(sdg: "Shopl design guide")
        .typo(.body2_R, .neutral700)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 16)
    .padding(.bottom, 20)
    .overlay(alignment: .bottom) {
      Rectangle()
        .fill(Color.neutral700)
        .frame(height: 1)
    }
  }
}

private struct SDGMenuSectionView: View {
  let section: SDGMenuSectionViewState
  let onTapRow: (String) -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(sdg: section.title)
        .typo(.body2_SB, .neutral350)
      
      ForEach(section.rows) { row in
        SDGMenuRowView(row: row) {
          onTapRow(row.id)
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .animation(.easeInOut(duration: 0.2), value: section.rows)
  }
}
private struct SDGMenuRowView: View {
  let row: SDGMenuRowViewState
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 4) {
        Text(sdg: row.title)
          .typo(.title2_SB, textColor)
          .lineLimit(1)
        
        if row.isExpandable {
          Image(sdg: .icCommonTriangledown)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(Color.neutral350)
            .frame(width: 12, height: 12)
            .rotationEffect(.degrees(row.isExpanded ? 180 : 0))
            .animation(.easeInOut(duration: 0.2), value: row.isExpanded)
        }
      }
      .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
      .padding(.leading, CGFloat(row.depth) * 8)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .disabled(!isRowEnabled)
    .opacity(isRowEnabled ? 1 : 0.55)
    .accessibilityLabel(accessibilityLabel)
  }
  
  private var textColor: SDG.Color {
    if row.isSelected {
      return .primary300
    }
    
    if !isRowEnabled {
      return .neutral250
    }

    return row.depth == 0 ? .neutral700 : .neutral600
  }

  private var isRowEnabled: Bool {
    row.isExpandable || (row.isImplemented && row.isDemoAvailable)
  }

  private var accessibilityLabel: String {
    if row.isExpandable {
      return row.isExpanded ? "\(row.title), 펼쳐짐" : "\(row.title), 접힘"
    }

    if !isRowEnabled {
      return "\(row.title), 준비 중"
    }
    
    return row.title
  }
}

#Preview {
  SDGMenuView(
    viewModel: SDGMenuViewModel(selectedItemID: "component_dropdown"),
    onClose: { }
  )
}
