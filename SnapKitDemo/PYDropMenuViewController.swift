//
//  DropDownViewController.swift
//  SnapKitDemo
//
//  Created by bob on 12/31/15.
//  Copyright © 2015 bob. All rights reserved.
//

import UIKit

enum PYDropMenuState{
    case Open
    case Close
    
    mutating func toggle(){
        if self == Open {
            self = Close
        }else {
            self = Open
        }
    }
}

protocol PYDropMenuProtocal:class{
    func triggerDropDown(state st:PYDropMenuState);
}

class PYDMConfiguration{
    var dropMenuTitles: [String]!
    
    var menuTitle: String!
    var menuIcon: UIImage!
    
    private let themeColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
    
    var dropMenuBgColor: UIColor!
    var tableCellBgColor: UIColor!
    var tableHeaderColor: UIColor!
    
    init(){
        self.initializeDefault()
    }
    
    func initializeDefault(){
        dropMenuTitles = ["Most Popular", "Latest", "Trending", "Nearest", "Top Pick"]
        
        menuTitle = dropMenuTitles[0]
        menuIcon = UIImage(named: "arrow_down")
        
        dropMenuBgColor = UIColor.lightGrayColor()
        tableCellBgColor = themeColor
        tableHeaderColor = themeColor
    }
}

class PYNaviMenuView : UIView {
    
    var menuLabel: UILabel!
    var menuImgView: UIImageView!
    
    var menuState: PYDropMenuState
    
    var configuration: PYDMConfiguration
    
    weak var delegate:PYDropMenuProtocal!
    
    init?(_ aDecoder: NSCoder? = nil, config:PYDMConfiguration) {
        
        self.configuration = config
        self.menuState = .Close
        
        if let coder = aDecoder {
            super.init(coder: coder)
        }else{
            super.init(frame: CGRectZero)
        }
        
        self.initializeView()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("shouldn't be called")
    }

    func initializeView(){
        menuLabel = UILabel()
        menuImgView = UIImageView()
        
        self.userInteractionEnabled = true
        
        menuLabel.backgroundColor = UIColor.clearColor()
        menuLabel.textColor = UIColor.whiteColor()
        menuLabel.font = UIFont.boldSystemFontOfSize(15)
        menuLabel.userInteractionEnabled = true
        self.addSubview(menuLabel)
        
        menuImgView.backgroundColor = UIColor.clearColor()
        menuImgView.userInteractionEnabled = true
        self.addSubview(menuImgView)
        
        menuLabel.text = self.configuration.menuTitle
        menuImgView.image = self.configuration.menuIcon
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapNaviTitleView")
        self.addGestureRecognizer(tapGesture)
        
        self.updateConstraints()
    }
    
    override func updateConstraints() {
        
        menuLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.snp_leading)
            make.trailing.equalTo(self.snp_trailing)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_bottom)
        }
        
        /*
        menuImgView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.menuLabel.snp_trailing).offset(10)
            make.trailing.equalTo(self.snp_trailing)
            make.bottom.equalTo(self.menuLabel.snp_baseline)
        }
        */
        
        super.updateConstraints()
    }
    
    func tapNaviTitleView(){

        print("tapNaviTitleView")
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.menuImgView.transform = CGAffineTransformRotate(self.menuImgView.transform, CGFloat(M_PI))
        }
        
        self.menuState.toggle()
        self.delegate.triggerDropDown(state: self.menuState)
    }
}

class PYDropMenu: NSObject, PYDropMenuProtocal, UITableViewDelegate, UITableViewDataSource{
    private let cellIdentifier = "Cell"
    private let headerHeight = 300
    
    private var wrapperView: UIView!
    private var backgroundView: UIView!
    
    var menuView: PYNaviMenuView!
    var dropMenuTV: UITableView!
    
    var configuration:PYDMConfiguration
    unowned var controller: UIViewController
    
    init(controller:UIViewController, config: PYDMConfiguration) {
        self.controller = controller
        self.configuration = config
        
        assert(controller.navigationController != nil)
        
        super.init()
        
        self.initializeMenuView(config)
        self.initializeDropMenuView(config)
        
    }
    
    //initialize menu
    func initializeMenuView(config:PYDMConfiguration){
        menuView = PYNaviMenuView(config: config)
        menuView.delegate = self
        
        let size = menuView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        
        menuView.frame = CGRectMake(0, 0, size.width, size.height)
        controller.navigationController?.navigationItem.titleView = menuView
        
    }
    
    func initializeDropMenuView(config:PYDMConfiguration){
        let view = self.controller.view
        
        wrapperView = UIView()
        wrapperView.backgroundColor = UIColor.clearColor()
        view.addSubview(wrapperView)
        
        wrapperView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom)
            make.leading.trailing.equalTo(view)
            make.top.equalTo(CGRectGetMaxY(self.controller.navigationController!.navigationBar.frame))
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
        dropMenuTV = UITableView()
        dropMenuTV.registerClass(UITableViewCell.self, forCellReuseIdentifier:cellIdentifier)
        dropMenuTV.separatorStyle = .SingleLine
        dropMenuTV.tableFooterView = UIView()
        
        let headerView = UIView(frame: CGRectMake(0, 0, 0, 300))
        headerView.backgroundColor = self.configuration.tableHeaderColor
        dropMenuTV.tableHeaderView = headerView
        dropMenuTV.backgroundColor = UIColor.clearColor()
        
        dropMenuTV.delegate = self
        dropMenuTV.dataSource = self
        
        self.wrapperView.addSubview(dropMenuTV)
    
        dropMenuTV.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(self.wrapperView)
            make.top.equalTo(self.wrapperView).offset(-self.configuration.dropMenuTitles.count*44-headerHeight)
            make.bottom.equalTo(self.wrapperView.snp_bottom)
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return configuration.dropMenuTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = configuration.tableCellBgColor
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(14)
        
        cell.textLabel?.text = configuration.dropMenuTitles[indexPath.row]
        
        return cell
    }
    
    func triggerDropDown(state state:PYDropMenuState){
        
        //self.dropMenuTV.reloadData()
        //self.dropMenuTV.layoutIfNeeded()
        
        self.dropMenuTV.snp_updateConstraints { (make) -> Void in
            if state == .Close {
                make.top.equalTo(self.wrapperView.snp_top).offset(-self.configuration.dropMenuTitles.count*44-self.headerHeight)
                make.bottom.equalTo(self.wrapperView.snp_bottom)
            }else{
                make.top.equalTo(self.wrapperView.snp_top).offset(-self.headerHeight)
                make.bottom.equalTo(self.wrapperView.snp_bottom)
            }
            
        }
        
        UIView.animateWithDuration(0.7, delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 15,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                self.dropMenuTV.layoutIfNeeded()
            }, completion: { (finish) -> Void in
                
            }
        )
    }
    
}

class PYDropMenuViewController: UIViewController{
    let themeColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
    var dropMenu : PYDropMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barTintColor = themeColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
     
        dropMenu = PYDropMenu(controller: self, config: PYDMConfiguration())
        
    }
}










