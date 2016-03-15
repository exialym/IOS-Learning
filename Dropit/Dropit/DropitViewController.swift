//
//  DropitViewController.swift
//  Dropit
//
//  Created by exialym on 15/8/27.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController, UIDynamicAnimatorDelegate{

    @IBOutlet weak var gameView: BezierPathView!
    
    
    
    //var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: gameView)
    //这句话会报错因为现在我们还处在构造这个类的过程中，在构造完成前我们不能访问属性和方法
    lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.gameView)
        animator.delegate = self
        return animator
    }()//调用animator时要注意gameView一定已经初始化好了
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompleteRow()
    }
    
    var attachment: UIAttachmentBehavior?{
        willSet{
            if attachment != nil {
                animator.removeBehavior(attachment!)
                gameView.setPath(nil, named: "attachment")
            }
        }
        didSet{
            if attachment != nil {
                animator.addBehavior(attachment!)
                attachment?.action = {[unowned self] in
                    if let attachmentView = self.attachment?.items.first as? UIView {
                        let path = UIBezierPath()
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachmentView.center)
                        self.gameView.setPath(path, named: "attachment")
                    }
                }
            }
        }
    }
    
    @IBAction func grabDrop(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(gameView)
        switch sender.state {
        case .Began:
            if let viewTo = lastDropView {
                attachment = UIAttachmentBehavior(item: viewTo, attachedToAnchor: point)
                lastDropView = nil
            }
        case .Changed:
            attachment?.anchorPoint = point
        case .Ended:
            attachment = nil
        default:  attachment = nil
        }
    }
    var lastDropView: UIView?
    
    let dropitBehavior = DropitBehavior()
    
    var dropsPerRow = 10
    var dropSize: CGSize {
        let size = gameView.bounds.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    func drop() {
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        dropitBehavior.addDrop(dropView)
        lastDropView = dropView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropitBehavior)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let barrierSize = CGSize(width: gameView.bounds.width/4, height: gameView.bounds.height/4)
        let barrierOrigin = CGPoint(x: gameView.bounds.midX - barrierSize.width/2, y: gameView.bounds.midY - barrierSize.height/2)
        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        dropitBehavior.addBarrier(path, named: "midPath")
        gameView.setPath(path, named: "midPath")
    }
    
    func removeCompleteRow(){
        var dropsToRemove = [UIView]()
        var dropFrame = CGRect(x: 0, y: gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        
        repeat {
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            var dropsFound = [UIView]()
            var rowIsComplete = true
            for _ in 0 ..< dropsPerRow {
                if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil) {
                    if hitView.superview == gameView {
                        dropsFound.append(hitView)
                    } else {
                        rowIsComplete = false
                    }
                }
                dropFrame.origin.x += dropSize.width
            }
            if rowIsComplete {
                dropsToRemove += dropsFound
            }
        } while dropsToRemove.count == 0 && dropFrame.origin.y > 0
        
        for drop in dropsToRemove {
            dropitBehavior.removeDrop(drop)
        }
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random() % 6 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.redColor()
        case 2: return UIColor.blueColor()
        case 3: return UIColor.brownColor()
        case 4: return UIColor.orangeColor()
        case 5: return UIColor.purpleColor()
        case 6: return UIColor.blackColor()
        default: return UIColor.yellowColor()
        }
    }
}