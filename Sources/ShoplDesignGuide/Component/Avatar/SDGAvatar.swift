//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//
import SwiftUI

import Kingfisher

/// 기존 역할 뱃지와 임산부 Outline 호출의 호환성을 유지하는 아바타 모델입니다.
@available(*, deprecated, message: "데이터와 표시 설정을 SDGAvatar.Model에 담아 사용하세요.")
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

/// Figma의 Size와 Show Face·Show Ic·Show Outline·Show Retry 설정으로 원형 프로필을 표시합니다.
/// 데이터와 디자인 설정은 Model로 받고, 탭·재시도 동작은 별도 콜백으로 연결합니다.
/// 프로필 API의 재요청과 표시 상태 갱신은 호출 화면에서 담당합니다.
public struct SDGAvatar: View {
  /// 이 컴포넌트에 적용된 디자인 가이드 버전입니다.
  public static let version = "2.3.50"

  /// 아바타의 데이터와 디자인 설정을 한 단위로 전달하는 모델입니다.
  /// 표시 상태는 호출 화면이 소유하며, 아바타 내부에서 변경하지 않습니다.
  public struct Model: Equatable {
    /// 정상 상태에서 아바타를 누르면 `action`에 전달하는 식별자입니다.
    public let userId: String
    /// 서버에서 받은 표시용 URL입니다. 서버의 Empty 이미지 URL도 포함합니다.
    public let imageURL: URL?
    /// Figma의 Size입니다. 아바타 크기와 Outline·아이콘 규격을 결정합니다.
    public var size: Size
    /// Figma의 Show Face입니다. Retry가 꺼져 있을 때 `false`이면 URL을 사용하지 않고 placeholder를 표시합니다.
    public var showFace: Bool
    /// Figma의 Show Ic입니다. `true`이고 `ic`가 있을 때 우측 하단 아이콘을 표시합니다.
    public var showIc: Bool
    /// Figma의 Show Outline입니다. `true`이고 `outline`이 있을 때 외곽선을 표시합니다.
    public var showOutline: Bool
    /// Figma의 Show Retry입니다. `true`이면 Face보다 우선하며 이미지 뷰를 생성하지 않습니다.
    /// 호출 화면의 프로필 API 실패 표시에 사용하며, 내부 이미지 다운로드 실패로 자동 변경되지 않습니다.
    public var showRetry: Bool
    /// 원 바깥에 그릴 외곽선 색상입니다. `showOutline`을 꺼도 값은 유지합니다.
    public var outline: Color?
    /// 우측 하단에 표시할 아이콘입니다. `showIc`를 꺼도 값은 유지합니다.
    public var ic: Image?

    /// 데이터와 크기·표시 옵션을 명시해 아바타 입력을 생성합니다.
    /// Retry를 해제하면 현재 `showFace`와 `imageURL`에 따라 표시합니다.
    /// - Parameters:
    ///   - userId: 정상 탭 이벤트에 전달할 유저 식별자입니다.
    ///   - imageURL: 표시할 이미지 URL입니다. 서버 Empty 이미지도 그대로 표시합니다.
    ///     URL 없음·이미지 로딩 중·다운로드 실패는 로컬 placeholder로 처리합니다.
    ///   - size: Figma의 Size에 대응하는 아바타 크기입니다.
    ///   - showFace: Retry가 꺼져 있을 때 이미지 표시 여부입니다. `false`여도 모델의 이미지 URL은 유지됩니다.
    ///   - showIc: 우측 하단 아이콘 표시 여부입니다. `true`여도 `ic`가 없으면 숨깁니다.
    ///   - showOutline: 외곽선 표시 여부입니다. `true`여도 `outline`이 없으면 숨깁니다.
    ///   - showRetry: `true`이면 Face와 이미지 다운로드를 생략하고 Retry를 우선 표시합니다.
    ///   - outline: 외곽선 색상입니다. 기본값인 `nil`이면 표시하지 않습니다.
    ///   - ic: 우측 하단 아이콘입니다. 기본값인 `nil`이면 표시하지 않습니다.
    public init(
      userId: String,
      imageURL: URL?,
      size: Size,
      showFace: Bool,
      showIc: Bool,
      showOutline: Bool,
      showRetry: Bool,
      outline: Color? = nil,
      ic: Image? = nil
    ) {
      self.userId = userId
      self.imageURL = imageURL
      self.size = size
      self.showFace = showFace
      self.showIc = showIc
      self.showOutline = showOutline
      self.showRetry = showRetry
      self.outline = outline
      self.ic = ic
    }
  }

