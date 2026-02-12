//
//  Iflet.swift
//  ShoplDesignGuide
//
//  Created by kai on 1/16/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

extension View {
	@ViewBuilder
	func ifLet<Value, Content: View>(_ value: Value?, transform: (Self, Value) -> Content) -> some View {
		if let value = value {
			transform(self, value)
		} else {
			self
		}
	}
}
