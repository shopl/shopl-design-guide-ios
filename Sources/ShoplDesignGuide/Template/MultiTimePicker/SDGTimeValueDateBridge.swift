//
//  SDGTimeValueDateBridge.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/3/26.
//

import Foundation

enum SDGTimeValueDateBridge {
  static let timeZone = TimeZone.gmt

  static let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone
    return calendar
  }()

  private static let referenceDate = Date(timeIntervalSinceReferenceDate: 0)

  static func date(from time: SDGTimeValue) -> Date {
    return referenceDate.addingTimeInterval(
      TimeInterval(time.hour * 60 * 60 + time.minute * 60)
    )
  }

  static func time(from date: Date) -> SDGTimeValue {
    let components = calendar.dateComponents([.hour, .minute], from: date)

    guard let hour = components.hour,
      let minute = components.minute,
      let time = SDGTimeValue(hour: hour, minute: minute)
    else {
      return .midnight
    }

    return time
  }
}