  public enum AvatarType {
    case round
  }

  /// Figma의 Size에 대응하며 아바타의 너비와 높이를 포인트 단위로 정의합니다.
  public enum Size: CGFloat {
    case xxs = 20
    case xs = 24
    case s = 30
    case m = 40
    case l = 50
    case xl = 90
  }

  private let model: Model
  private let onRetry: (() -> Void)?
  private let action: (String) -> Void

  private var outlineWidth: CGFloat {
    switch model.size {
    case .xxs: return 1.5
    case .xs: return 1.8
    case .s: return 2.4
    case .m: return 3
    case .l: return 3.6
    case .xl: return 6
    }
  }

  private var iconSize: CGFloat {
    switch model.size {
    case .xxs: return 8
    case .xs: return 10
    case .s: return 12
    case .m: return 14
    case .l: return 16
    case .xl: return 24
    }
  }

  private var retryIconSize: CGFloat {
    switch model.size {
    case .xxs: return 10
    case .xs: return 12
    case .s: return 16
    case .m: return 20
    case .l: return 22
    case .xl: return 28
    }
  }

  /// 데이터와 디자인 설정을 담은 Model로 아바타를 생성합니다.
  /// Retry가 Face보다 우선하며, 해제하면 전달된 Face 설정과 이미지 URL로 표시합니다.
  /// URL 없음·이미지 로딩 중·다운로드 실패는 로컬 placeholder로 처리하고 Retry를 자동으로 켜지 않습니다.
  /// - Parameters:
  ///   - model: 유저 식별자·이미지 URL과 Figma의 Size·표시 옵션, 외곽선 색상·하단 아이콘입니다.
  ///     Outline과 ic는 Retry 표시 중에도 각 표시 옵션과 값에 따라 독립적으로 표시합니다.
  ///   - onRetry: Retry 상태에서 탭하면 호출합니다. 기본값인 `nil`이면 표시만 합니다.
  ///     프로필 API 재요청과 결과에 따른 모델·표시 옵션 갱신은 호출 화면에서 담당합니다.
  ///   - action: Retry가 꺼진 상태에서 탭하면 유저 식별자를 전달합니다.
  public init(
    model: Model,
    onRetry: (() -> Void)? = nil,
    action: @escaping (String) -> Void
  ) {
    self.model = model
    self.onRetry = onRetry
    self.action = action
  }

