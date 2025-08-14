//
//  SDGHistoryHeader.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct SDGHistoryHeader: View {
  
  public struct Model: Equatable {
    public let id: UUID
    public let date: String
    public let title: String
    public let positionType: HistoryPositionType
    public let profileModel: ProfileModel?
    
    public init(
      id: UUID,
      date: String,
      title: String,
      positionType: HistoryPositionType,
      profileModel: ProfileModel?
    ) {
      self.id = id
      self.date = date
      self.title = title
      self.positionType = positionType
      self.profileModel = profileModel
    }
  }
  
  private let _foregroundColor: Color
  private let _profileForegroundColor: Color
  private let _historyModel: Model
  private let _avatarAction: (String) -> Void
  
  public init(
    foregroundColor: Color,
    profileForegroundColor: Color,
    historyModel: Model,
    avatarAction: @escaping (String) -> Void
  ) {
    self._foregroundColor = foregroundColor
    self._profileForegroundColor = profileForegroundColor
    self._historyModel = historyModel
    self._avatarAction = avatarAction
  }
  
  public var body: some View {
    
    HStack(spacing: 0) {
      VStack(spacing: 0) {
        Divider(
          color: self._historyModel.positionType.firstFooterColor,
          option: .init(
            direction: .vertical,
            thickness: 1
          )
        )
        .frame(height: 20)
        
        RoundedRectangle(cornerRadius: 4)
          .foregroundColor(.neutral300)
          .frame(width: 8, height: 8)
          .padding(.top, 5)
        
        Divider(
          color: self._historyModel.positionType.secondFooterColor,
          option: .init(
            direction: .vertical,
            thickness: 1
          )
        )
        .padding(.top, 5)
        
      }
      .padding(.leading, 20)
      
      VStack(spacing: 0) {
        Text(self._historyModel.date)
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.neutral400)
          .fixedSize(horizontal: false, vertical: true)
          .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
          )
          .padding(.top, 20)
        
        Text(self._historyModel.title)
          .font(.system(size: 16, weight: .regular))
          .foregroundColor(self._foregroundColor)
          .fixedSize(horizontal: false, vertical: true)
          .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
          )
          .lineLimit(nil)
          .padding(.top, 20)
        
        if let profileModel = _historyModel.profileModel {
          VStack {
            SDGSecondProfile(
              type: .normal,
              model: profileModel,
              avatarAction: self._avatarAction
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
          }
          .background(self._profileForegroundColor)
          .cornerRadius(12)
          .padding(.top, 10)
          .padding(.bottom, 20)
        }
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 0)
    }
  }
}


struct SDGHistoryHeader_Preview: PreviewProvider {
  static var previews: some View {
    ScrollView {
      VStack(spacing: 0) {
        SDGHistoryHeader(
          foregroundColor: .neutral700,
          profileForegroundColor: .neutral50,
          historyModel: .init(
            id: UUID(),
            date: "2023.02.10(금) 11:00",
            title: "재작업 요청",
            positionType: .first,
            profileModel: ProfileModel(
              avatarModel: .init(userId: "", imageURL: nil, roleType: .leader),
              name: "직원명",
              groupName: "그룹명",
              activeStatus: .active
            )
          ),
          avatarAction: { _ in
            
          }
        )
        
        SDGHistoryHeader(
          foregroundColor: .neutral700,
          profileForegroundColor: .neutral50,
          historyModel: .init(
            id: UUID(),
            date: "2023.02.10(금) 11:00",
            title: "재작업 요청",
            positionType: .middle,
            profileModel: nil
          ),
          avatarAction: { _ in
            
          }
        )
        
        SDGHistoryHeader(
          foregroundColor: .primary300,
          profileForegroundColor: .primary300.opacity(0.1),
          historyModel: .init(
            id: UUID(),
            date: "2023.02.10(금) 11:00",
            title: "검수 성공",
            positionType: .middle,
            profileModel: ProfileModel(
              avatarModel: .init(userId: "", imageURL: nil, roleType: .leader),
              name: "직원명",
              groupName: "그룹명",
              activeStatus: .active
            )
          ),
          avatarAction: { _ in
            
          }
        )
        
        SDGHistoryHeader(
          foregroundColor: .red300,
          profileForegroundColor: .red300.opacity(0.1),
          historyModel: .init(
            id: UUID(),
            date: "2023.02.10(금) 11:00",
            title: "재작업 요청재작업 요청재작업 요청재작업 요청재작업 요청재작업 요청재작업 요청재작업 요청",
            positionType: .last,
            profileModel: ProfileModel(
              avatarModel: .init(userId: "", imageURL: nil, roleType: .leader),
              name: "직원명",
              groupName: "그룹명",
              activeStatus: .active
            )
          ),
          avatarAction: { _ in
            
          }
        )
      }
    }
  }
}

