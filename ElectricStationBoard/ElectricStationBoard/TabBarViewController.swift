//
//  TabBarViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/5/16.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    //显示页面前判断用户是否是登录状态,来判断第二个页面显示谁

  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setAllTabBarItem();


    }

  
    
    func setAllTabBarItem() ->Void {
        setEachTabBarItem(self.viewControllers![0])
        setEachTabBarItem(self.viewControllers![1])
        setEachTabBarItem(self.viewControllers![2])
        
    }
    
    func setEachTabBarItem(_ vc:UIViewController){
        var img = UIImage(named: "tab_pile_nor.png");
        var imgSelected = UIImage(named: "tab_pile_press.png");
        switch vc.childViewControllers[0] {
        case is ViewController:
            img = UIImage(named: "tab_pile_nor.png");
            imgSelected = UIImage(named: "tab_pile_press.png");
        case is ChargingViewController:
            img = UIImage(named: "tab_charging_nor.png");
            imgSelected = UIImage(named: "tab_charging_press.png");
        case is MeViewController:
            img = UIImage(named: "tab_me_nor.png");
            imgSelected = UIImage(named: "tab_me_press.png");
        case is ChargingLoginViewController:
            img = UIImage(named: "tab_charging_nor.png");
        default:break;
        }
        
        img = img!.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        
        imgSelected = imgSelected!.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
        vc.tabBarItem.image = img;
        vc.tabBarItem.selectedImage = imgSelected;
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.gray], for: UIControlState());
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .selected);
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
