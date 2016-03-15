//
//  ViewController.swift
//  Bouncer
//
//  Created by exialym on 15/8/29.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let bouncer = BouncerBehavior()
    lazy var animator: UIDynamicAnimator = {
        UIDynamicAnimator(referenceView: self.view)
    }()
    var redBlock: UIView?
    
    @IBAction func shortTap(sender: UITapGestureRecognizer) {
        //设置一个关键帧动画，总时间，延迟时间等
        UIView.animateKeyframesWithDuration(5.0, delay: 1, options: UIViewKeyframeAnimationOptions.LayoutSubviews, animations: { () -> Void in
            //接下来加入一个一个的关键帧即可，这里要注意，起始时间和持续时间都是之前设置的总时间的百分比
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.2, animations: { () -> Void in
                self.redBlock?.backgroundColor = UIColor.blackColor()
                self.animator.updateItemUsingCurrentState(self.redBlock!)
            })
            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.2, animations: { () -> Void in
                self.redBlock?.center = self.view.center
                self.animator.updateItemUsingCurrentState(self.redBlock!)
            })
            UIView.addKeyframeWithRelativeStartTime(0.4, relativeDuration: 0.6, animations: { () -> Void in
                let rotation = CGFloat(270 * M_PI / 180.0)
                self.redBlock?.transform = CGAffineTransformMakeRotation(rotation)
                self.animator.updateItemUsingCurrentState(self.redBlock!)
            })
            }) { (Bool) -> Void in
                //在动画全部结束时要做的事
                self.redBlock?.backgroundColor = UIColor.blueColor()
                self.animator.updateItemUsingCurrentState(self.redBlock!)
        }
    }
    @IBAction func tap(sender: UILongPressGestureRecognizer) {
        let state = sender.state
        switch state{
        case .Began:
            bouncer.fixBlock(redBlock!, point: sender.locationInView(self.view))
        case .Ended:
            bouncer.releaseBlock()
        default: break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(bouncer)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if redBlock == nil {
            redBlock = addBlock()
            redBlock?.backgroundColor = UIColor.blueColor()
            bouncer.addBlock(redBlock!)
        }
        let motionManager = AppDelegate.Motion.manager
        if motionManager.accelerometerAvailable {//检查加速度传感器是否可用
            //在新值传回来之后会在指定的队列执行下面的闭包
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue())
            { (data, error) -> Void in
                self.bouncer.gravity.gravityDirection = CGVector(dx: data!.acceleration.x, dy: -data!.acceleration.y)
            }
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.Motion.manager.stopAccelerometerUpdates()
    }
    
    struct Constants {
        static let BlockSize = CGSize(width: 40, height: 40)
    }
    
    func addBlock() -> UIView {
        let block = UIView(frame: CGRect(origin: CGPoint.zero, size: Constants.BlockSize))
        block.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(block)
        return block
    }

}

