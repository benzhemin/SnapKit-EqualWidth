//
//  ImageBlendViewController.swift
//  SnapKitDemo
//
//  Created by bob on 5/7/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import UIKit

//https://onevcat.com/2013/04/using-blending-in-ios/
extension UIImage {
    
    //设置TintColor
    func imageWithTintColor(tintColor: UIColor) -> UIImage {
        return imageWithTintColor(tintColor, blendMode: .DestinationIn)
    }
    
    //设置亮暗
    func imageWithGradientTintColor(tintColor: UIColor) -> UIImage {
        return imageWithTintColor(tintColor, blendMode: .Overlay)
    }
    
    func imageWithTintColor(tintColor: UIColor, blendMode:CGBlendMode) -> UIImage {
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        tintColor.setFill()
        UIRectFill(bounds)
        
        if blendMode != .DestinationIn {
            self.drawInRect(bounds, blendMode: blendMode, alpha: 1.0)
        }
        self.drawInRect(bounds, blendMode: .DestinationIn, alpha: 1.0)
        
        let tintImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintImage
    }
    
}

class ImageBlendViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.6)//UIColor.whiteColor()
        
        let image = UIImage(named: "star")?.imageWithGradientTintColor(UIColor.orangeColor())
        let imageView = UIImageView(image: image)
        
        self.view.addSubview(imageView)
        imageView.center = view.center
        
        let image2 = UIImage(named: "star")?.imageWithTintColor(UIColor.orangeColor())
        let imageView2 = UIImageView(image: image2)
        self.view.addSubview(imageView2)
        imageView2.center = CGPoint(x: view.center.x, y: view.center.y+90)
    }
    
}