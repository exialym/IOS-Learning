//
//  ViewController.swift
//  IOSSharing
//
//  Created by 🦁️ on 15/12/10.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBAction func sendNotification(sender: UIButton) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        localNotification.category = "com.bbbb.exialym"
        localNotification.alertTitle = "Oh No"
        localNotification.alertBody = "The world is in peril!"
        localNotification.applicationIconBadgeNumber = 9999
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    @IBAction func shareText(sender: AnyObject) {
        let activity = UIActivityViewController(activityItems: [self.textView.text!], applicationActivities: nil)
        //presentViewController是model的呈现一个ViewController，它有很多种呈现的方式，在iPhone上默认是覆盖整个屏幕，不用设置什么别的属性直接调用即可
        //在iPad上则默认弹出一个小框，如果引发这个弹窗的是一个BarItem，貌似也不需要设置什么，系统会自动判断弹窗应该从什么地方出现
        //但是如果是一个案件，就需要设置下面这句话了，告诉系统这个弹窗该指向哪里
        activity.popoverPresentationController?.sourceView = sender as? UIView
        self.presentViewController(activity, animated: true, completion: nil)
    }
    @IBAction func shareImage(sender: AnyObject) {
        if let image = self.imageView.image,let image2 = self.imageView2.image {
            //这里就是共享的全部过程，创建一个UIActivityViewController类，并将要共享的对象放在数组里传入
            //第二个参数，接受一个UIActivity子类的数组，当App要使用自定义的共享目标时可以使用，但是要注意，这种自定义的共享目标只能在本App内使用
            let activity = UIActivityViewController(activityItems: [image,self.textView.text!,image2], applicationActivities: nil)
            activity.popoverPresentationController?.sourceView = sender as? UIView
            self.presentViewController(activity, animated: true, completion: nil)
        } else {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        //注册通知到来时可进行的操作
        let notificationAction = UIMutableUserNotificationAction()
        notificationAction.title = "Save World"
        notificationAction.identifier = "saveWorld"
        notificationAction.activationMode = UIUserNotificationActivationMode.Foreground
        notificationAction.authenticationRequired = true
        notificationAction.destructive = false
        
        let badNotificationAction = UIMutableUserNotificationAction()
        badNotificationAction.title = "Destroy World"
        badNotificationAction.identifier = "destroyWorld"
        badNotificationAction.activationMode = UIUserNotificationActivationMode.Background
        badNotificationAction.authenticationRequired = false
        badNotificationAction.destructive = true
        
        let badbadNotificationAction = UIMutableUserNotificationAction()
        badbadNotificationAction.title = "Conquer World"
        badbadNotificationAction.identifier = "conquerWorld"
        badbadNotificationAction.activationMode = UIUserNotificationActivationMode.Background
        badbadNotificationAction.authenticationRequired = false
        badbadNotificationAction.destructive = true
        
        //这个就是通知到来时真正通知的对象，他的标示符应该和通知的一样
        let notificationCategory = UIMutableUserNotificationCategory()
        notificationCategory.identifier = "com.bbbb.exialym"
        //在空间足够时显示什么操作
        notificationCategory.setActions([notificationAction,badNotificationAction,badbadNotificationAction], forContext: UIUserNotificationActionContext.Default)
        //在空间不够时显示什么操作
        notificationCategory.setActions([notificationAction,badNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        let notificationCategories = NSSet(object: notificationCategory)
        let notificationSettingsWithAction = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: notificationCategories as? Set<UIUserNotificationCategory>)
        notificationSettingsWithAction
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettingsWithAction)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}

