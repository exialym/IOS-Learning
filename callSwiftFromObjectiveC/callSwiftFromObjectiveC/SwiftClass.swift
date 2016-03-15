//
//  SwiftClass.swift
//  callSwiftFromObjectiveC
//
//  Created by 🦁️ on 15/12/23.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

public class SwiftClass: NSObject {
    override init() {
        NSLog("创建Swift实例")
    }
    public func sayHello(){
        NSLog("Hello")
    }
}
