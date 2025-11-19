//
//  SDGSegment.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGSegment: View {
  
  public enum SegmentedControlStyle {
    /// 부모 뷰의 전체 너비를 차지하고 1/n로 너비를 나눕니다.
    case fixed
    /// 텍스트 길이에 맞춰 동적으로 너비가 조절됩니다.
    case dynamic
  }
  
  public enum TextLine: CGFloat {
    case one = 32
    case two = 50
    
    var numberOfLines: Int {
      switch self {
      case .one: return 1
      case .two: return 2
      }
    }
  }
  
  private struct Constants {
    static let trackCornerRadius: CGFloat = 12
    static let thumbCornerRadius: CGFloat = 8
    
    struct Dynamic {
      static let trackPadding: CGFloat = 4
      static let segmentSpacing: CGFloat = 4
      static let textInternalPadding: CGFloat = 8
    }
    
    struct Fixed {
      static let thumbOuterPadding: CGFloat = 4
      static let thumbSpacing: CGFloat = 4
      static let textOuterPadding: CGFloat = 8
      static let textSpacing: CGFloat = 12
    }
  }
  
  @Binding var selectedSegmentIndex: Int
  private let textLine: TextLine
  private let items: [String]
  private let style: SegmentedControlStyle
  
  private let trackColor: Color = .neutral100
  private let thumbColor: Color = .neutral0
  private let selectedTextColor: TypoColor = .neutral700
  private let unselectedTextColor: TypoColor = .neutral500
  
  @Namespace private var segmentNamespace
  
  public init(
    selectedSegmentIndex: Binding<Int>,
    textLine: TextLine,
    items: [String],
    style: SegmentedControlStyle = .fixed
  ) {
    self._selectedSegmentIndex = selectedSegmentIndex
    self.textLine = textLine
    self.items = items
    self.style = style
  }
  
  public var body: some View {
    ZStack {
      if style == .fixed {
        fixedWidthBody
      } else {
        dynamicWidthBody
      }
    }
  }
  
  private var dynamicWidthBody: some View {
    GeometryReader { geo in
      ZStack {
        // 배경
        RoundedRectangle(cornerRadius: Constants.trackCornerRadius)
          .fill(trackColor)
        
        // 선택 썸
        RoundedRectangle(cornerRadius: Constants.thumbCornerRadius)
          .fill(thumbColor)
          .shadow(color: .black.opacity(0.05), radius: 4, x: 1, y: 1)
          .matchedGeometryEffect(id: "\(selectedSegmentIndex)", in: segmentNamespace, isSource: false)
          .frame(height: textLine.rawValue)
          .padding(.horizontal, Constants.Dynamic.textInternalPadding)
          .padding(Constants.Dynamic.trackPadding)
        
        HStack(spacing: Constants.Dynamic.segmentSpacing) {
          ForEach(items.indices, id: \.self) { index in
            // 타이틀
            Text(items[index])
              .typo(.body2_R, selectedSegmentIndex == index ? selectedTextColor : unselectedTextColor)
              .lineLimit(textLine.numberOfLines)
              .padding(.horizontal, Constants.Dynamic.textInternalPadding)
              .frame(height: textLine.rawValue)
              .multilineTextAlignment(.center)
              .matchedGeometryEffect(id: "\(index)", in: segmentNamespace)
              .contentShape(Rectangle())
              .onTapGesture {
                withAnimation(.easeInOut(duration: 0.25)) {
                  self.selectedSegmentIndex = index
                }
              }
              .background(.clear)
          }
        }
        .padding(Constants.Dynamic.trackPadding)
        .frame(maxWidth: geo.size.width)
        .frame(height: textLine.rawValue + (Constants.Dynamic.trackPadding * 2))
      }
      .fixedSize(horizontal: true, vertical: false)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    .frame(height: textLine.rawValue + (Constants.Dynamic.trackPadding * 2))
  }
  
  private var fixedWidthBody: some View {
    GeometryReader { geo in
      let width = geo.size.width
      let itemsCount = CGFloat(items.count)
      
      let totalThumbOuterPadding = Constants.Fixed.thumbOuterPadding * 2
      let totalThumbSpacing = Constants.Fixed.thumbSpacing * (itemsCount - 1)
      let totalHorizontalSpacingForThumb = totalThumbOuterPadding + totalThumbSpacing
      let segmentWidth = (width - totalHorizontalSpacingForThumb) / itemsCount
      
      let segmentStepWidth = segmentWidth + Constants.Fixed.thumbSpacing
      
      ZStack(alignment: .leading) {
        // 배경
        RoundedRectangle(cornerRadius: Constants.trackCornerRadius)
          .fill(trackColor)
        
        // 선택 썸
        RoundedRectangle(cornerRadius: Constants.thumbCornerRadius)
          .fill(thumbColor)
          .frame(width: segmentWidth, height: textLine.rawValue)
          .offset(x: CGFloat(selectedSegmentIndex) * segmentStepWidth)
          .shadow(color: .black.opacity(0.05), radius: 4, x: 1, y: 1)
          .animation(.easeInOut(duration: 0.25), value: selectedSegmentIndex)
          .padding(Constants.Fixed.thumbOuterPadding)
        
        // 타이틀
        HStack(spacing: Constants.Fixed.textSpacing) {
          ForEach(items.indices, id: \.self) { index in
            Text(items[index])
              .typo(.body2_R, selectedSegmentIndex == index ? selectedTextColor : unselectedTextColor)
              .lineLimit(textLine.numberOfLines)
              .frame(maxWidth: .infinity)
              .multilineTextAlignment(.center)
              .frame(height: textLine.rawValue)
              .contentShape(Rectangle())
              .onTapGesture {
                self.selectedSegmentIndex = index
              }
          }
        }
        .padding(.horizontal, Constants.Fixed.textOuterPadding)
      }
    }
    .frame(height: textLine.rawValue + (Constants.Fixed.thumbOuterPadding * 2))
  }
}

