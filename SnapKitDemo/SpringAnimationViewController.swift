//
//  SpringAnimationViewController.swift
//  SnapKitDemo
//
//  Created by bob on 1/11/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class SpringAnimationViewController: UIViewController {

    var topView: UIView!
    var centerView: UIView!
    var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true

        self.view.backgroundColor = UIColor.whiteColor()
        
        topView = UIView()
        topView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(topView)
        topView.alpha = 0.1
        
        centerView = UIView()
        centerView.backgroundColor = UIColor.orangeColor()
        self.view.addSubview(centerView)
        
        bottomView = UIView()
        bottomView.backgroundColor = UIColor.magentaColor()
        self.view.addSubview(bottomView)
        bottomView.alpha = 0.1
        
        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        
        topView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp_top)
            make.centerX.equalTo(self.view.snp_centerX)
            
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        centerView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(topView)
            make.center.equalTo(self.view.snp_center)
        }
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(topView)
            
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(self.view.snp_bottom)
        }
        
        super.updateViewConstraints()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.springAnimation()
        }
    }
    
    func springAnimation(){
        UIView.animateWithDuration(5.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .Repeat, animations: { () -> Void in
                self.topView.center.y += 200
                self.topView.alpha = 1.0
            }) { (finish) -> Void in
                print("finsh")
        }
        
        UIView.animateWithDuration(5.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .Repeat, animations: { () -> Void in
                self.bottomView.center.y -= 200
                self.bottomView.alpha = 1.0
            }, completion: nil)
    }
    
}

















