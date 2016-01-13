//
//  AppDelegate.swift
//  SnapKitDemo
//
//  Created by bob on 12/21/15.
//  Copyright © 2015 bob. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var timer : NSTimer?
    //var bgTaskId : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window{
            window.backgroundColor = UIColor.whiteColor()
            
            //window.rootViewController = UINavigationController(rootViewController: ViewController()!)
            
            //window.rootViewController = UINavigationController(rootViewController: WHEqualViewController()!)
            
            //window.rootViewController = UINavigationController(rootViewController: RWAutoLayoutViewController()!)
            
            window.rootViewController = UINavigationController(rootViewController: PracticeListViewController()!)
            
            window.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //let application : UIApplication = UIApplication.sharedApplication()
        
        //print("begin ==============")
        /*
        bgTaskId = application.beginBackgroundTaskWithExpirationHandler { () -> Void in
            print("begin background ===============")
            
            print("end ===============")
            application.endBackgroundTask(self.bgTaskId)
            
        }
        */
        
        /*
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerClock", userInfo: nil, repeats: true)
        self.timer?.fire()
        */
    }

    /*
    func timerClock(){
        print("current date: \(NSDate())")
        var a = 0
        a++
        if a == 100 {
            /*
            UIApplication.sharedApplication().endBackgroundTask(bgTaskId)
            self.bgTaskId = UIBackgroundTaskInvalid
            */
        }
    }
    */
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

