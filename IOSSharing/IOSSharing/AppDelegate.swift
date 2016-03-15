//
//  AppDelegate.swift
//  IOSSharing
//
//  Created by 🦁️ on 15/12/10.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if let op = launchOptions {
            if let notification = op[UIApplicationLaunchOptionsLocalNotificationKey] {
                if let myView = window?.rootViewController as? ViewController{
                    myView.label.text = "DO YOU KNOW WHAT YOU ARE DOING"
                }
            }
        }
        return true
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //当用户点击了本地通知，但没有选择操作时调用
        if let myView = window?.rootViewController as? ViewController{
            myView.label.text = "MAKE YOUR CHOICE"
        }
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        //当用户选择了对应的操作时调用
        if let myView = window?.rootViewController as? ViewController{
            if identifier == "saveWorld" {
                myView.label.text = "YOU SAVE THE WORLD"
            } else if identifier == "destroyWorld" {
                myView.label.text = "YOU DESTROY THE WORLD"
            } else if identifier == "conquerWorld" {
                myView.label.text = "YOU CONQUER THE WORLD"
            }
            notification.applicationIconBadgeNumber = 0
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        //completionHandler必须调用，当操作是在后台激活程序时，UIUserNotificationActivationMode.Background
        //应用是不能运行太长时间的，要让系统知道什么时候可以挂起你的程序
        completionHandler()
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

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