struct SDGSegment_Previews: PreviewProvider {
  
  private struct PreviewWrapper: View {
    @State private var selectionFixedOne = 0
    @State private var selectionFixedTwo = 0
    @State private var selectionDynamicOne = 0
    @State private var selectionDynamicTwo = 0
    
    let optionsOneLine = ["Short", "Medium Length", "A Very Long Option"]
    
    let optionsTwoLine = ["First\nOption", "A Very Long Option A Very Long Option A Very Long Option A Very Long Option", "Third\nOption"]
    
    var body: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          
          // --- 1. Fixed / One Line ---
          Text("Style: .fixed, Line: .one")
            .font(.headline).padding(.leading)
          SDGSegment(
            selectedSegmentIndex: $selectionFixedOne,
            textLine: .one,
            items: optionsOneLine,
            style: .fixed
          )
          .padding(.horizontal)
          
          
          // --- 2. Fixed / Two Line ---
          Text("Style: .fixed, Line: .two")
            .font(.headline).padding(.leading)
          SDGSegment(
            selectedSegmentIndex: $selectionFixedTwo,
            textLine: .two,
            items: optionsTwoLine,
            style: .fixed
          )
          .padding(.horizontal)
          
          
          // --- 3. Dynamic / One Line ---
          Text("Style: .dynamic, Line: .one")
            .font(.headline).padding(.leading)
          SDGSegment(
            selectedSegmentIndex: $selectionDynamicOne,
            textLine: .one,
            items: optionsOneLine,
            style: .dynamic
          )
          .padding(.horizontal)
          
          
          // --- 4. Dynamic / Two Line ---
          Text("Style: .dynamic, Line: .two")
            .font(.headline).padding(.leading)
          SDGSegment(
            selectedSegmentIndex: $selectionDynamicTwo,
            textLine: .two,
            items: optionsTwoLine,
            style: .dynamic
          )
          .padding(.horizontal)
          
          Spacer()
        }
        .padding(.top, 20)
      }
    }
  }
  
  static var previews: some View {
    PreviewWrapper()
  }
}
