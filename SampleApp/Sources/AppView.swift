import SwiftUI
import ShoplDesignGuide

struct AppView: View {
  var body: some View {
    NavigationStack {
      DSListView(
        title: "SDG",
        description: "Shopl Design Guide",
        subDescription: nil,
        items: DSData.menu,
        isRoot: true
      )
    }
  }
}

struct DSListView: View {
  let title: String
  let description: String?
  let subDescription: String?
  let items: [DSItem]
  let isRoot: Bool
  
  init(title: String, description: String?, subDescription: String?, items: [DSItem], isRoot: Bool = false) {
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
                        DSListView(
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
                        DSDetailView(item: childItem)
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
  let item: DSItem
  
  var body: some View {
    VStack {
      Text(item.title)
        .typo(.title2_SB, .neutral700)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(height: 42)
  }
}

struct SectionHeaderView: View {
  let item: DSItem
  
  var body: some View {
    Text(item.title)
      .typo(.body2_SB, .neutral350)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

struct DSDetailView: View {
  let item: DSItem
  
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
          DSViewRegistry.shared.build(id: viewID)
        } else {
          Text("View ID가 없습니다.")
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
      Text(title)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.system(size: 24, weight: .bold))
        .foregroundStyle(.neutral700)
      
      if let description {
        Text(description)
          .frame(maxWidth: .infinity, alignment: .leading)
          .typo(.body3_SB, .neutral700)
      }
      
      if let subDescription {
        Text(subDescription)
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
