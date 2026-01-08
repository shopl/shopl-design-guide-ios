//
//  SDGListHeaderLabel.swift
//  ShoplDesignGuide
//
//  Created by kai on 1/8/26.
//  Copyright © 2026 Shopl. All rights reserved.
//

import SwiftUI

/// https://www.figma.com/design/qWVshatQ9eqoIn4fdEZqWy/SDG?m=dev&node-id=22084-3889
public struct SDGListHeaderLabel: View {
  
  public struct Model {
	let title: String
	let count: Int?
	
	let isShowDropdownIcon: Bool
	
	public init(title: String, count: Int?, isShowDropdownIcon: Bool) {
	  self.title = title
	  self.count = count
	  self.isShowDropdownIcon = isShowDropdownIcon
	}
  }
  
  private let model: Model
  
  public init(model: Model) {
	self.model = model
  }
  
  public var body: some View {
	HStack(spacing: SDGSpacing.spacing2) {
	  Text(self.model.title)
		.typo(.body1_SB, .neutral700)
		.lineLimit(1)
	  
	  if let count = self.model.count {
		Text("(\(count))")
		  .typo(.body1_SB, .neutral700)
		  .lineLimit(1)
		  .layoutPriority(1)
	  }
	  
	  if self.model.isShowDropdownIcon {
		Image(.icCommonDropdown)
		  .resizable()
		  .frame(width: 20, height: 20)
		  .foregroundColor(.neutral700)
		  .layoutPriority(1)
	  }
	  
	  Spacer()
	}
  }
}


struct SDGListHeaderLabel_Preview: PreviewProvider {
  static var previews: some View {
	VStack {
	  // title, count, dropdownIcon 존재
	  SDGListHeaderLabel(
		model: .init(
		  title: "타이틀",
		  count: 0,
		  isShowDropdownIcon: true
		)
	  )
	  
	  // title, count 만 존재
	  SDGListHeaderLabel(
		model: .init(
		  title: "타이틀",
		  count: 2,
		  isShowDropdownIcon: false
		)
	  )
	  
	  // title, dropdownIcon 존재
	  SDGListHeaderLabel(
		model: .init(
		  title: "타이틀 엄청 긴 텍스트입니다아아아아아아아",
		  count: nil,
		  isShowDropdownIcon: true
		)
	  )
	  
	  // title만 존재
	  SDGListHeaderLabel(
		model: .init(
		  title: "타이틀",
		  count: nil,
		  isShowDropdownIcon: false
		)
	  )
	  
	}
	.padding()
	.ignoresSafeArea()
	.background(
	  Color.neutral250.opacity(0.3)
	)
  }
}

