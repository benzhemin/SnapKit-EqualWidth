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
        
        //self.navigationController?.navigationBar.hidden = true
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.whEqualView.backgroundColor = UIColor.purpleColor()
        
        self.view.addSubview(self.whEqualView)
        
        
        self.updateViewConstraints()
    }
    
    //updateViewConstraints() only gets called if the constraints need to be updated.
    //http://spin.atomicobject.com/2015/06/03/ios-square-view-auto-layout/
    override func updateViewConstraints(){

        whEqualView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(whEqualView.snp_height).priorityRequired()
            
            make.center.equalTo(self.view.snp_center)
            
            make.height.lessThanOrEqualTo(self.view.snp_height).priorityRequired()
            make.width.lessThanOrEqualTo(self.view.snp_width).priorityRequired()
            
            /*
            What these constraints do is maximize the size the square to be the larger of the width or height of the containing view (whichever is smaller).
            
            */
            make.height.equalTo(self.view.snp_height).priorityHigh()
            make.width.equalTo(self.view.snp_width).priorityHigh()
        }
        
        super.updateViewConstraints()
    }
}



















