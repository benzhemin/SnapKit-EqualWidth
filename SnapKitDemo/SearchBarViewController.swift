//
//  SearchBarViewController.swift
//  SnapKitDemo
//
//  Created by bob on 2/16/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class SearchBarViewController: UIViewController, UISearchBarDelegate {
    
    var searchBar = UISearchBar()
    
    var rightBarButtomItem: UIBarButtonItem?
    var leftBarButtonItem: UIBarButtonItem?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchPressed:")
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .Prominent
        //searchBar.showsCancelButton = true
        searchBar.translucent = true
        searchBar.placeholder = "请输入故事名"
        //searchBar.tintColor = UIColor.redColor()
        self.rightBarButtomItem = navigationItem.rightBarButtonItem
        self.leftBarButtonItem = navigationItem.leftBarButtonItem
        
    }
    
    
    func searchPressed(sender: AnyObject){
        searchBar.alpha = 0
        //navigationItem.setLeftBarButtonItem(nil, animated: true)
        navigationItem.setRightBarButtonItem(nil, animated: true)
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.titleView = searchBar
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.searchBar.alpha = 1
            }) { (finish) -> Void in
                self.searchBar.becomeFirstResponder()
        }
    }
    
    func hideSearchBar(){
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        navigationItem.setRightBarButtonItem(rightBarButtomItem, animated: true)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.navigationItem.titleView = nil
            }) { (finish) -> Void in
                self.navigationItem.setHidesBackButton(false, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
}











