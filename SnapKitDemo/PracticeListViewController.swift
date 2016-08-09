//
//  PracticeListViewController.swift
//  SnapKitDemo
//
//  Created by bob on 12/30/15.
//  Copyright © 2015 bob. All rights reserved.
//

import UIKit

class PracticeListViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    let practiceListTV : UITableView
    let controllerList : [UIViewController.Type]
    
    init?(_ aDecoder: NSCoder? = nil) {
        
        practiceListTV = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        controllerList = [ViewController.self, WHEqualViewController.self,
                          RWAutoLayoutViewController.self, RWGalleryViewController.self,
                          PYDropMenuViewController.self, AnimationsViewController.self,
                          AnimationExplainedViewController.self, ClockAnimationViewController.self,
                          UIKitDynamicsViewController.self, UserGuideViewController.self,
                          SpringAnimationViewController.self, NeedsDisplayForKeyViewController.self,
                          GradientViewController.self, SearchBarViewController.self,
                          IntrinsicContentViewController.self, TagViewController.self, DrawViewController.self,
                          ImageBlendViewController.self, ReplicateViewController.self]
        
        if let coder = aDecoder {
            super.init(coder: coder)
        }else{
            super.init(nibName: nil, bundle: nil)
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        practiceListTV.backgroundView = nil
        practiceListTV.delegate = self
        practiceListTV.dataSource = self
        
        self.view.addSubview(practiceListTV)
        
        self.practiceListTV.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        
        let group = dispatch_group_create()
        
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            print("enter first dispatch")
            NSThread.sleepForTimeInterval(5.0)
            print("do some long running task")
        }
        
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            print("enter second dispatch")
            NSThread.sleepForTimeInterval(2.0)
            print("do some short running task")
        }
        
        let localQueue = dispatch_queue_create("LocalQueue", DISPATCH_QUEUE_CONCURRENT)
        dispatch_group_notify(group, localQueue) { () -> Void in
            print("Hello dispatch group queue")
        }
        
        print("check to see continue")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        let classFullName: String = NSStringFromClass(self.controllerList[indexPath.row])
        cell.textLabel?.text = NSURL(fileURLWithPath: classFullName).pathExtension
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        var controller: UIViewController? = nil
        
        //http://swifter.tips/self-anyclass/
        let controllerClass = self.controllerList[indexPath.row]
        controller = controllerClass.init()
        
        /*
        if indexPath.row == 0{
            controller = ViewController()
        }else if indexPath.row == 1{
            controller = WHEqualViewController()
        }else if indexPath.row == 2{
            controller = RWAutoLayoutViewController()
        }else if indexPath.row == 3 {
            controller = RWGalleryViewController()
        }else if indexPath.row == 4 {
            controller = PYDropMenuViewController()
        }else if indexPath.row == 5 {
            controller = AnimationsViewController()
        }else if indexPath.row == 6 {
            controller = AnimationExplainedViewController()
        }else if indexPath.row == 7 {
            controller = ClockAnimationViewController()
        }else if indexPath.row == 8 {
            controller = UIKitDynamicsViewController()
        }else if indexPath.row == 9 {
            controller = UserGuideViewController()
        }else if indexPath.row == 10 {
            controller = SpringAnimationViewController()
        }else if indexPath.row == 11 {
            controller = NeedsDisplayForKeyViewController()
        }else if indexPath.row == 12 {
            controller = GradientViewController()
        }else if indexPath.row == 13 {
            controller = SearchBarViewController()
        }
        */
        
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}













