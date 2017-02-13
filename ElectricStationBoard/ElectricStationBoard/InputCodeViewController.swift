//
//  InputCodeViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/6/6.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit

class InputCodeViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.setTextFieldAndButton();
//        if self.navigationController == nil {
//            self.backBt();
//        }
        
        

        
    }

    func setTextFieldAndButton() ->Void {
        
        let codeTF = UITextField();
        codeTF.placeholder = "请输入充电桩编码";
        codeTF.frame = CGRect(x: 50, y: 100, width: 250, height: 40);
        codeTF.borderStyle = .roundedRect;
        self.view.addSubview(codeTF);
        
        let btn = UIButton(type: .system);
        btn.frame = CGRect(x: 100, y: 150, width: 80, height: 30);
        btn.setTitle("确定", for: UIControlState());
        btn.setTitleColor(UIColor.white, for: UIControlState());
        btn.backgroundColor = UIColor.orange;
        btn.layer.cornerRadius = 8.0;
        btn.addTarget(self, action: #selector(InputCodeViewController.sureBt), for: .touchUpInside);
        self.view.addSubview(btn);
        
    }
    
  
    //点击确定按钮触发的方法
    func sureBt() ->Void {
        
        let vc = InChargingViewController()
        self.navigationController?.pushViewController(vc, animated: true);
        //self.presentViewController(vc, animated: true, completion: nil);
        
    }
    
//    func backBt() ->Void {
//        let btn = UIButton();
//        btn.frame = CGRectMake(200, 150, 80, 30);
//        btn.backgroundColor = UIColor.orangeColor();
//        btn.setTitle("返回", forState: .Normal);
//        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal);
//        btn.layer.cornerRadius = 8.0;
//        btn.addTarget(self, action: #selector(InputCodeViewController.goBack), forControlEvents: .TouchUpInside);
//        self.view.addSubview(btn);
//    }
    
//    func goBack() ->Void {
//        dismissViewControllerAnimated(true, completion: nil);
//    }
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
