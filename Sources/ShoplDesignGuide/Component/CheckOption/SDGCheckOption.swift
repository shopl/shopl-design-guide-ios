//
//  SDGCheckOption.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGCheckOption: View {
  public static let version = "2.3.42"

  public enum Style: Equatable {
    case solid
    case line
  }

  @available(*, deprecated, renamed: "Style")
  public typealias CheckType = Style
  
  public enum Spec: Equatable {
    case large
    case medim
  
    fileprivate var iconSize: CGFloat {
      switch self {
      case .large: return 16
      case .medim: return 14
      }
    }
  }

  public enum SelectColor: Equatable {
    case normal
    case neutral

    var backgroundColor: Color {
      switch self {
      case .normal:
        SDG.Color.primary300.color
      case .neutral:
        SDG.Color.neutral700.color
      }
    }
  }

  public struct Model: Equatable {
    public var state: SDGCheckOptionState
    public var style: Style
    public let spec: Spec
    public let selectColor: SelectColor

    @available(*, deprecated, renamed: "state")
    public var status: SDGCheckOptionState {
      get { state }
      set { state = newValue }
    }

    @available(*, deprecated, renamed: "style")
    public var type: Style {
      get { style }
      set { style = newValue }
    }

    public init(
      state: SDGCheckOptionState,
      style: Style,
      spec: Spec,
      selectColor: SelectColor
    ) {
      self.state = state
      self.style = style
      self.spec = spec
      self.selectColor = selectColor
    }

    @available(*, deprecated, renamed: "init(state:style:spec:selectColor:)")
    public init(
      status: SDGCheckOptionState,
      type: Style,
      spec: Spec,
      selectColor: SelectColor
    ) {
      self.init(state: status, style: type, spec: spec, selectColor: selectColor)
    }

    fileprivate var solidBackgroundColor: Color {
      switch state {
      case .default:
        return .neutral250
      case .selected:
        return selectColor.backgroundColor
      case .disabled:
        return .neutral200
      }
    }

    fileprivate var lineColor: Color {
      switch state {
      case .default:
        return .neutral350
      case .selected:
        return selectColor.backgroundColor
      case .disabled:
        return .neutral300
      }
    }
  }
  
  private var model: Model
  private var selected: (() -> ())
  
  public init(
    model: Model,
    selected: @escaping (() -> ())
  ) {
    self.model = model
    self.selected = selected
  }
  
  public var body: some View {
    Button {
      self.selected()
    } label: {
      switch model.style {
      case .solid:
        Image(sdg: .icCommonCheckS)
          .resizable()
          .renderingMode(.template)
          .frame(width: model.spec.iconSize, height: model.spec.iconSize, alignment: .center)
          .padding(.all, 1)
          .background(model.solidBackgroundColor)
          .foregroundStyle(.neutral0)
          .clipShape(Circle())
        
      case .line:
        ZStack {
          Image(sdg: .icCommonCheckS)
            .resizable()
            .renderingMode(.template)
            .frame(width: model.spec.iconSize, height: model.spec.iconSize)
            .background(.clear)
            .foregroundStyle(model.lineColor)
            .clipShape(Circle())
        }
        .padding(.all, 1)
        .overlay(
          Circle()
            .strokeBorder(
              model.lineColor,
              lineWidth: 1
            )
        )
      }
    }
    .allowsHitTesting(model.state != .disabled)
  }
}


#Preview {
  ZStack {
    VStack {
      HStack {
        SDGCheckOption(
          model: .init(
            state: .default,
            style: .solid,
            spec: .medim,
            selectColor: .normal
          ),
          selected: {
            
          }
        )

        SDGCheckOption(
          model: .init(
            state: .selected,
            style: .solid,
            spec: .medim,
            selectColor: .normal
          ),
          selected: {
            
          }
        )

        SDGCheckOption(
          model: .init(
            state: .selected,
            style: .solid,
            spec: .medim,
            selectColor: .neutral
          ),
          selected: {

          }
        )

        SDGCheckOption(
          model: .init(
            state: .disabled,
            style: .solid,
            spec: .medim,
            selectColor: .normal
          ),
          selected: {
            
          }
        )
      }
      
      HStack {
        
        SDGCheckOption(
          model: .init(
            state: .default,
            style: .line,
            spec: .medim,
            selectColor: .neutral
          ),
          selected: {
            
          }
        )

        SDGCheckOption(
          model: .init(
            state: .selected,
            style: .line,
            spec: .medim,
            selectColor: .normal
          ),
          selected: {

          }
        )

        SDGCheckOption(
          model: .init(
            state: .selected,
            style: .line,
            spec: .medim,
            selectColor: .neutral
          ),
          selected: {
            
          }
        )
        
        SDGCheckOption(
          model: .init(
            state: .disabled,
            style: .line,
            spec: .medim,
            selectColor: .neutral
          ),
          selected: {
            
          }
        )
      }
      
      HStack {
        SDGCheckOption(
          model: .init(
            state: .default,
            style: .solid,
            spec: .large,
            selectColor: .normal
          ),
          selected: {
            
          }
        )

        SDGCheckOption(
          model: .init(
            state: .selected,
            style: .solid,
            spec: .large,
            selectColor: .normal
          ),
          selected: {

          }
        )

        SDGCheckOption(
          model: .init(
            state: .selected,
            style: .solid,
            spec: .large,
            selectColor: .neutral
          ),
          selected: {
            
          }
        )
        
        SDGCheckOption(
          model: .init(
            state: .disabled,
            style: .solid,
            spec: .large,
            selectColor: .normal
          ),
          selected: {
            
          }
        )
      }
      
      HStack {
        
        SDGCheckOption(
          model: .init(
            state: .default,
            style: .line,
            spec: .large,
            selectColor: .normal
          ),
          selected: {
            
          }
        )

        SDGCheckOption(
          model: .init(
            state: .selected,
            style: .line,
            spec: .large,
            selectColor: .normal
          ),
          selected: {

          }
        )

        SDGCheckOption(
          model: .init(
            state: .selected,
            style: .line,
            spec: .large,
            selectColor: .neutral
          ),
          selected: {
            
          }
        )
        
        SDGCheckOption(
          model: .init(
            state: .disabled,
            style: .line,
            spec: .large,
            selectColor: .normal
          ),
          selected: {
            
          }
        )
      }
      
    }
  }
}
