//
//  ViewController.swift
//  SnapKitDemo
//
//  Created by bob on 12/21/15.
//  Copyright © 2015 bob. All rights reserved.
//

import UIKit
import Foundation

class CustomButton : UIButton{
    override func alignmentRectInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left:50, bottom:0, right:50)
    }
}

class ViewController: UIViewController {
    let bgView : UIView
    
    let addViewBtn : CustomButton
    let delViewBtn : UIButton
    let refreshBtn : UIButton
    
    var constraintViews:[UIView];
    
    //构造了一个无参数构造函数
    init?(_ coder: NSCoder? = nil){
        
        self.bgView = UIView()
        self.constraintViews = [UIView]()
        self.addViewBtn = CustomButton(type: UIButtonType.Custom)
        self.delViewBtn = UIButton(type: UIButtonType.Custom)
        self.refreshBtn = UIButton(type: UIButtonType.Custom)
        
        if let aCoder=coder {
            super.init(coder: aCoder)
        }else {
            super.init(nibName: nil, bundle: nil)
        }
    }
    
    required convenience init?(coder: NSCoder){
        self.init(coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "swift SnapKit"
        
        bgView.backgroundColor = self.getRandomColor()
        self.view.addSubview(bgView)
        bgView.snp_remakeConstraints { (make) -> Void in
            make.centerY.equalTo(self.view.snp_centerY)
            make.leading.equalTo(self.view.snp_leading)
            make.trailing.equalTo(self.view.snp_trailing)
            make.height.equalTo(120)
        }

        
        self.addViewBtn.backgroundColor = UIColor.clearColor()
        self.addViewBtn.setTitle("Add", forState: UIControlState.Normal)
        self.addViewBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.addViewBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Highlighted)
        self.addViewBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(19)
        self.view.addSubview(self.addViewBtn)
        self.addViewBtn.layer.borderColor = UIColor.redColor().CGColor
        self.addViewBtn.layer.borderWidth = 1.0
        
        self.addViewBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp_bottom).offset(-10)
            
            make.trailing.equalTo(self.view.snp_centerX).offset(-20)
        }
        
        self.addViewBtn.addTarget(self, action: "pressAddBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.delViewBtn.backgroundColor = UIColor.clearColor()
        self.delViewBtn.setTitle("Delete", forState: UIControlState.Normal)
        self.delViewBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.delViewBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Highlighted)
        self.delViewBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(19)
        self.view.addSubview(self.delViewBtn)
        
        self.delViewBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp_bottom).offset(-10)
            
            make.leading.equalTo(self.view.snp_centerX).offset(20)
        }
        
        self.delViewBtn.addTarget(self, action: "pressDelBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.refreshBtn.backgroundColor = UIColor.clearColor()
        self.refreshBtn.setTitle("Refresh", forState: UIControlState.Normal)
        self.refreshBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.refreshBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Highlighted)
        self.refreshBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(19)
        self.view.addSubview(self.refreshBtn)
        
        self.refreshBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp_bottom).offset(-10)
            
            make.trailing.equalTo(self.view.snp_trailing).offset(-10)
        }
        self.refreshBtn.addTarget(self, action: "pressRefreshBtn:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func updateViewConstraints() {
        //remove all constraints
        
        //if remove constraints will trigger bug!
        //newly added view will not effect imediately
        for (_ , view) in self.constraintViews.enumerate(){
            view.removeFromSuperview()
        }
        
        for (_, view) in self.constraintViews.enumerate(){
            self.bgView.addSubview(view)
        }

        let spacing = 10
        
        for addView in self.constraintViews{
            addView.snp_makeConstraints(closure: { (make) -> Void in
                make.width.equalTo(addView.snp_height).priority(800)
                make.width.greaterThanOrEqualTo(30).priority(800)
                make.width.lessThanOrEqualTo(80).priority(800)
            })
        }
        
        let firstView = self.constraintViews.first
        firstView?.snp_makeConstraints(closure: { (make) -> Void in
            make.leading.equalTo(self.bgView.snp_leading).offset(spacing).priority(300)
        })
        
        var previousView : UIView? = nil
        for (_ , addView) in self.constraintViews.enumerate(){
            addView.snp_makeConstraints(closure: { (make) -> Void in
                
                //center Y axis
                make.centerY.equalTo(self.bgView.snp_centerY)
                
            })
            
            if let prev = previousView {
                
                //make layout specific
                prev.snp_makeConstraints(closure: { (make) -> Void in
                    make.trailing.equalTo(addView.snp_leading).offset(-spacing)
                    make.width.equalTo(addView.snp_width).priority(800)
                })
                
            }
            
            previousView = addView
        }
        
        let lastView = self.constraintViews.last
        lastView?.snp_makeConstraints(closure: { (make) -> Void in
            make.trailing.equalTo(self.bgView.snp_trailing).offset(-spacing).priority(250)
        })
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        for (index, addView) in self.constraintViews.enumerate() {
            print("id:\(index) frame:\(NSStringFromCGRect(addView.frame))")
        }
    }

    func pressAddBtn(sender:UIButton){
        let addView = UIView()
        addView.backgroundColor = self.getRandomColor()
        
        self.bgView.addSubview(addView)
        self.constraintViews.append(addView)
        
        self.updateViewConstraints()
    }
    
    func pressDelBtn(sender:UIButton){
        if self.constraintViews.count > 0 {
            let view = self.constraintViews.removeLast()
            view.removeFromSuperview()
            
            self.updateViewConstraints()
        }
    }
    
    func pressRefreshBtn(sender:UIButton){
        self.updateViewConstraints()
    }
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

}










