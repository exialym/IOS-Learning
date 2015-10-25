//
//  BouncerBehavior.swift
//  Bouncer
//
//  Created by exialym on 15/8/29.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class BouncerBehavior: UIDynamicBehavior {
    lazy var collider: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    
    let gravity = UIGravityBehavior()
    var snap: UISnapBehavior!
    
    
    lazy var blockBehavior: UIDynamicItemBehavior = {
        let item = UIDynamicItemBehavior()
        item.elasticity = 0.8//CGFloat(NSUserDefaults.standardUserDefaults().doubleForKey("my.Elasticity"))不知为什么获取不到默认值，只有在设置里修改后才读得到
        item.resistance = 0
        item.friction = 0
        NSNotificationCenter.defaultCenter().addObserverForName(NSUserDefaultsDidChangeNotification, object: nil, queue: nil)
            { (NSNotification) -> Void in
            item.elasticity = CGFloat(NSUserDefaults.standardUserDefaults().doubleForKey("my.Elasticity"))
        }
        return item
        }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(blockBehavior)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func addBlock(block: UIView){
        dynamicAnimator?.referenceView?.addSubview(block)
        gravity.addItem(block)
        collider.addItem(block)
        blockBehavior.addItem(block)
    }
    
    func removeBlock(block: UIView){
        gravity.removeItem(block)
        collider.removeItem(block)
        blockBehavior.removeItem(block)
        block.removeFromSuperview()
    }
    func fixBlock(block: UIView, point: CGPoint){
        snap = UISnapBehavior(item: block, snapToPoint: point)
        dynamicAnimator?.addBehavior(snap)
    }
    func releaseBlock(){
        dynamicAnimator?.removeBehavior(snap)
    }
}
