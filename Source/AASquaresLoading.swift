//
//  AASquaresLoading.swift
//  Etix Mobile
//
//  Created by Anas Ait Ali on 18/02/15.
//  Copyright (c) 2015 Etix. All rights reserved.
//

import UIKit

//MARK: AASquareLoadingInterface
/**
 Interface for the AASquareLoading class
*/
public protocol AASquareLoadingInterface: class {
  var color : UIColor { get set }
  var backgroundColor : UIColor? { get set }
  
  func start(_ delay : TimeInterval)
  func stop(_ delay : TimeInterval)
  func setSquareSize(_ size: Float)
}

private var AASLAssociationKey: UInt8 = 0

//MARK: UIView extension
public extension UIView {

  /**
   Variable to allow access to the class AASquareLoading
   */
  public var squareLoading: AASquareLoadingInterface {
    get {
      if let value = objc_getAssociatedObject(self, &AASLAssociationKey) as? AASquareLoadingInterface {
        return value
      } else {
        let squareLoading = AASquaresLoading(target: self)
        
        objc_setAssociatedObject(self, &AASLAssociationKey, squareLoading,
          objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        return squareLoading
      }
    }
    
    set {
      objc_setAssociatedObject(self, &AASLAssociationKey, newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
  }
}

//MARK: AASquareLoading class

/**
 Main class AASquareLoading
*/
open class AASquaresLoading : UIView, AASquareLoadingInterface, CAAnimationDelegate {
  open var view : UIView = UIView()
  fileprivate(set) open var size : Float = 0
  open var color : UIColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1) {
    didSet {
      for layer in squares {
        layer.backgroundColor = color.cgColor
      }
    }
  }
  open var parentView : UIView?

  fileprivate var squareSize: Float?
  fileprivate var gapSize: Float?
  fileprivate var moveTime: Float?
  fileprivate var squareStartX: Float?
  fileprivate var squareStartY: Float?
  fileprivate var squareStartOpacity: Float?
  fileprivate var squareEndX: Float?
  fileprivate var squareEndY: Float?
  fileprivate var squareEndOpacity: Float?
  fileprivate var squareOffsetX: [Float] = [Float](repeating: 0, count: 9)
  fileprivate var squareOffsetY: [Float] = [Float](repeating: 0, count: 9)
  fileprivate var squareOpacity: [Float] = [Float](repeating: 0, count: 9)
  fileprivate var squares : [CALayer] = [CALayer]()

  public init(target: UIView) {
    super.init(frame: target.frame)

    parentView = target
    setup(self.size)
  }

  public init(target: UIView, size: Float) {
    super.init(frame: target.frame)

    parentView = target
    setup(size)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup(0)
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setup(0)
  }
  
  open override func layoutSubviews() {
    updateFrame()
    super.layoutSubviews()
  }
  
  fileprivate func setup(_ size: Float) {
    self.size = size
    updateFrame()
    self.initialize()
  }
  
  fileprivate func updateFrame() {
    if parentView != nil {
      self.frame = CGRect(x: 0, y: 0, width: parentView!.frame.width, height: parentView!.frame.height)
    }
    if size == 0 {
      let width = frame.size.width
      let height = frame.size.height
      size = width > height ? Float(height/8) : Float(width/8)
    }
    self.view.frame = CGRect(x: frame.width / 2 - CGFloat(size) / 2,
      y: frame.height / 2 - CGFloat(size) / 2, width: CGFloat(size), height: CGFloat(size))
  }
  
  /**
   Function to start the loading animation
   
   - Parameter delay : The delay before the loading start
   */
  open func start(_ delay : TimeInterval = 0.0) {
    if (parentView != nil) {
      self.layer.opacity = 0
      self.parentView!.addSubview(self)
      UIView.animate(withDuration: 0.6, delay: delay, options: UIViewAnimationOptions(),
        animations: { () -> Void in
          self.layer.opacity = 1
        }, completion: nil)
    }
  }

  /**
   Function to start the loading animation
   
   - Parameter delay : The delay before the loading start
   */
  open func stop(_ delay : TimeInterval = 0.0) {
    if (parentView != nil) {
      self.layer.opacity = 1
      UIView.animate(withDuration: 0.6, delay: delay, options: UIViewAnimationOptions(),
        animations: { () -> Void in
          self.layer.opacity = 0
        }, completion: { (success: Bool) -> Void in
          self.removeFromSuperview()
      })
    }
  }

  open func setSquareSize(_ size: Float) {
    self.view.layer.sublayers = nil
    setup(size)
  }
  
  fileprivate func initialize() {
    let gap : Float = 0.04
    gapSize = size * gap
    squareSize = size * (1.0 - 2 * gap) / 3
    moveTime = 0.15
    squares = [CALayer]()

    self.addSubview(view)
    if (self.backgroundColor == nil) {
      self.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }
    for i : Int in 0 ..< 3 {
      for j : Int in 0 ..< 3 {
        var offsetX, offsetY : Float
        let idx : Int = 3 * i + j
        if i == 1 {
          offsetX = squareSize! * (2 - Float(j)) + gapSize! * (2 - Float(j))
          offsetY = squareSize! * Float(i) + gapSize! * Float(i)
        } else {
          offsetX = squareSize! * Float(j) + gapSize! * Float(j)
          offsetY = squareSize! * Float(i) + gapSize! * Float(i)
        }
        squareOffsetX[idx] = offsetX
        squareOffsetY[idx] = offsetY
        squareOpacity[idx] = 0.1 * (Float(idx) + 1)
      }
    }
    squareStartX = squareOffsetX[0]
    squareStartY = squareOffsetY[0] - 2 * squareSize! - 2 * gapSize!
    squareStartOpacity = 0.0
    squareEndX = squareOffsetX[8]
    squareEndY = squareOffsetY[8] + 2 * squareSize! + 2 * gapSize!
    squareEndOpacity = 0.0

    for i in -1 ..< 9 {
      self.addSquareAnimation(i)
    }
  }

  fileprivate func addSquareAnimation(_ position: Int) {
    let square : CALayer = CALayer()
    if position == -1 {
      square.frame = CGRect(x: CGFloat(squareStartX!), y: CGFloat(squareStartY!),
        width: CGFloat(squareSize!), height: CGFloat(squareSize!))
      square.opacity = squareStartOpacity!
    } else {
      square.frame = CGRect(x: CGFloat(squareOffsetX[position]),
        y: CGFloat(squareOffsetY[position]), width: CGFloat(squareSize!), height: CGFloat(squareSize!))
      square.opacity = squareOpacity[position]
    }
    square.backgroundColor = self.color.cgColor
    squares.append(square)
    self.view.layer.addSublayer(square)

    var keyTimes = [Float]()
    var alphas = [Float]()
    keyTimes.append(0.0)
    if position == -1 {
      alphas.append(0.0)
    } else {
      alphas.append(squareOpacity[position])
    }
    if position == 0 {
      square.opacity = 0.0
    }

    let sp : CGPoint = square.position
    let path : CGMutablePath = CGMutablePath()

    path.move(to: CGPoint(x: sp.x, y: sp.y))

    var x, y, a : Float
    if position == -1 {
      x = squareOffsetX[0] - squareStartX!
      y = squareOffsetY[0] - squareStartY!
      a = squareOpacity[0]
    } else if position == 8 {
      x = squareEndX! - squareOffsetX[position]
      y = squareEndY! - squareOffsetY[position]
      a = squareEndOpacity!
    } else {
      x = squareOffsetX[position + 1] - squareOffsetX[position]
      y = squareOffsetY[position + 1] - squareOffsetY[position]
      a = squareOpacity[position + 1]
    }
    path.addLine(to: CGPoint(x: sp.x + CGFloat(x), y: sp.y + CGFloat(y)))
    keyTimes.append(1.0 / 8.0)
    alphas.append(a)

    path.addLine(to: CGPoint(x: sp.x + CGFloat(x), y: sp.y + CGFloat(y)))
    keyTimes.append(1.0)
    alphas.append(a)

    let posAnim : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
    posAnim.isRemovedOnCompletion = false
    posAnim.duration = Double(moveTime! * 8)
    posAnim.path = path
    posAnim.keyTimes = keyTimes as [NSNumber]?

    let alphaAnim : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
    alphaAnim.isRemovedOnCompletion = false
    alphaAnim.duration = Double(moveTime! * 8)
    alphaAnim.values = alphas
    alphaAnim.keyTimes = keyTimes as [NSNumber]?

    let blankAnim : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
    blankAnim.isRemovedOnCompletion = false
    blankAnim.beginTime = Double(moveTime! * 8)
    blankAnim.duration = Double(moveTime!)
    blankAnim.values = [0.0, 0.0]
    blankAnim.keyTimes = [0.0, 1.0]

    var beginTime : Float
    if position == -1 {
      beginTime = 0
    } else {
      beginTime = moveTime! * Float(8 - position)
    }
    let group : CAAnimationGroup = CAAnimationGroup()
    group.animations = [posAnim, alphaAnim, blankAnim]
    group.beginTime = CACurrentMediaTime() + Double(beginTime)
    group.repeatCount = HUGE
    group.isRemovedOnCompletion = false
    group.delegate = self
    group.duration = Double(9 * moveTime!)

    square.add(group, forKey: "square-\(position)")
  }
}
