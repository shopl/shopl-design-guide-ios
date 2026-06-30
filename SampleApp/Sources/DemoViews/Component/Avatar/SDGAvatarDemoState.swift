//
//  SDGAvatarDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import Combine
import UIKit
import ShoplDesignGuide

final class SDGAvatarDemoState: ObservableObject {
  static let shared = SDGAvatarDemoState()
  
  let roles = SDGAvatarDemoRole.allCases
  let sizes = SDGAvatarDemoSize.allCases
  
  @Published var selectedRoleIndex = 0
  @Published var selectedSizeIndex = 0
  @Published var isPhotoEnabled = false
  @Published var isMaternityEnabled = false
  
  private init() { }
  
  var selectedRole: SDGAvatarDemoRole {
    roles[safe: selectedRoleIndex] ?? .admin
  }
  
  var selectedSize: SDGAvatarDemoSize {
    sizes[safe: selectedSizeIndex] ?? .xlarge
  }
  
  var avatarModel: AvatarModel {
    AvatarModel(
      userId: "avatar_sample_user",
      imageURL: isPhotoEnabled ? Self.sampleImageURL : nil,
      roleType: selectedRole.roleType,
      maternity: isMaternityEnabled ? .pre : .none
    )
  }
  
  var avatarPreviewID: String {
    [
      selectedRole.id,
      selectedSize.id,
      isPhotoEnabled ? "photo_on" : "photo_off",
      isMaternityEnabled ? "maternity_on" : "maternity_off"
    ].joined(separator: "_")
  }
  
  private static let sampleImageURL: URL? = {
    guard let image = UIImage(named: "Avatar_Sample"),
          let imageData = image.jpegData(compressionQuality: 1) else {
      return nil
    }
    
    let fileURL = FileManager.default.temporaryDirectory
      .appendingPathComponent("SDGAvatarDemo_Avatar_Sample.jpg")
    
    do {
      try imageData.write(to: fileURL, options: .atomic)
      return fileURL
    } catch {
      return nil
    }
  }()
}

enum SDGAvatarDemoRole: String, CaseIterable, Identifiable {
  case admin = "Admin"
  case leader = "Leader"
  case staff = "Staff"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  var roleType: AvatarModel.RoleType {
    switch self {
    case .admin:
      return .opLeader
    case .leader:
      return .leader
    case .staff:
      return .worker
    }
  }
}

enum SDGAvatarDemoSize: String, CaseIterable, Identifiable {
  case xlarge = "XLarge"
  case large = "Large"
  case medium = "Medium"
  case small = "Small"
  case xsmall = "XSmall"
  case xxsmall = "XXSmall"
  
  var id: String {
    rawValue
  }
  
  var title: String {
    rawValue
  }
  
  var avatarSize: SDGAvatar.Size {
    switch self {
    case .xlarge:
      return .xl
    case .large:
      return .l
    case .medium:
      return .m
    case .small:
      return .s
    case .xsmall:
      return .xs
    case .xxsmall:
      return .xxs
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
