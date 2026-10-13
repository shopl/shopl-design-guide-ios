//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//
import SwiftUI

import Kingfisher

@available(*, deprecated, message: "Use SDGAvatar.Model and pass icon and outlineColor to SDGAvatar.")
public struct AvatarModel: Equatable, Hashable {
  
  public enum RoleType: Equatable {
    case worker, leader, opLeader
    
    public init(rawValue: String) {
      switch rawValue {
      case "1", "LEADER", "leader":
        self = .leader
      case "2", "ADMIN", "opLeader":
        self = .opLeader
      case "7", "SUPER_ADMIN":
        self = .opLeader
      case "9", "OPERATOR":
        self = .opLeader
      default: //0, STAFF, worker
        self = .worker
      }
    }
  }
  
  public enum Maternity: Equatable {
    case none, pre, post
  }
  
  public let userId: String
  public let imageURL: URL?
  public let roleType: RoleType
  public let maternity: Maternity
  
  public init(userId: String, imageURL: URL?, roleType: RoleType, maternity: Maternity = .none) {
    self.userId = userId
    self.imageURL = imageURL
    self.roleType = roleType
    self.maternity = maternity
  }
}

public struct SDGAvatar: View {
  public static let version = "2.3.50"

  public struct Model: Equatable, Hashable {
    public let userId: String
    /// 서버에서 받은 표시용 URL입니다. 서버의 Empty 이미지 URL도 포함합니다.
    public let imageURL: URL?

    public init(userId: String, imageURL: URL?) {
      self.userId = userId
      self.imageURL = imageURL
    }
  }

  public enum AvatarType {
    case round
  }

  public enum Size: CGFloat {
    case xxs = 20
    case xs = 24
    case s = 30
    case m = 40
    case l = 50
    case xl = 90
  }

  private let _model: Model
  private let _size: Size
  private let _showFace: Bool
  private let _icon: Image?
  private let _outlineColor: Color?
  private let _showRetry: Bool
  private let _onRetry: (() -> Void)?
  private let _action: (String) -> Void

  private var _outlineWidth: CGFloat {
    switch _size {
    case .xxs: return 1.5
    case .xs: return 1.8
    case .s: return 2.4
    case .m: return 3
    case .l: return 3.6
    case .xl: return 6
    }
  }

  private var _iconSize: CGFloat {
    switch _size {
    case .xxs: return 8
    case .xs: return 10
    case .s: return 12
    case .m: return 14
    case .l: return 16
    case .xl: return 24
    }
  }

  private var _retryIconSize: CGFloat {
    switch _size {
    case .xxs: return 10
    case .xs: return 12
    case .s: return 16
    case .m: return 20
    case .l: return 22
    case .xl: return 28
    }
  }

  /// `showFace`는 전달된 이미지를 명시적으로 숨기며, 프로필 등록 여부를 뜻하지 않습니다.
  /// 재시도 요청과 `showRetry` 상태 갱신은 호출 화면에서 담당합니다.
  public init(
    model: Model,
    size: Size,
    showFace: Bool = true,
    icon: Image? = nil,
    outlineColor: Color? = nil,
    showRetry: Bool = false,
    onRetry: (() -> Void)? = nil,
    action: @escaping (String) -> Void
  ) {
    _model = model
    _size = size
    _showFace = showFace
    _icon = icon
    _outlineColor = outlineColor
    _showRetry = showRetry
    _onRetry = onRetry
    _action = action
  }

  @available(*, deprecated, message: "Use init(model:size:showFace:icon:outlineColor:showRetry:onRetry:action:).")
  public init(type: AvatarType, model: AvatarModel, size: Size, action: @escaping (String) -> Void) {
    let icon: Image?
    switch model.roleType {
    case .worker:
      icon = nil
    case .leader:
      icon = Image(sdg: .leaderBadge)
    case .opLeader:
      icon = Image(sdg: .adminBadge)
    }

    self.init(
      model: Model(userId: model.userId, imageURL: model.imageURL),
      size: size,
      icon: icon,
      outlineColor: model.maternity == .none ? nil : .sdgSpecialPink,
      action: action
    )
  }

  @ViewBuilder
  public var body: some View {
    if _showRetry, _onRetry == nil {
      content
    } else {
      Button {
        if _showRetry {
          _onRetry?()
        } else {
          _action(_model.userId)
        }
      } label: {
        content
      }
      .buttonStyle(.plain)
    }
  }

  private var content: some View {
    ZStack {
      face
        .frame(width: _size.rawValue, height: _size.rawValue)
        .clipShape(Circle())

      if _showRetry {
        Circle()
          .fill(Color.sdgCoolGray)
          .overlay {
            Image(sdg: .icRetry)
              .resizable()
              .scaledToFit()
              .foregroundStyle(Color.neutral600)
              .frame(width: _retryIconSize, height: _retryIconSize)
          }
      }
    }
    .frame(width: _size.rawValue, height: _size.rawValue)
    .overlay {
      if let color = _outlineColor {
        Circle()
          .inset(by: -_outlineWidth / 2)
          .stroke(color, lineWidth: _outlineWidth)
      }
    }
    .overlay(alignment: .bottomTrailing) {
      if let icon = _icon {
        icon
          .resizable()
          .scaledToFit()
          .frame(width: _iconSize, height: _iconSize)
      }
    }
    .contentShape(Rectangle())
  }

  @ViewBuilder
  private var face: some View {
    if _showFace, let imageURL = _model.imageURL {
      KFImage(imageURL)
        .placeholder {
          emptyImage
        }
        .resizable()
        .scaledToFill()
    } else {
      emptyImage
    }
  }

  private var emptyImage: some View {
    Image(sdg: .icDashPerson)
      .resizable()
      .scaledToFit()
      .foregroundStyle(Color.neutral400)
      .frame(width: _size.rawValue, height: _size.rawValue)
      .overlay {
        Rectangle()
          .fill(Color.secondary300_10)
      }
      .clipShape(Circle())
  }
}

private struct AvatarPreview: View {
  private let sizes: [SDGAvatar.Size] = [.xxs, .xs, .s, .m, .l, .xl]
  private let model = SDGAvatar.Model(userId: "preview", imageURL: nil)

  var body: some View {
    ScrollView(.horizontal) {
      Grid(horizontalSpacing: 20, verticalSpacing: 20) {
        GridRow {
          Text("Size")
          Text("Empty")
          Text("Outline")
          Text("Icon")
          Text("Retry")
        }
        .font(.caption)

        ForEach(sizes, id: \.rawValue) { size in
          GridRow {
            Text("\(Int(size.rawValue))")
              .font(.caption)
            SDGAvatar(model: model, size: size, action: { _ in })
            SDGAvatar(
              model: model,
              size: size,
              outlineColor: .sdgSpecialPink,
              action: { _ in }
            )
            SDGAvatar(
              model: model,
              size: size,
              icon: Image(sdg: .leaderBadge),
              action: { _ in }
            )
            SDGAvatar(
              model: model,
              size: size,
              icon: Image(sdg: .adminBadge),
              outlineColor: .primary300,
              showRetry: true,
              onRetry: { },
              action: { _ in }
            )
          }
        }
      }
      .fixedSize(horizontal: true, vertical: false)
      .padding(24)
    }
    .background(Color.neutral0)
  }
}

#Preview {
  AvatarPreview()
}
