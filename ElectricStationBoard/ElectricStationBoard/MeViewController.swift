//
//  MeViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/5/13.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit


class MeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //头像
    @IBOutlet weak var photo: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true;
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        appdelegate.vc3 = self;
        
        //设置未登录时的头像
        self.photoSet("me_avatar@2x.png");
        //设置tabBarItem
        self.setTabBarItem();
        
        

        
    }
    
    //设置tabBarItem方法
    func setTabBarItem() ->Void {
        var img5 = UIImage(named: "tab_me_nor.png");
        img5 = img5!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        var img6 = UIImage(named: "tab_me_press.png");
        img6 = img6!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        print(self.navigationController)
        self.navigationController?.tabBarItem.image = img5;
        self.navigationController?.tabBarItem.selectedImage = img6;
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.grayColor()], forState: .Normal);
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orangeColor()], forState: .Selected);
        
    }
    
    //头像未登录
    func photoSet(imageName:String) ->UIImageView {
        var img = UIImage(named: imageName);
        //用设置圆角的方法设置圆形
        photo.layer.cornerRadius = CGRectGetHeight(photo.bounds)/2;
        //设置photo的外围原框
        photo.layer.masksToBounds = true;
        photo.layer.borderColor = UIColor.grayColor().CGColor;
        photo.image = img;
        return photo;
        
    }

    //设置tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseID");
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "reuseID");
        }
        //cell前面的小图片
        let img1 = UIImage(named: "me_money@2x.png");
        let img2 = UIImage(named: "me_favorite@2x.png");
        let img3 = UIImage(named: "me_record@2x.png");
        let img4 = UIImage(named: "me_setting@2x.png");
        
        var picArr = [img1!,img2!,img3!,img4!];
        cell?.imageView?.image = picArr[indexPath.row];
        //cell的标题
        let title1 = "支付方式";
        let title2 = "我的收藏";
        let title3 = "充电记录";
        let title4 = "设置";
        var titleName = [title1,title2,title3,title4];
        cell?.textLabel?.text = titleName[indexPath.row];
        cell?.accessoryType = .DisclosureIndicator;
        cell?.userInteractionEnabled = true;
        
        return cell!;
        
        
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
