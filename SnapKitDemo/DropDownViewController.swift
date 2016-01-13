//
//  DropDownViewController.swift
//  SnapKitDemo
//
//  Created by bob on 12/31/15.
//  Copyright © 2015 bob. All rights reserved.
//

import UIKit

enum DropDownState{
    case Drop
    case Stay
    
    mutating func toggle(){
        if self == Drop {
            self = Stay
        }else {
            self = Drop
        }
    }
}

protocol DropDownProtocal:class{
    func triggerDropDown();
}

class NaviTitleView : UIView {
    
    typealias descTuple = (titleName:String, imgName:String)
    
    let titleLabel: UILabel
    let titleImgView: UIImageView
    let desc : descTuple?
    
    var titleState: DropDownState
    
    weak var delegate:DropDownProtocal!
    
    init?(_ aDecoder: NSCoder? = nil, withDesc desc:descTuple?) {
        
        titleLabel = UILabel()
        titleImgView = UIImageView()
        titleState = .Stay
        
        self.desc = desc
        
        
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
        self.userInteractionEnabled = true
        
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(15)
        titleLabel.userInteractionEnabled = true
        self.addSubview(titleLabel)
        
        titleImgView.backgroundColor = UIColor.clearColor()
        titleImgView.userInteractionEnabled = true
        self.addSubview(titleImgView)
        
        if let aDesc = self.desc {
            titleLabel.text = aDesc.titleName
            let image = UIImage(named: aDesc.imgName)
            self.titleImgView.image = image
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapNaviTitleView")
        self.addGestureRecognizer(tapGesture)
        
        self.updateConstraints()
    }
    
    override func updateConstraints() {
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.snp_leading)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        titleImgView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.titleLabel.snp_trailing).offset(10)
            make.trailing.equalTo(self.snp_trailing)
            make.bottom.equalTo(self.titleLabel.snp_baseline)
        }
        
        super.updateConstraints()
    }
    
    func tapNaviTitleView(){
        print("press NaviTitleView")
        
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.titleImgView.transform = CGAffineTransformRotate(self.titleImgView.transform, CGFloat(M_PI))
        }
        
        self.titleState.toggle()
        self.delegate.triggerDropDown()
    }
}

class DropDownViewController: UIViewController, DropDownProtocal, UITableViewDelegate, UITableViewDataSource {

    let titleView: NaviTitleView
    let menuTitle: [String]
    
    var placeView: UIView!
    var wrapperView: UIView!
    var backgroundView: UIView!
    var dropDownTV : UITableView!
    var dropDownTVHeight : CGFloat! = 0
    
    var themeColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
    private let CELL_IDENTIFER = "CELL_IDENTIFER"
    
    //构造了一个无参数构造函数
    init?(_ coder: NSCoder? = nil){
        
        self.titleView = NaviTitleView(withDesc: ("Most Popular", "arrow_down"))!
        self.menuTitle = ["Most Popular", "Latest", "Trending", "Nearest", "Top Pick"]
        
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
    
        self.view.userInteractionEnabled = true
        
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barTintColor = themeColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let size = self.titleView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        self.titleView.frame = CGRectMake(0, 0, size.width, size.height)
        self.navigationItem.titleView = self.titleView
        
        self.titleView.delegate = self
        
        wrapperView = UIView()
        wrapperView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(wrapperView)
        
        wrapperView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp_bottom)
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(CGRectGetMaxY(self.navigationController!.navigationBar.frame))
        }
        
        //wrapperView.clipsToBounds = true
        
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightGrayColor()
        backgroundView.alpha = 0.6
        wrapperView.addSubview(backgroundView)
        backgroundView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(wrapperView)
        }
        
        // Do any additional setup after loading the view.
        self.dropDownTV = UITableView()
        self.dropDownTV.registerClass(UITableViewCell.self, forCellReuseIdentifier:CELL_IDENTIFER)
        self.dropDownTV.separatorStyle = .SingleLine
        self.dropDownTV.tableFooterView = UIView()
        
        let headerView = UIView(frame: CGRectMake(0, 0, 0, 300))
        headerView.backgroundColor = themeColor
        self.dropDownTV.tableHeaderView = headerView
        
        dropDownTV.backgroundColor = UIColor.clearColor()
        
        dropDownTV.delegate = self
        dropDownTV.dataSource = self
        
        self.wrapperView.addSubview(dropDownTV)
        
        dropDownTV.reloadData()
        dropDownTV.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(self.wrapperView)
            make.top.equalTo(self.wrapperView).offset(-self.menuTitle.count*44-300)
            make.bottom.equalTo(self.wrapperView.snp_bottom)
        }
        
        //wrapperView.hidden = true
        //self.updateViewConstraints()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.menuTitle.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFER, forIndexPath: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = themeColor
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(14)
        
        cell.textLabel?.text = self.menuTitle[indexPath.row]
        
        return cell
    }
    
    func triggerDropDown() {
        
        self.dropDownTV.reloadData()
        self.dropDownTV.layoutIfNeeded()
        
        self.dropDownTV.snp_updateConstraints { (make) -> Void in
            if self.titleView.titleState == .Stay {
                make.top.equalTo(self.wrapperView.snp_top).offset(-self.menuTitle.count*44-300)
                make.bottom.equalTo(self.wrapperView.snp_bottom).offset(self.menuTitle.count*44+300)
            }else{
                make.top.equalTo(self.wrapperView.snp_top).offset(-300)
                make.bottom.equalTo(self.wrapperView.snp_bottom).offset(300)
            }
            
        }
        
        UIView.animateWithDuration(0.7, delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 15,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                self.dropDownTV.layoutIfNeeded()
            }, completion: { (finish) -> Void in
                if self.titleView.titleState == .Stay{
                    
                }else{
                    
                }
            }
        )
    }
}










