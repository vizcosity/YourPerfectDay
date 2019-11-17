//
//  AppDelegate.swift
//  Benson
//
//  Created by Aaron Baw on 18/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit
import Alamofire

struct Colour {
    static var primary: UIColor = #colorLiteral(red: 0.9471271634, green: 0.8354215026, blue: 1, alpha: 1)
    static var secondary: UIColor = #colorLiteral(red: 0.6681160927, green: 0.5804412365, blue: 0.7499276996, alpha: 1)
    static var darkText: UIColor = #colorLiteral(red: 0.5621231198, green: 0.4875727296, blue: 0.60321486, alpha: 1)
    static var gradientOne: UIColor = #colorLiteral(red: 0.2296182215, green: 0.0797938332, blue: 0.2422780991, alpha: 1)
    static var gradientTwo: UIColor = #colorLiteral(red: 0.01777612977, green: 0.06035795063, blue: 0.151725024, alpha: 1)
    static var selectedButtonText: UIColor = #colorLiteral(red: 0.1964504421, green: 0.171156913, blue: 0.233199805, alpha: 1)
}

struct Constants {
    static var horizontalButtonMargin: CGFloat = 35
    static var buttonEdgeInsets: CGFloat = 5
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

