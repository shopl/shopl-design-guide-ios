//
//  SegmentView.swift
//  ShoplDesignGuide
//
//  Created by Jerry on 5/30/25.
//

import UIKit

public final class SegmentView: UISegmentedControl {
  
  public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.removeBackgroundAndDivider()
  }
  
  override init(items: [Any]?) {
    super.init(items: items)
    self.removeBackgroundAndDivider()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(width: (screenWidth - (leftPadding + rightPadding)), height: height + 8)
  }
  
  public var height: CGFloat = 32
  public var leftPadding: CGFloat = 0
  public var rightPadding: CGFloat = 0
  
  private func removeBackgroundAndDivider() {
    let image = UIImage()
    
    self.setBackgroundImage(image, for: .normal, barMetrics: .default)
    self.setBackgroundImage(image, for: .selected, barMetrics: .default)
    self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
    
    self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    
    self.backgroundColor = .neutral0
  }
  
  private lazy var backgroundView: UIView = {
    let width = (screenWidth - (leftPadding + rightPadding)) / CGFloat(self.numberOfSegments) - (CGFloat(self.numberOfSegments) * 2.0 + 2.0)
    let height = self.height
    
    let xPosition = CGFloat(self.selectedSegmentIndex * Int(width)) + CGFloat(self.numberOfSegments) * 2.0
    let yPosition = 4.0
    
    let frame = CGRect(
      x: xPosition, y: yPosition, width: width, height: height
    )
    
    let view = UIView(frame: frame)
    view.backgroundColor = .neutral0
    view.layer.cornerRadius = 8
    view.clipsToBounds = true
    view.layer.shadow(
      color: .neutral900,
      alpha: 0.05,
      offset: CGSize(width: 1, height: 1),
      blur: 4,
      spread: 0,
      cornerRadius: 8
    )
    
    self.insertSubview(view, at: 0)
    
    return view
  }()
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    let backgroundViewFinalXPosition = (
      self.bounds.width / CGFloat(self.numberOfSegments)
    ) * CGFloat(self.selectedSegmentIndex) + (self.selectedSegmentIndex != 0 ? 4 : 4)
    
    UIView.animate(
      withDuration: 0.2,
      animations: {
        self.backgroundView.frame.origin.x = backgroundViewFinalXPosition
      }
    )
  }
}


