import SwiftUI
import ShoplDesignGuide

struct AppView: View {
  @StateObject private var appViewModel = SDGAppViewModel()
  @StateObject private var overviewViewModel = SDGOverviewViewModel()
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .trailing) {
        NavigationStack(path: $appViewModel.navigationPath) {
          SDGOverviewView(
            viewModel: overviewViewModel,
            onMenuTap: presentMenu
          )
          .navigationDestination(for: SDGAppRoute.self) { route in
            switch route {
            case let .demo(itemID, viewID):
              SDGGuideDetailView(
                itemID: itemID,
                viewID: viewID,
                onMenuTap: presentMenu
              )
            }
          }
        }
        .enableInteractivePopGesture(isEnabled: !appViewModel.isMenuPresented)
        .toolbar(.hidden, for: .navigationBar)
        
        if appViewModel.isMenuPresented {
          SDGMenuView(
            viewModel: appViewModel.menuViewModel,
            topInset: geometry.safeAreaInsets.top,
            onClose: dismissMenu,
            onRoute: handleMenuRoute
          )
          .transition(.move(edge: .trailing))
          .zIndex(1)
        }
      }
      .animation(.easeInOut(duration: 0.25), value: appViewModel.isMenuPresented)
      .background(Color.neutral0)
    }
  }
  
  private func presentMenu() {
    withAnimation(.easeInOut(duration: 0.25)) {
      appViewModel.presentMenu()
    }
  }
  
  private func dismissMenu() {
    withAnimation(.easeInOut(duration: 0.25)) {
      appViewModel.dismissMenu()
    }
  }
  
  private func handleMenuRoute(_ route: SDGMenuRoute) {
    var transaction = Transaction(animation: nil)
    transaction.disablesAnimations = true
    
    withTransaction(transaction) {
      appViewModel.navigate(to: route)
    }
    
    dismissMenu()
  }
}

private enum SDGAppRoute: Hashable {
  case demo(itemID: String, viewID: String)
  
  var itemID: String {
    switch self {
    case .demo(let itemID, _):
      return itemID
    }
  }
}

private final class SDGAppViewModel: ObservableObject {
  @Published var navigationPath: [SDGAppRoute] = []
  @Published var isMenuPresented = false

  let menuViewModel = SDGMenuViewModel()

  var selectedMenuItemID: String {
    navigationPath.last?.itemID ?? SDGMenuViewModel.overviewItemID
  }
  
  func presentMenu() {
    menuViewModel.selectItem(id: selectedMenuItemID)
    isMenuPresented = true
  }
  
  func dismissMenu() {
    isMenuPresented = false
  }
  
  func navigate(to route: SDGMenuRoute) {
    switch route {
    case .overview:
      navigationPath = []
      menuViewModel.selectItem(id: SDGMenuViewModel.overviewItemID)
    case .demo(let itemID, let viewID):
      navigationPath = [.demo(itemID: itemID, viewID: viewID)]
      menuViewModel.selectItem(id: itemID)
    }
  }
}

struct SDGListView: View {
  let title: String
  let description: String?
  let subDescription: String?
  let items: [SDGItem]
  let isRoot: Bool
  
  init(title: String, description: String?, subDescription: String?, items: [SDGItem], isRoot: Bool = false) {
    self.title = title
    self.description = description
    self.subDescription = subDescription
    self.items = items
    self.isRoot = isRoot
  }
  
  var body: some View {
    VStack(spacing: 0) {
      if !isRoot { NavigationBar() }
      
      ScrollView {
        VStack(spacing: 0) {
          ComponentTitleView(
            title: title,
            description: description,
            subDescription: subDescription
          )
          
          Divider(color: .neutral700, option: .init(direction: .horizental, thickness: 1))
            .padding(.horizontal, 20)
          
          VStack(spacing: 8) {
            ForEach(items) { sectionItem in
              VStack(alignment: .leading, spacing: 8) {
                SectionHeaderView(item: sectionItem)
                  .padding(.top, 20)
                
                if let children = sectionItem.children {
                  ForEach(children) { childItem in
                    if childItem.children != nil {
                      NavigationLink {
                        SDGListView(
                          title: sectionItem.title,
                          description: childItem.description,
                          subDescription: childItem.subDescription,
                          items: [childItem],
                          isRoot: false
                        )
                      } label: {
                        RowView(item: childItem)
                      }
                    } else {
                      NavigationLink {
                        SDGDetailView(item: childItem)
                      } label: {
                        RowView(item: childItem)
                      }
                    }
                  }
                }
              }
            }
          }
          .padding(.top, 8)
          .padding(.horizontal, 20)
        }
      }
      .toolbar(.hidden, for: .navigationBar)
    }
  }
}

// MARK: - Subviews

struct RowView: View {
  let item: SDGItem
  
  var body: some View {
    VStack {
      Text(sdg: item.title)
        .typo(.title2_SB, .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(height: 42)
  }
}

struct SectionHeaderView: View {
  let item: SDGItem
  
  var body: some View {
    Text(sdg: item.title)
      .typo(.body2_SB, .neutral350)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct SDGDetailView: View {
  let item: SDGItem
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar()
      ScrollView {
        VStack(spacing: 0) {
          ComponentTitleView(
            title: item.title,
            description: item.description,
            subDescription: item.subDescription
          )
        }
        
        Divider(color: .neutral700, option: .init(direction: .horizental, thickness: 1))
          .padding(.horizontal, 20)
        
        if let viewID = item.viewID {
          SDGViewRegistry.shared.build(id: viewID)
        } else {
          Text(sdg: "View ID가 없습니다.")
        }
      }
    }
    .toolbar(.hidden, for: .navigationBar)
  }
}

struct NavigationBar: View {
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    SDGBasicNavi(
      naviType: .pop(
        tintColor: .neutral700,
        onDismiss: {
          dismiss()
        }
      ),
      title: nil,
      backgroundColor: .neutral0
    )
  }
}

struct ComponentTitleView: View {
  let title: String
  let description: String?
  let subDescription: String?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(sdg: title)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.system(size: 24, weight: .bold))
        .foregroundStyle(.neutral700)
      
      if let description {
        Text(sdg: description)
          .frame(maxWidth: .infinity, alignment: .leading)
          .typo(.body3_SB, .neutral700)
      }
      
      if let subDescription {
        Text(sdg: subDescription)
          .frame(maxWidth: .infinity, alignment: .leading)
          .typo(.body3_R, .neutral400)
      }
    }
    .padding(.top, 10)
    .padding([.leading, .trailing, .bottom], 20)
  }
}

// MARK: - Preview
#Preview {
  AppView()
}
