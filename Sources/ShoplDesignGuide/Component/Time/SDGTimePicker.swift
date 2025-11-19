//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 6/11/25.
//

import SwiftUI

struct SDGTimePicker: View {
  
  public enum `Type`: Equatable {
    case hour(Int), minute(Int)
    
    var modular: Int {
      switch self {
        case let .hour(modular): return modular
        case let .minute(modular): return modular
      }
    }
  }
  
  let type: `Type`
  let options: [Int]
  let initValue: Int
  @Binding var selection: Int
  @State private var drag: Double = 0
  
  let cellAngles = 20.0
  
  init(
    _ type: `Type`,
    _ options: [Int],
    _ initValue: Int,
    _ selection: Binding<Int>
  ) {
    self.type = type
    self.options = options
    self.initValue = initValue
    self._selection = selection
  }
  
  var body: some View {
    let selectedIndex = getSelectedIndex()
    HStack {
      ZStack {
        ForEach(0..<options.count, id: \.self) { index in
          let item: Int = options[index]
          
          SDGTimePickerCell(
            isChanged: ((item % type.modular) != initValue % type.modular) && (item == selection),
            title: String(format: "%02d", item % type.modular),
            angle: Double(index - selectedIndex) * cellAngles + drag
          )
          .frame(maxWidth: .infinity, minHeight: 32, maxHeight: 32)
        }
      }
      .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 160)
      .gesture(
        DragGesture()
          .onChanged { gesture in
            drag = gesture.translation.height
          }
          .onEnded { _ in
            var newIndex = selectedIndex - Int(round(drag / cellAngles))
            if newIndex < 0 {
              newIndex = 0
            }
            if newIndex >= options.count - 1 {
              newIndex = options.count - 1
            }
            selection = options[newIndex]
            drag = 0
          }
      )
    }
  }
  
  func getSelectedIndex() -> Int {
    return options.firstIndex(of: selection) ?? 0
  }
  
}

private struct SDGTimePickerCell: View {
  
  let isChanged: Bool
  let title: String
  let angle: Double
  
  var body: some View {
    if abs(angle) > 90 {
      EmptyView()
    }
    
    else {
      let sinValue = sin(rad(angle))
      let cosValue = cos(rad(angle))
      Text(title)
        .font(.system(size: 16))
        .foregroundColor(
          isChanged ? .primary300 : .neutral700
        )
        .scaleEffect(y: cosValue)
        .offset(y: sinValue * 85)
        .opacity(abs(angle) < 5 ? 1.0 : cosValue/2)
        .frame(maxWidth: .infinity, minHeight: 32, maxHeight: 32)
    }
  }
  
  func rad(_ number: Double) -> Double {
    return number * .pi / 180
  }
}
