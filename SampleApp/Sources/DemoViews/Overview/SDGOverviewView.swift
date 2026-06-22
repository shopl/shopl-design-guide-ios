//
//  SDGOverviewView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/22/26.
//

import SwiftUI
import ShoplDesignGuide

struct SDGOverviewView: View {
  @ObservedObject var viewModel: SDGOverviewViewModel
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .trailing) {
        VStack(spacing: 0) {
          SDGOverviewHeader(
            topInset: geometry.safeAreaInsets.top,
            onMenuTap: presentMenu
          )
          
          ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
              ForEach(viewModel.sections) { section in
                SDGOverviewSectionCard(section: section)
              }
              
              Text(sdg: viewModel.footerText)
                .multilineTextAlignment(.center)
                .typo(.body4_R, .neutral200)
                .padding(.top, 44)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
          }
          .background(Color.neutral0)
        }
        .background(Color.neutral0)
        
        if viewModel.isMenuPresented {
          SDGMenuView(
            viewModel: SDGMenuViewModel(selectedItemID: SDGMenuViewModel.overviewItemID),
            topInset: geometry.safeAreaInsets.top,
            onClose: dismissMenu,
            onRoute: { route in
              switch route {
              case .overview:
                dismissMenu()
              case .demo:
                break
              }
            }
          )
          .transition(.move(edge: .trailing))
          .zIndex(1)
        }
      }
      .animation(.easeInOut(duration: 0.25), value: viewModel.isMenuPresented)
      .background(Color.neutral0)
      .ignoresSafeArea(edges: .top)
      .toolbar(.hidden, for: .navigationBar)
    }
  }
  
  private func presentMenu() {
    withAnimation(.easeInOut(duration: 0.25)) {
      viewModel.didTapMenuButton()
    }
  }
  
  private func dismissMenu() {
    withAnimation(.easeInOut(duration: 0.25)) {
      viewModel.dismissMenu()
    }
  }
}

private struct SDGOverviewHeader: View {
  let topInset: CGFloat
  let onMenuTap: () -> Void
  
  var body: some View {
    VStack(spacing: 0) {
      Color.clear
        .frame(height: topInset)
      
      SDGBasicNavi(
        naviType: .none,
        title: nil,
        backgroundColor: .black,
        buttons: [
          TopNaviButtonOption(
            image: Image(sdg: .icNaviDrawer),
            tintColor: .neutral0,
            touchUpInside: onMenuTap
          )
        ]
      )
      
      VStack(spacing: 6) {
        SDGOverviewLogo()
        
        Text(sdg: "Shopl Design Guide")
          .typo(.title2_SB, .neutral0)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(.bottom, 34)
    }
    .frame(height: topInset + 244)
    .background(Color.black)
  }
}

private struct SDGOverviewLogo: View {
  var body: some View {
    Text(sdg: "sdg")
      .font(.system(size: 76, weight: .bold))
      .foregroundStyle(logoGradient)
      .lineLimit(1)
      .minimumScaleFactor(0.8)
  }
  
  private var logoGradient: LinearGradient {
    LinearGradient(
      colors: [
        Color(red: 50 / 255, green: 153 / 255, blue: 254 / 255),
        Color(red: 8 / 255, green: 126 / 255, blue: 244 / 255)
      ],
      startPoint: UnitPoint(x: -0.052740007638931274, y: 0.6612302660942078),
      endPoint: UnitPoint(x: 0.5310259759426117, y: 0.2179669737815857)
    )
  }
}

private struct SDGOverviewSectionCard: View {
  let section: SDGOverviewSectionViewState
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .leading, spacing: 8) {
        Text(sdg: section.title)
          .typo(.point2_SB, .neutral700)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text(sdg: section.description)
          .typo(.body1_R, .neutral600)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      SDGFlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(section.badges) { badge in
          SDGOverviewBadge(badge: badge)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 20)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.neutral0)
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    .overlay {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .stroke(Color.neutral100, lineWidth: 1)
    }
  }
}

private struct SDGOverviewBadge: View {
  let badge: SDGOverviewBadgeViewState
  
  var body: some View {
    SDGBoxBadge(
      text: badge.title,
      type: .solid(
        .init(
          backgroundColor: .neutral50,
          textColor: badge.isImplemented ? .neutral400 : .neutral250
        )
      )
    )
    .opacity(badge.isImplemented ? 1 : 0.55)
    .accessibilityLabel(accessibilityLabel)
  }
  
  private var accessibilityLabel: String {
    badge.isImplemented ? badge.title : "\(badge.title), 준비 중"
  }
}

private struct SDGFlowLayout: Layout {
  let horizontalSpacing: CGFloat
  let verticalSpacing: CGFloat
  
  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    guard !subviews.isEmpty else {
      return .zero
    }
    
    let maxWidth = proposal.width ?? .infinity
    let measuredRows = rows(maxWidth: maxWidth, subviews: subviews)
    let height = measuredRows.reduce(CGFloat.zero) { partialHeight, row in
      partialHeight + row.height
    } + verticalSpacing * CGFloat(max(measuredRows.count - 1, 0))
    let width = proposal.width ?? measuredRows.map(\.width).max() ?? 0
    
    return CGSize(width: width, height: height)
  }
  
  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    var origin = bounds.origin
    var rowHeight: CGFloat = 0
    
    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      
      if origin.x > bounds.minX, origin.x + size.width > bounds.maxX {
        origin.x = bounds.minX
        origin.y += rowHeight + verticalSpacing
        rowHeight = 0
      }
      
      subview.place(
        at: origin,
        anchor: .topLeading,
        proposal: ProposedViewSize(width: size.width, height: size.height)
      )
      
      origin.x += size.width + horizontalSpacing
      rowHeight = max(rowHeight, size.height)
    }
  }
  
  private func rows(maxWidth: CGFloat, subviews: Subviews) -> [FlowRow] {
    var rows: [FlowRow] = []
    var currentRow = FlowRow()
    
    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      let nextWidth = currentRow.width == 0 ? size.width : currentRow.width + horizontalSpacing + size.width
      
      if currentRow.width > 0, nextWidth > maxWidth {
        rows.append(currentRow)
        currentRow = FlowRow()
      }
      
      currentRow.width = currentRow.width == 0 ? size.width : currentRow.width + horizontalSpacing + size.width
      currentRow.height = max(currentRow.height, size.height)
    }
    
    if currentRow.width > 0 {
      rows.append(currentRow)
    }
    
    return rows
  }
  
  private struct FlowRow {
    var width: CGFloat = 0
    var height: CGFloat = 0
  }
}

#Preview {
  SDGOverviewView(viewModel: SDGOverviewViewModel())
}
