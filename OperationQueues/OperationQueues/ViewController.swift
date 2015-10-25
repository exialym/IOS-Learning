//
//  ViewController.swift
//  OperationQueues
//
//  Created by exialym on 15/10/22.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit
//在stroyBoard中通过拖拽使这个ViewController成为tableView的dataSource和delegate
class ViewController: UIViewController {
    let hosts = ["feng.com","apple.com/cn"]
    let queue = NSOperationQueue()
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FaviconCell") as! FaviconTableViewCell
        let host = hosts[indexPath.row]
        let url = NSURL(string: "http://\(host)/favicon.ico")
        cell.operationQueue = queue
        cell.url = url
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

