//
//  HappinessViewController.swift
//  Happiness
//
//  Created by exialym on 15/8/18.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceDataSource{//4、在这里声明实现协议，将自己作为代理
    
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{//didset会在IOS初始化时设置faceView这个变量时执行，恰巧就是我们需要的时机
            faceView.dataSource = self //6、最后通过拖拽方法从StroyBoard里拖进来一个Faceview，来实现一个指向faceview的指针,并将其dataSource指向自己来完成一个代理
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))//设置手势变化时执行操作的类和方法，方法一般需要将手势传进去以获得手势的状态，属性值和方法等，这时需要加上：
        }
    }
    
    private struct Constant {
        static let HappinessGestureScale: CGFloat =  4
    }
    
    @IBAction func ChangeHappiness(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constant.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                sender.setTranslation(CGPointZero, inView: faceView)
            }
        default : break
        }
    }
    var happiness: Int = 100 {//0 sad-100happy这相当于Model层
        didSet{
            happiness = min(max(happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()//在每次模型出现变动时调用重绘
        }
    }
    func updateUI() {
        faceView.setNeedsDisplay()
    }
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50//5、实现协议的方法，为View解释Model层
    }
}