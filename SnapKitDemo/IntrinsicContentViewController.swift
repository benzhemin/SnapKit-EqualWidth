//
//  IntrinsicContentViewController.swift
//  SnapKitDemo
//
//  Created by bob on 3/26/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import UIKit

class IntrinsicView : UIView {
    
    override func intrinsicContentSize() -> CGSize {
        print("override intrinsicContentSize")
        return CGSize(width: 250, height: 250)
    }
    
}

class IntrinsicContentViewController : UIViewController{
    var contentView : UIView!
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.contentView = IntrinsicView()
        contentView.backgroundColor = UIColor.yellowColor()
        
        self.view.addSubview(contentView)
        
        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        
        contentView.snp_makeConstraints { (make) in
            
            make.leading.equalTo(self.view.snp_leading).offset(10)
            make.trailing.equalTo(self.view.snp_trailing).offset(-10)
            
            make.height.equalTo(50)
            
            make.center.equalTo(self.view.snp_center)
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        print("contentView \(NSStringFromCGRect(contentView.frame))")
        
        super.viewDidLayoutSubviews()
    }
}