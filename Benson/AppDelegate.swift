//
//  AppDelegate.swift
//  Benson
//
//  Created by Aaron Baw on 18/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit
import SwiftUI
import Alamofire

import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var notificationCenter: UNUserNotificationCenter?
    var notifier: BensonNotifier?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("[Webserver] | Using API: \(Webserver.endpoint)")
        
        // Register notifications.
        self.notifier = BensonNotifier(alertTimes: nil, message: "It's time to checkin.")
        
        // Fetch unenriched checkins and submit pending health data.
        Fetcher.sharedInstance.fetchUnenrichedCheckinDates { (dates) in
            
            self.log("Fetched unenriched checkin dates: \(dates)")
            
            BensonHealthManager.sharedInstance?.fetchHealthData(forDays: dates, completionHandler: { (healthDataObjects) in
                self.log("Fetched \(healthDataObjects.count). Submitting these now.")

                Fetcher.sharedInstance.submitHealthDataObjects(healthDataObjects: healthDataObjects) { (result, error) in
                    self.log("Submitted all healthDataObjects. Result: \(String(describing: result)). Error: \(String(describing: error))")
                }

            })
            
        }
        
        self.log("Fetching aggregated health and checkin data.")
        Fetcher.sharedInstance.fetchAggregatedHealthAndCheckinData(byAggregationCriteria: .day) { (response) in
           
//            self.log("Fetched aggregated health data: \(response)")
            
        }
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

    private func log(_ message: String){
        print("[AppDelegate] \(message)")
    }
}

