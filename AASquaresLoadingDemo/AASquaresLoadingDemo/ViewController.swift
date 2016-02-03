//
//  ViewController.swift
//  AASquaresLoadingDemo
//
//  Created by Anas Ait Ali on 27/02/15.
//  Copyright (c) 2015 Anas AIT ALI. All rights reserved.
//

import UIKit
import AASquaresLoading

class ViewController: UIViewController {
  
  @IBOutlet weak var topLeft: AASquaresLoading!
  @IBOutlet weak var topRight: UIView!
  @IBOutlet weak var bottomRight: UIView!
  @IBOutlet weak var bottomCenter: UIView!
  @IBOutlet weak var bottomLeft: UIView!
  
  var topRightSquare : AASquaresLoading!
  var bottomRightSquare : AASquaresLoading!
  var bottomCenterSquare : AASquaresLoading!
  var bottomLeftSquare : AASquaresLoading!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    topRightSquare = AASquaresLoading(target: self.topRight, size: 40)
    topRightSquare.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
    topRightSquare.color = UIColor.whiteColor()
    topRightSquare.start()
    
    bottomRightSquare = AASquaresLoading(target: self.bottomRight)
    bottomRightSquare.backgroundColor = nil
    bottomRightSquare.color = UIColor.yellowColor()
    bottomRightSquare.start(4.0)
    
    self.bottomCenter.squareLoading.start(0.0)
    self.bottomCenter.squareLoading.backgroundColor = UIColor.redColor()
    self.bottomCenter.squareLoading.color = UIColor.whiteColor()
    self.bottomCenter.squareLoading.stop(8.0)
    
    bottomLeftSquare = AASquaresLoading(target: self.bottomLeft)
    bottomLeftSquare.color = UIColor.blackColor()
    bottomLeftSquare.backgroundColor = UIColor.clearColor()
    bottomLeftSquare.start()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    self.topRightSquare.setNeedsLayout()
    self.bottomRightSquare.setNeedsLayout()
    self.bottomLeftSquare.setNeedsLayout()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
}

