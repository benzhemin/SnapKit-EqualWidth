//
//  UIKitDynamicsViewController.swift
//  SnapKitDemo
//
//  Created by bob on 1/9/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class UIKitDynamicsViewController: UIViewController {
    var square : UIView!
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        square = UIView(frame: CGRectMake(100, 100, 100, 100))
        square.backgroundColor = UIColor.grayColor()
        self.view.addSubview(square)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [square])
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.animator.addBehavior(self.gravity)
        }
    }

}










