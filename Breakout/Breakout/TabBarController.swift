//
//  TabBarController.swift
//  Breakout
//
//  Created by 🦁️ on 16/2/18.
//  Copyright © 2016年 exialym. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers![0].tabBarItem.title = "Game"
        //self.viewControllers[0].tabBarItem.image =
        self.viewControllers![1].tabBarItem.title = "Settings"
        //self.viewControllers[0].tabBarItem.image =
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
