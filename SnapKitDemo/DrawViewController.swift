//
//  DrawViews.swift
//  SnapKitDemo
//
//  Created by bob on 4/13/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import UIKit

class DrawView : UIView {
    override func drawRect(rect: CGRect) {
        
    }
}

class DrawViewController : UIViewController {
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.hidden = true
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let image = createBitmapUsingUIGraphics(self.view.bounds.size)
        
        let imageView = UIImageView(image: image)
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
    }
    
    func createBitmapContext(pixelWide: Int, pixelHeight: Int) -> CGContext{
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()//CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB)
        
        let bitmapBytesPerRow = pixelWide * 4
        let bitmapByteCount = bitmapBytesPerRow * pixelHeight
        
        let bitmapData = calloc(bitmapByteCount, 1)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        let context = CGBitmapContextCreate(bitmapData,
                                            pixelWide, pixelHeight,
                                            8,
                                            bitmapBytesPerRow,
                                            colorSpace,
                                            bitmapInfo.rawValue)!
        
        return context
    }
    
    func createBitmapUsingQuartz(size: CGSize) -> UIImage{
        
        //let factor = Int(UIScreen.mainScreen().scale)
        
        let context = createBitmapContext(Int(size.width), pixelHeight: Int(size.height))
    
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0, -size.height)
        
        CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: 200, height: 100))
        CGContextSetRGBFillColor(context, 0.0, 0, 1.0, 0.5)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: 100, height: 200))
        
        let captureImg = CGBitmapContextCreateImage(context)
        
        return UIImage(CGImage: captureImg!)
    }
    
    func createBitmapUsingUIGraphics(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBFillColor(context, 1, 1, 1, 1.0)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: 200, height: 100))
        CGContextSetRGBFillColor(context, 0.0, 0, 1.0, 0.5)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: 100, height: 200))
        
        CGContextSaveGState(context)
        
        CGContextTranslateCTM(context, 160, 40)
        
        var path = createPentagonPath()
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1)
        CGContextSetRGBFillColor(context, 1, 0, 0, 1)
        
        CGContextSetLineWidth(context, 4.0)
        CGContextSetLineJoin(context, .Round)
        
        CGContextAddPath(context, path.CGPath)
        CGContextFillPath(context)
        
        //after fill or stroke context clear the path
        CGContextAddPath(context, path.CGPath)
        CGContextStrokePath(context)
        
        CGContextRestoreGState(context)
        
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 120, 150)
        
        path = createArcPath()
        CGContextSetRGBFillColor(context, 1, 0, 0, 1)
        CGContextAddPath(context, path.CGPath)
        CGContextFillPath(context)
        
        CGContextSetLineWidth(context, 4)
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1)
        CGContextAddPath(context, path.CGPath)
        CGContextStrokePath(context)
        CGContextRestoreGState(context)
        
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 70, 170)
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 1)
        CGContextSetLineWidth(context, 4)
        CGContextAddArc(context, 0, 0, 50, 0, CGFloat(M_PI), 0)
        CGContextStrokePath(context)
        
        CGContextSetRGBStrokeColor(context, 0, 0, 1, 1)
        CGContextMoveToPoint(context, 150, 0)
        //current point to (x1,y1), (x1,y1) to (x2, y2) compose the arc
        CGContextAddArcToPoint(context, 150, 50, 100, 50, 60)
        CGContextStrokePath(context)
        
        let captureImg = UIGraphicsGetImageFromCurrentImageContext()//CGBitmapContextCreateImage(context)
        
        //pop the context from the graphics stack.
        UIGraphicsEndImageContext()
        
        return captureImg
    }
    
    func createPentagonPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.moveToPoint(CGPoint(x: 100, y: 0))
        
        path.addLineToPoint(CGPoint(x: 200, y: 40))
        path.addLineToPoint(CGPoint(x: 160, y: 140))
        path.addLineToPoint(CGPoint(x: 40, y: 140))
        path.addLineToPoint(CGPoint(x: 0, y: 40))
        
        path.closePath()
        
        return path
    }
    
    func createArcPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        let center = CGPoint(x:60, y:60)
        path.moveToPoint(center)
        path.addArcWithCenter(center,
                              radius: 60,
                              startAngle: 0,
                              endAngle: CGFloat(M_PI * 2 / 8), clockwise: true)
        
        path.closePath()
        
        return path
    }
}





























