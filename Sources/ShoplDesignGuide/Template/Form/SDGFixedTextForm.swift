//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

public struct SDGFixedTextForm: View {
  @Binding private var text: String
  @Binding private var isFocused: Bool
  @Binding private var isError: String?
  
  private let title: String
  
  private let icon: FormIconModel?
  private let type: FormType
  
  private let placeHolder: String?
  private let backgroundColor: Color
  private let maxCharacterCount: Int?
  private let inputViewHeight: CGFloat
  
  private let isRequiered: Bool
  
  private let onRefresh: () -> Void
  
  public init(
    title: String,
    icon: FormIconModel? = nil,
    type: FormType,
    text: Binding<String>,
    placeHolder: String?,
    backgroundColor: Color,
    maxCharacterCount: Int? = nil,
    isFocused: Binding<Bool>,
    inputViewHeight: CGFloat = 94,
    isRequiered: Bool = false,
    onRefresh: @escaping () -> Void,
    isError: Binding<String?> = .constant(nil)
  ) {
    self.title = title
    self.icon = icon
    self.type = type
    self._text = text
    self.placeHolder = placeHolder
    self.backgroundColor = backgroundColor
    self.maxCharacterCount = maxCharacterCount
    self._isFocused = isFocused
    self.inputViewHeight = inputViewHeight
    self.isRequiered = isRequiered
    self.onRefresh = onRefresh
    self._isError = isError
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
        
        if let icon = icon {
          
          Button {
            icon.onImageTap?()
          } label: {
            ZStack {
              icon.image
                .resizable()
                .foregroundStyle(icon.tintColor)
                .frame(width: 14, height: 14)
                .padding(.vertical, 3)
                .padding(.leading, 4)
                .padding(.trailing, 8)
            }
          }
          .buttonStyle(NoTapAnimationButtonStyle())
        }
        
        Spacer(minLength: 8)
        
        if !text.isEmpty && !isRequiered {
          
          Button {
            
            onRefresh()
            
          } label: {
            ZStack {
              
              Image(sdg: .icCommonRefresh)
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
      
      SDGFixedTextInput(
        type: .solid,
        text: self.$text,
        placeHolder: self.placeHolder,
        backgroundColor: self.backgroundColor,
        maxCharacterCount: self.maxCharacterCount,
        isFocused: self.$isFocused,
        inputViewHeight: self.inputViewHeight,
        isError: self.$isError
      )
      
    }
  }
}

#Preview {
  VStack {
    SDGFixedTextForm(
      title: "타이틀",
      icon: .init(image: Image(sdg: .icClip), tintColor: .neutral500),
      type: .normal,
      text: .constant("awdawdad"),
      placeHolder: "입력",
      backgroundColor: .neutral50,
      maxCharacterCount: 5000,
      isFocused: .constant(false),
      inputViewHeight: 94,
      isRequiered: false,
      onRefresh: { },
      isError: .constant(nil)
    )
    
    SDGFixedTextForm(
      title: "타이틀",
      icon: .init(image: Image(sdg: .icClip), tintColor: .neutral500),
      type: .normal,
      text: .constant("입력입력입력"),
      placeHolder: "입력",
      backgroundColor: .neutral50,
      maxCharacterCount: 5000,
      isFocused: .constant(false),
      inputViewHeight: 94,
      isRequiered: true,
      onRefresh: { },
      isError: .constant(nil)
    )
    
    SDGFixedTextForm(
      title: "타이틀",
      icon: .init(image: Image(sdg: .icClip), tintColor: .neutral500),
      type: .normal,
      text: .constant(""),
      placeHolder: "입력",
      backgroundColor: .neutral50,
      maxCharacterCount: 5000,
      isFocused: .constant(false),
      inputViewHeight: 94,
      isRequiered: true,
      onRefresh: { },
      isError: .constant("에러 에러에러에러에러에러에러에러에러에러에러")
    )
  }
  .padding(20)
}
