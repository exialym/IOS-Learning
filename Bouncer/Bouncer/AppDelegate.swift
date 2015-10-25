//
//  AppDelegate.swift
//  Bouncer
//
//  Created by exialym on 15/8/29.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    struct Motion {
        static let manager = CMMotionManager()
    }

}

