//
//  NeedsDisplayForKeyViewController.swift
//  SnapKitDemo
//
//  Created by bob on 1/22/16.
//  Copyright © 2016 bob. All rights reserved.
//
import UIKit

//http://blog.csdn.net/sinat_27706697/article/details/49738957

/*
首先了解下layer自己的属性如何实现动画。
1. layer首次加载时会调用 +(BOOL)needsDisplayForKey:(NSString *)key方法来判断当前指定的属性key改变是否需要重新绘制。
2. 当Core Animartion中的key或者keypath等于+(BOOL)needsDisplayForKey:(NSString *)key 方法中指定的key，便会自动调用setNeedsDisplay方法，这样就会触发重绘，达到我们想要的效果。

layer方法响应链有两种:
1. [layer setNeedDisplay] -> [layer displayIfNeed] -> [layer display] -> [layerDelegate displayLayer:]
2. [layer setNeedDisplay] -> [layer displayIfNeed] -> [layer display] -> [layer drawInContext:] -> [layerDelegate drawLayer: inContext:]
说明一下，如果layerDelegate实现了displayLayer:协议，之后layer就不会再调用自身的重绘代码。
这里使用第二种方式来实现圆形进度条，将代码集成到layer中，降低耦合。

*/

let progress = "progress"

class CircleLayer: CALayer {
    
    /*
    override class func needsDisplayForKey(key: String) -> Bool{
        if key == progress {
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
    func animateCircle{
        let anim = CAKeyframeAnimation(keyPath: progress)
        
        anim.values =
    }
    
    func valuesListWithDuration(duration:Int) -> [CGFloat]{
        //60 frames per second
        let frames = duration * 60
        
        var values = [CGFloat]()
        
        let fromValue: CGFloat = 0.0
        let toValue: CGFloat = 1.0
        
        let diff = toValue - fromValue
        
        for (var frame=1; frame<=frames; frame++){
            
        }
        
    }
    */
    
}

class NeedsDisplayForKeyViewController: UIViewController {

    
    
}





