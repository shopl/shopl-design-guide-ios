//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//
import SwiftUI

import Kingfisher

/// 기존 역할 뱃지와 임산부 Outline 호출의 호환성을 유지하는 아바타 모델입니다.
@available(*, deprecated, message: "SDGAvatar.Model을 사용하고 outline과 ic를 SDGAvatar에 전달하세요.")
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

/// 가이드의 Avatar, Outline, ic, Spec 입력으로 유저의 원형 프로필을 표시합니다.
/// 프로필 API의 재요청과 표시 상태 갱신은 호출 화면에서 담당합니다.
public struct SDGAvatar: View {
  /// 이 컴포넌트에 적용된 디자인 가이드 버전입니다.
  public static let version = "2.3.50"

  /// 아바타에 표시할 이미지와 정상 탭 이벤트에 전달할 유저 식별자입니다.
  public struct Model: Equatable, Hashable {
    /// 정상 상태에서 아바타를 누르면 `action`에 전달하는 식별자입니다.
    public let userId: String
    /// 서버에서 받은 표시용 URL입니다. 서버의 Empty 이미지 URL도 포함합니다.
    public let imageURL: URL?

    /// 아바타 표시 데이터를 생성합니다.
    /// - Parameters:
    ///   - userId: 정상 탭 이벤트에 전달할 유저 식별자입니다.
    ///   - imageURL: 표시할 이미지 URL입니다. `nil`이면 로컬 placeholder를 사용합니다.
    public init(userId: String, imageURL: URL?) {
      self.userId = userId
      self.imageURL = imageURL
    }
  }

  /// 가이드의 Face와 Retry 표시 옵션입니다. 두 값이 모두 `true`이면 Retry를 우선 표시합니다.
  /// 값은 호출 화면이 소유하며, 아바타 내부에서 변경하지 않습니다.
  public struct Avatar: Equatable, Hashable {
    /// Retry가 꺼져 있을 때 전달된 이미지를 표시할지 결정합니다. `false`이면 placeholder를 표시합니다.
    public var showFace: Bool
    /// 프로필 API 실패에 대한 Retry를 표시합니다. 내부 이미지 다운로드 실패로 자동 변경되지 않습니다.
    public var showRetry: Bool

    /// Face와 Retry의 표시 옵션을 모두 명시해 생성합니다.
    /// - Parameters:
    ///   - showFace: Retry가 꺼져 있을 때 이미지 표시 여부입니다. `false`여도 모델의 이미지 URL은 유지됩니다.
    ///   - showRetry: `true`이면 Face보다 Retry를 우선 표시합니다.
    public init(showFace: Bool, showRetry: Bool) {
      self.showFace = showFace
      self.showRetry = showRetry
    }
  }

  public enum AvatarType {
    case round
  }

  /// 아바타의 너비와 높이를 포인트 단위로 정의한 기존 크기입니다.
  public enum Size: CGFloat {
    case xxs = 20
    case xs = 24
    case s = 30
    case m = 40
    case l = 50
    case xl = 90
  }

  /// 가이드의 Spec에 대응하는 크기입니다. 기존 `Size`의 케이스와 raw value를 공유합니다.
  public typealias Spec = Size

  private let _model: Model
  private let _avatar: Avatar
  private let _outline: Color?
  private let _ic: Image?
  private let _spec: Spec
  private let _onRetry: (() -> Void)?
  private let _action: (String) -> Void

  private var _outlineWidth: CGFloat {
    switch _spec {
    case .xxs: return 1.5
    case .xs: return 1.8
    case .s: return 2.4
    case .m: return 3
    case .l: return 3.6
    case .xl: return 6
    }
  }

  private var _iconSize: CGFloat {
    switch _spec {
    case .xxs: return 8
    case .xs: return 10
    case .s: return 12
    case .m: return 14
    case .l: return 16
    case .xl: return 24
    }
  }

  private var _retryIconSize: CGFloat {
    switch _spec {
    case .xxs: return 10
    case .xs: return 12
    case .s: return 16
    case .m: return 20
    case .l: return 22
    case .xl: return 28
    }
  }

