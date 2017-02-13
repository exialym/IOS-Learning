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
        self.navigationController?.isNavigationBarHidden = false;
        
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 2;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        
        cell.imageView?.image = UIImage(named: "me_charging_list_pls@2x.png");

        //titleLabel
        titleLabel = UILabel();
        titleLabel?.frame = CGRect(x: 100, y: 3, width: 300, height: 20);
        titleLabel?.text = "4个快速充电桩,0个慢速充电桩,00:00-24:00";
        titleLabel?.font = UIFont(name: "Helvetica", size: 11);
        cell.contentView.addSubview(titleLabel!);
        //companyLabel
        companyLabel = UILabel();
        companyLabel?.frame = CGRect(x: 130, y: 70, width: 300, height: 20);
        companyLabel?.text = "由北京电力公司运营";
        companyLabel?.textColor = UIColor.gray;
        companyLabel?.font = UIFont(name: "Helvetica", size: 11);
        cell.contentView.addSubview(companyLabel!);
        //companyImage
        companyImage = UIImageView();
        companyImage?.frame = CGRect(x: 100, y: 70, width: 18, height: 18);
        companyImage?.image = UIImage(named: "carr_guowang_hl@2x.png");
        cell.contentView.addSubview(companyImage!);

        return cell
    }
 
    //设置cell的高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0;
    }
    //设置cell的header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myView = UIView();
        myView.backgroundColor = UIColor.white;
        let label = UILabel();
        label.text = "海淀区鼎好电子商务公共充电点";
        label.font = UIFont(name: "Helvetica", size: 15);
        label.frame = CGRect(x: 10, y: 0, width: 250, height: 22);
        myView.addSubview(label);
        
        let button = UIButton(type: .system);
        button.setBackgroundImage(UIImage(named: "g_delete_nor@2x.png"), for: UIControlState());
        button.frame = CGRect(x: 340, y: 3, width: 18, height: 20);
        myView.addSubview(button);
        
        
        
        
        return myView;
        
    }
    
    //footerInSection
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 30;
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "空闲";
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myView = UIView();
        myView.backgroundColor = UIColor.init(red: 230, green: 230, blue: 230, alpha: 0);
        let image = UIImageView();
        image.frame = CGRect(x: 10, y: 6, width: 15, height: 15);
        image.image = UIImage(named: "icon_free@2x.png");
        myView.addSubview(image);
        
        let label1 = UILabel();
        label1.frame = CGRect(x: 30, y: 5, width: 40, height: 20);
        label1.text = "空闲";
        label1.font = UIFont(name: "Helvetica", size: 10);
        label1.textColor = UIColor.black;
        myView.addSubview(label1);
        
        let label2 = UILabel();
        label2.frame = CGRect(x: 250, y: 10, width: 5, height: 10);
        label2.text = "1";
        label2.font = UIFont(name: "Helvetica", size: 11);
        label2.textColor = UIColor.orange;
        myView.addSubview(label2);
        
        let label3 = UILabel();
        label3.frame = CGRect(x: 259, y: 5, width: 40, height: 20)
        label3.text = "个快桩,";
        label3.textColor = UIColor.gray;
        label3.font = UIFont(name: "Helvetica", size: 10);
        myView.addSubview(label3);
        
        let label4 = UILabel();
        label4.frame = CGRect(x: 300, y: 10, width: 5, height: 10);
        label4.text = "2";
        label4.textColor = UIColor.orange;
        label4.font = UIFont(name: "Helvetica", size: 11);
        myView.addSubview(label4);
        
        let label5 = UILabel();
        label5.frame = CGRect(x: 310, y: 10, width: 40, height: 10);
        label5.text = "个慢桩";
        label5.textColor = UIColor.gray;
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
