//
//  TagViewController.swift
//  SnapKitDemo
//
//  Created by bob on 3/26/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import UIKit

class RandomColor {
    class func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

class YYTagConfig {
    
    let defaultFontSize = CGFloat(13.0)
    let textColor = RandomColor.getRandomColor()

    let normalBackgroundColor = UIColor.init(red:0, green:0, blue:0, alpha: 0.1)//UIColor.lightGrayColor()
    let highlightBackgroundColor = UIColor.whiteColor()
    
    let cornerRadius = CGFloat(10)
    
    let text: String
    
    init(text: String){
        self.text = text
    }
}

class YYTagButton : UIButton {
    var config: YYTagConfig!
    var lineNumber : Int!
    
    init(config: YYTagConfig) {
        super.init(frame: CGRectZero)
        
        self.config = config
        self.lineNumber = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configButton() -> YYTagButton{
        //let button = UIButton(type: .Custom)
        
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(config.defaultFontSize)
        self.backgroundColor = config.normalBackgroundColor
        
        self.setTitle(config.text, forState: .Normal)
        self.setTitleColor(config.textColor, forState: .Normal)
        
        self.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        
        self.layer.cornerRadius = config.cornerRadius
        //button.layer.masksToBounds = true
        return self
    }
    
    override var highlighted: Bool {
        didSet{
            if highlighted {
                self.backgroundColor = config.highlightBackgroundColor
            }else {
                self.backgroundColor = config.normalBackgroundColor
            }
        }
    }
}

let horizPadding = CGFloat(8)
let vertiPadding = CGFloat(10)

class TagViewController : UIViewController{
    
    let tags = ["Java", "Javascript", "C", "Swift", "Objective-C", "Shell", "PHP", "Ruby", "Scala"]
    var tagButtons = [YYTagButton]()
    
    var contentView: UIView!
    
    var addTagsButton: YYTagButton!
    var removeTagsButton: YYTagButton!
    
    var startPoint: CGPoint!
    var contentWidth : CGFloat!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        contentView = UIView()
        contentView.userInteractionEnabled = true
        contentView.backgroundColor = UIColor.whiteColor()

        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.redColor().CGColor
        self.view.addSubview(contentView)
        
        contentView.snp_remakeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.top.equalTo(self.snp_topLayoutGuideBottom)
        }
        
        for tag in tags {
            let tagConfig = YYTagConfig(text: tag)
            let tagButton = YYTagButton(config:tagConfig).configButton()
            
            contentView.addSubview(tagButton)
            
            tagButtons.append(tagButton)
        }
        
        addTagsButton = YYTagButton(config:YYTagConfig(text:"AddTag")).configButton()
        addTagsButton.addTarget(self, action: #selector(addTag), forControlEvents: .TouchUpInside)
        contentView.addSubview(addTagsButton)
        
        removeTagsButton = YYTagButton(config: YYTagConfig(text:"RemoveTag")).configButton()
        removeTagsButton.addTarget(self, action: #selector(removeTag), forControlEvents: .TouchUpInside)
        contentView.addSubview(removeTagsButton)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        self.view.addGestureRecognizer(pan)
        
        self.updateViewConstraints()
    }
    
    func panGesture(pan:UIPanGestureRecognizer){
        let location = pan.locationInView(self.view)

        switch pan.state {
        case .Began:
            startPoint = location
            contentWidth = self.contentView.bounds.width
        case .Changed:
            let offsetX = location.x - startPoint.x
            let transWidth = contentWidth + offsetX
            
            let adjustWidth = min(self.view.bounds.width, max(self.view.bounds.width/4, transWidth))
            print("adjustWidth \(adjustWidth) ")
            self.contentView.snp_remakeConstraints { (make) in
                make.leading.equalTo(self.view.snp_leading)
                make.width.equalTo(adjustWidth)
                make.top.equalTo(self.snp_topLayoutGuideBottom)
                make.bottom.equalTo(self.view.snp_bottom)
            }
            
            self.view.updateConstraints()
        case .Ended:
            self.view.updateConstraints()
        default:
            print()
        }
    }
    
    func addTag(sender: UIButton){
        let random = Int(arc4random_uniform(UInt32(tags.count-1)))
        let tagConfig = YYTagConfig(text: tags[random])
        let tagButton = YYTagButton(config:tagConfig).configButton()
        
        tagButton.lineNumber = tagButtons.last?.lineNumber ?? 0
        
        self.contentView.addSubview(tagButton)
        tagButtons.append(tagButton)
        
        self.updateViewConstraints()
    }
    
    func removeTag(sender: UIButton){
        if !tagButtons.isEmpty {
            
            let tagButton = tagButtons.removeLast()
            tagButton.removeFromSuperview()

            self.updateViewConstraints()
        }
    }
    
    override func updateViewConstraints() {
        
        addTagsButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-10)
            make.centerX.equalTo(self.contentView.snp_centerX)
        }
        
        removeTagsButton.snp_makeConstraints { (make) in
            make.leading.equalTo(addTagsButton.snp_trailing).offset(horizPadding)
            make.centerY.equalTo(addTagsButton.snp_centerY)
        }
        
        var previous: YYTagButton?
        for tagButton in tagButtons {
            if let pre = previous {
                
                tagButton.snp_remakeConstraints(closure: { (make) in
                    //新起一行
                    if tagButton.lineNumber > pre.lineNumber {
                        make.top.equalTo(pre.snp_bottom).offset(vertiPadding)
                        make.leading.equalTo(tagButtons[0].snp_leading)
                    }else {
                        make.centerY.equalTo(pre.snp_centerY)
                        make.leading.equalTo(pre.snp_trailing).offset(horizPadding)
                    }
                })
                
                previous = tagButton
                
            }else {
                previous = tagButton
                
                tagButton.snp_remakeConstraints(closure: { (make) in
                    make.leading.equalTo(self.contentView.snp_leading).offset(horizPadding)
                    make.top.equalTo(self.snp_topLayoutGuideBottom).offset(vertiPadding)
                })
            }
        }
        
        super.updateViewConstraints()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        contentView.snp_remakeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.top.equalTo(self.snp_topLayoutGuideBottom)
        }
        
        self.updateViewConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var lineNumber = 0
        var needsConstraints = false
        var previous : YYTagButton?
        
        let preferredWidth = CGRectGetMaxX(self.contentView.frame)
        
        outter:for (_, current) in self.tagButtons.enumerate() {
            if let pre = previous {
                print("pre \(pre.titleLabel?.text) current \(current.titleLabel?.text)")
                
                if current.lineNumber > pre.lineNumber {
                    
                    let afterCurButtons = tagButtons[tagButtons.indexOf(current)!..<tagButtons.count]
                    
                    let expectedMaxWidth = CGRectGetMaxX(pre.frame)
                    
                    for expectButton in afterCurButtons {
                        if expectedMaxWidth+horizPadding+expectButton.bounds.size.width < preferredWidth {
                            current.lineNumber = current.lineNumber - 1
                            needsConstraints = true
                        }else {
                            break
                        }
                    }
                    
                    if needsConstraints {
                        break outter
                    }
                    
                }
                
                //区域缩小
                if (CGRectGetMaxX(current.frame) > preferredWidth) {
                    current.lineNumber = lineNumber+1
                    needsConstraints = true
                    break;
                }else {
                    lineNumber = current.lineNumber
                }
            }
            previous = current
        }
        
        if needsConstraints {
            
            
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.updateViewConstraints()
        
        
        //super.viewDidLayoutSubviews()
    }
}