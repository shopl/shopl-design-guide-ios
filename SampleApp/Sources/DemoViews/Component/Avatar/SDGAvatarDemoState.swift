//
//  SDGAvatarDemoState.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/24/26.
//

import Combine
import SwiftUI
import UIKit
import ShoplDesignGuide

final class SDGAvatarDemoState: ObservableObject {
  static let shared = SDGAvatarDemoState()
  
  let roles = SDGAvatarDemoRole.allCases
  let sizes = SDGAvatarDemoSize.allCases
  let outlineColors = SDGAvatarDemoOutlineColor.allCases
  
  @Published var selectedRoleIndex = 0
  @Published var selectedSizeIndex = 0
  @Published var isPhotoEnabled = false
  @Published var isIconEnabled = true
  @Published var isOutlineEnabled = false
  @Published var selectedOutlineColorIndex = 0
  @Published var isRetryEnabled = false
  
  private init() { }
  
  var selectedRole: SDGAvatarDemoRole {
    roles[safe: selectedRoleIndex] ?? .admin
  }
  
  var selectedSize: SDGAvatarDemoSize {
    sizes[safe: selectedSizeIndex] ?? .xlarge
  }
  
  var avatarModel: SDGAvatar.Model {
    SDGAvatar.Model(
      userId: "avatar_sample_user",
      imageURL: Self.sampleImageURL
    )
  }

  var icon: Image? {
    isIconEnabled ? selectedRole.icon : nil
  }

  var outlineColor: Color? {
    guard isOutlineEnabled else { return nil }
    return (outlineColors[safe: selectedOutlineColorIndex] ?? .pink).color
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
  
  var icon: Image? {
    switch self {
    case .admin:
      return Image(sdg: .adminBadge)
    case .leader:
      return Image(sdg: .leaderBadge)
    case .staff:
      return nil
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

enum SDGAvatarDemoOutlineColor: String, CaseIterable {
  case pink = "Pink"
  case primary = "Primary"
  case neutral = "Neutral"

  var color: Color {
    switch self {
    case .pink: return .sdgSpecialPink
    case .primary: return .primary300
    case .neutral: return .neutral700
    }
  }
}

private extension Array {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
