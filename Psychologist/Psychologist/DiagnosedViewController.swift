//
//  DiagnosedViewController.swift
//  Psychologist
//
//  Created by exialym on 15/8/20.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit
//这个类继承自HappinessViewController，继承了所有属性和方法，在StoryBoard中即便把笑脸所在的View引到这个类也完全没有问题
class DiagnosedViewController : HappinessViewController, UIPopoverPresentationControllerDelegate{
    //var diagnosticHistory = [Int]()  当每次点击master中的按钮时，右边的ditial都会重新创建。
    //如果只是这样写这个变量，那么这个变量每次都会被初始化，这个历史纪录并不能纪录什么
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory: [Int] {
        get{
            return defaults.objectForKey("History") as? [Int] ?? []
        }
        set{
            defaults.setObject(newValue, forKey: "History")
        }
    }
    override var happiness: Int{//这里复写变量的didSet方法并不会覆盖父类里的
        didSet{
            diagnosticHistory += [happiness]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            switch id {
            case "Show History":
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default: break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
