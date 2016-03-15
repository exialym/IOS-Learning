//
//  ViewController.swift
//  Earthquake
//
//  Created by 🦁️ on 15/12/26.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let manager = AFHTTPSessionManager()
        let url = "http://comcat.cr.usgs.gov/fdsnws/event/1/query"
        let parameters = ["format":"geojson","format":"geojson","format":"geojson","format":"geojson","format":"geojson"]
        manager.GET(url, parameters: parameters, progress: nil, success: { (task:NSURLSessionDataTask, result:AnyObject?) -> Void in
            //解析数据
            }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
                //错误处理
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

