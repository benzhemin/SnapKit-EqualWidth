//
//  AnimationExplainedViewController.swift
//  SnapKitDemo
//
//  Created by bob on 1/6/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

/*
demo https://www.objc.io/issues/12-animations/animations-explained/
*/

class AnimationExplainedViewController: UIViewController {

    var arrow: UIView!
    var arrow2: UIView!
    
    var textInput: UITextField!

    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        arrow = UIView()
        arrow.backgroundColor = UIColor.redColor()
        self.view.addSubview(arrow)
        
        arrow2 = UIView()
        arrow2.backgroundColor = UIColor.greenColor()
        self.view.addSubview(arrow2)
        
        textInput = UITextField()
        textInput.borderStyle = UITextBorderStyle.RoundedRect
        textInput.backgroundColor = UIColor.whiteColor()
        textInput.placeholder = "account"
        self.view.addSubview(textInput)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapView"))
        
        self.updateViewConstraints()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            //self.launchArrowAnimation()
            
            //self.reuseAnimation()
            
            //self.shakeTextField()
            
            self.orbitRotation()
        }
    }
    
    func tapView(){
        self.view.endEditing(true)
    }
    
    func launchArrowAnimation(){
        
        let animation = CABasicAnimation(keyPath: "position.x")
        
        //一定要指定fromValue，不然动画会直接跳到最后的model tree指定的值
        /*
        模型层是由开始动画前的CALayer对象的属性定义的。当开始动画后，CAAnimation创建了CALayer对象的副本并进行修改，使其变成表现层，你可以大致理解为就是它们在屏幕上显示什么内容。
        
        前面的示例中，当执行动画时，状态从模型层变为表现层，表现层被绘制到屏幕上，绘制完成后，所有的更改都会丢失并由模型层决定当前状态，因为模型层没有改变，所以会恢复到一开始的状态。
        
        解决方法1：你可以通过设置动画的 fillMode 属性为 kCAFillModeForwards或kCAFillModeBoth使得动画 以留在最终状态，并设置removedOnCompletion 为 NO 以防止它被自动移除：
        
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        但这不是好的解决方法，因为这样模型层永远不会更新，如果之后对它进行隐性动画，那它不会正常工作。
        
        
        解决方法2:直接在 model layer 上更新属性
        
        */
        /*
        http://oleb.net/blog/2012/11/prevent-caanimation-snap-back/
        The code for this animation might look like this:
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        animation.toValue = @300.0;
        animation.duration = 1.0;
        [layer addAnimation:animation forKey:@"positionAnimation"];
        
        Explicit Animations Only Affect the Presentation Layer
        The reason for this behavior is that explicit CAAnimations only affect the presentation layer tree. The underlying model layer tree remains unchanged. As long as the animation is running, it assigns interpolated position values to the presentation layer, which is used for displaying the scene on screen. However, when the animation has finished the presentation layer automatically reverts back to the values of its corresponding model layer, which causes the sudden bounce back to the layer’s original position on screen.
        
        To solve the problem, we have to explicitly change the model layer’s position property. Unfortunately, doing so just before or after adding the animation to the layer overrides the animation and causes the layer to snap to its new position with no animation at all. Now that we have changed the model value before running the animation, the animation’s fromValue and toValue are identical, resulting in an “animation” without movement.
        
        To avoid this, save the original model value before changing it and explicitly set the animation’s fromValue:
        
        // Save the original value
        CGFloat originalY = layer.position.y;
        
        // Change the model value
        layer.position = CGPointMake(layer.position.x, 300.0);
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        
        // Now specify the fromValue for the animation because
        // the current model value is already the correct toValue
        animation.fromValue = @(originalY);
        animation.duration = 1.0;
        
        // Use the name of the animated property as key
        // to override the implicit animation
        [layer addAnimation:animation forKey:@"position"];
        */
        animation.fromValue = self.arrow.center.x
        animation.toValue = self.view.bounds.size.width
        animation.duration = 1
        self.arrow.layer.addAnimation(animation, forKey: "arrowAnimation")
        
        self.arrow.layer.position = CGPointMake(self.view.bounds.size.width, self.view.center.y)
        
    }
    
    func reuseAnimation(){
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = self.arrow.center.x
        animation.toValue = self.view.center.x
        animation.duration = 1
        
        self.arrow.layer.addAnimation(animation, forKey: "basic")
        self.arrow.layer.position = CGPointMake(self.view.center.x, self.arrow.center.y)
        
        /*
        beginTime
        Specifies the begin time of the receiver in relation to its parent object, if applicable.
        如果一个animation是在一个animation group中，则beginTime就是其parent object——animation group 开始的一个偏移。如果一个animation 的 beginTime为5，则此动画在group aniamtion开始之后的5s在开始动画。
        如果一个animation是直接添加在layer上，beginTime同样是是其parent object——layer 开始的一个偏移，但是一个layer的beginning是一个过去的时间（猜想layer的beginning可能是其被添加到layer tree上的时间），因此不能简单的设置beginTime为5去延迟动画5s之后开始，因为有可能layer的beginning加上5s之后也是一个过去的时间（很有可能），因此，当要延迟一个添加到layer上的动画的时候，需要定义一个addTime，因此
        [cpp] view plaincopy
        animation.beginTime = addTime + delay;
        
        通过使用CACurrentMediaTime去获取addTime：
        [cpp] view plaincopy
        addTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
        
        如果一个layer他自己的beginTime已经设置，则animation的addTime的计算必须在layer的beginTime设置之后，因为要有一个时间的转移，具体看下面的例子：
        [cpp] view plaincopy
        CFTimeInterval currentTime = CACurrentMediaTime();
        CFTimeInterval currentTimeInSuperLayer = [superLayer convertTime:currentTime fromLayer:nil];
        layer.beginTime = currentTimeInSuperLayer + 2;
        CFTimeInterval currentTimeInLayer = [layer convertTime:currentTimeInSuperLayer fromLayer:superLayer];
        CFTimeInterval addTime = currentTimeInLayer;
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.beginTime = addTime + 1;
        group.animations = [NSArray arrayWithObject:anim];
        group.duration = 2;
        anim.beginTime = 0.5;
        [layer addAnimation:group forKey:nil];
        
        timeOffset
        Specifies an additional time offset in active local time. (required)
        此句话不太容易理解，但是通过一个例子很容易理解。
        假定一个3s的动画，它的状态为t0,t1,t2,t3，当没有timeOffset的时候，正常的状态序列应该为：
        t0->t1->t2->t3
        当设置timeOffset为1的时候状态序列就变为
        t1->t2->t3->t0
        同理当timeOffset为2的时候状态序列就变为：
        t2->t3->t0=>t2
        是不是理解了？
        
        下面举一个例子，效果图参见空间图片地址http://my.csdn.net/my/album/detail/1651105 （不知道怎么直接嵌入的，因为是个gif，直接上传也不会播放，哪位同学知道好的处理方法可以告诉我）
        
        主要代码如下：
        [cpp] view plaincopy
        // Add layer.
        CATextLayer *A = [CATextLayer layer];
        A.string = @"A";
        A.fontSize = 48;
        A.foregroundColor = [UIColor blackColor].CGColor;
        A.bounds = CGRectMake(0, 0, 48, 48);
        A.position = self.center;
        [self.layer addSublayer:A];
        
        // Move animation.
        CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        move.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))], [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds))], [NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))], nil];
        move.calculationMode = kCAAnimationCubic;
        move.duration = 10;
        move.speed = 2;
        
        // Opacity animation.
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.toValue = [NSNumber numberWithFloat:0];
        opacity.duration = 2.5;
        opacity.beginTime = 2.5; // Fade from the half way.
        
        // Animatin group.
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = [NSArray arrayWithObjects:move, opacity, nil];
        group.duration = 8;
        group.repeatCount = HUGE_VALF;
        
        // Time warp.
        CFTimeInterval currentTime = CACurrentMediaTime();
        CFTimeInterval currentTimeInSuperLayer = [self.layer convertTime:currentTime fromLayer:nil];
        A.beginTime = currentTimeInSuperLayer + 5; // Delay the appearance of A.
        CFTimeInterval currentTimeInLayer = [A convertTime:currentTimeInSuperLayer fromLayer:self.layer];
        CFTimeInterval addTime = currentTimeInLayer;
        group.beginTime = addTime + 3; // Delay the animatin group.
        
        [A addAnimation:group forKey:nil];
        
        // Timer. For nice visual effect. Optional.
        CATextLayer *timer = [CATextLayer layer];
        timer.fontSize = 48;
        timer.foregroundColor = [UIColor redColor].CGColor;
        timer.bounds = CGRectMake(0, 0, 48, 48);
        timer.position = self.center;
        [self.layer addSublayer:timer];
        CAKeyframeAnimation *count = [CAKeyframeAnimation animationWithKeyPath:@"string"];
        count.values = [NSArray arrayWithObjects:@"5", @"4", @"3", @"2", @"1", nil];
        CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        fade.toValue = [NSNumber numberWithFloat:0.2];
        group = [CAAnimationGroup animation];  
        group.animations = [NSArray arrayWithObjects:count, fade, nil];  
        group.duration = 5;  
        [timer addAnimation:group forKey:nil];  
        
        大概解释一下，其实就是先播放一个倒计时5-4-3-2-1的动画，之后在显示layer A，因为A的beginTime为5，而当A显示3秒之后，A上才开始做group的动画。
        */
        animation.beginTime = CACurrentMediaTime() + 0.5
        self.arrow2.layer.addAnimation(animation, forKey: "basic")
        self.arrow2.layer.position = CGPointMake(self.view.center.x, self.arrow2.center.y)
    }
    
    func shakeTextField(){
        
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [0, 10, -10, 10, -10, 10, 0]
        animation.keyTimes = [0, 1/6.0, 2/6.0, 3/6.0, 4/6.0, 5/6.0, 1]
        animation.duration = 0.5
        
        //Setting the additive property to YES tells Core Animation to add the values specified by the animation to the value of the current render tree. 
        //用values值加上当前的render tree 显示值
        animation.additive = true
        
        self.textInput.layer.addAnimation(animation, forKey: "shake")
        
    }
    
    func orbitRotation(){
        
        let WHValue = 300.0
        let boundingRect = CGRectMake(0, 0, CGFloat(WHValue), CGFloat(WHValue))
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = CGPathCreateWithEllipseInRect(boundingRect, nil)
        animation.duration = 4
        
        animation.additive = true
        animation.repeatCount = Float.infinity
        animation.calculationMode = kCAAnimationPaced
        animation.rotationMode = kCAAnimationRotateAuto
        
        self.arrow.layer.addAnimation(animation, forKey: "orbit")
    }
    
    override func updateViewConstraints() {
        
        self.arrow.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            
            make.centerY.equalTo(self.view.snp_centerY)
            make.leading.equalTo(self.view.snp_leading)
        }
        
        self.arrow2.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(self.arrow)
            
            make.leading.equalTo(self.arrow.snp_leading)
            make.centerY.equalTo(self.arrow.snp_centerY).offset(100)
        }
        
        self.textInput.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.width.equalTo(120)
            
            make.centerX.equalTo(self.view.snp_centerX)
            make.centerY.equalTo(self.view.snp_centerY).offset(-100)
        }
        
        super.updateViewConstraints()
    }
}












































