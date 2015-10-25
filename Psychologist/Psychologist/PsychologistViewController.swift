//
//  ViewController.swift
//  Psychologist
//
//  Created by exialym on 15/8/20.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("nothing", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //在HappinessViewController前添加了一个NavigationController后segue指向了NavController，通过下面的方法来修复
        var dastination = segue.destinationViewController as? UIViewController
        if let navController = dastination as? UINavigationController {//这里可以获得现在View所在的navController
            dastination = navController.visibleViewController//这个方法可以获得UINavigationController中最顶层的View即可视的View
        }
        if let happinessViewController = dastination as? HappinessViewController {
            //然后再判断是哪一个id的segue
            if let identifier = segue.identifier {
                switch identifier {
                    case "sad": happinessViewController.happiness=0
//一开始执行上面被注释掉的语句会崩溃，因为将这个值赋给happiness时调用了faceView的重绘方法（faceView.setNeedsDisplay()）。
//而faceView这个OutLet是在HappinessViewController里定义的，在做这段准备时它并没有被定义。
//不过如果你将faceView放在一个Optional链里这个问题就很好解决了，当faceView为nil时，整句话不会报错，只是返回一个nil。（faceView?.setNeedsDisplay()）
                    case "meh": happinessViewController.happiness=50
                    case "happy": happinessViewController.happiness=100
                    case "nothing": happinessViewController.happiness=25
                default: break
                }
            }
        }
    }


}

