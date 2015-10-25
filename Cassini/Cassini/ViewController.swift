//
//  ViewController.swift
//  Cassini
//
//  Created by exialym on 15/8/24.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var dastination = segue.destinationViewController as? UIViewController
        if let navController = dastination as? UINavigationController {//这里可以获得现在View所在的navController
            dastination = navController.visibleViewController//这个方法可以获得UINavigationController中最顶层的View即可视的View
        }
        if let ivc = dastination as? ImageViewController {
            if let id = segue.identifier {
                switch id {
                case "pic1":
                    ivc.imageURL = URL.url1
                    ivc.title = "pic1"
                case "pic2":
                    ivc.imageURL = URL.url2
                    ivc.title = "pic2"
                case "pic3":
                    ivc.imageURL = URL.url3
                    ivc.title = "pic3"
                default: break
                    
                }
            }
        }
    }
}

