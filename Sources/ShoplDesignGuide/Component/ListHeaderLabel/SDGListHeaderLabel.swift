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
  
  public struct Content {
	let title: String
	let count: Int?
	
	public init(title: String, count: Int?) {
	  self.title = title
	  self.count = count
	}
  }
  
  public struct Property {
	let isShowDropdownIcon: Bool
	
	public init(isShowDropdownIcon: Bool) {
	  self.isShowDropdownIcon = isShowDropdownIcon
	}
  }
  
  private let content: Content
  private let property: Property
  
  public init(content: Content, property: Property) {
	self.content = content
	self.property = property
  }
  
  public var body: some View {
	HStack(spacing: SDGSpacing.spacing2) {
	  Text(self.content.title)
		.typo(.body1_SB, .neutral700)
		.lineLimit(1)
	  
	  if let count = self.content.count {
		Text("(\(count))")
		  .typo(.body1_SB, .neutral700)
		  .lineLimit(1)
		  .layoutPriority(1)
	  }
	  
	  if self.property.isShowDropdownIcon {
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
		content: .init(
		  title: "타이틀",
		  count: 0
		),
		property: .init(isShowDropdownIcon: true)
	  )
	  
	  // title, count 만 존재
	  SDGListHeaderLabel(
		content: .init(
		  title: "타이틀",
		  count: 2
		),
		property: .init(isShowDropdownIcon: false)
	  )
	  
	  // title, dropdownIcon 존재
	  SDGListHeaderLabel(
		content: .init(
		  title: "타이틀 엄청 긴 텍스트입니다아아아아아아아",
		  count: nil
		),
		property: .init(isShowDropdownIcon: true)
	  )
	  
	  // title만 존재
	  SDGListHeaderLabel(
		content: .init(
		  title: "타이틀",
		  count: nil
		),
		property: .init(isShowDropdownIcon: false)
	  )
	  
	}
	.padding()
	.ignoresSafeArea()
	.background(
	  Color.neutral250.opacity(0.3)
	)
  }
}

