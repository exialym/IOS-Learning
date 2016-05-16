//
//  ChargingViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/5/13.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit

class ChargingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        appdelegate.vc2 = self;
        //self.setTabBarItem();

        
    }
    
    
    //设置tabBarItem方法
    func setTabBarItem() -> Void {
        var img3 = UIImage(named: "tab_charging_nor.png");
        img3 = img3!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        var img4 = UIImage(named: "tab_charging_press.png");
        img4 = img4!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        self.navigationController?.tabBarItem.image = img3;
        self.navigationController?.tabBarItem.selectedImage = img4;
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.grayColor()], forState: .Normal);
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orangeColor()], forState: .Selected);
        
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
