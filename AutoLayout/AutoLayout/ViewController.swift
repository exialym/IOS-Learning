//
//  ViewController.swift
//  AutoLayout
//
//  Created by exialym on 15/8/21.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
  
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var passwordLable: UILabel!
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var companyLable: UILabel!

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var lastLogin: UILabel!
    
    var aspect: NSLayoutConstraint? {
        didSet{
            if let newConstraint = aspect {
                view.addConstraint(newConstraint)
            }
        }
        willSet{
            if let existingConstraint = aspect {
                view.removeConstraint(existingConstraint)
            }
        }
    }
    var imageSize: UIImage? {
        get{
            return image.image
        }
        set{
            image.image = newValue
            if let constrainedView = image {
                if let newImage = newValue {
                    aspect = NSLayoutConstraint(
                        item: constrainedView,//目标View
                        attribute: .Width,//目标属性
                        relatedBy: .Equal,//目标属性与参考值的关系
                        toItem: constrainedView,//参考View
                        attribute: .Height,//参考属性
                        multiplier: newImage.aspectRatio,//乘的倍数
                        constant: 0)//加的常量
                }else{
                    aspect=nil
                }
            }
        }
    }
    
    @IBAction func Sec() {
        secure = !secure
    }
    
    var loginTime: NSDate?
    
    @IBAction func login() {
        loggedInUser = User.login(loginField.text ?? "", passwd: passwordField.text ?? "")
        if loggedInUser == nil {
            let alert = UIAlertController(title: "Login Failed", message: "Invalid Username or Password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Destructive, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            loginTime = NSDate()
            updateUI()
            loggedInUser?.lastlogin = loginTime
            
        }
    }
    
    var loggedInUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    var secure: Bool = false{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        let password = NSLocalizedString("Password",  comment: "Password")
        let securedPassword = NSLocalizedString("Secured",  comment: "Password")
        passwordField.secureTextEntry = secure
        passwordLable.text = secure ? securedPassword : password
        nameLable.text = loggedInUser?.name
        companyLable.text = loggedInUser?.company
        imageSize = loggedInUser?.image
        if let lastLoginTime = loggedInUser?.lastlogin {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            let time = dateFormatter.stringFromDate(lastLoginTime)
            
            let numberFormatter = NSNumberFormatter()
            numberFormatter.maximumFractionDigits = 1
            let dayAgo = numberFormatter.stringFromNumber(-lastLoginTime.timeIntervalSinceNow/(60*60*24))
            let string = NSLocalizedString("Last Login %@ days ago at %@", comment: "")
            lastLogin.text = String.localizedStringWithFormat(string, dayAgo!, time)
        } else {
            lastLogin.text = "Not Found"
        }
    }
}
extension User{
    var image: UIImage?{
        if let image = UIImage(named: login) {
            return image
        }else{
            return nil
        }
    }
}
extension UIImage{
    var aspectRatio: CGFloat  {
        return size.height != 0 ? size.width / size.height : 0
    }
}
