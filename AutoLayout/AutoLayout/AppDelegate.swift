//
//  AppDelegate.swift
//  AutoLayout
//
//  Created by exialym on 15/8/21.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //下载并处理一些数据，并让系统知道是否成功
        let error = true
        if error {
            completionHandler(UIBackgroundFetchResult.Failed)
            return
        }
        return
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        var backgroundTask : UIBackgroundTaskIdentifier! = nil
        //注册一个后台任务，并提供一个在时间耗尽时执行的代码块
        backgroundTask = application.beginBackgroundTaskWithExpirationHandler() {
            //在时间耗尽时调用这个代码块
            //这段代码后必须有endBackgroundTask否则应用会被终止
            application.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskInvalid
        }
        let backgroundQueue = NSOperationQueue()
        backgroundQueue.addOperationWithBlock() {
            NSLog("do somgthing")
            //有最多10分钟执行这个代码块
            //这段代码后必须有endBackgroundTask否则应用会被终止
            application.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskInvalid
        }
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

