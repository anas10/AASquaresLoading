//
//  AASquaresLoading.swift
//  Etix Mobile
//
//  Created by Anas Ait Ali on 18/02/15.
//  Copyright (c) 2015 Etix. All rights reserved.
//

import UIKit

public class AASquaresLoading : UIView {
    var view : UIView = UIView()
    var size : Float = 0
    var squareSize: Float?
    var gapSize: Float?
    var moveTime: Float?
    var squareStartX: Float?
    var squareStartY: Float?
    var squareStartOpacity: Float?
    var squareEndX: Float?
    var squareEndY: Float?
    var squareEndOpacity: Float?
    var squareOffsetX: [Float] = [Float](count: 9, repeatedValue: 0)
    var squareOffsetY: [Float] = [Float](count: 9, repeatedValue: 0)
    var squareOpacity: [Float] = [Float](count: 9, repeatedValue: 0)
    var squares : [CALayer] = [CALayer]()
    var color : UIColor = UIColor.blackColor()
    var parentView : UIView?

    public init(target: UIView) {
        let size : Float = 40
        let frame = target.frame
        super.init(frame: frame)
        
        setup(target, size: 40)
    }
    
    init(target: UIView, size: Float) {
        let frame = target.frame
        super.init(frame: frame)
        
        setup(target, size: size)
    }
    
    func setup(target: UIView, size: Float) {
        self.size = size
        self.view.frame = CGRectMake(frame.width / 2 - CGFloat(size) / 2,
            frame.height / 2 - CGFloat(size) / 2, CGFloat(size), CGFloat(size))
        parentView = target
        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if size == 0 {
            let width = frame.size.width
            let height = frame.size.height
            size = width > height ? Float(height) : Float(width)
        }
        self.view.frame = frame
        self.initialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if size == 0 {
            let width = CGRectGetWidth(self.frame)
            let height = CGRectGetHeight(self.frame)
            size = width > height ? Float(height) : Float(width)
        }
        self.view.frame = frame
        self.initialize()
    }
    
    func setColor(color: UIColor) {
        self.color = color
        for layer in squares {
            layer.backgroundColor = color.CGColor
        }
    }
    
    func start() {
        if (parentView != nil) {
            self.layer.opacity = 0
            self.parentView!.addSubview(self)
            UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in
                    self.layer.opacity = 1
            }, completion: nil)
        }
    }
    
    func stop() {
        if (parentView != nil) {
            self.layer.opacity = 1
            UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in
                    self.layer.opacity = 0
                }, completion: { (success: Bool) -> Void in
                    self.removeFromSuperview()
            })
        }
    }
    
    func initialize() {
        let gap : Float = 0.04
        gapSize = size * gap
        squareSize = size * (1.0 - 2 * gap) / 3
        moveTime = 0.15
        squares = [CALayer]()
        
        self.addSubview(view)
        self.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.4)
        for var i : Int = 0; i < 3; i++ {
            for var j : Int = 0; j < 3; j++ {
                var offsetX, offsetY : Float
                var idx : Int = 3 * i + j
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
        
        if floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1 {
            color = UIColor.blackColor()
        } else {
            color = self.tintColor
        }
        
        for var i = -1; i < 9; i++ {
            self.addSquareAnimation(i)
        }
    }
    
    func addSquareAnimation(position: Int) {
        var square : CALayer = CALayer()
        if position == -1 {
            square.frame = CGRectMake(CGFloat(squareStartX!), CGFloat(squareStartY!),
                CGFloat(squareSize!), CGFloat(squareSize!))
            square.opacity = squareStartOpacity!
        } else {
            square.frame = CGRectMake(CGFloat(squareOffsetX[position]),
                CGFloat(squareOffsetY[position]), CGFloat(squareSize!), CGFloat(squareSize!))
            square.opacity = squareOpacity[position]
        }
        square.backgroundColor = self.color.CGColor
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
        let path : CGMutablePathRef = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, sp.x, sp.y)
        
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
        CGPathAddLineToPoint(path, nil, sp.x + CGFloat(x), sp.y + CGFloat(y))
        keyTimes.append(1.0 / 8.0)
        alphas.append(a)
        
        CGPathAddLineToPoint(path, nil, sp.x + CGFloat(x), sp.y + CGFloat(y))
        keyTimes.append(1.0)
        alphas.append(a)
        
        var posAnim : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        posAnim.removedOnCompletion = false
        posAnim.duration = Double(moveTime! * 8)
        posAnim.path = path
        posAnim.keyTimes = keyTimes
        
        var alphaAnim : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
        alphaAnim.removedOnCompletion = false
        alphaAnim.duration = Double(moveTime! * 8)
        alphaAnim.values = alphas
        alphaAnim.keyTimes = keyTimes
        
        var blankAnim : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
        blankAnim.removedOnCompletion = false
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
        var group : CAAnimationGroup = CAAnimationGroup()
        group.animations = [posAnim, alphaAnim, blankAnim]
        group.beginTime = CACurrentMediaTime() + Double(beginTime)
        group.repeatCount = HUGE
        group.removedOnCompletion = false
        group.delegate = self
        group.duration = Double(9 * moveTime!)
        
        square.addAnimation(group, forKey: "square-\(position)")
    }
}