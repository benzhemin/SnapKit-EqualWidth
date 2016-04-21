//
//  YYPageBarStripViewController.swift
//  Tales
//
//  Created by bob on 3/25/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import UIKit

class YYPageStripViewController : UIViewController, UIScrollViewDelegate{
    
    var scrollView : UIScrollView!
    var containerView : UIView!
    
    var vcs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        scrollView = UIScrollView(frame: CGRectZero)
        //自动调整
        self.automaticallyAdjustsScrollViewInsets = false
        
        scrollView.directionalLockEnabled = true
        scrollView.bounces = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
 
        scrollView.pagingEnabled = true
        
        self.view.addSubview(scrollView)
        
        scrollView.contentInset = UIEdgeInsets(top: CGFloat(CGRectGetMaxY(self.navigationController!.navigationBar.frame)),
                                               left: 0, bottom: 0, right: 0)
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.redColor()
        containerView.userInteractionEnabled = true
        containerView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(containerView)
        containerView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.scrollView)
            make.height.equalTo(self.view.bounds.height - CGRectGetMaxY(self.navigationController!.navigationBar.frame))
        }
        
        addChildViewControllers()
        
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        var prevc : UIViewController?
        for controller in vcs {
            
            controller.view.snp_makeConstraints(closure: { (make) in
                if let pre = prevc {
                    make.leading.equalTo(pre.view.snp_trailing)
                }else {
                    make.leading.equalTo(containerView.snp_leading)
                }
                make.top.equalTo(containerView.snp_top)
                make.height.equalTo(containerView.snp_height)
                make.width.equalTo(self.view.snp_width)
            })
            
            prevc = controller
        }
        containerView.snp_makeConstraints { (make) in
            make.trailing.equalTo(prevc!.view.snp_trailing)
        }

        //self.updateViewConstraints()
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("contentView frame \(NSStringFromCGRect(self.containerView.frame)) scrollView frame \(NSStringFromCGRect(self.scrollView.frame))")
        
        super.viewDidLayoutSubviews()
    }
    
    func addChildViewControllers() -> [UIViewController] {
        vcs.removeAll()
        
        for _ in 1...4 {
            let controller = UIViewController()
            controller.view.userInteractionEnabled = true
            controller.view.backgroundColor = RandomColor.getRandomColor()
            
            //self.addChildViewController(controller)
            containerView.addSubview(controller.view)
            
            vcs.append(controller)
        }
        return vcs
    }
    
}

class RandomColor {
    class func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}