//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

public struct SDGMiniProfile: View {
  
  public enum ProfileType {
    case normal, empha
  }
  
  private let _type: ProfileType
  private let _model: MiniProfileModel
  private let _avaterAction: (String) -> Void
  
  public init(type: ProfileType, model: MiniProfileModel, avatarAction: @escaping (String) -> Void) {
    _type = type
    _model = model
    _avaterAction = avatarAction
  }
  
  public var body: some View {
    
    HStack(spacing: 8) {
      
      SDGAvatar(type: .round, model: _model.avatarModel, size: .xxs) { userId in
        _avaterAction(userId)
      }
      
      VStack(alignment: .leading, spacing: 2) {
        switch _type {
        case .normal:
          Text(_model.name)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.neutral400)
          
        case .empha:
          
          Text(_model.name)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.neutral700)
          
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  struct MiniProfile_Preview: PreviewProvider {
    static var previews: some View {
      
      VStack(spacing: 10) {
        
        Text("Normal")
        
        SDGMiniProfile(
          type: .normal,
          model: MiniProfileModel(
            avatarModel: .init(userId: "", imageURL: nil, roleType: .leader),
            name: "직원명"
          ),
          avatarAction: { userId in
            
          }
        )
        
        Text("Empha")
          .padding(.top, 10)
        
        SDGMiniProfile(
          type: .empha,
          model: MiniProfileModel(
            avatarModel: .init(userId: "", imageURL: nil, roleType: .leader),
            name: "직원명"
          ),
          avatarAction: { userId in
            
          }
        )
      }
    }
  }
}

