//
//  MainViewController.swift
//  MagicBox
//
//  Created by 🦁️ on 15/12/27.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    let ma = ConfigManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        ma.parserJsonData("")
        ma.refreshConfigurePlist()
        loadAllViewController()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadAllViewController(){
        let boxPlazaViewController = UIStoryboard(name: "BoxPlaza", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let myBoxViewController = UIStoryboard(name: "MyBox", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let boxInfoViewController = UIStoryboard(name: "BoxInfo", bundle: nil).instantiateInitialViewController() as! UINavigationController
        boxInfoViewController.tabBarItem.image = UIImage(named: "BoxInfo")
        boxInfoViewController.tabBarItem.selectedImage = UIImage(named: "BoxInfo")
        boxInfoViewController.tabBarItem.title = "About"
        myBoxViewController.tabBarItem.image = UIImage(named: "MyBox")
        myBoxViewController.tabBarItem.selectedImage = UIImage(named: "MyBox")
        myBoxViewController.tabBarItem.title = "My Box"
        boxPlazaViewController.tabBarItem.image = UIImage(named: "BoxPlaza")
        boxPlazaViewController.tabBarItem.selectedImage = UIImage(named: "BoxPlaza")
        boxPlazaViewController.tabBarItem.title = "Box Plaza"
        let tabBarViewController = [boxPlazaViewController,myBoxViewController,boxInfoViewController]
        self.setViewControllers(tabBarViewController, animated: true)
        self.selectedIndex = 1
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
