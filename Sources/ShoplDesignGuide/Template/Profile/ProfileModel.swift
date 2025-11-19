//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import Foundation

public struct ProfileModel: Equatable, Hashable {
  
  public enum ActiveStatus: Sendable, Decodable, Equatable {
    case active
    case resign
    case deleted
  }
  
  public let avatarModel: AvatarModel
  public let name: String
  public let groupName: String?
  public let resignDate: String?
  public let activeStatus: ActiveStatus
  
  public init(
    avatarModel: AvatarModel,
    name: String,
    groupName: String?,
    resignDate: String? = nil,
    activeStatus: ActiveStatus
  ) {
    self.avatarModel = avatarModel
    self.name = name
    self.groupName = groupName
    self.resignDate = resignDate
    self.activeStatus = activeStatus
  }
}

public struct Profile2Model {
  public let avatarModel: AvatarModel
  public let name: String?
  public let date: Date
  public let userLanguageCode: String
  
  public init(avatarModel: AvatarModel, name: String?, date: Date, userLanguageCode: String) {
    self.avatarModel = avatarModel
    self.name = name
    self.date = date
    self.userLanguageCode = userLanguageCode
  }
}

public struct MiniProfileModel: Equatable, Hashable {
  public let avatarModel: AvatarModel
  public let name: String
  
  public init(avatarModel: AvatarModel, name: String) {
    self.avatarModel = avatarModel
    self.name = name
  }
}