  /// 가이드의 Anatomy와 Spec에 맞춰 아바타를 생성합니다.
  /// Retry가 Face보다 우선하며, 해제하면 전달된 Face 설정과 이미지 URL로 표시합니다.
  /// URL 없음·이미지 로딩 중·다운로드 실패는 로컬 placeholder로 처리하고 Retry를 자동으로 켜지 않습니다.
  /// - Parameters:
  ///   - model: 유저 식별자와 표시용 이미지 URL입니다. 서버 Empty 이미지도 그대로 표시합니다.
  ///   - avatar: Face·Retry 표시 옵션을 모두 명시합니다. 두 값이 모두 `true`이면 Retry를 우선 표시합니다.
  ///   - outline: 원 바깥에 그릴 테두리 색상입니다. 기본값인 `nil`이면 숨깁니다.
  ///   - ic: 우측 하단 아이콘입니다. 기본값인 `nil`이면 숨기며 크기는 Spec에 따릅니다.
  ///   - spec: 아바타 크기와 테두리 두께, 하단·Retry 아이콘 크기를 결정하는 규격입니다.
  ///   - onRetry: Retry 상태에서 탭하면 호출합니다. 기본값인 `nil`이면 표시만 합니다.
  ///     프로필 API 재요청과 결과에 따른 모델·표시 옵션 갱신은 호출 화면에서 담당합니다.
  ///   - action: Retry가 꺼진 상태에서 탭하면 유저 식별자를 전달합니다.
  public init(
    model: Model,
    avatar: Avatar,
    outline: Color? = nil,
    ic: Image? = nil,
    spec: Spec,
    onRetry: (() -> Void)? = nil,
    action: @escaping (String) -> Void
  ) {
    _model = model
    _avatar = avatar
    _outline = outline
    _ic = ic
    _spec = spec
    _onRetry = onRetry
    _action = action
  }

  /// 기존 배포 API의 역할 뱃지와 임산부 Outline을 새 표시 옵션으로 변환합니다.
  /// Face는 표시하고 Retry는 숨겨 기존 동작을 유지합니다.
  /// - Parameters:
  ///   - type: 기존 원형 아바타 타입입니다.
  ///   - model: 이미지와 역할·임산부 정보입니다. 리더·관리자는 기존 뱃지, 임산부는 분홍색 테두리로 표시합니다.
  ///   - size: 기존 아바타 크기입니다. 새 API의 `spec`과 동일한 규격입니다.
  ///   - action: 아바타를 누르면 유저 식별자를 전달합니다.
  @available(*, deprecated, message: "init(model:avatar:outline:ic:spec:onRetry:action:)을 사용하세요.")
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
      avatar: .init(showFace: true, showRetry: false),
      outline: model.maternity == .none ? nil : .sdgSpecialPink,
      ic: icon,
      spec: size,
      action: action
    )
  }

  @ViewBuilder
  public var body: some View {
    if _avatar.showRetry, _onRetry == nil {
      content
    } else {
      Button {
        if _avatar.showRetry {
          _onRetry?()
        } else {
          _action(_model.userId)
        }
      } label: {
        content
          // 눌림 효과를 Avatar 전체에 적용해 Retry 아래의 이미지가 비치지 않게 합니다.
          .compositingGroup()
      }
      .buttonStyle(.plain)
    }
  }

  private var content: some View {
    ZStack {
      face
        .frame(width: _spec.rawValue, height: _spec.rawValue)
        .clipShape(Circle())

      if _avatar.showRetry {
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
    .frame(width: _spec.rawValue, height: _spec.rawValue)
    .overlay {
      if let color = _outline {
        Circle()
          .inset(by: -_outlineWidth / 2)
          .stroke(color, lineWidth: _outlineWidth)
      }
    }
    .overlay(alignment: .bottomTrailing) {
      if let icon = _ic {
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
    if _avatar.showFace, let imageURL = _model.imageURL {
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
      .frame(width: _spec.rawValue, height: _spec.rawValue)
      .overlay {
        Rectangle()
          .fill(Color.secondary300_10)
      }
      .clipShape(Circle())
  }
}

private struct AvatarPreview: View {
  private let specs: [SDGAvatar.Spec] = [.xxs, .xs, .s, .m, .l, .xl]
  private let model = SDGAvatar.Model(userId: "preview", imageURL: nil)

  var body: some View {
    ScrollView(.horizontal) {
      Grid(horizontalSpacing: 20, verticalSpacing: 20) {
        GridRow {
          Text("Spec")
          Text("Empty")
          Text("Outline")
          Text("ic")
          Text("Retry")
        }
        .font(.caption)

        ForEach(specs, id: \.rawValue) { spec in
          GridRow {
            Text("\(Int(spec.rawValue))")
              .font(.caption)
            SDGAvatar(
              model: model,
              avatar: .init(showFace: true, showRetry: false),
              spec: spec,
              action: { _ in }
            )
            SDGAvatar(
              model: model,
              avatar: .init(showFace: true, showRetry: false),
              outline: .sdgSpecialPink,
              spec: spec,
              action: { _ in }
            )
            SDGAvatar(
              model: model,
              avatar: .init(showFace: true, showRetry: false),
              ic: Image(sdg: .leaderBadge),
              spec: spec,
              action: { _ in }
            )
            SDGAvatar(
              model: model,
              avatar: .init(showFace: true, showRetry: true),
              outline: .primary300,
              ic: Image(sdg: .adminBadge),
              spec: spec,
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
