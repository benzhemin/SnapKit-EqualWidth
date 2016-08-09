//
//  ReplicateViewController.swift
//  SnapKitDemo
//
//  Created by bob on 8/9/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import UIKit

class ReplicateViewController: UIViewController {
    
    class func replicateLayerFactory(bounds: CGRect, position: CGPoint) -> CAReplicatorLayer {
        
        let layer = CAReplicatorLayer()
        layer.bounds = bounds
        layer.position = position
        layer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2).CGColor
        
        return layer
    }
    
    /*
     lazy var replicateLayer : CAReplicatorLayer = { [unowned self] in
     ViewController.replicateLayerFactory(CGRect(x: 0, y: 0, width: 100, height: 100), position: self.view.center)
     }()
     */
    
    var replicateLayer: CAReplicatorLayer!
    var replicateLayer2: CAReplicatorLayer!
    
    lazy var dotLayer: CALayer = { [unowned self] in
        let layer = CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        layer.position = CGPoint(x: 20, y: self.replicateLayer2.frame.size.height/2)
        layer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6).CGColor
        layer.cornerRadius = 7.5
        return layer
        }()
    
    lazy var bounceLayer: CALayer = {
        [unowned self] in
        
        let layer = CALayer()
        layer.bounds = CGRect(x: 10, y: 0, width: 10, height: 25)
        layer.backgroundColor = UIColor.redColor().CGColor
        layer.anchorPoint = CGPoint(x: 0, y: 1.0)
        layer.position = CGPoint(x: 0, y: self.replicateLayer.frame.height)
        layer.cornerRadius = 2.0
        return layer
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        replicateLayer = ReplicateViewController.replicateLayerFactory(CGRect(x: 0, y: 0, width: 100, height: 100),
                                                              position: CGPoint(x: self.view.center.x, y: self.view.center.y-70))
        replicateLayer2 = ReplicateViewController.replicateLayerFactory(CGRect(x: 0, y: 0, width: 100, height: 100),
                                                               position: CGPoint(x: self.view.center.x, y: self.view.center.y+70))
        
        view.layer.addSublayer(replicateLayer)
        view.layer.addSublayer(replicateLayer2)
        
        addBouncePlayingAnimation()
        addCircleLoadingAnimation()
    }
    
    func addBouncePlayingAnimation(){
        
        replicateLayer.addSublayer(bounceLayer)
        
        bounceLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        
        replicateLayer.instanceCount = 5
        replicateLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        
        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        animation.fromValue = 1.0
        animation.toValue = 3.0
        animation.duration = 0.6
        animation.repeatCount = MAXFLOAT
        animation.autoreverses = true
        bounceLayer.addAnimation(animation, forKey: nil)
        
        replicateLayer.instanceDelay = 1.0/5.0
    }
    
    func addCircleLoadingAnimation(){
        replicateLayer2.addSublayer(dotLayer)
        
        dotLayer.transform = CATransform3DMakeScale(0, 0, 0)
        
        replicateLayer2.instanceCount = 20
        replicateLayer2.instanceTransform = CATransform3DMakeRotation(CGFloat(M_PI*2/20.0), 0, 0, 1)//CATransform3DMakeTranslation(replicateLayer.frame.size.width/5, 0, 0)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 1.5
        animation.fromValue = 0.5
        animation.toValue = 0
        animation.repeatCount = MAXFLOAT
        dotLayer.addAnimation(animation, forKey: nil)
        
        replicateLayer2.instanceDelay = 1.5/20
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
}