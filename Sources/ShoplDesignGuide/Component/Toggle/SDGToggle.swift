//
//  SDGToggle.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGToggle: View {

  private enum Constants {
    static let animationDuration = 0.2
    static let mediumWidth: CGFloat = 40
    static let mediumHeight: CGFloat = 22
    static let mediumThumbSize: CGFloat = 18
    static let mediumThumbOffset: CGFloat = 9
    static let smallWidth: CGFloat = 30
    static let smallHeight: CGFloat = 16
    static let smallThumbSize: CGFloat = 14
    static let smallThumbOffset: CGFloat = 6.75
  }
  
  @available(*, deprecated, message: "Use init(size:isEnabled:onColorType:isOn:) instead.")
  public enum ToggleState: Equatable {
    case normal
    case disabled
  }

  public enum OnColorType: Equatable {
    case primary
    case neutral

    fileprivate var enabledTrackColor: Color {
      switch self {
      case .primary:
        return .primary300
      case .neutral:
        return .neutral700
      }
    }

    fileprivate var enabledTrackUIColor: UIColor {
      switch self {
      case .primary:
        return .primary300
      case .neutral:
        return .neutral700
      }
    }
  }
  
  public enum Size: Equatable {
    case m
    case s
    
    fileprivate var width: CGFloat {
      switch self {
      case .m:
        return Constants.mediumWidth
      case .s:
        return Constants.smallWidth
      }
    }
    
    fileprivate var height: CGFloat {
      switch self {
      case .m:
        return Constants.mediumHeight
      case .s:
        return Constants.smallHeight
      }
    }
    
    fileprivate var toggleSize: CGFloat {
      switch self {
      case .m:
        return Constants.mediumThumbSize
      case .s:
        return Constants.smallThumbSize
      }
    }
    
    fileprivate var thumbOffset: CGFloat {
      switch self {
      case .m:
        return Constants.mediumThumbOffset
      case .s:
        return Constants.smallThumbOffset
      }
    }
  }
  
  private let size: Size
  private let isEnabled: Bool
  private let onColorType: OnColorType
  @Binding private var isOn: Bool
  
  private var trackColor: Color {
    guard isEnabled else {
      return .neutral200
    }

    return isOn ? onColorType.enabledTrackColor : .neutral300
  }

  public init(
    size: Size,
    isEnabled: Bool = true,
    onColorType: OnColorType = .primary,
    isOn: Binding<Bool>
  ) {
    self.size = size
    self.isEnabled = isEnabled
    self.onColorType = onColorType
    self._isOn = isOn
  }

  @available(*, deprecated, message: "Use init(size:isEnabled:onColorType:isOn:) instead.")
  public init(
    size: Size,
    toggleState: ToggleState,
    isOn: Binding<Bool>
  ) {
    self.init(
      size: size,
      isEnabled: toggleState == .normal,
      onColorType: .primary,
      isOn: isOn
    )
  }

  public var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: size.toggleSize / 2)
        .fill(Color.neutral0)
        .frame(width: size.toggleSize, height: size.toggleSize)
        .offset(x: isOn ? size.thumbOffset : -size.thumbOffset)
        .animation(.easeInOut(duration: Constants.animationDuration), value: isOn)
    }
    .frame(width: size.width, height: size.height)
    .background(trackColor)
    .cornerRadius(size.height / 2)
    .contentShape(Rectangle())
    .onTapGesture {
      guard isEnabled else { return }
      isOn.toggle()
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    VStack(spacing: 8) {
      SDGToggle(size: .m, isEnabled: true, onColorType: .primary, isOn: .constant(false))
      SDGToggle(size: .m, isEnabled: true, onColorType: .primary, isOn: .constant(true))
      SDGToggle(size: .m, isEnabled: false, onColorType: .primary, isOn: .constant(false))
      SDGToggle(size: .m, isEnabled: false, onColorType: .primary, isOn: .constant(true))
    }

    VStack(spacing: 8) {
      SDGToggle(size: .m, isEnabled: true, onColorType: .neutral, isOn: .constant(false))
      SDGToggle(size: .m, isEnabled: true, onColorType: .neutral, isOn: .constant(true))
      SDGToggle(size: .m, isEnabled: false, onColorType: .neutral, isOn: .constant(false))
      SDGToggle(size: .m, isEnabled: false, onColorType: .neutral, isOn: .constant(true))
    }

    HStack(spacing: 12) {
      SDGToggle(size: .s, isEnabled: true, onColorType: .primary, isOn: .constant(false))
      SDGToggle(size: .s, isEnabled: true, onColorType: .primary, isOn: .constant(true))
      SDGToggle(size: .s, isEnabled: true, onColorType: .neutral, isOn: .constant(true))
      SDGToggle(size: .s, isEnabled: false, onColorType: .neutral, isOn: .constant(true))
    }
  }
}

public final class Toggle_UIKit: UISwitch {

  private enum Constants {
    static let mediumScale: CGFloat = 0.7
    static let smallScale: CGFloat = 0.5625
  }

  public typealias OnColorType = SDGToggle.OnColorType
  
  public enum Size {
    case m
    case s

    fileprivate var scale: CGFloat {
      switch self {
      case .m:
        return Constants.mediumScale
      case .s:
        return Constants.smallScale
      }
    }
  }
  
  public var size: Size = .m {
    didSet {
      transform = CGAffineTransform(scaleX: size.scale, y: size.scale)
    }
  }

  public var onColorType: OnColorType = .primary {
    didSet {
      updateAppearance()
    }
  }

  public override var isEnabled: Bool {
    didSet {
      updateAppearance()
    }
  }

  public override var isOn: Bool {
    didSet {
      updateAppearance()
    }
  }
  
  public init(size: Size, onColorType: OnColorType = .primary) {
    super.init(frame: CGRect.zero)

    self.size = size
    self.onColorType = onColorType
    commonInit()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
  }

  private func commonInit() {
    thumbTintColor = .neutral0
    transform = CGAffineTransform(scaleX: size.scale, y: size.scale)
    updateAppearance()
  }

  private func updateAppearance() {
    let currentTrackColor: UIColor = {
      guard isEnabled else {
        return .neutral200
      }

      return isOn ? onColorType.enabledTrackUIColor : .neutral300
    }()

    alpha = 1
    tintColor = currentTrackColor
    onTintColor = currentTrackColor
    backgroundColor = currentTrackColor
    layer.masksToBounds = true
  }
}
