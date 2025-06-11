//
//  Segment.swift
//  shopl-design-guide-ios
//
//  Created by Jerry on 5/28/25.
//

import SwiftUI

public struct Segment: UIViewRepresentable {
  public enum TextLine: CGFloat {
    case one = 32
    case two = 50
    
    var numberOfLines: Int {
      switch self {
        case .one: return 1
        case .two: return 2
      }
    }
  }
  
  @Binding var selectedSegmentIndex: Int?
  
  private let textLine: TextLine
  
  private let items: [String]
  private let leftPadding: CGFloat
  private let rightPadding: CGFloat
  
  public init(
    selectedSegmentIndex: Binding<Int?>,
    textLine: TextLine,
    items: [String],
    leftPadding: CGFloat = 0,
    rightPadding: CGFloat = 0
  ) {
    self._selectedSegmentIndex = selectedSegmentIndex
    self.textLine = textLine
    self.items = items
    self.leftPadding = leftPadding
    self.rightPadding = rightPadding
  }
  
  public func makeUIView(context: Context) -> SegmentView {
    let segmentView = SegmentView(items: items)
    
    segmentView.leftPadding = self.leftPadding
    segmentView.rightPadding = self.rightPadding
    segmentView.height = self.textLine.rawValue
    
    segmentView.setTitleTextAttributes(
      [NSAttributedString.Key.foregroundColor: UIColor.neutral700,
       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
      for: .selected
    )
    segmentView.setTitleTextAttributes(
      [NSAttributedString.Key.foregroundColor: UIColor.neutral500,
       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
      for: .normal
    )
    
    segmentView.backgroundColor = .neutral100
    segmentView.selectedSegmentIndex = 0
    segmentView.clipsToBounds = true
    segmentView.layer.cornerRadius = 12
    
    segmentView.addTarget(
      context.coordinator,
      action: #selector(Coordinator.valueChanged(sender:)),
      for: .valueChanged
    )
    
    segmentView.subviews
      .map { $0.subviews }
      .flatMap { $0 }
      .compactMap { $0 as? UILabel }
      .forEach { $0.numberOfLines = self.textLine.numberOfLines }
    
    return segmentView
  }
  
  public func updateUIView(_ uiView: SegmentView, context: Context) {
    uiView.selectedSegmentIndex = selectedSegmentIndex ?? 0
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  public class Coordinator: NSObject, UIScrollViewDelegate {
    var parent: Segment
    
    init(parent: Segment) {
      self.parent = parent
    }
    
    @objc func valueChanged(sender: UISegmentedControl) {
      parent.selectedSegmentIndex = sender.selectedSegmentIndex
    }
  }
}

