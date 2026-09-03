//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

public struct SDGTimePicker: View {
  
  @Binding var selectedDate: Date

  /// 기존 화면을 24시간 고정 피커로 마이그레이션할 때까지 유지하는 호환 값.
  ///
  /// 기존 스케줄 피커는 24시간 고정 `Time`에서 기기 설정을 따르는 `DatePicker`로
  /// 교체되었고(shopl-ios: 97b2f2566e), 이후 `SDGTimePicker` 도입 시에도
  /// 기존 동작을 유지하도록 이 값이 추가되었다(shopl-ios: ea1d3f1099).
  /// `true`는 24시간제를 강제하고, `false`는 12시간제 강제가 아닌 기기 설정을 따른다.
  ///
  /// 시간 피커를 24시간제로 통일하기 위해 이 값을 받는 초기화는 deprecated되었다.
  /// 기존 호출부가 `init(selectedDate:)`로 전환되면 호환 초기화와 함께 제거한다.
  private var is24HourFormat: Bool

  public init(selectedDate: Binding<Date>) {
    self._selectedDate = selectedDate
    self.is24HourFormat = true
  }

  /// 기존 화면의 시간 형식을 보존하며 24시간제로 점진적으로 전환하기 위한 호환 초기화.
  /// 신규 화면과 마이그레이션을 마친 화면에서는 `init(selectedDate:)`를 사용한다.
  /// - Parameter is24HourFormat: `true`이면 24시간제를 강제하고, `false`이면 기기 설정을 따른다.
  @available(*, deprecated, message: "Use init(selectedDate:) for a 24-hour picker.")
  public init(
    selectedDate: Binding<Date>,
    is24HourFormat: Bool
  ) {
    self._selectedDate = selectedDate
    self.is24HourFormat = is24HourFormat
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      DatePicker(
           "",
           selection: $selectedDate,
           displayedComponents: .hourAndMinute
         )
      .labelsHidden()
      .datePickerStyle(.wheel)
      .applyIf(is24HourFormat, apply: {
        $0.environment(\.locale, Locale(identifier: "en_GB"))
      })
    }
  }
}

struct SDGTimePicker_Previews: PreviewProvider {
  
  struct PreviewWrapper: View {

    @State var selectedDate = Date()

    var body: some View {
      VStack(spacing: 0) {
        Text("24 Hour Format")

        SDGTimePicker(selectedDate: $selectedDate)
      }
    }
  }
  
  static var previews: some View {
    PreviewWrapper()
  }
}
