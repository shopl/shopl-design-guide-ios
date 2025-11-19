//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

public struct SDGTimePicker: View {
  
  @Binding var selectedDate: Date
  private var is24HourFormat: Bool
  
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
    
    @State var selectedDate1 = Date()
    @State var selectedDate2 = Date()

    var body: some View {
      VStack(spacing: 20) {
        VStack(spacing: 0){
          Text("24 Hour Format")
          
          SDGTimePicker(
            selectedDate: $selectedDate1,
            is24HourFormat: true
          )
        }
        
        Divider(color: .neutral700,
                option: .init(direction: .horizental, thickness: 1))
        
        VStack(spacing: 0){
          Text("12 Hour Format")
          
          SDGTimePicker(
            selectedDate: $selectedDate2,
            is24HourFormat: false
          )
        }
      }
    }
  }
  
  static var previews: some View {
    PreviewWrapper()
  }
}
