//
//  File.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct Time: View {
  
  private var _changeHour: ((Int) -> ())
  private var _changeMinute: ((Int) -> ())
  
  private var _hour: [Int]
  private var _minute: [Int]
  
  private var _initHour: Int
  private var _initMinute: Int
  
  @State private var _selectedHour: Int = 0
  @State private var _selectedMinute: Int = 0
  
  public struct Model: Equatable {
    public let selectedHour: Int
    public let selectedMinute: Int
    
    public init(
      selectedHour: Int,
      selectedMinute: Int
    ) {
      self.selectedHour = selectedHour
      self.selectedMinute = selectedMinute
    }
  }
  
  public init(
    model: Model,
    changeHour: @escaping ((Int) -> ()),
    changeMinute: @escaping ((Int) -> ())
  ) {
    self._changeHour = changeHour
    self._changeMinute = changeMinute
    
    let selectedHour = model.selectedHour
    
    let hour = if selectedHour == 0 { 120 }
    else { selectedHour + 120 }
    
    self._selectedHour = hour
    self._initHour = hour
    
    let selectedMinute = model.selectedMinute
    
    let minute = if selectedMinute == 0 { 300 }
    else { selectedMinute + 300 }
    
    self._selectedMinute = minute
    self._initMinute = minute
    
    self._hour = Array(stride(from: 0, through: 239, by: 1))
    self._minute = Array(stride(from: 0, through: 559, by: 1))
  }
  
  public var body: some View {
    ZStack {
      Color.neutral150
        .frame(maxWidth: .infinity, minHeight: 32, maxHeight: 32)
        .cornerRadius(8)
      
      HStack {
        TimePicker(.hour(24), _hour, _initHour, $_selectedHour)
          .frame(maxWidth: .infinity)
        
        Text(":")
          .font(.system(size: 16))
          .foregroundStyle(.neutral700)
        
        TimePicker(.minute(60), _minute, _initMinute, $_selectedMinute)
          .frame(maxWidth: .infinity)
      }
      .frame(height: 160)
    }
    .onChange(of: _selectedHour) { selectedHour in
      _changeHour(selectedHour % 24)
    }
    .onChange(of: _selectedMinute) { selectedMinute in
      _changeMinute(selectedMinute % 60)
    }
  }
}

#Preview {
  ZStack {
    Time(
      model: .init(
        selectedHour: 10,
        selectedMinute: 0
      ),
      changeHour: { _ in
        
      },
      changeMinute: { _ in
        
      }
    )
  }
}

