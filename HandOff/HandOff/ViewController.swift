//
//  ViewController.swift
//  HandOff
//
//  Created by 🦁️ on 15/11/26.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController,NSUserActivityDelegate{

    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch3: UISwitch!
    @IBAction func switchUpdate(sender: AnyObject) {
        self.activity?.needsSave = true
    }
    func userActivityWillSave(userActivity: NSUserActivity) {
        userActivity.userInfo = activityInfoDictionary()
    }
    var activity: NSUserActivity?
    func activityInfoDictionary() -> [String:Bool] {
        return[
            "switch1":switch1.on,
            "switch2":switch2.on,
            "switch3":switch3.on,
        ]
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activity = NSUserActivity(activityType: "com.exialym.BUPT.Handoff.switchs")
        activity?.userInfo = activityInfoDictionary()
        activity?.title = "Switches"
        activity?.delegate = self
        activity?.becomeCurrent()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        activity?.invalidate()
        activity = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

