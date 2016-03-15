//
//  AppDelegate.swift
//  MultipleWindow
//
//  Created by 🦁️ on 15/12/13.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var secondWindow: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //注册屏幕连接和断开时通知对应的方法
        let notification = NSNotificationCenter.defaultCenter()
        notification.addObserver(self, selector: Selector("screenDidConnect:"), name: UIScreenDidConnectNotification, object: nil)
        notification.addObserver(self, selector: Selector("screenDidDisconnect"), name: UIScreenDidDisconnectNotification, object: nil)
        //如果刚一启动时就连接了屏幕，就开始设置屏幕
        if UIScreen.screens().count >= 2 {
            let secondScreen = UIScreen.screens()[1] as UIScreen
            self.setupScreen(secondScreen)
        }
        return true
    }
    func setupScreen(screen: UIScreen){
        if self.secondWindow != nil {
            return
        }
        self.secondWindow = UIWindow(frame: screen.bounds)
        self.secondWindow?.screen = screen
        self.secondWindow?.hidden = false
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewControllerWithIdentifier("secondWindowVC") as UIViewController
        self.secondWindow?.rootViewController = viewController
    }
    func screenDidConnect(notification: NSNotification){
        let screen = notification.object as! UIScreen
        self.setupScreen(screen)
    }
    func screenDidDisconnect(notification: NSNotification){
        let screen = notification.object as! UIScreen
        if self.secondWindow?.screen == screen {
            self.secondWindow = nil
        }
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

