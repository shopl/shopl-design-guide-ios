//
//  SDGCheckBox.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

/// 크기와 상태에 따라 배경색을 표시하는 체크박스입니다. 선택 상태는 호출부에서 관리합니다.
public struct SDGCheckBox: View {
  /// 적용된 컴포넌트 디자인 버전입니다.
  public static let version = "2.0.0"
  
  public enum Size: Equatable {
    case large, medim
    
    fileprivate var value: CGFloat {
      switch self {
      case .large: return 18
      case .medim: return 16
      }
    }
  }
  
  /// 체크박스의 크기, 선택 배경색과 표시 상태를 묶는 모델입니다.
  public struct Model: Equatable {
    public let size: Size
    public let selectedColor: Color
    public let status: SDGCheckBoxStatus
    
    /// - Parameters:
    ///   - size: 체크박스와 아이콘의 크기입니다.
    ///   - selectedColor: 선택 상태에만 적용하는 배경색입니다. 기본값은 primary300입니다.
    ///   - status: Default는 neutral250, Disabled는 neutral200 배경을 표시합니다.
    public init(
      size: Size, selectedColor: Color = .primary300, status: SDGCheckBoxStatus
    ) {
      self.size = size
      self.selectedColor = selectedColor
      self.status = status
    }
  }
  
  private let model: Model
  
  private var onSelect: (() -> ())?
  
  /// - Parameters:
  ///   - model: 체크박스의 크기와 표시 상태입니다.
  ///   - onSelect: 탭 시 호출합니다. Disabled 상태의 선택 차단 및 안내는 호출부에서 처리합니다.
  public init(
    model: Model,
    onSelect: (() -> ())? = nil
  ) {
    self.model = model
    self.onSelect = onSelect
  }
  
  public var body: some View {
    Button {
      onSelect?()
    } label: {
      HStack {
        Image(sdg: .icCommonCheckS)
          .resizable()
          .frame(width: model.size.value, height: model.size.value)
          .foregroundColor(.neutral0)
      }
      .background(backgroundColor)
      .cornerRadius(4)
    }
    .buttonStyle(NoTapAnimationButtonStyle())
  }

  private var backgroundColor: Color {
    switch model.status {
    case .default: return .neutral250
    case .selected: return model.selectedColor
    case .disabled: return .neutral200
    }
  }
}

struct CheckBox_Multi_Preview: PreviewProvider {
  static var previews: some View {
    VStack {
      HStack {
        SDGCheckBox(
          model: .init(size: .large, status: .default)
        )
        
        SDGCheckBox(
          model: .init(size: .large, status: .selected)
        )
        
        SDGCheckBox(
          model: .init(size: .large, status: .selected)
        )
        
        SDGCheckBox(
          model: .init(size: .large, status: .disabled),
        )
      }
      
      HStack {
        SDGCheckBox(
          model: .init(size: .medim, status: .default)
        )
        
        SDGCheckBox(
          model: .init(size: .medim, status: .selected)
        )
        
        SDGCheckBox(
          model: .init(size: .medim, selectedColor: .neutral700, status: .selected)
        )
        
        SDGCheckBox(
          model: .init(size: .medim, status: .disabled)
        )
      }
    }
    
  }
}
