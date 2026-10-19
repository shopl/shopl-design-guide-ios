//
//  SDGSelectInputModel.swift
//  ShoplDesignGuide
//
//  Created by kai on 10/14/26.
//

import SwiftUI

extension SDGSelectInput {
  public struct SelectInputModel {
    /// 선택된 데이터를 표현하는 요소입니다. Input Field는 최대 두 요소(높이 80pt)까지 지원합니다.
    public let selectedElements: [SelectedElement]
    public let placeholder: String
    public let inputField: InputField
    public let state: State
    /// 상태, 선택값, 콜백 유무와 무관하게 호출부에서 Clear 아이콘 노출을 결정합니다.
    public let showClearIcon: Bool
    /// 다중 선택 텍스트(Selected Text+N)는 호출부에서 구성합니다.
    public let isMultipleSelection: Bool

    /// 기존 초기화 함수 참조와 호출 방식을 유지합니다.
    public init(
      selectedElements: [SelectedElement] = [],
      placeholder: String,
      inputField: InputField,
      state: State
    ) {
      self.init(
        selectedElements: selectedElements,
        placeholder: placeholder,
        inputField: inputField,
        state: state,
        showClearIcon: false,
        isMultipleSelection: nil
      )
    }

    public init(
      selectedElements: [SelectedElement] = [],
      placeholder: String,
      inputField: InputField,
      state: State,
      showClearIcon: Bool = false,
      isMultipleSelection: Bool? = nil
    ) {
      assert(selectedElements.count <= 2, "SDGSelectInput supports up to two selected elements.")
      self.selectedElements = Array(selectedElements.prefix(2))
      self.placeholder = placeholder
      self.inputField = inputField
      self.state = state
      self.showClearIcon = showClearIcon
      // 생략한 기존 호출부는 두 요소일 때 중간 말줄임을 사용하던 동작을 유지합니다.
      self.isMultipleSelection = isMultipleSelection ?? (selectedElements.count > 1)
    }

    public enum InputField {
      case gray
      case white

      var color: SDG.Color {
        switch self {
        case .gray:
          .neutral50
        case .white:
          .neutral0
        }
      }
    }

    public enum State {
      case `default`
      case selected
      case disabled
      case error
    }

    public struct SelectedElement {
      public let text: String
      let content: AnyView?

      public init(text: String) {
        self.text = text
        self.content = nil
      }

      /// 가이드에 정의된 이미지 규격을 적용합니다. 아바타 등 커스텀 콘텐츠는 content 초기화 구문을 사용합니다.
      public init(
        text: String,
        image: Image,
        imageType: SelectedElementImage.ImageType
      ) {
        self.text = text
        self.content = AnyView(SelectedElementImage(image: image, type: imageType))
      }

      public init<Content: View>(
        text: String,
        @ViewBuilder content: () -> Content
      ) {
        self.text = text
        self.content = AnyView(content())
      }
    }
  }
}
