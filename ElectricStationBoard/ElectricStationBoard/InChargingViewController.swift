//
//  InChargingViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/6/6.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit

class InChargingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "正在充电";
        self.view.backgroundColor = UIColor.white;
        self.percentageLabel("20%");
        self.otherLabeld("00:03:23", quantity: "5.43度", price: "1.95/度", amount: "10.00元");
        self.chargeButton();
        if self.navigationController == nil {
            self.backBt();
        }


    }

    //百分比标签
    func percentageLabel(_ percentage:String) ->Void {
        let label = UILabel();
        label.numberOfLines = 0;
        label.frame = CGRect(x: 150, y: 80, width: 80, height: 80);
        label.text = "已充\n" + percentage;
        label.textAlignment = .center;
        label.backgroundColor = UIColor.orange;
        label.textColor = UIColor.white;
        label.layer.cornerRadius = label.bounds.size.width/2;
        label.layer.masksToBounds = true;
        self.view.addSubview(label);
    }
    
    //4个标签
    func otherLabeld(_ time:String,quantity:String,price:String,amount:String) ->Void {
        
        //显示时间标签
        let timeLabel = UILabel()
        timeLabel.numberOfLines = 0;
        timeLabel.frame = CGRect(x: 40, y: 180, width: 80, height: 60);
        timeLabel.backgroundColor = UIColor.clear;
        timeLabel.text = "已充时间\n\(time)";
        timeLabel.textColor = UIColor.gray;
        self.view.addSubview(timeLabel);
        
//        var timeLabel2 = UILabel();
//        timeLabel2.frame = CGRectMake(30, 185, 80, 20);
//        timeLabel2.backgroundColor = UIColor.orangeColor();
//        timeLabel2.text = time;
//        timeLabel2.textColor = UIColor.whiteColor();
//        self.view.addSubview(timeLabel2);
        
        //显示已充度数标签
        let quantityLabel1 = UILabel();
        quantityLabel1.numberOfLines = 0;
        quantityLabel1.frame = CGRect(x: 250, y: 180, width: 80, height: 60);
        quantityLabel1.backgroundColor = UIColor.clear;
        quantityLabel1.text = "已充度数\n\(quantity)";
        quantityLabel1.textColor = UIColor.gray;
        self.view.addSubview(quantityLabel1);
        
//        var quantityLabel2 = UILabel();
//        quantityLabel2.frame = CGRectMake(250, 185, 80, 20);
//        quantityLabel2.backgroundColor = UIColor.orangeColor();
//        quantityLabel2.text = quantity;
//        quantityLabel2.textColor = UIColor.whiteColor();
//        self.view.addSubview(quantityLabel2);
        
        //显示当前单价标签
        let priceLabel1 = UILabel();
        priceLabel1.numberOfLines = 0;
        priceLabel1.frame = CGRect(x: 40, y: 250, width: 80, height: 60);
        priceLabel1.backgroundColor = UIColor.clear;
        priceLabel1.text = "当前单价\n\(price)";
        priceLabel1.textColor = UIColor.gray;
        self.view.addSubview(priceLabel1);
        
//        var priceLabel2 = UILabel();
//        priceLabel2.frame = CGRectMake(30, 235, 80, 20);
//        priceLabel2.backgroundColor = UIColor.orangeColor();
//        priceLabel2.text = price;
//        priceLabel2.textColor = UIColor.whiteColor();
//        self.view.addSubview(priceLabel2);
        
        //显示消费金额标签
        let amountLabel1 = UILabel();
        amountLabel1.numberOfLines = 0;
        amountLabel1.frame = CGRect(x: 250, y: 250, width: 80, height: 60);
        amountLabel1.backgroundColor = UIColor.clear;
        amountLabel1.text = "消费金额\n\(amount)";
        amountLabel1.textColor = UIColor.gray;
        self.view.addSubview(amountLabel1);
        
//        var amountLabel2 = UILabel();
//        amountLabel2.frame = CGRectMake(250, 235, 80, 20);
//        amountLabel2.backgroundColor = UIColor.orangeColor();
//        amountLabel2.text = amount;
//        amountLabel2.textColor = UIColor.whiteColor();
//        self.view.addSubview(amountLabel2);
        
        
    }
    
    //启动充电按钮
    func chargeButton() ->Void {
        let btn = UIButton();
        btn.frame = CGRect(x: 150, y: 330, width: 80, height: 30);
        btn.backgroundColor = UIColor.clear;
        btn.setTitle("启动充电", for: UIControlState());
        btn.setTitle("停止充电", for: .selected);
        btn.setTitleColor(UIColor.gray, for: UIControlState());
        btn.addTarget(self, action: #selector(InChargingViewController.startCharge), for: .touchUpInside);
        self.view.addSubview(btn);
    }
    
    //返回按钮
    func backBt() -> Void {
        let btn = UIButton();
        btn.frame = CGRect(x: 150, y: 370, width: 80, height: 30);
        btn.backgroundColor = UIColor.clear;
        btn.setTitleColor(UIColor.gray, for: UIControlState());
        btn.setTitle("返回", for: UIControlState());
        btn.addTarget(self, action: #selector(InChargingViewController.goBack), for: .touchUpInside);
        self.view.addSubview(btn);
    }
    
    func goBack() ->Void {
        dismiss(animated: true, completion: nil);
    }
    
    //开始充电按钮方法
    func startCharge() ->Void {
        let alert = UIAlertController(title: "开始充电", message: nil, preferredStyle: .actionSheet);
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil));
        present(alert, animated: true, completion: nil);
        
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
