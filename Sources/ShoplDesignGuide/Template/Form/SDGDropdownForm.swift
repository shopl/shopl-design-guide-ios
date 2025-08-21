//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

public struct SDGDropdownForm: View {
  
  public enum `Type` {
    case empha
    case normal
  }
  
  private let title: String
  private let titleImage: Image?
  private let type: `Type`
  private let selectedText: String?
  private let placeHolder: String
  
  private let onImageTap: (() -> Void)?
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
    titleImage: Image? = nil,
    type: `Type`,
    selectedText: String?,
    placeHolder: String,
    onImageTap: (() -> Void)? = nil,
    onRefresh: @escaping () -> Void,
    onSelect: @escaping () -> Void
  ) {
    self.title = title
    self.titleImage = titleImage
    self.type = type
    self.selectedText = selectedText
    self.placeHolder = placeHolder
    self.onImageTap = onImageTap
    self.onRefresh = onRefresh
    self.onSelect = onSelect
  }
  
  public var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 0) {
        Text(title)
          .typo(self.type == .empha ? .body1_SB : .body1_R, .neutral700)
        
        if let titleImage = titleImage {
          
          Button {
            onImageTap?()
          } label: {
            ZStack {
              titleImage
                .resizable()
                .frame(width: 14, height: 14)
                .padding(.vertical, 3)
                .padding(.leading, 4)
                .padding(.trailing, 8)
            }
          }
          .buttonStyle(NoTapAnimationButtonStyle())
        }
        
        Spacer(minLength: 8)
        
        if isSelected {
          
          Button {
            
            onRefresh()
            
          } label: {
            ZStack {
              
              Image(.icCommonRefresh)
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
            
            Image(.icCommonDropdown)
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
    SDGDropdownForm(
      title: "타이틀",
      type: .empha,
      selectedText: nil,
      placeHolder: "입력",
      onRefresh: { },
      onSelect: { }
    )
    
    SDGDropdownForm(
      title: "타이틀",
      titleImage: Image(.icCommonEdit),
      type: .empha,
      selectedText: nil,
      placeHolder: "입력",
      onRefresh: { },
      onSelect: { }
    )
    
    SDGDropdownForm(
      title: "타이틀",
      titleImage: Image(.icCommonEdit),
      type: .empha,
      selectedText: "입력했음",
      placeHolder: "입력",
      onRefresh: { },
      onSelect: { }
    )
  }
  .padding(20)
}
