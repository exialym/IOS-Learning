//
//  SettingTableViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/5/23.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
//var titleArr = ["关于我们","用户协议","新功能引导","意见反馈","注销登录"];
    //退出按钮
//    var bt = UIButton();
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false;
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        footerView.backgroundColor = UIColor.black
        (view as? UITableView)?.tableFooterView = footerView

//        bt = UIButton(type: .System);
//        bt.backgroundColor = UIColor.orangeColor();
//        bt.titleLabel?.text = "注销";
//        bt.titleLabel?.textColor = UIColor.whiteColor();
//        bt.addTarget(self, action: #selector(SettingTableViewController.logout), forControlEvents: .TouchUpInside);
//        
//        bt.frame = CGRectMake(180, 400, 80, 50);
//        self.view.addSubview(bt);

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//        return 1;
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return titleArr.count;
//    }
//
//   
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("setreuse", forIndexPath: indexPath)
//
//        cell.textLabel?.text = titleArr[indexPath.row];
//
//        return cell
//    }
   
    //注销
    func logout() ->Void {
        let userDefault = UserDefaults.standard;
        userDefault.removeObject(forKey: "name");
        userDefault.removeObject(forKey: "password");
        userDefault.synchronize();
        self.dismiss(animated: true, completion: nil);
        //跳转到之前页面
        let story = UIStoryboard(name: "Main", bundle: nil);
        let vc3 = story.instantiateViewController(withIdentifier: "me");
        self.show(vc3, sender: self);
        print("注销成功");
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
