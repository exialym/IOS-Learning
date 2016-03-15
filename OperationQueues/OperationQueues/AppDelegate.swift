//
//  AppDelegate.swift
//  OperationQueues
//
//  Created by exialym on 15/10/22.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.backgroundTask = application.beginBackgroundTaskWithExpirationHandler({ () -> Void in
            application.endBackgroundTask(self.backgroundTask!)
        })
        let backgroundQueue = NSOperationQueue()
        let notificationUrl = NSURL(string: "http://www.feng.com")
        let notificationURLRequest = NSURLRequest(URL: notificationUrl!)
        NSURLConnection.sendAsynchronousRequest(notificationURLRequest, queue: backgroundQueue, completionHandler: { (response: NSURLResponse?, data:NSData?, error:NSError?) -> Void in
            let loadedString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Loaded:\(loadedString)")
            application.endBackgroundTask(self.backgroundTask!)
        })
//        backgroundQueue.addOperationWithBlock { () -> Void in
//            let notificationUrl = NSURL(string: "http://www.feng.com")
//            let notificationURLRequest = NSURLRequest(URL: notificationUrl!)
//            try? data = NSURLConnection.sendSynchronousRequest(notificationURLRequest, returningResponse: nil)
//            if let theData = data{
//                
//            }
//            
//        }
    }

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

