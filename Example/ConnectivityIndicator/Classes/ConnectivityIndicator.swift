// Copyright (c) 2017 Filtercode Ltd <jandro@filtercode.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import QuartzCore

open class ConnectivityIndicator: UIView {
  
  // MARK: - Public properties
  
  /// Sets up the color of the elements
  @IBInspectable public var color: UIColor = .black {
    didSet {
      updateFrames()
    }
  }
  
  /// Speed of the animation in seconds
  @IBInspectable public var speed: Double = 1.0 {
    didSet {
      updateFrames()
    }
  }
  
  /// The width of the rings
  @IBInspectable public var lineWidth: CGFloat = 3.0 {
    didSet {
      updateFrames()
    }
  }
  
  /// If the control should be hidden when it's not animating
  @IBInspectable public var hidesWhenStopped: Bool = false {
    didSet {
      updateFrames()
    }
  }
  
  /// Status property
  public var isAnimating = false
  
  // MARK: - Private properties
  
  private let coreLayer = CoreLayer()
  private let innerRingLayer = RingLayer()
  private let outerRingLayer = RingLayer()
  
  // MARK: - Initializers
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    commonInit()
  }
  
  // MARK: - Private methods
  
  /// Sets up the different elements
  private func commonInit() {
    coreLayer.indicator = self
    innerRingLayer.indicator = self
    outerRingLayer.indicator = self
    outerRingLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(outerRingLayer)
    innerRingLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(innerRingLayer)
    coreLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(coreLayer)
    updateFrames()
  }
  
  /// Updates the frames of the different elements
  private func updateFrames() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    let centerPoint = CGPoint(x: (bounds.origin.x + bounds.width) / 2.0, y: (bounds.origin.y + bounds.height) / 2.0)
    
    coreLayer.frame = CGRect(x: centerPoint.x - (min(bounds.height, bounds.width) / 3.0) / 2.0, y: centerPoint.y - (min(bounds.height, bounds.width) / 3.0) / 2.0, width: min(bounds.height, bounds.width) / 3.0, height: min(bounds.height, bounds.width) / 3.0)
    coreLayer.setNeedsDisplay()
    
    innerRingLayer.frame = CGRect(x: centerPoint.x - ((min(bounds.height, bounds.width) / 2.0) / 2.0) * 1.2, y: centerPoint.y - ((min(bounds.height, bounds.width) / 2.0) / 2.0) * 1.2, width: (min(bounds.height, bounds.width) / 2.0) * 1.2, height: (min(bounds.height, bounds.width) / 2.0) * 1.2)
    innerRingLayer.setNeedsDisplay()
    
    outerRingLayer.frame = CGRect(x: centerPoint.x - ((min(bounds.height, bounds.width) / 2.0) / 2.0) * 1.8, y: centerPoint.y - ((min(bounds.height, bounds.width) / 2.0) / 2.0) * 1.8, width: (min(bounds.height, bounds.width) / 2.0) * 1.8, height: (min(bounds.height, bounds.width) / 2.0) * 1.8)
    outerRingLayer.setNeedsDisplay()
    
    CATransaction.commit()
  }
  
  /// Adds an opacity animatation to the given layer
  ///
  /// - Parameters:
  ///   - layer: The CAShapeLayer to use
  ///   - offset: The offset time for the animation
  private func addAlphaAnimation(for layer: CAShapeLayer, offset: Double) {
    let fadeOutIn = CABasicAnimation(keyPath: "opacity")
    fadeOutIn.fromValue = 1.0
    fadeOutIn.toValue = 0.0
    fadeOutIn.duration = speed
    fadeOutIn.repeatCount = Float.infinity
    fadeOutIn.autoreverses = true
    fadeOutIn.timeOffset = offset
    fadeOutIn.isRemovedOnCompletion = false
    layer.add(fadeOutIn, forKey: "animate_alpha")
  }
  
  // MARK: - Public methods
  
  /// Starts the animation
  public func startAnimating() {
    guard isAnimating == false else {
      return
    }
    
    if hidesWhenStopped {
      isHidden = false
    }
    addAlphaAnimation(for: coreLayer, offset: speed)
    addAlphaAnimation(for: innerRingLayer, offset: speed - (speed / 1.2))
    addAlphaAnimation(for: outerRingLayer, offset: speed - (speed / 1.6))
    isAnimating = true
  }
  
  /// Stops the aninmation and hides the elements based on `hidesWhenStopped`
  public func stopAnimating() {
    coreLayer.removeAnimation(forKey: "animate_alpha")
    innerRingLayer.removeAnimation(forKey: "animate_alpha")
    outerRingLayer.removeAnimation(forKey: "animate_alpha")
    if hidesWhenStopped {
      isHidden = true
    }
    isAnimating = false
  }
}

// MARK: - Custom CAShapeLayers

private class CoreLayer: CAShapeLayer {
  
  weak var indicator: ConnectivityIndicator?
  
  fileprivate override func draw(in ctx: CGContext) {
    if let indicator = indicator {
      ctx.setFillColor(indicator.color.cgColor)
      let path = UIBezierPath(ovalIn: CGRect(x: bounds.origin.x + lineWidth, y: bounds.origin.y + lineWidth, width: bounds.width - lineWidth * 2, height: bounds.height - lineWidth * 2.0))
      ctx.addPath(path.cgPath)
      ctx.fillPath()
    }
  }
}

private class RingLayer: CAShapeLayer {
  
  weak var indicator: ConnectivityIndicator?
  
  fileprivate override func draw(in ctx: CGContext) {
    if let indicator = indicator {
      ctx.setStrokeColor(indicator.color.cgColor)
      ctx.setLineWidth(indicator.lineWidth)
      let path = UIBezierPath(ovalIn: CGRect(x: bounds.origin.x + indicator.lineWidth, y: bounds.origin.y + indicator.lineWidth, width: bounds.width - indicator.lineWidth * 2, height: bounds.height - indicator.lineWidth * 2.0))
      ctx.addPath(path.cgPath)
      ctx.strokePath()
    }
  }
}
