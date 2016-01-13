//
//  ClockAnimationViewController.swift
//  SnapKitDemo
//
//  Created by bob on 1/8/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class ClockFace: CAShapeLayer{
    var hourHand: CAShapeLayer!
    var minuteHand: CAShapeLayer!
    var secHand: CAShapeLayer!
    
    
    override init() {
        super.init()
        
        hourHand = CAShapeLayer()
        minuteHand = CAShapeLayer()
        secHand = CAShapeLayer()
        
        self.addSublayer(hourHand)
        self.addSublayer(minuteHand)
        self.addSublayer(secHand)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayer(){
        path = UIBezierPath(ovalInRect: self.bounds).CGPath
        fillColor = UIColor.whiteColor().CGColor
        strokeColor = UIColor.blackColor().CGColor
        lineWidth = 4
        
        let midWidth = self.bounds.size.width/2
        
        let hourRect = CGRectMake(0, 0, 4, midWidth/2)
        hourHand.path = UIBezierPath(rect: hourRect).CGPath
        hourHand.frame = hourRect
        hourHand.fillColor = UIColor.blackColor().CGColor
        hourHand.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        //要设置frame，anchorPoint才生效!!
        hourHand.anchorPoint = CGPointMake(0.5, 1.0)
        
        
        let minuteRect = CGRectMake(0, 0, 2, midWidth/1.5)
        minuteHand.path = UIBezierPath(rect: minuteRect).CGPath
        minuteHand.frame = minuteRect
        minuteHand.fillColor = UIColor.blackColor().CGColor
        minuteHand.anchorPoint = CGPointMake(0.5, 1.0)
        minuteHand.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        
        
        let secRect = CGRectMake(0, 0, 2, midWidth/1.2)
        secHand.path = UIBezierPath(rect: secRect).CGPath
        secHand.frame = secRect
        secHand.fillColor = UIColor.redColor().CGColor
        secHand.anchorPoint = CGPointMake(0.5, 1.0)
        secHand.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    }
    
    func updateClockFace(){
        let date = NSDate()
        
        let canlendar = NSCalendar.currentCalendar()
        let hour = canlendar.component(.Hour, fromDate: date)
        let minute = canlendar.component(.Minute, fromDate: date)
        let second = canlendar.component(.Second, fromDate: date)
     
        self.hourHand.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(Double(hour)/12.0 * (2.0*M_PI))))
        self.minuteHand.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(Double(minute)/60.0 * (2.0*M_PI))))
        self.secHand.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(Double(second)/60.0 * (2.0*M_PI))))
    }
}

class ClockView :UIView{
    override class func layerClass() -> AnyClass{
        return ClockFace.self
    }
    
    func updateClockFace(){
        let layer = self.layer as! ClockFace
        layer.updateClockFace()
    }
    
    func layoutLayer(){
        let layer = self.layer as! ClockFace
        
        //layer.bounds = self.bounds
        layer.updateLayer()
    }
}

class ClockAnimationViewController: UIViewController {
    var clockView : ClockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        clockView = ClockView()
        self.view.addSubview(clockView)
        clockView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }

        NSTimer.scheduledTimerWithTimeInterval(1.0, target: clockView, selector: "updateClockFace", userInfo: nil, repeats: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.clockView.layoutLayer()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
