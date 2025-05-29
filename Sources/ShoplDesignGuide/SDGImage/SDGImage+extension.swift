//
//  SDGImage.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/29/25.
//

import SwiftUI

// MARK: - SDGImage
public extension SDGImage {
  static let admin_badge: SDGImage = SDGImage(name: "admin_badge")
  static let avatar_emplty: SDGImage = SDGImage(name: "avatar_empty")
  static let empty_member: SDGImage = SDGImage(name: "empty_member")
  static let ic_clip: SDGImage = SDGImage(name: "ic_clip")
  static let ic_common_check_s: SDGImage = SDGImage(name: "ic_common_check_s")
  static let ic_common_company: SDGImage = SDGImage(name: "ic_common_company")
  static let ic_common_distributor: SDGImage = SDGImage(name: "ic_common_distributor")
  static let ic_common_dropdown: SDGImage = SDGImage(name: "ic_common_dropdown")
  static let ic_common_edit: SDGImage = SDGImage(name: "ic_common_edit")
  static let ic_common_mail: SDGImage = SDGImage(name: "ic_common_mail")
  static let ic_common_memo: SDGImage = SDGImage(name: "ic_common_memo")
  static let ic_common_next_s: SDGImage = SDGImage(name: "ic_common_next_s")
  static let ic_common_next: SDGImage = SDGImage(name: "ic_common_next")
  static let ic_common_prev: SDGImage = SDGImage(name: "ic_common_prev")
  static let ic_common_refresh: SDGImage = SDGImage(name: "ic_common_refresh")
  static let ic_common_rest: SDGImage = SDGImage(name: "ic_common_rest")
  static let ic_common_search: SDGImage = SDGImage(name: "ic_common_search")
  static let ic_common_time: SDGImage = SDGImage(name: "ic_common_time")
  static let ic_common_warning: SDGImage = SDGImage(name: "ic_common_warning")
  static let ic_common_x: SDGImage = SDGImage(name: "ic_common_x")
  static let ic_input_delete: SDGImage = SDGImage(name: "ic_input_delete")
  static let ic_menu_attendance: SDGImage = SDGImage(name: "ic_menu_attendance")
  static let ic_navi_chat: SDGImage = SDGImage(name: "ic_navi_chat")
  static let ic_navi_close: SDGImage = SDGImage(name: "ic_navi_close")
  static let ic_navi_filter: SDGImage = SDGImage(name: "ic_navi_filter")
  static let ic_toolbar_back: SDGImage = SDGImage(name: "ic_toolbar_back")
  static let leader_badge: SDGImage = SDGImage(name: "leader_badge")
  static let popup_warning: SDGImage = SDGImage(name: "popup_warning")
  static let profile_small: SDGImage = SDGImage(name: "profile_small")
}

/// A collection of all `SDGImage` instances.
fileprivate extension SDGImage {
  static let images: [SDGImage] = [
    .admin_badge,
    .avatar_emplty,
    .empty_member,
    .ic_clip,
    .ic_common_check_s,
    .ic_common_company,
    .ic_common_distributor,
    .ic_common_dropdown,
    .ic_common_edit,
    .ic_common_mail,
    .ic_common_memo,
    .ic_common_next_s,
    .ic_common_next,
    .ic_common_prev,
    .ic_common_refresh,
    .ic_common_rest,
    .ic_common_search,
    .ic_common_time,
    .ic_common_warning,
    .ic_common_x,
    .ic_input_delete,
    .ic_menu_attendance,
    .ic_navi_chat,
    .ic_navi_close,
    .ic_navi_filter,
    .ic_toolbar_back,
    .leader_badge,
    .popup_warning,
    .profile_small,
  ]
}

/// A preview of all `SDGImage` instances in a grid layout.
#Preview {
  let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
  
  ScrollView {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(SDGImage.images, id: \.name) { image in
        VStack(spacing: 8) {
          Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
          Text(image.name)
            .font(.caption)
            .multilineTextAlignment(.center)
        }
        .padding()
      }
    }
    .padding()
  }
}
