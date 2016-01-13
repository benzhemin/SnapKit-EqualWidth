//
//  UserGuideViewController.swift
//  SnapKitDemo
//
//  Created by bob on 1/10/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

private class LayerBasedView : UIView{
    override class func layerClass() -> AnyClass{
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let fullPath = UIBezierPath(rect: CGRectMake(0, 0, frame.size.width, frame.size.height))
        let circlePath = UIBezierPath(ovalInRect: CGRectMake(80, 100, 100, 100))
        fullPath.appendPath(circlePath)
        fullPath.usesEvenOddFillRule = true
        
        let layer = self.layer as! CAShapeLayer
        layer.path = fullPath.CGPath
        layer.fillRule = kCAFillRuleEvenOdd
        layer.fillColor = UIColor.darkGrayColor().CGColor
        layer.opacity = 0.9
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("shouldn't called")
    }
    
}


class UserGuideViewController: UIViewController {

    private var shapeView : LayerBasedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImg: UIImage! = UIImage(named: "background")
        self.view.layer.contents = bgImg.CGImage
        
        shapeView = LayerBasedView(frame: self.view.bounds)
        
        self.view.addSubview(shapeView)
        
        let image = UIImage(named: "avatar")
        let maskShape = CAShapeLayer()
        maskShape.anchorPoint = CGPointMake(0.5, 0.5)
        maskShape.path = UIBezierPath(ovalInRect: CGRectMake(0, 0, image!.size.width, image!.size.height)).CGPath
        
        let avatorLayer = CALayer()
        avatorLayer.bounds = CGRectMake(0, 0, image!.size.width, image!.size.height)
        avatorLayer.position = self.view.center
        avatorLayer.contents = image?.CGImage
        avatorLayer.mask = maskShape
        
        self.shapeView.layer.addSublayer(avatorLayer)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //self.shapeView.updateLayer()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

}
