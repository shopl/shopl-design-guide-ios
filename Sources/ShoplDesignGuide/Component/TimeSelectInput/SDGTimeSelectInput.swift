//
//  File.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 8/22/25.
//

import SwiftUI

public struct SDGTimeSelectInput: View {
  
  public enum Status: Equatable {
    case `default`
    case selected
    case disalbed
    case error(String)
    
    public static func == (lhs: Status, rhs: Status) -> Bool {
      switch (lhs, rhs) {
      case (.default, .default),
        (.selected, .selected),
        (.disalbed, .disalbed): return true
      case (.error(let lhsError), .error(let rhsError)):
        return lhsError == rhsError
      default: return false
      }
    }
  }
  
  @Binding private var status: Status
  
  private var startTime: String?
  private var endTime: String?
  
  private var startPlaceholder: String
  private var endPlaceholder: String
  
  private var start: String {
    if let startTime = startTime {
      return startTime
    }
    
    return startPlaceholder
  }
  
  private var end: String {
    if let endTime = endTime {
      return endTime
    }
    
    return endPlaceholder
  }
  
  private var backgroundColor: Color {
    switch status {
    case .error: return .red300.opacity(0.1)
    default: return .neutral50
    }
  }
  
  private var errorMessage: String? {
    switch status {
    case .error(let error): return error
    default: return nil
    }
  }
  
  public init(
    status: Binding<Status>,
    startTime: String?,
    endTime: String?,
    startPlaceholder: String,
    endPlaceholder: String
  ) {
    self._status = status
    self.startTime = startTime
    self.endTime = endTime
    self.startPlaceholder = startPlaceholder
    self.endPlaceholder = endPlaceholder
  }
  
  public var body: some View {
    VStack(spacing: 10) {
      ZStack {
        HStack(spacing: 12) {
          Text(start)
            .typo(.body1_R, startTime == nil ? .neutral300 : .neutral700)
            .frame(maxWidth: .infinity, alignment: .center)
          
          Text("~")
            .typo(.body1_R, .neutral700)
          
          Text(end)
            .typo(.body1_R, startTime == nil ? .neutral300 : .neutral700)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
      }
      .background(backgroundColor)
      .cornerRadius(12)
      
      if let errorMessage = errorMessage {
        Text(errorMessage)
          .typo(.body3_R, .red300)
          .frame(maxWidth: .infinity, alignment: .leading)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
}

#Preview {
  VStack {
    SDGTimeSelectInput(
      status: .constant(.`default`),
      startTime: nil,
      endTime: nil,
      startPlaceholder: "시간",
      endPlaceholder: "시간"
    )
    
    SDGTimeSelectInput(
      status: .constant(.`default`),
      startTime: "1:11",
      endTime: "2.22",
      startPlaceholder: "시간",
      endPlaceholder: "시간"
    )
    
    SDGTimeSelectInput(
      status: .constant(.error("에러에러에러에러")),
      startTime: "1:11",
      endTime: "2.22",
      startPlaceholder: "시간",
      endPlaceholder: "시간"
    )
  }
  .padding(20)
}
