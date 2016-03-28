//
//  RWAutoLayoutViewController.swift
//  SnapKitDemo
//
//  Created by bob on 12/29/15.
//  Copyright © 2015 bob. All rights reserved.
//

import UIKit

class RWAutoLayoutViewController: UIViewController {

    var upperLeft : UIView!
    var upperRight : UIView!
    var bottom : UIView!
    
    override func viewDidLoad() {
        self.upperLeft = UIView()
        self.upperRight = UIView()
        self.bottom = UIView()

        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.hidden = true
        
        self.upperLeft.backgroundColor = UIColor.greenColor()
        self.upperRight.backgroundColor = UIColor.yellowColor()
        self.bottom.backgroundColor = UIColor.blueColor()
        
        self.view.addSubview(self.upperLeft)
        self.view.addSubview(self.upperRight)
        self.view.addSubview(self.bottom)
        
        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        
        let spacing = 20
        
        self.upperLeft.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.view).offset(spacing)
            make.top.equalTo(self.view).offset(spacing)
        }
        
        self.upperRight.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.upperLeft.snp_trailing).offset(spacing)//.priorityHigh()
            make.trailing.equalTo(self.view).offset(-spacing)
            make.top.equalTo(self.upperLeft.snp_top)
            make.width.equalTo(self.upperLeft)//.priority(750)
        }
        
        self.bottom.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.upperLeft.snp_bottom).offset(spacing)
            make.bottom.equalTo(self.view.snp_bottom).offset(-spacing)
            make.leading.equalTo(self.view.snp_leading).offset(spacing)
            make.trailing.equalTo(self.view.snp_trailing).offset(-spacing)
        }
        
        
        upperRight.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(self.upperLeft.snp_height)//.priority(750)
        }
        
        bottom.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(self.upperRight.snp_height).dividedBy(2.0)//.priority(750)
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        print("upper right frame \(NSStringFromCGRect(self.upperRight.frame))")
    }
}















