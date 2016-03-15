//
//  ViewController.swift
//  Motion
//
//  Created by 🦁️ on 15/11/25.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit
import CoreMotion
import LocalAuthentication
class ViewController: UIViewController {

    @IBOutlet weak var XLabel: UILabel!
    @IBOutlet weak var YLabel: UILabel!
    @IBOutlet weak var ZLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var rollLabel: UILabel!
    @IBOutlet weak var yawLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var nowSteps: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBAction func printButton(sender: UIButton) {
        let printInteraction = UIPrintInteractionController.sharedPrintController()
        let labelFormatter = UISimpleTextPrintFormatter(text: self.textView.text!)
        printInteraction.printFormatter = labelFormatter
        printInteraction.presentAnimated(true) { (printController:UIPrintInteractionController, completed:Bool, error:NSError?) -> Void in
            
        }
    }
    
    var motionManager = CMMotionManager()
    let altimer = CMAltimeter()
    let pedometer = CMPedometer()
    let authenticationContext = LAContext()
    let policy = LAPolicy.DeviceOwnerAuthentication
    var error: NSError? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        let canAuthenticate = authenticationContext.canEvaluatePolicy(policy, error: &error)
        if canAuthenticate == false {
            print("can't use because:\(error)")
        }
        let authenticationReason = "You are about to See Top Secert"
        authenticationContext.evaluatePolicy(policy, localizedReason: authenticationReason) { (succeeded:Bool, error:NSError?) -> Void in
            if succeeded {
                self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (motion:CMDeviceMotion?, error:NSError?) -> Void in
                    let xString = NSString(format: "%.1f", (motion?.userAcceleration.x)!)
                    let yString = NSString(format: "%.1f", (motion?.userAcceleration.y)!)
                    let zString = NSString(format: "%.1f", (motion?.userAcceleration.z)!)
                    self.XLabel.text = xString as String
                    self.YLabel.text = yString as String
                    self.ZLabel.text = zString as String
                    let pitchDegress = (motion?.attitude.pitch)! * 180 / M_PI
                    let rollDegress = (motion?.attitude.roll)! * 180 / M_PI
                    let yawDegress = (motion?.attitude.yaw)! * 180 / M_PI
                    let pitchString = NSString(format: "%.1f", pitchDegress)
                    let rollString = NSString(format: "%.1f", rollDegress)
                    let yawString = NSString(format: "%.1f", yawDegress)
                    self.pitchLabel.text = pitchString as String
                    self.rollLabel.text = rollString as String
                    self.yawLabel.text = yawString as String
                }
                //高度计
                if CMAltimeter.isRelativeAltitudeAvailable() {
                    var currentAltitude: Float =  0.0
                    self.altimer.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data:CMAltitudeData?, error:NSError?) -> Void in
                        currentAltitude += Float((data?.relativeAltitude)!)
                        self.heightLabel.text = "\(currentAltitude)"
                    })
                }
                //计步器
                if CMPedometer.isStepCountingAvailable() {
                    let calender = NSCalendar.currentCalendar()
                    let now = NSDate()
                    let weekAgo = calender.dateByAddingUnit(NSCalendarUnit.Day, value: -6, toDate: now, options: NSCalendarOptions())
                    self.pedometer.queryPedometerDataFromDate(weekAgo!, toDate: now, withHandler: { (data:CMPedometerData?, error:NSError?) -> Void in
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            if let stepData = data{
                                self.weekLabel.text = "\(stepData.numberOfSteps)"
                            }
                        })
                    })
                    //这两个API不能同时使用
                    //            pedometer.startPedometerUpdatesFromDate(now, withHandler: { (data:CMPedometerData?, error:NSError?) -> Void in
                    //                if let stepData = data{
                    //                    self.nowSteps.text = "\(stepData.numberOfSteps)"
                    //                }
                    //            })
                }
            } else {
                print("Not authenticated!\(error)")
                //对于不同的错误可以做不同的处理
                if error?.code == LAError.UserFallback.rawValue {
                    //用户决定输入密码
                    print("请输入密码")
                }
                if error?.code == LAError.UserCancel.rawValue {
                    //用户取消
                    print("取消了就不给你看咯")
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

