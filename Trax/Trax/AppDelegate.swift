//
//  AppDelegate.swift
//  Trax
//
//  Created by exialym on 15/8/29.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

struct GPXURL {
    static let Notification = "GPXURL Radio Station"
    static let Key = "GPX URL Key"
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: GPXURL.Notification, object: self, userInfo: [GPXURL.Key : url])
        center.postNotification(notification)
        return true
        
    }

}

