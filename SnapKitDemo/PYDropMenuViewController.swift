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
    
    mutating func toggle() -> PYDropMenuState{
        if self == Open {
            self = Close
        }else {
            self = Open
        }
        return self
    }
}

protocol PYDropMenuProtocal:class{
    func triggerDropDown(state st:PYDropMenuState)
}

public protocol PYDropMenuPickProtocal:class{
    func dropMenuPickIndex(index:Int)
}

class PYDMConfiguration{
    var dropMenuTitles: [String]!
    
    var menuTitle: String {
        get {
            return dropMenuTitles[self.currentIndex]
        }
    }
    
    var menuIcon: UIImage!
    
    private let themeColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
    
    var dropMenuBgColor: UIColor!
    var tableCellBgColor: UIColor!
    var tableHeaderColor: UIColor!
    
    var tableCellTintColor: UIColor!
    var tableCellTextColor: UIColor!
    
    var currentIndex = 0
    
    init(){
        self.initializeDefault()
    }
    
    func initializeDefault(){
        dropMenuTitles = ["Most Popular", "Latest", "Trending", "Nearest", "Top Pick"]
        
        menuIcon = UIImage(named: "arrow_down")
        
        dropMenuBgColor = UIColor.lightGrayColor()
        tableCellBgColor = themeColor
        tableHeaderColor = themeColor
        
        tableCellTintColor = UIColor.whiteColor()
        tableCellTextColor = UIColor.whiteColor()
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNaviTitleView))
        self.addGestureRecognizer(tapGesture)
        
        self.updateConstraints()
    }
    
    override func updateConstraints() {
        
        menuLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.snp_leading)
            make.centerY.equalTo(self.snp_centerY)
            
            make.top.bottom.equalTo(self)
        }
        
        menuImgView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.menuLabel.snp_trailing).offset(10)
            make.trailing.equalTo(self.snp_trailing)
            make.bottom.equalTo(self.menuLabel.snp_baseline)
        }
        
        super.updateConstraints()
    }
    
    func tapNaviTitleView(){
        
        self.delegate.triggerDropDown(state: menuState.toggle())
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        let size = self.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        self.bounds = CGRectMake(0, 0, size.width, size.height)
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
    
    weak var delegate: PYDropMenuPickProtocal!
    
    init(controller:UIViewController, config: PYDMConfiguration) {
        self.controller = controller
        self.configuration = config
        
        assert(controller.navigationController != nil)
        
        super.init()
        
        self.initializeMenuView(config)
        self.initializeDropMenuView(config)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    //fix device orientation changed, navigation height changed bug
    func orientationChanged(notify:NSNotification){
        //UIDevice.currentDevice().orientation
        wrapperView.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(CGRectGetMaxY(self.controller.navigationController!.navigationBar.frame))
        }
    }
    
    //initialize menu
    func initializeMenuView(config:PYDMConfiguration){
        menuView = PYNaviMenuView(config: config)
        menuView.delegate = self
        
        controller.navigationItem.titleView = menuView
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
        
        self.backgroundView.alpha = 0.0
        self.wrapperView.hidden = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return configuration.dropMenuTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.tintColor = configuration.tableCellTintColor
        
        if indexPath.row == configuration.currentIndex{
            cell.accessoryType = .Checkmark
        }else {
            cell.accessoryType = .None
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = configuration.tableCellBgColor
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(14)
        cell.textLabel?.textColor = configuration.tableCellTextColor
        cell.textLabel?.text = configuration.dropMenuTitles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let lightColor = configuration.tableCellBgColor.colorWithAlphaComponent(0.5)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.backgroundColor = lightColor
        
        configuration.currentIndex = indexPath.row
        dropMenuTV.reloadData()
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.triggerDropDown(state: self.menuView.menuState.toggle())
        }
        
        self.delegate.dropMenuPickIndex(indexPath.row)
    }
    
    func triggerDropDown(state state:PYDropMenuState){
        
        self.dropMenuTV.snp_updateConstraints { (make) -> Void in
            if state == .Close {
                make.top.equalTo(wrapperView.snp_top).offset(-self.configuration.dropMenuTitles.count*44-self.headerHeight)
                make.bottom.equalTo(wrapperView.snp_bottom)
            }else{
                make.top.equalTo(wrapperView.snp_top).offset(-self.headerHeight)
                make.bottom.equalTo(wrapperView.snp_bottom)
                wrapperView.hidden = false
            }
            
        }
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.menuView.menuImgView.transform = CGAffineTransformRotate(self.menuView.menuImgView.transform, CGFloat(M_PI))
        }
        
        let damping = (state == PYDropMenuState.Close) ? 1 : 0.7
        
        UIView.animateWithDuration(0.8, delay: 0,
            usingSpringWithDamping: CGFloat(damping),
            initialSpringVelocity: 15,
            options: [.CurveLinear, .AllowUserInteraction],
            animations: { () -> Void in
                self.dropMenuTV.layoutIfNeeded()
                
                if state == .Open {
                    self.backgroundView.alpha = 0.5
                }else {
                    self.backgroundView.alpha = 0
                }
            }, completion: { (finish) -> Void in
                
                if self.menuView.menuState == .Close {
                    
                    self.wrapperView.hidden = true
                }
            }
        )
        
        self.menuView.menuLabel.text = self.configuration.menuTitle
    }
    
}

class PYDropMenuViewController: UIViewController, PYDropMenuPickProtocal{
    let themeColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
    var dropMenu : PYDropMenu!
    
    var centerLabel: UILabel!
    
    var config: PYDMConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barTintColor = themeColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        config = PYDMConfiguration()
        dropMenu = PYDropMenu(controller: self, config: config)
        dropMenu.delegate = self
        
        centerLabel = UILabel()
        centerLabel.font = UIFont.boldSystemFontOfSize(23)
        centerLabel.textColor = UIColor.blackColor()
        centerLabel.backgroundColor = UIColor.clearColor()
        self.view.addSubview(centerLabel)
        
        centerLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
        }
        
        self.dropMenuPickIndex(0)
    }
    
    func dropMenuPickIndex(index: Int) {
        centerLabel.text = config.menuTitle
    }
}










