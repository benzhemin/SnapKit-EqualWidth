//
//  TagViewController.swift
//  SnapKitDemo
//
//  Created by bob on 3/26/16.
//  Copyright © 2016 bob. All rights reserved.
//

import Foundation
import UIKit

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
let vertiPadding = CGFloat(8)

class TagsView : UIView {
    var tagButtons: [YYTagButton]!
    
    var intinsicSize : CGSize! = CGSizeMake(0, 0)
    var preferredMaxLayoutWidth : CGFloat = 0 {
        didSet{
            layoutTags = false
            self.invalidateIntrinsicContentSize()
        }
    }
    
    var layoutTags = false
    
    init(tags: [String]){
        self.tagButtons = [YYTagButton]()
        super.init(frame: CGRectZero)
        
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = 3.0
        
        for tag in tags {
            let tagConfig = YYTagConfig(text: tag)
            let tagButton = YYTagButton(config:tagConfig).configButton()
            
            tagButtons.append(tagButton)
            addSubview(tagButton)
        }
    }
    
    required init(coder deCoder: NSCoder){
        fatalError("This class does not support NSCoding")
    }
    
    func addTag(tag:String) {
        let tagConfig = YYTagConfig(text: tag)
        let tagButton = YYTagButton(config: tagConfig).configButton()
        
        tagButtons.append(tagButton)
        self.addSubview(tagButton)
    }
    
    func removeTag(){
        if self.tagButtons.count > 0 {
            let tagView = tagButtons.removeLast()
            tagView.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        self.preferredMaxLayoutWidth = self.frame.size.width
        
        super.layoutSubviews()
        
        self.updateTagsCoordinates()
    }
    
    func updateTagsCoordinates() {
        if layoutTags {
            return
        }
        
        let width = self.preferredMaxLayoutWidth
        
        var startY = vertiPadding
        var startX = horizPadding
        
        var lastBtn: YYTagButton?
        for tagBtn in self.tagButtons {
            let size = tagBtn.intrinsicContentSize()
            
            if (startX + size.width) <= width {
                tagBtn.frame = CGRectMake(startX, startY,
                                          tagBtn.intrinsicContentSize().width,
                                          tagBtn.intrinsicContentSize().height)
                
                startX = CGRectGetMaxX(tagBtn.frame) + horizPadding
            } else {
                if let lastBtn = lastBtn {
                    startY += CGRectGetHeight(lastBtn.frame) + vertiPadding
                    startX = horizPadding
                }
                
                tagBtn.frame = CGRectMake(startX, startY,
                                          tagBtn.intrinsicContentSize().width,
                                          tagBtn.intrinsicContentSize().height)
                
                startX = CGRectGetMaxX(tagBtn.frame) + horizPadding
            }
            
            lastBtn = tagBtn
        }
        
        self.intinsicSize = CGSize(width:width, height:0)
        
        if self.tagButtons.count > 0 {
            self.intinsicSize = CGSize(width:width, height:CGRectGetMaxY(lastBtn!.frame))
        }
        
        layoutTags = true
    }
    
    
    override func intrinsicContentSize() -> CGSize {
        if self.tagButtons.count <= 0 {
            return CGSizeZero
        }
        
        if self.preferredMaxLayoutWidth > 0 {
            var startX = horizPadding
            var startY = vertiPadding
            
            var lastBtn : YYTagButton?
            for tagBtn in self.tagButtons {
                let size = tagBtn.intrinsicContentSize()
                
                if startX+size.width > self.preferredMaxLayoutWidth {
                    //起始元素要填充计算
                    startX = horizPadding + size.width + horizPadding
                    startY += size.height + vertiPadding
                }else {
                    startX += size.width + horizPadding
                }
                
                lastBtn = tagBtn
                
                print("\(tagBtn.titleLabel!.text!) startX \(startX) startY \(startY) width \(self.preferredMaxLayoutWidth)")
            }
            
            startY += lastBtn!.intrinsicContentSize().height + vertiPadding
            print("startX \(startX) startY \(startY) width \(self.preferredMaxLayoutWidth)")
            
            return CGSizeMake(self.preferredMaxLayoutWidth, startY)
        }
        else {
            var intrinsicWidth : CGFloat = horizPadding
            let intrinsicHeight : CGFloat = tagButtons.first!.intrinsicContentSize().height + vertiPadding*2
            
            for tagBtn in self.tagButtons {
                let size = tagBtn.intrinsicContentSize()
                intrinsicWidth += size.width + horizPadding
            }
            
            return CGSizeMake(intrinsicWidth, intrinsicHeight)
        }
    }
}

class TagViewController : UIViewController{
    
    let tags = ["Java", "Javascript", "C", "Swift", "Objective-C", "Shell", "PHP", "Ruby", "Scala"]
    var tagButtons = [YYTagButton]()
    
    var contentView: UIView!
    var tagsView: TagsView!
    
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
        
        tagsView = TagsView(tags:tags)
        tagsView.userInteractionEnabled = true
        contentView.addSubview(tagsView)
        tagsView.snp_makeConstraints { (make) in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(contentView.snp_top)
        }
        
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.redColor().CGColor
        self.view.addSubview(contentView)
        
        contentView.snp_makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.top.equalTo(self.snp_topLayoutGuideBottom)
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
            //print("adjustWidth \(adjustWidth) ")
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
        
        tagsView.addTag(tags[random])
    }
    
    func removeTag(sender: UIButton){
        tagsView.removeTag()
    }
    
    override func updateViewConstraints() {
        
        addTagsButton.snp_remakeConstraints { (make) in
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-10)
            make.centerX.equalTo(self.contentView.snp_centerX)
        }
        
        removeTagsButton.snp_remakeConstraints { (make) in
            make.leading.equalTo(addTagsButton.snp_trailing).offset(horizPadding)
            make.centerY.equalTo(addTagsButton.snp_centerY)
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
}
