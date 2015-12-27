//
//  WHEqualViewController.swift
//  SnapKitDemo
//
//  Created by bob on 12/27/15.
//  Copyright © 2015 bob. All rights reserved.
//

import UIKit

class WHEqualViewController: UIViewController {
    
    let whEqualView : UIView
    
    //构造了一个无参数构造函数
    init?(_ coder: NSCoder? = nil){
        
        self.whEqualView = UIView()
        
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
        
        self.navigationController?.navigationBar.hidden = true
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.whEqualView.backgroundColor = UIColor.purpleColor()
        
        self.view.addSubview(self.whEqualView)
        
        
        self.updateViewConstraints()
    }
    
    //updateViewConstraints() only gets called if the constraints need to be updated.
    override func updateViewConstraints(){
        let orientation = UIDevice.currentDevice().orientation

        whEqualView.snp_remakeConstraints { (make) -> Void in
            make.width.equalTo(whEqualView.snp_height).priorityHigh()
            make.center.equalTo(self.view.snp_center)
            
            if orientation == UIDeviceOrientation.Portrait {
                
                make.width.equalTo(self.view.snp_width).priorityRequired()
            } else if orientation == UIDeviceOrientation.LandscapeLeft ||
                orientation == UIDeviceOrientation.LandscapeRight {
                    
                make.height.equalTo(self.view.snp_height).priorityRequired()
            }
        }
        
        super.updateViewConstraints()
    }
}



















