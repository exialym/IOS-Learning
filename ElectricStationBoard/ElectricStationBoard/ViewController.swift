//
//  ViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/5/13.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        appdelegate.vc1 = self;
        
        //设置tabBarItem
        //self.setTabBarItem();
      

    }

   
    //设置tabBarItem方法
    func setTabBarItem() -> Void {
        var img1 = UIImage(named: "tab_pile_nor.png");
        img1 = img1!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        var  img2 = UIImage(named: "tab_pile_press.png");
        img2 = img2!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        self.navigationController?.tabBarItem.image = img1;
        self.navigationController?.tabBarItem.selectedImage = img2;
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.grayColor()], forState: .Normal);
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orangeColor()], forState: .Selected);
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

