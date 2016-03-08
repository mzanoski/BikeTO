//
//  AppDelegate.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-16.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController: DataController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UITabBar.appearance().backgroundImage = Utilities.imageFromColor(ApplicationSettings.Settings.theme["baseColor"] as! UIColor, forSize: CGSizeMake(UIScreen.mainScreen().bounds.width, 44))
        UITabBar.appearance().tintColor = UIColor.redColor()
        UITableView.appearance().backgroundColor = ApplicationSettings.Settings.theme["tableViewBackground"] as! UIColor
        
        self.dataController = DataController()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // TODO: load data mofo!
        
    }
}

