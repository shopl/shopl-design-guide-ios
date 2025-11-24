//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/12/25.
//

import Foundation

/*
 in AppDelegate write this code
 
 // MARK: - SDGStringProvider Implementation using ESLocalizedString
 class LocalizedStringProvider: SDGStringProvider {
  func getString(key: String) -> String? {
    // Get localized string using ESLocalizedString with the provided key
    return ESLocalizedString(key)
  }
 }
 
 // MARK: - AppDelegate func
 func application(
     _ application: UIApplication,
     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
 ) -> Bool {
 
  // Set up the localization provider at app launch
  // This enables SDGLocalizationKey enum to fetch localized strings via ESLocalizedString
 
  SDGString.shared.setProvider(provider: LocalizedStringProvider())
  
  ...
 
  return true
 }
 
 Usage Example:
 - SDGLocalizationKey.confirm.string → Gets "확인" or "Confirm" based on device language
 - SDGLocalizationKey.cancel.string → Gets "취소" or "Cancel" based on device language
 - String(format: SDGLocalizationKey.quitting_limit_time.string, "8", "30") → Gets "8시간 30분" or "8 hours 30 minutes"
*/

@MainActor
public class SDGString {
  
  public static let shared = SDGString()
  
  private var provider: SDGStringProvider?
  
  private init() { }
  
  public func setProvider(provider: SDGStringProvider) {
    self.provider = provider
  }
  
  func getSDGString(key: SDGLocalizationKey) -> String {
    guard let provider = provider else {
      fatalError("SDGString provider is not set. Please set a provider before accessing localization strings.")
    }
    
    guard let string = provider.getString(key: key.rawValue) else {
      fatalError("Localization string for key '\(key.rawValue)' not found. Please ensure the key exists in your localization files.")
    }
    
    return string
  }
}
