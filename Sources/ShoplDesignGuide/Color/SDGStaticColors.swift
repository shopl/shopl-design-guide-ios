//
//  SDGStaticColors.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/29/25.
//

import SwiftUI

//// A static collection of colors used in the design guide.
public extension SDGColor {
  private init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    self.init(value: UIColor(red: red, green: green, blue: blue, alpha: alpha))
  }
  
  //MARK: - Brand
  static let primary50 = SDGColor(red: 0.867, green: 0.925, blue: 0.980, alpha: 1)
  static let primary200 = SDGColor(red: 0.510, green: 0.757, blue: 1.000, alpha: 1)
  static let primary300 = SDGColor(red: 0.196, green: 0.600, blue: 0.996, alpha: 1)
  static let primary400 = SDGColor(red: 0.169, green: 0.510, blue: 0.847, alpha: 1)
  static let secondary50 = SDGColor(red: 0.875, green: 0.910, blue: 0.937, alpha: 1)
  static let secondary200 = SDGColor(red: 0.592, green: 0.686, blue: 0.773, alpha: 1)
  static let secondary300 = SDGColor(red: 0.263, green: 0.420, blue: 0.569, alpha: 1)
  static let secondary400 = SDGColor(red: 0.208, green: 0.282, blue: 0.375, alpha: 1)
  
  //MARK: - Neutral
  static let neutral0 = SDGColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1)
  static let neutral50 = SDGColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1)
  static let neutral100 = SDGColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
  static let neutral150 = SDGColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
  static let neutral200 = SDGColor(red: 0.918, green: 0.918, blue: 0.918, alpha: 1)
  static let neutral250 = SDGColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1)
  static let neutral300 = SDGColor(red: 0.800, green: 0.800, blue: 0.800, alpha: 1)
  static let neutral350 = SDGColor(red: 0.733, green: 0.733, blue: 0.733, alpha: 1)
  static let neutral400 = SDGColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
  static let neutral500 = SDGColor(red: 0.467, green: 0.467, blue: 0.467, alpha: 1)
  static let neutral600 = SDGColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1)
  static let neutral700 = SDGColor(red: 0.222, green: 0.222, blue: 0.222, alpha: 1)
  static let neutral900 = SDGColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1)
  
  //MARK: - Point
  static let green = SDGColor(red: 0.392, green: 0.733, blue: 0.647, alpha: 1)
  static let purple = SDGColor(red: 0.412, green: 0.475, blue: 0.973, alpha: 1)
  static let red50 = SDGColor(red: 1.000, green: 0.918, blue: 0.918, alpha: 1)
  static let red300 = SDGColor(red: 1.000, green: 0.475, blue: 0.475, alpha: 1)
  static let red350 = SDGColor(red: 1.000, green: 0.400, blue: 0.400, alpha: 1)
  static let red400 = SDGColor(red: 0.851, green: 0.404, blue: 0.404, alpha: 1)
  static let yellow = SDGColor(red: 1.000, green: 0.835, blue: 0.118, alpha: 1)
  
  //MARK: - Special Color
  static let lemon = SDGColor(red: 1.000, green: 0.961, blue: 0.000, alpha: 1)
  static let orange = SDGColor(red: 1.000, green: 0.698, blue: 0.000, alpha: 1)
  static let pink = SDGColor(red: 1.000, green: 0.698, blue: 0.773, alpha: 1)
}

/// A collection of static colors used in the design guide.
fileprivate extension SDGColor {
  static let brands: [SDGColor] = [.primary50, .primary200, .primary300, .primary400,
                                    .secondary50, .secondary200, .secondary300, .secondary400]
  static let neutrals: [SDGColor] = [.neutral0, .neutral50, .neutral100, .neutral150,
                                      .neutral200, .neutral250, .neutral300, .neutral350,
                                      .neutral400, .neutral500, .neutral600, .neutral700,
                                      .neutral900]
  static let points: [SDGColor] = [.green, .purple, .red50, .red300, .red350, .red400, .yellow]
  static let specials: [SDGColor] = [.lemon, .orange, .pink]
  
  static let allCases: [SDGColor] = SDGColor.brands + SDGColor.neutrals + SDGColor.points + SDGColor.specials
}

/// A preview of the static colors in a scrollable view.
#Preview {
  ScrollView {
    VStack {
      ForEach(SDGColor.allCases.indices, id: \.self) { index in
        Color(SDGColor.allCases[index])
          .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)
      }
    }
    .padding(20)
  }
}
