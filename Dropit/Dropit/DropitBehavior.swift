//
//  DropitBehavior.swift
//  Dropit
//
//  Created by exialym on 15/8/27.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class DropitBehavior: UIDynamicBehavior {
    lazy var collider: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
        }()
    
    
    let gravity = UIGravityBehavior()
    
    
    
    lazy var dropBehavior: UIDynamicItemBehavior = {
        let item = UIDynamicItemBehavior()
        item.elasticity = 1
        return item
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func addDrop(drop: UIView){
        dynamicAnimator?.referenceView?.addSubview(drop)
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(drop: UIView){
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
}
