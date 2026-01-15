//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/22/25.
//

import SwiftUI

public struct SDGTimeSelectForm: View {
  
  private let title: String
  private let icon: FormIconModel?
  private let type: FormType
  @Binding private var status: SDGTimeSelectInput.Status
  private let startTime: String?
  private let endTime: String?
  private let startPlaceHolder: String
  private let endPlaceHolder: String
  private let isRequiered: Bool
  @Binding private var disabled: Bool
  
  private let onRefresh: () -> Void
  private let onSelect: () -> Void
  
  private var isSelected: Bool {
    return !((startTime?.isBlank ?? true) && (endTime?.isBlank ?? true))
  }
  
  public init(
    title: String,
    icon: FormIconModel? = nil,
    type: FormType,
    status: Binding<SDGTimeSelectInput.Status>,
    startTime: String?,
    endTime: String?,
    startPlaceHolder: String,
    endPlaceHolder: String,
    isRequiered: Bool = false,
    disabled: Binding<Bool> = .constant(false),
    onRefresh: @escaping () -> Void,
    onSelect: @escaping () -> Void
  ) {
    self.title = title
    self.icon = icon
    self.type = type
    self._status = status
    self.startTime = startTime
    self.endTime = endTime
    self.startPlaceHolder = startPlaceHolder
    self.endPlaceHolder = endPlaceHolder
    self.isRequiered = isRequiered
    self._disabled = disabled
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
        
        if isSelected && !isRequiered {
          
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
      
      Button {
        onSelect()
      } label: {
        
        SDGTimeSelectInput(
          status: $status,
          startTime: startTime,
          endTime: endTime,
          startPlaceholder: startPlaceHolder,
          endPlaceholder: endPlaceHolder
        )
      }
      .buttonStyle(NoTapAnimationButtonStyle())
    }
  }
}

#Preview {
  VStack {
    SDGTimeSelectForm(
      title: "타이틀",
      icon: .init(image: Image(sdg: .avatarEmpty), tintColor: .neutral500),
      type: .empha,
      status: .constant(.default),
      startTime: nil,
      endTime: nil,
      startPlaceHolder: "시간",
      endPlaceHolder: "시간",
      onRefresh: { },
      onSelect: { }
    )
    
    SDGTimeSelectForm(
      title: "타이틀",
      icon: .init(image: Image(sdg: .avatarEmpty), tintColor: .neutral500),
      type: .empha,
      status: .constant(.default),
      startTime: "1:11",
      endTime: "2:22",
      startPlaceHolder: "시간",
      endPlaceHolder: "시간",
      onRefresh: { },
      onSelect: { }
    )
    
    SDGTimeSelectForm(
      title: "타이틀",
      icon: .init(image: Image(sdg: .avatarEmpty), tintColor: .neutral500),
      type: .empha,
      status: .constant(.error(" 시간입력 오류  시간입력 오류 시간입력 오류 시간입력 오류 시간입력 오류 시간입력 오류 ")),
      startTime: "1:11",
      endTime: "2:22",
      startPlaceHolder: "시간",
      endPlaceHolder: "시간",
      onRefresh: { },
      onSelect: { }
    )
  }
  .padding(20)
}
