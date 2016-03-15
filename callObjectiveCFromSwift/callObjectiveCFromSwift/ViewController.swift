//
//  ViewController.swift
//  callObjectiveCFromSwift
//
//  Created by 🦁️ on 15/12/23.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let oc = ObjecttiveC()
        oc.saySomething()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

