//
//  PayViewController.swift
//  ElectricStationBoard
//
//  Created by Galaxy on 16/5/18.
//  Copyright © 2016年 Iris. All rights reserved.
//

import UIKit

class PayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

 
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false;
        self.view.backgroundColor = UIColor.whiteColor();
        
    }

    //tableView
    
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("reuseID");
    if cell == nil {
        
        cell = UITableViewCell(style: .Default, reuseIdentifier: "reuseID");
    }
    let image = UIImage(named: "logo_alipay@2x.png");
        cell!.imageView?.image = image;
        cell!.userInteractionEnabled = true;
        
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
