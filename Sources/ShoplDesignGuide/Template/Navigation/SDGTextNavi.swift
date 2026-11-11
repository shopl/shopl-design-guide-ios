//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

/// 화면 상단에 한 줄 타이틀과 화면 이동, 우측 실행 기능을 제공하는 내비게이션입니다.
/// 긴 타이틀은 말줄임하고 우측 액션을 우선 표시합니다. 액션 자체가 가용 폭을 넘으면 말줄임합니다.
public struct SDGTextNavi: View {
  /// 적용한 Text Navi 컴포넌트 디자인 가이드 버전입니다.
  public static let version = "2.3.53"
  
  /// 내비게이션 구성입니다. 동등 비교는 표시 값만 비교하며 콜백 변경은 비교하지 않습니다.
  /// `.search`의 AnyView는 비교할 수 없어 기존처럼 항상 비동등으로 처리합니다.
  public enum NaviType: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case (.full(let lhsLeft, let lhsTitle, let lhsRight), .full(let rhsLeft, let rhsTitle, let rhsRight)):
        return lhsLeft == rhsLeft && lhsTitle == rhsTitle && lhsRight == rhsRight
      case (.back(_, let lhsTitle, let lhsRight), .back(_, let rhsTitle, let rhsRight)):
        return lhsTitle == rhsTitle && lhsRight == rhsRight
      case (.text(let lhsTitle, let lhsRight), .text(let rhsTitle, let rhsRight)):
        return lhsTitle == rhsTitle && lhsRight == rhsRight
      default:
        return false
      }
    }
    
    public struct Left: Equatable {
      public static func == (lhs: Self, rhs: Self) -> Bool {
        let image = lhs.image == rhs.image
        let color = lhs.color == rhs.color
        
        return image && color
      }
      
      let image: Image
      let color: Color
      let action: () -> Void
      
      public init(
        image: Image,
        color: Color? = nil,
        action: @escaping () -> Void
      ) {
        self.image = image
        if let color = color {
          self.color = color
        } else {
          self.color = .neutral700
        }
        self.action = action
      }
    }
    
    /// 한 줄로 표시하는 타이틀과 색상입니다. 빈 문자열로 타이틀을 생략할 수 있습니다.
    public struct Title: Equatable {
      let text: String
      let color: Color
      
      /// - Parameters:
      ///   - text: 타이틀 문구. 영역을 넘으면 끝을 말줄임합니다.
      ///   - color: 타이틀 색상. nil이면 Neutral/900을 사용합니다.
      public init(text: String, color: Color? = nil) {
        self.text = text
        
        if let color = color {
          self.color = color
        } else {
          self.color = .neutral900
        }
      }
    }
    
    /// 선택적 아이콘과 짧은 액션 문구를 하나의 버튼으로 묶습니다.
    public struct Right: Equatable {
      public static func == (lhs: Self, rhs: Self) -> Bool {
        let image = lhs.image == rhs.image
        let color = lhs.color == rhs.color
        let title = lhs.text == rhs.text
        
        return image && color && title
      }
      
      let image: Image?
      let text: String
      let color: Color
      let action: () -> Void
      
      /// - Parameters:
      ///   - image: 문구 왼쪽의 20×20pt 아이콘. nil이면 표시하지 않습니다.
      ///   - text: 타이틀보다 우선 표시할 짧은 동사형 문구. 액션 자체가 가용 폭을 넘으면 말줄임합니다.
      ///   - color: 아이콘과 문구 색상. nil이면 Neutral/700을 사용합니다.
      ///   - action: 액션 버튼을 누를 때 실행할 콜백입니다.
      public init(
        image: Image?,
        text: String,
        color: Color? = nil,
        action: @escaping () -> Void
      ) {
        self.image = image
        self.text = text
        if let color = color {
          self.color = color
        } else {
          self.color = .neutral700
        }
        self.action = action
      }
    }
    
    case full(left: Left, title: Title, right: Right?)
    case back(back: () -> Void, title: Title, right: Right?)
    case text(title: Title, right: Right?)
    case search(back: () -> Void, view: AnyView)
  }
  
  
  private struct LeftItem {
    let image: Image
    var color: Color
    let action: () -> Void
    let resizesImage: Bool
    let usesBackColor: Bool
  }

  // 입력 API의 차이는 여기서 흡수하고, 각 아이템은 아래 공통 뷰에서 한 번만 그립니다.
  private struct Items {
    var left: LeftItem?
    var title: NaviType.Title?
    var right: NaviType.Right?
    var search: AnyView?
    var rightVerticalPadding: CGFloat = 0
  }

  private var items: Items
  private let backgroundColor: Color

  /// 기존 구성·여백·아이콘 생략·콜백 동작을 유지하는 호환 초기화 함수입니다.
  /// - Parameters:
  ///   - naviType: 좌측 요소, 타이틀, 우측 액션 구성. 버튼을 누르면 전달한 콜백을 실행합니다.
  ///   - backgroundColor: 배경색. 기본 디자인은 Neutral/100이며 투명색도 사용할 수 있습니다.
  @available(*, deprecated, message: "새 Text Navi는 init(model:onBack:onAction:)을 사용하세요. 기존 full/text/search 구성은 이 호환 API에서 유지됩니다.")
  public init(naviType: NaviType, backgroundColor: Color) {
    switch naviType {
    case .full(let left, let title, let right):
      items = Items(
        left: LeftItem(image: left.image, color: left.color, action: left.action,
                       resizesImage: true, usesBackColor: false),
        title: title, right: right
      )
    case .back(let back, let title, let right):
      items = Items(
        left: LeftItem(image: Image(sdg: .icNaviBack), color: .neutral700, action: back,
                       resizesImage: false, usesBackColor: true),
        title: title, right: right, rightVerticalPadding: 14
      )
    case .text(let title, let right):
      items = Items(title: title, right: right)
    case .search(let back, let view):
      items = Items(
        left: LeftItem(image: Image(sdg: .icNaviBack), color: .neutral700, action: back,
                       resizesImage: false, usesBackColor: true),
        search: view
      )
    }
    self.backgroundColor = backgroundColor
  }

  /// 기본 뒤로가기 아이콘의 색상을 지정합니다. 진한 배경에서는 Neutral/0을 사용할 수 있습니다.
  /// - Parameter color: 기존 `.back`·`.search` 및 새 Model 구성의 뒤로가기 색상입니다.
  ///   `.full`의 사용자 지정 좌측 아이콘에는 적용하지 않습니다. 새 API에서는 Model.backColor를 사용합니다.
  /// - Returns: 뒤로가기 색상을 적용한 내비게이션입니다.
  public func backButtonColor(_ color: Color) -> Self {
    var view = self
    if view.items.left?.usesBackColor == true {
      view.items.left?.color = color
    }
    return view
  }

  /// Model 값은 호출 화면에서 소유하며 버튼을 누를 때 해당 콜백만 실행합니다.
  /// - Parameters:
  ///   - model: Figma 표시 설정, 콘텐츠와 색상입니다.
  ///   - onBack: 뒤로가기 버튼을 누를 때 실행합니다.
  ///   - onAction: 우측 아이콘·문구로 구성된 단일 버튼을 누를 때 실행합니다.
  public init(model: Model, onBack: @escaping () -> Void, onAction: @escaping () -> Void) {
    items = Items(
      left: LeftItem(image: model.backIc, color: model.backColor, action: onBack,
                     resizesImage: true, usesBackColor: true),
      // 숨긴 타이틀도 기존 빈 타이틀과 같은 폭 협상을 유지해 긴 액션의 크기가 달라지지 않게 합니다.
      title: .init(text: model.showLabel ? model.label : "", color: model.labelColor),
      right: .init(image: model.showActionIc ? model.actionIc : nil,
                   text: model.actionLabel, color: model.actionColor, action: onAction)
    )
    backgroundColor = model.backgroundColor
  }

  public var body: some View {
    HStack(spacing: 0) {
      if let left = items.left {
        leftButton(left)
      }
      if let search = items.search {
        search
      } else {
        if let title = items.title {
          titleLabel(title)
        } else {
          Spacer(minLength: 0)
        }
        if let right = items.right {
          actionButton(right)
        }
      }
    }
    .frame(height: 48)
    .background(backgroundColor)
  }

  private func leftButton(_ item: LeftItem) -> some View {
    Button(action: item.action) {
      // 기존 back/search는 원본 에셋, full은 리사이즈한 이미지를 사용하던 동작을 유지합니다.
      (item.resizesImage ? item.image.resizable() : item.image)
        .frame(width: 40, height: 40)
        .foregroundColor(item.color)
    }
    .layoutPriority(items.search == nil ? 2 : 0)
    .padding(.leading, 10)
  }

  private func titleLabel(_ item: NaviType.Title) -> some View {
    Text(item.text)
      .typo(.naviTitle)
      .foregroundColor(item.color)
      .lineLimit(1)
      .truncationMode(.tail)
      .frame(height: 24)
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, items.left == nil ? 16 : 2)
      .padding(.trailing, items.right == nil ? 10 : 0)
  }

  private func actionButton(_ item: NaviType.Right) -> some View {
    Button(action: item.action) {
      HStack(spacing: 0) {
        if let image = item.image {
          image
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(item.color)
        }
        Text(item.text)
          .typo(.body1_R)
          .foregroundColor(item.color)
          .lineLimit(1)
          .truncationMode(.tail)
          .frame(height: 20)
      }
    }
    .layoutPriority(1)
    .padding(.leading, 8)
    .padding(.trailing, 16)
    .padding(.vertical, items.rightVerticalPadding)
  }
}


#Preview {
  SDGTextNavi(
    model: .init(showLabel: true, label: "타이틀", showActionIc: true,
                 actionLabel: "저장", actionIc: Image(sdg: .icCommonCompany)),
    onBack: {}, onAction: {}
  )
}
