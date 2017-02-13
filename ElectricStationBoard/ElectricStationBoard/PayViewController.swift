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

        self.navigationController?.isNavigationBarHidden = false;
        self.view.backgroundColor = UIColor.white;
        
    }

    //tableView
    
  func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "reuseID");
    if cell == nil {
        
        cell = UITableViewCell(style: .default, reuseIdentifier: "reuseID");
    }
    let image = UIImage(named: "logo_alipay@2x.png");
        cell!.imageView?.image = image;
        cell!.isUserInteractionEnabled = true;
        
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
