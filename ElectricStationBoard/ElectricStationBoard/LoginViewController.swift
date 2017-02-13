//
//  LoginViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/5/17.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var teleTF: UITextField!
    
    @IBOutlet weak var testTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false;
    }

  //登录按钮方法
    @IBAction func loginBT(_ sender: AnyObject) {
        print("登录成功");
        //假设验证码为1234
        let verifyNo = 1234;
        //获取用户输入的信息
        let userName = teleTF.text;
        let password = testTF.text;
        //对用户信息进行验证
        if Int(password!) == verifyNo {
            //获取userDefaults
            let userDefault = UserDefaults.standard;
            //登录成功后将用户名和密码存到userdefault
            userDefault.set(userName, forKey: "name");
            userDefault.set(password, forKey: "password");
            userDefault.synchronize();
            //跳转到之前页面
            let story = UIStoryboard(name: "Main", bundle: nil);
            let vc3 = story.instantiateViewController(withIdentifier: "me");
            self.show(vc3, sender: self);
            
            
        }else {
            let failAlert = UIAlertView(title: "您输入的验证码有误", message: nil, delegate: self, cancelButtonTitle: "取消");
            failAlert.show();
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
