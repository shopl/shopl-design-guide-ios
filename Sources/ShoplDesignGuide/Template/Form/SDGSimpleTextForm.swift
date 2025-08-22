//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/21/25.
//

import SwiftUI

public struct SDGSimpleTextForm: View {
  
  private let title: String
  private let icon: FormIconModel?
  private let type: FormType
  @Binding private var searchText: String
  @Binding private var state: SDGSimpleInput.InputState
  private let keyboardType: UIKeyboardType
  private let placeHolder: String
  private let isRequiered: Bool
  private let errorMessage: String?
  private let maxCount: Int
  
  private let onRefresh: () -> Void
  private let onSearchButtonTap: (String) -> Void
  private let onSearchTextChange: (String) -> Void
  
  private var isSelected: Bool {
    return !searchText.isBlank
  }
  
  public init(
    title: String,
    icon: FormIconModel? = nil,
    type: FormType,
    searchText: Binding<String>,
    state: Binding<SDGSimpleInput.InputState> = .constant(.default),
    keyboardType: UIKeyboardType = .default,
    placeHolder: String,
    errorMessage: String? = nil,
    isRequiered: Bool = false,
    maxCount: Int = 10000,
    onRefresh: @escaping () -> Void,
    onSearchButtonTap: @escaping (String) -> Void,
    onSearchTextChange: @escaping (String) -> Void
  ) {
    self.title = title
    self.icon = icon
    self.type = type
    self._searchText = searchText
    self._state = state
    self.keyboardType = keyboardType
    self.placeHolder = placeHolder
    self.isRequiered = isRequiered
    self.errorMessage = errorMessage
    self.maxCount = maxCount
    self.onRefresh = onRefresh
    self.onSearchButtonTap = onSearchButtonTap
    self.onSearchTextChange = onSearchTextChange
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
      
      SDGSimpleInput(
        type: .solid,
        state: $state,
        text: $searchText,
        hint: placeHolder,
        keyboardType: keyboardType,
        backgroundColor: .neutral50,
        maxCount: maxCount
      )
    }
  }
}

struct SDGSimpleTextForm_Wrapper: View {
  @State var searchTextOne: String = ""
  @State var searchTextTwo: String = ""
  @State var searchTextThree: String = ""
  @State var searchTextFour: String = ""
  
  
  var body: some View {
    VStack {
      SDGSimpleTextForm(
        title: "타이틀",
        type: .empha,
        searchText: $searchTextOne,
        placeHolder: "입력",
        isRequiered: true,
        onRefresh: { },
        onSearchButtonTap: { text in },
        onSearchTextChange: { text in }
      )
      
      SDGSimpleTextForm(
        title: "타이틀",
        type: .empha,
        searchText: $searchTextTwo,
        placeHolder: "입력",
        isRequiered: false,
        onRefresh: {
          searchTextTwo = ""
        },
        onSearchButtonTap: { text in },
        onSearchTextChange: { text in }
      )
      
      SDGSimpleTextForm(
        title: "타이틀",
        type: .empha,
        searchText: $searchTextThree,
        state: .constant(.error("에러메세지")),
        placeHolder: "입력",
        isRequiered: false,
        onRefresh: {
          searchTextTwo = ""
        },
        onSearchButtonTap: { text in },
        onSearchTextChange: { text in }
      )
      
      SDGSimpleTextForm(
        title: "긴 타이틀 긴 타이틀긴 타이틀긴 타이틀 긴 타이틀긴 타이틀긴 타이틀긴 타이틀 긴 타이틀",
        icon: FormIconModel(image: Image(.icClip), tintColor: .neutral500),
        type: .empha,
        searchText: $searchTextFour,
        state: .constant(.error("긴 에러메세지 긴 에러메세지 긴 에러메세지 긴 에러메세지 긴 에러메세지 긴 에러메세지")),
        placeHolder: "입력",
        isRequiered: false,
        onRefresh: {
          searchTextTwo = ""
        },
        onSearchButtonTap: { text in },
        onSearchTextChange: { text in }
      )
    }
    .padding(20)
  }
}


struct SDGSimpleTextForm_Preview: PreviewProvider {
  static var previews: some View {
    SDGSimpleTextForm_Wrapper()
  }
}
