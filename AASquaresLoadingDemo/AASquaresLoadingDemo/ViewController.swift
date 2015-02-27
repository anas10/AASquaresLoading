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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var square = AASquaresLoading(target: self.view)
        square.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.1)
        square.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

