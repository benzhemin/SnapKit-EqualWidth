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
    let controllerList : [NSObject.Type]
    
    init?(_ aDecoder: NSCoder? = nil) {
        
        practiceListTV = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        controllerList = [ViewController.self, WHEqualViewController.self,
                          RWAutoLayoutViewController.self, RWGalleryViewController.self]
        
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
        var controller : UIViewController?
        if indexPath.row == 0{
            controller = ViewController()
        }else if indexPath.row == 1{
            controller = WHEqualViewController()
        }else if indexPath.row == 2{
            controller = RWAutoLayoutViewController()
        }else if indexPath.row == 3 {
            controller = RWGalleryViewController()
        }
        
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}
