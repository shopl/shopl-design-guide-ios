//
//  DSData.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/27/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

class DSData {
  static let menu: [DSItem] = [
    
    // MARK: - Foundation
    .category(
      title: "Foundation",
      description: "디자인 시스템의 기본 요소",
      subDescription: "Color, Typography, Icons",
      children: [
        .item(
          title: "Color",
          description: "SDG의 컬러 팔레트",
          subDescription: "일관된 브랜드 경험을 만들 수 있도록 표준 색상 차트와 사용자 가이드를 제공합니다. 사용자가 서비스의 메시지를 명확하게 이해할 수 있도록 의도적으로 색상을 적용합니다.",
          viewID: "foundation_color"
        ),
        .item(
          title: "Typography",
          description: "SDG의 폰트 스타일",
          subDescription: "정의된 유형, 규모, 색상을 고려하여 적용된 타이포그래피는 콘텐츠의 중요도를 분류하고, 전체 텍스트의 균형을 맞춥니다.",
          viewID: "foundation_typo"
        ),
      ]
    ),
    
    // MARK: - Component
    .category(
      title: "Component",
      description: nil,
      subDescription: nil,
      children: [
        .category(
          title: "Button",
          description: nil,
          subDescription: nil,
          children: [
            .item(
              title: "Bottom Button",
              description: "유저의 행동 유도 또는 명확한 선택을 하기 위한 가장 강조되는 버튼 컴포넌트",
              subDescription: "화면 하단에 플로팅 형태의 Fill로 배치됩니다.",
              viewID: "component_bottom_button"
            ),
            .item(
              title: "Box Button",
              description: "옵션 조작을 위한 상자 형태의 가장 일반적인 버튼 컴포넌트",
              subDescription: "메인 액션에 대한 부가적인 행동이나, 한 페이지 내에 다양한 기능을 담아야 할 때 콘텐츠 영역 또는 화면 하단에 배치됩니다.",
              viewID: "component_box_button"
            ),
            .item(
              title: "Capsule Button",
              description: "옵션 조작을 위한 캡슐 형태의 버튼 컴포넌트",
              subDescription: "메인 액션에 대한 부가적인 행동이나, 한 페이지 내에 다양한 기능을 담아야 할 때 콘텐츠 영역 또는 화면 하단에 배치됩니다.",
              viewID: "component_capsule_button"
            ),
            .item(
              title: "Floating Button",
              description: "추가/작성/생성 등의 행동을 수행하는 버튼 컴포넌트",
              subDescription: "화면의 모든 콘텐츠 최상단에 표시되며, 중앙에 아이콘이 포함된 원형 모양으로 우측 하단에 배치됩니다.",
              viewID: "component_floating_button"
            ),
            .item(
              title: "Icon Button",
              description: "직관적인 아이콘으로 행동을 수행할 수 있는 버튼 컴포넌트",
              subDescription: "공간이 충분하지 않거나, 이해하기 쉬운 직관적인 아이콘인 경우 라벨 없이 사용하는 버튼으로 콘텐츠 영역에 배치됩니다.",
              viewID: "component_icon_button"
            )
          ]
        )
      ]
    )
  ]
}
