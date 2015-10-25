//
//  BezierPathView.swift
//  Dropit
//
//  Created by exialym on 15/8/27.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class BezierPathView: UIView {

    private var bezierPath = [String:UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPath[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPath {
            path.stroke()
        }
    }
   

}
