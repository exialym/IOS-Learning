//
//  MyCollectionTableViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/5/18.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit

class MyCollectionTableViewController: UITableViewController {
    var titleLabel:UILabel?;
    var companyLabel:UILabel?;
    var companyImage:UIImageView?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false;
        
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return 2;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        
        cell.imageView?.image = UIImage(named: "me_charging_list_pls@2x.png");

        //titleLabel
        titleLabel = UILabel();
        titleLabel?.frame = CGRectMake(100, 3, 300, 20);
        titleLabel?.text = "4个快速充电桩,0个慢速充电桩,00:00-24:00";
        titleLabel?.font = UIFont(name: "Helvetica", size: 11);
        cell.contentView.addSubview(titleLabel!);
        //companyLabel
        companyLabel = UILabel();
        companyLabel?.frame = CGRectMake(130, 70, 300, 20);
        companyLabel?.text = "由北京电力公司运营";
        companyLabel?.textColor = UIColor.grayColor();
        companyLabel?.font = UIFont(name: "Helvetica", size: 11);
        cell.contentView.addSubview(companyLabel!);
        //companyImage
        companyImage = UIImageView();
        companyImage?.frame = CGRectMake(100, 70, 18, 18);
        companyImage?.image = UIImage(named: "carr_guowang_hl@2x.png");
        cell.contentView.addSubview(companyImage!);

        return cell
    }
 
    //设置cell的高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0;
    }
    //设置cell的header
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "海淀区鼎好电子商务公共充电点";
//        }else{
//            return nil;
//        }
//       
//    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myView = UIView();
        myView.backgroundColor = UIColor.whiteColor();
        var label = UILabel();
        label.text = "海淀区鼎好电子商务公共充电点";
        label.font = UIFont(name: "Helvetica", size: 15);
        label.frame = CGRectMake(10, 0, 250, 22);
        myView.addSubview(label);
        
        let button = UIButton(type: .System);
        button.setBackgroundImage(UIImage(named: "g_delete_nor@2x.png"), forState: .Normal);
        button.frame = CGRectMake(340, 3, 18, 20);
        myView.addSubview(button);
        
        
        
        
        return myView;
        
    }
    
    //footerInSection
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 30;
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "空闲";
    }
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myView = UIView();
        myView.backgroundColor = UIColor.init(red: 230, green: 230, blue: 230, alpha: 0);
        var image = UIImageView();
        image.frame = CGRectMake(10, 6, 15, 15);
        image.image = UIImage(named: "icon_free@2x.png");
        myView.addSubview(image);
        
        var label1 = UILabel();
        label1.frame = CGRectMake(30, 5, 40, 20);
        label1.text = "空闲";
        label1.font = UIFont(name: "Helvetica", size: 10);
        label1.textColor = UIColor.blackColor();
        myView.addSubview(label1);
        
        var label2 = UILabel();
        label2.frame = CGRectMake(250, 10, 5, 10);
        label2.text = "1";
        label2.font = UIFont(name: "Helvetica", size: 11);
        label2.textColor = UIColor.orangeColor();
        myView.addSubview(label2);
        
        var label3 = UILabel();
        label3.frame = CGRectMake(259, 5, 40, 20)
        label3.text = "个快桩,";
        label3.textColor = UIColor.grayColor();
        label3.font = UIFont(name: "Helvetica", size: 10);
        myView.addSubview(label3);
        
        var label4 = UILabel();
        label4.frame = CGRectMake(300, 10, 5, 10);
        label4.text = "2";
        label4.textColor = UIColor.orangeColor();
        label4.font = UIFont(name: "Helvetica", size: 11);
        myView.addSubview(label4);
        
        var label5 = UILabel();
        label5.frame = CGRectMake(310, 10, 40, 10);
        label5.text = "个慢桩";
        label5.textColor = UIColor.grayColor();
        label5.font = UIFont(name: "Helvetica", size: 10);
        myView.addSubview(label5);
        
        
        
       return myView;
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
