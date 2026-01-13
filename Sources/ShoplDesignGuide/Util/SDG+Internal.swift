//
//  SDG+Internal.swift
//  ShoplDesignGuide
//
//  Created by Dino on 1/12/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

extension Image {
    // SDG 라이브러리 내부 전용 숏컷
    init(_ resource: SDG.Image) {
        self.init(sdg: resource)
    }
}
