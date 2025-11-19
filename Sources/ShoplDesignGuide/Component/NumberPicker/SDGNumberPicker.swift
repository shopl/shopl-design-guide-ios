//
//  SDGNumberPicker.swift
//  ShoplDesignGuide
//
//  Created by Dino on 11/19/25.
//

import SwiftUI

public struct SDGNumberPicker: View {
  
  public enum `Type` {
    case one(Binding<Int>, [Int])
    case two(Binding<Int>, [Int], Binding<Int>, [Int])
  }
  
  private let type: `Type`
  
  public init(
    type: `Type`
  ) {
    self.type = type
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      switch type {
      case let .one(selection, selectables):
        Picker(selection: selection, label: Text("")) {
          ForEach(selectables, id: \.self) {
            Text(String($0))
          }
        }
        .labelsHidden()
        .pickerStyle(.wheel)
        
      case let .two(selection1, selectables1, selection2, selectables2):
        Picker(selection: selection1, label: Text("")) {
          ForEach(selectables1, id: \.self) {
            Text(String($0))
          }
        }
        .labelsHidden()
        .pickerStyle(.wheel)
        
        Picker(selection: selection2, label: Text("")) {
          ForEach(selectables2, id: \.self) {
            Text(String($0))
          }
        }
        .labelsHidden()
        .pickerStyle(.wheel)
      }
    }
  }
}

struct SDGNumberPicker_Previews: PreviewProvider {
  
  struct PreviewWrapper: View {
    @State var selectedHour = 0
    @State var selectedMinute = 0
    
    private let minuteInterval: Int = 5
    private let maxHour: Int = 12
    
    var body: some View {
      VStack(spacing: 20) {
        VStack(spacing: 0){
          Text("one")
          
          SDGNumberPicker(
            type: .one(
              $selectedHour,
              Array(0...maxHour)
            )
          )
        }
        
        Divider(color: .neutral700,
                option: .init(direction: .horizental, thickness: 1))
        
        VStack(spacing: 0){
          Text("two")
          
          SDGNumberPicker(
            type: .two(
              $selectedHour,
              Array(0...maxHour),
              $selectedMinute,
              Array(stride(from: 0, to: 60, by: minuteInterval))
            )
          )
        }
      }
    }
  }
  
  static var previews: some View {
    PreviewWrapper()
  }
}