  /// 기존 배포 API의 역할 뱃지와 임산부 Outline을 새 표시 옵션으로 변환합니다.
  /// Face는 표시하고 Retry는 숨겨 기존 동작을 유지합니다.
  /// - Parameters:
  ///   - type: 기존 원형 아바타 타입입니다.
  ///   - model: 이미지와 역할·임산부 정보입니다. 리더·관리자는 기존 뱃지, 임산부는 분홍색 테두리로 표시합니다.
  ///   - size: 기존 아바타 크기입니다. 새 Model의 `size`와 동일한 규격입니다.
  ///   - action: 아바타를 누르면 유저 식별자를 전달합니다.
  @available(*, deprecated, message: "데이터와 표시 설정을 SDGAvatar.Model에 담아 init(model:onRetry:action:)을 사용하세요.")
  public init(
    type: AvatarType,
    model: AvatarModel,
    size: Size,
    action: @escaping (String) -> Void
  ) {
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
      model: Model(
        userId: model.userId,
        imageURL: model.imageURL,
        size: size,
        showFace: true,
        showIc: icon != nil,
        showOutline: model.maternity != .none,
        showRetry: false,
        outline: model.maternity == .none ? nil : .sdgSpecialPink,
        ic: icon
      ),
      action: action
    )
  }

  @ViewBuilder
  public var body: some View {
    if model.showRetry, onRetry == nil {
      content
    } else {
      Button {
        if model.showRetry {
          onRetry?()
        } else {
          action(model.userId)
        }
      } label: {
        content
          // 눌림 효과를 아바타 전체에 한 번 적용해 각 레이어의 합성 결과를 유지합니다.
          .compositingGroup()
      }
      .buttonStyle(.plain)
    }
  }

  private var content: some View {
    ZStack {
      if model.showRetry {
        retry
      } else {
        face
          .frame(width: model.size.rawValue, height: model.size.rawValue)
          .clipShape(Circle())
      }
    }
    .frame(width: model.size.rawValue, height: model.size.rawValue)
    .overlay {
      outline
    }
    .overlay(alignment: .bottomTrailing) {
      ic
    }
    .contentShape(Rectangle())
  }

  @ViewBuilder
  private var face: some View {
    if model.showFace, let imageURL = model.imageURL {
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

  private var retry: some View {
    Circle()
      .fill(Color.sdgCoolGray)
      .overlay {
        Image(sdg: .icRetry)
          .resizable()
          .scaledToFit()
          .foregroundStyle(Color.neutral600)
          .frame(width: retryIconSize, height: retryIconSize)
      }
  }

  @ViewBuilder
  private var outline: some View {
    if model.showOutline, let color = model.outline {
      Circle()
        .inset(by: -outlineWidth / 2)
        .stroke(color, lineWidth: outlineWidth)
    }
  }

  @ViewBuilder
  private var ic: some View {
    if model.showIc, let icon = model.ic {
      icon
        .resizable()
        .scaledToFit()
        .frame(width: iconSize, height: iconSize)
    }
  }

  private var emptyImage: some View {
    Image(sdg: .icDashPerson)
      .resizable()
      .scaledToFit()
      .foregroundStyle(Color.neutral400)
      .frame(width: model.size.rawValue, height: model.size.rawValue)
      .overlay {
        Rectangle()
          .fill(Color.secondary300_10)
      }
      .clipShape(Circle())
  }
}

private struct AvatarPreview: View {
  private let sizes: [SDGAvatar.Size] = [.xxs, .xs, .s, .m, .l, .xl]

  var body: some View {
    ScrollView(.horizontal) {
      Grid(horizontalSpacing: 20, verticalSpacing: 20) {
        GridRow {
          Text("Size")
          Text("Empty")
          Text("Outline")
          Text("ic")
          Text("Retry")
        }
        .font(.caption)

        ForEach(sizes, id: \.rawValue) { size in
          GridRow {
            Text("\(Int(size.rawValue))")
              .font(.caption)
            SDGAvatar(
              model: .init(
                userId: "preview",
                imageURL: nil,
                size: size,
                showFace: true,
                showIc: false,
                showOutline: false,
                showRetry: false
              ),
              action: { _ in }
            )
            SDGAvatar(
              model: .init(
                userId: "preview",
                imageURL: nil,
                size: size,
                showFace: true,
                showIc: false,
                showOutline: true,
                showRetry: false,
                outline: .sdgSpecialPink
              ),
              action: { _ in }
            )
            SDGAvatar(
              model: .init(
                userId: "preview",
                imageURL: nil,
                size: size,
                showFace: true,
                showIc: true,
                showOutline: false,
                showRetry: false,
                ic: Image(sdg: .leaderBadge)
              ),
              action: { _ in }
            )
            SDGAvatar(
              model: .init(
                userId: "preview",
                imageURL: nil,
                size: size,
                showFace: true,
                showIc: true,
                showOutline: true,
                showRetry: true,
                outline: .primary300,
                ic: Image(sdg: .adminBadge)
              ),
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
