//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//
import SwiftUI

import Kingfisher

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
  
  private let _type: AvatarType
  private let _model: AvatarModel
  private let _size: Size
  private let _action: (String) -> Void
  
  private var _maternityStorkeWidth: CGFloat {
    switch _size {
      case .xxs:  return 1.5
      case .xs:   return 1.8
      case .s:    return 2.4
      case .m:    return 3
      case .l:    return 3.6
      case .xl:   return 6
    }
  }
  
  private var _badgeSize: CGFloat {
    switch _size {
      case .xxs: return 8
      case .xs: return 10
      case .s: return 12
      case .m: return 14
      case .l: return 16
      case .xl: return 28
    }
  }
  
  public init(type: AvatarType, model: AvatarModel, size: Size, action: @escaping (String) -> Void) {
    _type = type
    _model = model
    _size = size
    _action = action
  }

  public var body: some View {
    
    Button {
      
      _action(_model.userId)
      
    } label: {
      
      ZStack(alignment: .bottomTrailing) {
      
        KFImage(_model.imageURL)
          .placeholder {
            Image(.avatarEmptyDot)
              .resizable()
              .frame(width: _size.rawValue, height: _size.rawValue)
              .foregroundColor(.neutral250)
          }
          .resizable()
          .background(.neutral100)
          .clipShape(Circle())
          .frame(width: _size.rawValue, height: _size.rawValue)
          .applyIf(_model.maternity != .none) { view in
            view
              .overlay(
                RoundedRectangle(cornerRadius: 100, style: .circular)
                  .strokeBorder(.pink, lineWidth: _maternityStorkeWidth)
              )
          }
        
        switch _model.roleType {
          case .worker:
            EmptyView()
            
          case .leader:
            Image(.leaderBadge)
              .resizable()
              .frame(width: _badgeSize, height: _badgeSize)
            
          case .opLeader:
            Image(.adminBadge)
              .resizable()
              .frame(width: _badgeSize, height: _badgeSize)
            
        }
      }
    }
  }
}

struct Avatar_Preview: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 5) {
      Group {
        Text("XXS")
        
        HStack(spacing: 10) {
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .worker
            ),
            size: .xxs,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .leader
            ),
            size: .xxs,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader
            ),
            size: .xxs,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader,
              maternity: .pre
            ),
            size: .xxs,
            action: { userId in
              
            }
          )
        }
      }
      .padding(.top, 10)
      
      Group {
        Text("XS")
        HStack(spacing: 10) {
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .worker
            ),
            size: .xs,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .leader
            ),
            size: .xs,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader
            ),
            size: .xs,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader,
              maternity: .pre
            ),
            size: .xs,
            action: { userId in
              
            }
          )
        }
      }
      .padding(.top, 10)
      
      Group {
        Text("S")
        HStack(spacing: 10) {
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .worker
            ),
            size: .s,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .leader
            ),
            size: .s,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader
            ),
            size: .s,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader,
              maternity: .pre
            ),
            size: .s,
            action: { userId in
              
            }
          )
        }
      }
      .padding(.top, 10)
      
      Group {
        Text("M")
        HStack(spacing: 10) {
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .worker
            ),
            size: .m,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .leader
            ),
            size: .m,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader
            ),
            size: .m,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader,
              maternity: .pre
            ),
            size: .m,
            action: { userId in
              
            }
          )
        }
      }
      .padding(.top, 10)
      
      Group {
        Text("L")
        HStack(spacing: 10) {
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .worker
            ),
            size: .l,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .leader
            ),
            size: .l,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader
            ),
            size: .l,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader,
              maternity: .pre
            ),
            size: .l,
            action: { userId in
              
            }
          )
        }
      }
      .padding(.top, 10)
      
      Group {
        Text("XL")
        HStack(spacing: 10) {
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .worker
            ),
            size: .xl,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .leader
            ),
            size: .xl,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader
            ),
            size: .xl,
            action: { userId in
              
            }
          )
          
          SDGAvatar(
            type: .round,
            model: AvatarModel(
              userId: "",
              imageURL: nil,
              roleType: .opLeader,
              maternity: .pre
            ),
            size: .xl,
            action: { userId in
              
            }
          )
        }
      }
      .padding(.top, 10)
      
    }
  }
}
