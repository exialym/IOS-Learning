//
//  BallBehavior.swift
//  Breakout
//
//  Created by 🦁️ on 16/2/18.
//  Copyright © 2016年 exialym. All rights reserved.
//

import UIKit

class BallBehavior: UIDynamicBehavior{
    lazy var collision:UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        //behavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        return behavior
    }()
    
    let gravity = UIGravityBehavior()
    override init() {
        super.init()
        addChildBehavior(collision)
        addChildBehavior(gravity)
        addChildBehavior(myBehavior)
    }
    
    lazy var myBehavior: UIDynamicItemBehavior = {
        let item = UIDynamicItemBehavior()
        item.elasticity = 1
        item.resistance = 0
        item.friction = 0
        item.allowsRotation = false
        return item
    }()
    
    
    func addBarrier(name : String , path : UIBezierPath) {
        collision.removeBoundaryWithIdentifier(name)
        collision.addBoundaryWithIdentifier(name, forPath: path)
    }
}
