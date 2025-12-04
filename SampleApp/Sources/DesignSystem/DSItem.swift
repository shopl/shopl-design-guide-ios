//
//  DSItem.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/27/25.
//  Copyright © 2025 Shopl. All rights reserved.
//

import SwiftUI

import SwiftUI

struct DSItem: Identifiable, Codable {
    var id: UUID = UUID()
    let title: String
    let description: String?
    let subDescription: String?
    
    let viewID: String? // 뷰 매핑을 위한 String Key
    let children: [DSItem]?
    
    static func category(title: String, description: String? = nil, subDescription: String? = nil, children: [DSItem]) -> DSItem {
        DSItem(title: title, description: description, subDescription: subDescription, viewID: nil, children: children)
    }
    
    static func item(title: String, description: String? = nil, subDescription: String? = nil, viewID: String) -> DSItem {
        DSItem(title: title, description: description, subDescription: subDescription, viewID: viewID, children: nil)
    }
}
