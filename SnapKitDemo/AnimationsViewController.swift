//
//  AnimationsViewController.swift
//  SnapKitDemo
//
//  Created by bob on 1/4/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class AnimationsViewController: UIViewController {

    var firstView: UIView? = nil
    var secView : UIView? = nil
    var topView: UIView? = nil
    
    var topLayer : CALayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        firstView = UIView()
        firstView?.backgroundColor = UIColor.redColor()
        self.view.addSubview(firstView!)
        
        topView = UIView()
        topView?.backgroundColor = UIColor.greenColor()
        self.firstView?.addSubview(topView!)
        
        secView = UIView()
        secView?.backgroundColor = UIColor.blueColor()
        self.view.addSubview(secView!)
        
        topLayer = CALayer()
        topLayer?.backgroundColor = UIColor.orangeColor().CGColor
        secView?.layer.addSublayer(topLayer!)
        
        self.updateViewConstraints()
    }

   
    override func updateViewConstraints() {
        firstView?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(100)
            
            make.center.equalTo(self.view.snp_center).offset(CGPoint(x: 0, y: -50))
        })
        
        topView?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            
            make.center.equalTo(firstView!)
        })
        
        secView?.snp_makeConstraints(closure: { (make) -> Void in
            make.size.equalTo(self.firstView!)
            make.center.equalTo(self.view.snp_center).offset(CGPoint(x: 0, y: 50))
        })
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topLayer?.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        topLayer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        topLayer?.position = CGPoint(x: CGRectGetMidX(self.secView!.bounds), y: CGRectGetMidY(self.secView!.bounds))
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            //self.animationStartSameTime()
            //self.animationViewTransition()
            
            self.animationViewLayer()
        }
        
    }
    
    func animationViewLayer(){
        self.firstView?.layer.allowsEdgeAntialiasing = true
        self.topView?.layer.allowsEdgeAntialiasing = true
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveLinear, animations: { () -> Void in
            
            let xform = CGAffineTransformMakeRotation(CGFloat(-180/180.0*M_PI))
            self.firstView?.transform = xform
            
            let layerAnimation = CABasicAnimation(keyPath: "transform")
            layerAnimation.duration = 2.0
            layerAnimation.beginTime = 0
            layerAnimation.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)
            layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            layerAnimation.fromValue = 0.0
            layerAnimation.toValue = 2*M_PI
            layerAnimation.byValue = M_PI
            //self.topView?.layer.addAnimation(layerAnimation, forKey: "topAnimation")
            
            self.topLayer?.addAnimation(layerAnimation, forKey: "topAnimation")
            
            }) { (finish) -> Void in
                
        }
    }
    
    func animationViewTransition(){

        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft,
                animations: { () -> Void in
                    
                    self.firstView?.hidden = true
                    self.secView?.hidden = false
                    
                }, completion: nil)
        }
    }
    
    func animationStartSameTime(){
        dispatch_after(1, dispatch_get_main_queue()) { () -> Void in
            UIView.animateWithDuration(1.0, delay: 1.0,
                options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    
                    self.firstView?.alpha = 0.0
                    
                    UIView.animateWithDuration(3.0, delay: 0.0,
                        options: [.OverrideInheritedCurve, .CurveLinear ,
                            .OverrideInheritedDuration ,
                            .Repeat , .Autoreverse]
                        , animations: { () -> Void in
                            UIView.setAnimationRepeatCount(2.5)
                            
                            self.secView?.alpha = 0.0
                            
                        }, completion: nil)
                    
                }, completion: nil)
        }
    }
    
}
