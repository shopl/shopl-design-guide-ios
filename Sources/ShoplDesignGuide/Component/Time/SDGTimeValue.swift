//
//  SDGTimeValue.swift
//  ShoplDesignGuide
//
//  Created by dino on 9/2/26.
//

public struct SDGTimeValue: Equatable, Sendable {
  public static let midnight = SDGTimeValue(
    validatedHour: 0,
    minute: 0
  )

  public let hour: Int
  public let minute: Int

  public init?(hour: Int, minute: Int) {
    guard (0..<24).contains(hour),
      (0..<60).contains(minute)
    else {
      return nil
    }

    self.init(
      validatedHour: hour,
      minute: minute
    )
  }

  public init?(hhmm: String) {
    let components = hhmm.split(
      separator: ":",
      omittingEmptySubsequences: false
    )
    guard components.count == 2,
      components.allSatisfy({ component in
        component.utf8.count == 2 &&
          component.utf8.allSatisfy { byte in
            (48...57).contains(byte)
          }
      }),
      let hour = Int(components[0]),
      let minute = Int(components[1])
    else {
      return nil
    }

    self.init(hour: hour, minute: minute)
  }

  public var hhmm: String {
    let hourText = hour < 10 ? "0\(hour)" : "\(hour)"
    let minuteText = minute < 10 ? "0\(minute)" : "\(minute)"
    return "\(hourText):\(minuteText)"
  }

  private init(validatedHour: Int, minute: Int) {
    self.hour = validatedHour
    self.minute = minute
  }
}
