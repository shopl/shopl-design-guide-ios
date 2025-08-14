//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/13/25.
//

import SwiftUI

public struct SDGSecondProfile: View {
  
  public enum ProfileType {
    case normal, empha
  }
  
  private let _type: ProfileType
  private let _model: ProfileModel
  private let _lineLimit: Int?
  private let _avaterAction: (String) -> Void
  
  public init(
    type: ProfileType,
    model: ProfileModel,
    lineLimit: Int? = nil,
    avatarAction: @escaping (String) -> Void
  ) {
    _type = type
    _model = model
    _lineLimit = lineLimit
    _avaterAction = avatarAction
  }
  
  public var body: some View {
    
    HStack(alignment: .top, spacing: 8) {
      
      Avatar(type: .round, model: _model.avatarModel, size: .s) { userId in
        _avaterAction(userId)
      }
      
      VStack(alignment: .leading, spacing: 0) {
        
        switch _type {
        case .normal:
          
          switch _model.activeStatus {
          case .active:
            Text(_model.name)
              .lineLimit(_lineLimit)
              .font(.system(size: 14, weight: .regular))
              .foregroundColor(.neutral700)
            
          case .resign:
            Text(String())
              .attributeText(
                fullText: "[\(SDGLocalizationKey.resign_title.string)] \(_model.name)",
                defaultFont: .system(size: 14),
                defaultColor: .neutral700,
                highlights: [
                  TextHighlight(
                    word: "[\(SDGLocalizationKey.resign_title.string)]",
                    font: .system(size: 14, weight: .semibold),
                    color: .red350,
                    underline: false
                  )
                ]
              )
            
          case .deleted:
            
            Text(String())
              .attributeText(
                fullText: "[\(SDGLocalizationKey.delete_account.string)] \(_model.name)",
                defaultFont: .system(size: 14),
                defaultColor: .neutral700,
                highlights: [
                  TextHighlight(
                    word: "[\(SDGLocalizationKey.delete_account.string)]",
                    font: .system(size: 14, weight: .semibold),
                    color: .primary300,
                    underline: false
                  )
                ]
              )
          }
          
          Text(_model.groupName ?? "")
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.neutral500)
          
        case .empha:
          
          switch _model.activeStatus {
          case .active:
            Text(_model.name)
              .lineLimit(_lineLimit)
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.neutral700)
            
          case .resign:
            Text(String())
              .attributeText(
                fullText: "[\(SDGLocalizationKey.resign_title.string)] \(_model.name)",
                defaultFont: .system(size: 14),
                defaultColor: .neutral700,
                highlights: [
                  TextHighlight(
                    word: "[\(SDGLocalizationKey.resign_title.string)]",
                    font: .system(size: 14, weight: .semibold),
                    color: .red350,
                    underline: false
                  )
                ]
              )
            
          case .deleted:
            Text(String())
              .attributeText(
                fullText: "[\(SDGLocalizationKey.delete_account.string)] \(_model.name)",
                defaultFont: .system(size: 14),
                defaultColor: .neutral700,
                highlights: [
                  TextHighlight(
                    word: "[\(SDGLocalizationKey.delete_account.string)]",
                    font: .system(size: 14, weight: .semibold),
                    color: .primary300,
                    underline: false
                  )
                ]
              )
          }
          
          Text(_model.groupName ?? "")
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.neutral700)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
