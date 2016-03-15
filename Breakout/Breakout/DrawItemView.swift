//
//  DrawItemView.swift
//  Breakout
//
//  Created by 🦁️ on 16/2/18.
//  Copyright © 2016年 exialym. All rights reserved.
//

import UIKit

class DrawItemView: UIView {
    
    private var item = [String : UIBezierPath]()
    
    func setPath(name:String, path:UIBezierPath){
        item[name] = path
        setNeedsDisplay()
    }

//    override func drawRect(rect: CGRect) {
//        for (_ , path) in item {
//            
//        }
//    }
    

}
