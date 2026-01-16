//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

public struct SDGSelectForm: View {
  
  private let title: String
  private let iconList: [FormIconModel]?
  private let type: FormType
  private let selectedText: String?
  private let placeHolder: String
  private let isRequiered: Bool
  
  private let onRefresh: () -> Void
  private let onSelect: () -> Void
  
  private var text: String {
    if let selectedText = selectedText,
       !selectedText.isBlank {
      return selectedText
    }
    
    return placeHolder
  }
  
  private var isSelected: Bool {
    return !(selectedText?.isBlank ?? true)
  }
  
  public init(
    title: String,
    iconList: [FormIconModel]? = nil,
    type: FormType,
    selectedText: String?,
    placeHolder: String,
    isRequiered: Bool = false,
    onImageTap: (() -> Void)? = nil,
    onRefresh: @escaping () -> Void,
    onSelect: @escaping () -> Void
  ) {
    self.title = title
    self.iconList = iconList
    self.type = type
    self.selectedText = selectedText
    self.placeHolder = placeHolder
    self.isRequiered = isRequiered
    self.onRefresh = onRefresh
    self.onSelect = onSelect
  }
  
  public var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 0) {
        Text("")
          .attributeText(
            fullText: isRequiered ? "\(title)*" : title,
            defaultFont: self.type == .empha ? .system(size: 16, weight: .semibold) : .system(size: 16),
            defaultColor: .neutral700,
            highlights: [
              .init(
                word: "*",
                font: .system(size: 16),
                color: .red300,
                underline: false
              )
            ]
          )
          .typo(self.type == .empha ? .body1_SB : .body1_R, .neutral700)
          .frame(minHeight: 28, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
        
        if let iconList = iconList,
           !iconList.isEmpty {
          
          HStack(spacing: 0) {
            ForEach(iconList.indices, id: \.self) { index in
              let icon = iconList[index]
              
              Button {
                icon.onImageTap?()
              } label: {
                ZStack {
                  icon.image
                    .resizable()
                    .foregroundStyle(icon.tintColor)
                    .frame(width: 14, height: 14)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 4)
                }
              }
              .buttonStyle(NoTapAnimationButtonStyle())
            }
          }
        }
        
        Spacer(minLength: 8)
        
        if isSelected && !isRequiered {
          
          Button {
            
            onRefresh()
            
          } label: {
            ZStack {
              
              Image(sdg: .icCommonRefresh)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(.neutral400)
                .frame(width: 24, height: 24)
                .padding(2)
              
            }
            .background(.neutral50)
            .cornerRadius(14)
          }
        }
      }
      
      Button {
        
        onSelect()
        
      } label: {
       
        ZStack {
          
          HStack(spacing: 10) {
            
            Text(text)
              .typo(.body1_R, isSelected ? .neutral700 : .neutral300)
              .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(sdg: .icCommonNext)
              .resizable()
              .foregroundStyle(.neutral700)
              .frame(width: 20, height: 20)
              
          }
          .padding(.vertical, 10)
          .padding(.horizontal, 12)
          
        }
        .background(.neutral50)
        .cornerRadius(12)
        
      }
      .buttonStyle(NoTapAnimationButtonStyle())
    }
  }
}

#Preview {
  VStack {
    SDGSelectForm(
      title: "타이틀",
      type: .empha,
      selectedText: nil,
      placeHolder: "입력",
      onRefresh: { },
      onSelect: { }
    )
    
    SDGSelectForm(
      title: "타이틀",
      iconList: [FormIconModel(image: Image(sdg: .icCommonEdit), tintColor: .neutral400)],
      type: .empha,
      selectedText: nil,
      placeHolder: "입력",
      isRequiered: true,
      onRefresh: { },
      onSelect: { }
    )
    
    SDGSelectForm(
      title: "타이틀",
      iconList: [FormIconModel(image: Image(sdg: .icCommonEdit), tintColor: .neutral600)],
      type: .empha,
      selectedText: "입력했음",
      placeHolder: "입력",
      isRequiered: true,
      onRefresh: { },
      onSelect: { }
    )
    
    SDGSelectForm(
      title: "타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 ",
      type: .empha,
      selectedText: "입력했음",
      placeHolder: "입력",
      isRequiered: true,
      onRefresh: { },
      onSelect: { }
    )
    
    SDGSelectForm(
      title: "타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 타이틀 ",
      iconList: [
        FormIconModel(image: Image(sdg: .icCommonEdit), tintColor: .neutral600),
        FormIconModel(image: Image(sdg: .icClip), tintColor: .neutral600)
      ],
      type: .empha,
      selectedText: "입력했음",
      placeHolder: "입력",
      onRefresh: { },
      onSelect: { }
    )
  }
  .padding(20)
}

