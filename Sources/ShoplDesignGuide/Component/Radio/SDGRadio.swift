//
//  SDGRadio.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import SwiftUI

public struct SDGRadio: View {
  public static let version = "2.0.0"
  
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
  
  public struct Model: Equatable {
    public var status: SDGRadioStatus
    public let spec: Spec
    public let isPrimaryColor: Bool
    
    public init(status: SDGRadioStatus, spec: Spec, isPrimaryColor: Bool = true) {
      self.status = status
      self.spec = spec
      self.isPrimaryColor = isPrimaryColor
    }
    
    var backgroundColor: Color {
      return isPrimaryColor ? .primary300 : .neutral700
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
    
    ZStack(alignment: .center) {
      Circle()
        .frame(width: model.spec.iconSize, height: model.spec.iconSize)
        .foregroundColor(
          model.status == .selected ?
          model.backgroundColor :
            .neutral200
        )
        .applyIf(model.status == .disabled) {
          $0.foregroundStyle(.neutral200)
        }
      
      Circle()
        .frame(width: model.spec.iconSize / 2, height: model.spec.iconSize / 2)
        .foregroundColor(.neutral0)
    }
  }
}

#Preview {
  VStack(alignment: .leading, spacing: 16) {
    VStack(alignment: .leading, spacing: 8) {
      Text("Large / Primary")
        .typo(.body1_SB, .neutral500)
      
      HStack(spacing: 16) {
        SDGRadio(
          model: .init(status: .default, spec: .large),
          selected: { }
        )
        
        SDGRadio(
          model: .init(status: .selected, spec: .large),
          selected: { }
        )
        
        SDGRadio(
          model: .init(status: .disabled, spec: .large),
          selected: { }
        )
      }
    }
    
    VStack(alignment: .leading, spacing: 8) {
      Text("Medium / Primary")
        .typo(.body1_SB, .neutral500)
      
      HStack(spacing: 16) {
        SDGRadio(
          model: .init(status: .default, spec: .medim),
          selected: { }
        )
        
        SDGRadio(
          model: .init(status: .selected, spec: .medim),
          selected: { }
        )
        
        SDGRadio(
          model: .init(status: .disabled, spec: .medim),
          selected: { }
        )
      }
    }
    
    VStack(alignment: .leading, spacing: 8) {
      Text("Large / Neutral")
        .typo(.body1_SB, .neutral500)
      
      HStack(spacing: 16) {
        SDGRadio(
          model: .init(status: .default, spec: .large, isPrimaryColor: false),
          selected: { }
        )
        
        SDGRadio(
          model: .init(status: .selected, spec: .large, isPrimaryColor: false),
          selected: { }
        )
        
        SDGRadio(
          model: .init(status: .disabled, spec: .large, isPrimaryColor: false),
          selected: { }
        )
      }
    }
  }
  .padding(20)
}
