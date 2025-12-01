//
//  SDGBoxButtonDemoView.swift
//  ShoplDesignGuide
//
//  Created by Dino on 12/1/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

import ShoplDesignGuide

struct SDGBoxButtonDemoView: View {
  
  private let tabs = ["Default", "Pressed", "Disabled"]
  
  var body: some View {
    DemoViewTabContainer(tabs: tabs) { selectedTab in
      switch selectedTab {
      case "Default":
        DefaultView()
      case "Pressed":
        PressedView()
      case "Disabled":
        DisabledView()
      default:
        UnimplementedTabPlaceholder(tabName: selectedTab)
      }
    }
  }
}

private struct DefaultView: View {  
  var body: some View {
    VStack(spacing: 40) {
      VStack(spacing: 20) {
        Text("Medium")
          .typo(.body3_SB, .neutral500)
        
        SDGBoxButton(
          option: .init(
            size: .medium,
            title: "Label",
            color: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            ),
            selectedColor: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            )
          ),
          isSelected: .constant(false),
          isLoading: .constant(false)
        ) { }
        
        SDGBoxButton(
          option: .init(
            size: .medium,
            icon: .right(image: Image.icons, color: .neutral300),
            title: "Label",
            color: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            ),
            selectedColor: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            )
          ),
          isSelected: .constant(false),
          isLoading: .constant(false)
        ) { }
        
        SDGBoxButton(
          option: .init(
            size: .medium,
            icon: .left(image: Image.icons, color: .neutral300),
            title: "Label",
            color: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            ),
            selectedColor: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            )
          ),
          isSelected: .constant(false),
          isLoading: .constant(false)
        ) { }
      }
      
      VStack(spacing: 20) {
        Text("Small")
          .typo(.body3_SB, .neutral500)
        
        SDGBoxButton(
          option: .init(
            size: .small,
            title: "Label",
            color: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            ),
            selectedColor: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            )
          ),
          isSelected: .constant(false),
          isLoading: .constant(false)
        ) { }
        
        SDGBoxButton(
          option: .init(
            size: .small,
            icon: .right(image: Image.icons, color: .neutral300),
            title: "Label",
            color: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            ),
            selectedColor: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            )
          ),
          isSelected: .constant(false),
          isLoading: .constant(false)
        ) { }
              
        SDGBoxButton(
          option: .init(
            size: .small,
            icon: .left(image: Image.icons, color: .neutral300),
            title: "Label",
            color: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            ),
            selectedColor: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            )
          ),
          isSelected: .constant(false),
          isLoading: .constant(false)
        ) { }
      }
      
      VStack(spacing: 20) {
        Text("Small")
          .typo(.body3_SB, .neutral500)
        
        SDGBoxButton(
          option: .init(
            size: .xsmall,
            title: "Label",
            color: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            ),
            selectedColor: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            )
          ),
          isSelected: .constant(false),
          isLoading: .constant(false)
        ) { }
        
        SDGBoxButton(
          option: .init(
            size: .xsmall,
            icon: .right(image: Image.icons, color: .neutral300),
            title: "Label",
            color: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            ),
            selectedColor: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            )
          ),
          isSelected: .constant(false),
          isLoading: .constant(false)
        ) { }
              
        SDGBoxButton(
          option: .init(
            size: .xsmall,
            icon: .left(image: Image.icons, color: .neutral300),
            title: "Label",
            color: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            ),
            selectedColor: .init(
              backgroundColor: .neutral200,
              textColor: .neutral600
            )
          ),
          isSelected: .constant(false),
          isLoading: .constant(false)
        ) { }
      }
    }
  }
}


// 이 클래스는 오직 번들을 찾기 위해 존재합니다.
private class SampleBundleFinder {}

extension Foundation.Bundle {
    /// 샘플 앱의 리소스 번들을 가리키는 정적 변수
    static let sampleApp: Bundle = Bundle(for: SampleBundleFinder.self)
}

private struct PressedView: View {
  var body: some View {
  }
}


private struct DisabledView: View {
  var body: some View {
  }
}

#Preview {
  SDGBoxButtonDemoView()
}
