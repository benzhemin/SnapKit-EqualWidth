//
//  RWGalleryViewController.swift
//  SnapKitDemo
//
//  Created by bob on 12/29/15.
//  Copyright © 2015 bob. All rights reserved.
//

import UIKit

class GalleryView : UIView{
    
    let galleryDesc : (imgName:String, labelName:String)
    
    let galleryIV : UIImageView
    let galleryLV : UILabel
    
    init?(_ aDecoder: NSCoder? = nil, withDesc desc:(imgName:String, labelName:String)?) {
        
        self.galleryDesc = desc!
        self.galleryIV = UIImageView()
        self.galleryLV = UILabel()
        
        if let coder = aDecoder {
            super.init(coder: coder)
        }else{
            super.init(frame: CGRectZero)
        }
        
        self.initializeView()
    }
    
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder, withDesc:nil)
    }
    
    func initializeView(){
        
        self.galleryIV.contentMode = UIViewContentMode.ScaleAspectFit
        self.galleryIV.backgroundColor = UIColor.whiteColor()
        self.galleryIV.image = UIImage(named: self.galleryDesc.imgName)
        
        /*
        self.galleryIV.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Vertical)
        self.galleryIV.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
        */
        
        /*
        http://www.raywenderlich.com/115444/auto-layout-tutorial-in-ios-9-part-2-constraints
        
        If neither the image view nor the label has a fixed height, then Auto Layout doesn’t know by how much to scale each if the height of the green view should change. 
        Let’s say at some point in your app the green view becomes 100 points taller. How should Auto Layout distribute these new 100 points among the label and the image view? Does the image view become 100 points taller while the label stays the same size? Or does the label become taller while the image view stays the same? Do they both get 50 points extra, or is it split 25/75, 40/60, or in some other possible combination?
        If you don’t solve this problem somehow then Auto Layout is going to have to guess and the results may be unpredictable.
        The proper solution is to change the Content Compression Resistance Priority of the label. As the name suggests, this value determines how resistant a view is to being compressed, or shrunk. A higher value here means the view will be less likely to be compressed and more likely to stay the same.
        Similarly, the Content Hugging Priority determines how resistant a view is to being expanded. You can imagine “hugging” here to mean “size to fit” – the bounds of the view will “hug” or be close to the intrinsic content size. A higher value here means the view will be less likely to grow and more likely to stay the same.
        */
        self.galleryLV.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Vertical)
        
        self.galleryLV.text = self.galleryDesc.labelName
        self.galleryLV.backgroundColor = UIColor.clearColor()
        self.galleryLV.textColor = UIColor.blackColor()
        self.galleryLV.font = UIFont.boldSystemFontOfSize(13)
        
        self.addSubview(galleryIV)
        self.addSubview(galleryLV)
        
        let spacing = 10
        
        
        galleryLV.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp_bottom).offset(-spacing/2)
            make.centerX.equalTo(self.snp_centerX)
        }
        
        galleryIV.snp_makeConstraints { (make) -> Void in
            //make.centerX.equalTo(self.snp_centerX)
            
            make.leading.equalTo(self.snp_leading).offset(spacing)
            make.trailing.equalTo(self.snp_trailing).offset(-spacing)
            make.top.equalTo(self.snp_top).offset(spacing)
            make.bottom.equalTo(self.galleryLV.snp_top).offset(-spacing/2)
            //make.bottom.equalTo(self.snp_bottom).offset(-spacing/2).pri
        }
        
    }
}

class RWGalleryViewController: UIViewController {

    let galleryDict : [String: String] = [
        "Ray" : "Ray",
        "Matthijs" : "Matthijs",
        "Dennis" : "Dennis Ritchie",
        "Brad" : "Brad Cox"
    ];
    
    var viewList: [View]
    var viewBgColor: [UIColor]
    
    //构造了一个无参数构造函数
    init?(_ coder: NSCoder? = nil){
        
        viewList = [View]()
        viewBgColor = [UIColor.greenColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.blueColor()]
        
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

        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.hidden = true
        
        for (index , (imgName, labelName)) in self.galleryDict.enumerate(){
            if let bgView = GalleryView(withDesc: (imgName, labelName)) {
                bgView.backgroundColor = self.viewBgColor[index]
                self.view.addSubview(bgView)
                self.viewList.append(bgView)
            }
        }
        
        self.updateViewConstraints()
    }

    override func updateViewConstraints() {
        
        let upperL = self.viewList[0]
        let upperR = self.viewList[1]
        let bottomL = self.viewList[2]
        let bottomR = self.viewList[3]
        
        upperL.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(upperR.snp_leading)
            make.bottom.equalTo(bottomL.snp_top)
        }
        
        bottomR.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(bottomL.snp_trailing)
            make.top.equalTo(upperR.snp_bottom)
        }
        
        
        var preView: UIView? = nil
        for (index , view) in self.viewList.enumerate() {
            
            view.snp_makeConstraints(closure: { (make) -> Void in
                if index % 2 == 0{
                    make.leading.equalTo(self.view.snp_leading)
                }else{
                    make.trailing.equalTo(self.view.snp_trailing)
                }
                
                if index < 2 {
                    make.top.equalTo(self.view.snp_top)
                }else{
                    make.bottom.equalTo(self.view.snp_bottom)
                }
            })
            
            if let pre = preView {
                
                view.snp_makeConstraints(closure: { (make) -> Void in
                    make.height.equalTo(pre.snp_height)
                    make.width.equalTo(pre.snp_width)
                })
                
            }else {
                preView = view
            }
        }
        
        super.updateViewConstraints()
    }
    
}



