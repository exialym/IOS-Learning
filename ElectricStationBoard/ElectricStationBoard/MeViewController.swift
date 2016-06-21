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
    @IBOutlet weak var nameLabel: UILabel!

    
    @IBOutlet var photoTapRecognizer: UITapGestureRecognizer!
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true;
        //判断用户是否登录
        let userDefault = NSUserDefaults.standardUserDefaults();
        let name = userDefault.objectForKey("name");
        //用户登录后
        if name !== nil {
            //更改用户名称
            self.showUserName();
            photoTapRecognizer.addTarget(self, action: #selector(MeViewController.editAlert));
            self.photoSet("login_logo@2x.png");
            
            
            
        }else{
            photoTapRecognizer.addTarget(self, action: #selector(MeViewController.pushLoginVC));
            self.photoSet("me_avatar@2x.png");
        }
        
        

        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true;

        
    }
    

    
    //头像未登录
    func photoSet(imageName:String) ->UIImageView {
        
        var img = UIImage(named: imageName);
    
        //用设置圆角的方法设置圆形
        photo.backgroundColor = UIColor.whiteColor();
        photo.layer.cornerRadius = CGRectGetHeight(photo.bounds)/2;
        //设置photo的外围原框
        photo.layer.masksToBounds = true;
        photo.layer.borderColor = UIColor.grayColor().CGColor;
        photo.image = img;
        return photo;
        
    }
    //显示用户名称
    func showUserName() ->Void {
        let userDefault = NSUserDefaults.standardUserDefaults();
        let name = userDefault.objectForKey("name");
        if name !== nil {
        nameLabel.text = String(name!);
        }else{
            nameLabel.text = "登录/注册";
        }
    }

//    //用户登录后,点击头像编辑头像
//    func editPhoto() ->Void {
//        photo.userInteractionEnabled = true;
//        photo.targetForAction(#selector(MeViewController.editAlert), withSender: self);
//    }
    //编辑头像
    func editAlert() ->Void {
        let alert = UIAlertView.init(title: "从照片中选择", message: "拍照上传", delegate: self, cancelButtonTitle: "取消");
        alert.show();
    }
    
    func pushLoginVC() ->Void {
   
        self.performSegueWithIdentifier("toLogin", sender: self);
    }
    //注销登录
    @IBAction func logout(sender: AnyObject) {
        let userDefault = NSUserDefaults.standardUserDefaults();
        userDefault.removeObjectForKey("name");
        userDefault.removeObjectForKey("password");
        userDefault.synchronize();
        let alert = UIAlertView.init(title: "注销登录", message: "确认退出?", delegate: self, cancelButtonTitle: "确定");
        alert.show();
        
        
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
    
    //选择tableview cell跳转相应界面
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //判断用户是否登录
        let userDefault = NSUserDefaults.standardUserDefaults();
        let name = userDefault.objectForKey("name");
        if name != nil {
        //已有用户登录情况
        switch indexPath.row {
            
        case 0:
            self.performSegueWithIdentifier("pay", sender: self);
        case 1:
            self.performSegueWithIdentifier("collection", sender: self);
        case 2:
            self.performSegueWithIdentifier("record", sender: self);
        case 3:
            self.performSegueWithIdentifier("setting", sender: self);
        default:
            break;
        }
        }else {
            //未有用户登录情况
            switch indexPath.row {
                
            case 0:
                self.performSegueWithIdentifier("toLogin", sender: self);
            case 1:
                self.performSegueWithIdentifier("toLogin", sender: self);
            case 2:
                self.performSegueWithIdentifier("toLogin", sender: self);
            case 3:
                self.performSegueWithIdentifier("toLogin", sender: self);
            default:
                break;
            }
            
        }
        
        
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
