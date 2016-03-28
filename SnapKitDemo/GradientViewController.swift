//
//  GradientViewController.swift
//  SnapKitDemo
//
//  Created by bob on 2/7/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import UIKit

class GradientViewController : UIViewController{
    
    typealias GradientColor = (topColor:CGColorRef, bottomColor:CGColorRef)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let gradientBgLayer = CAGradientLayer()
        gradientBgLayer.frame = self.view.bounds
        print("bounds: \(NSStringFromCGRect(self.view.bounds))")
        
        let redGradient = self.orangeGradientColor()
        gradientBgLayer.colors = [redGradient.topColor, redGradient.bottomColor]
        //gradientBgLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientBgLayer, atIndex: 0)
    }
    
    func redGradientColor() -> GradientColor{
        return (UIColor(hexString: "#FF5E3A")!.CGColor, UIColor(hexString: "#FF2A68")!.CGColor)
    }
    
    func orangeGradientColor() -> GradientColor{
        return (UIColor(hexString: "#FF9500")!.CGColor, UIColor(hexString: "#FF5E3A")!.CGColor)
    }
    
    func yellowGradientColor() -> GradientColor{
        return (UIColor(hexString: "FFDB4C")!.CGColor, UIColor(hexString: "#FFCD02")!.CGColor)
    }
    
}