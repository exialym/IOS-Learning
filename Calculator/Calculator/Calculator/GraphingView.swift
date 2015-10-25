//
//  GraphingView.swift
//  Calculator
//
//  Created by exialym on 15/9/27.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

protocol GraphingData : class{
    func findYForX(x: Float) -> Float?
    func clearM()
}
@IBDesignable
class GraphingView: UIView{
    var axesDrawer = AxesDrawer()
    
    @IBInspectable
    var lineWidth: CGFloat = 3 {
        didSet {//使用Property observer，当有人重心设置了线宽就调用函数重绘
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var color: UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var scale: CGFloat = 1 {
        didSet {
            pointNum *= scale
            setNeedsDisplay()
        }
    }
    
    var pointNum:CGFloat = 50
    weak var y :GraphingData?
    
    var delta = CGPoint(x: 0, y: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    var maxAndMin = "MinY is: 0;MaxY is: 0"
    
    override func drawRect(rect: CGRect) {
        var max: Float = -Float.infinity
        var min: Float = Float.infinity
        var myCenter = CGPoint(x: self.bounds.midX + delta.x, y: self.bounds.midY + delta.y)
        axesDrawer.drawAxesInRect(self.bounds, origin: myCenter, pointsPerUnit: pointNum)
        let path = UIBezierPath()
        
        func convertedFormulaXFromViewX(vx: CGFloat) -> Float {
            return Float((vx - myCenter.x) / pointNum)
        }
        func convertedFormulaYFromViewY(vy: CGFloat) -> Float {
            return Float((-vy + myCenter.y) / pointNum)
        }
        func convertedViewXFromFormulaX(fx: Float) -> CGFloat {
            return CGFloat(fx) * pointNum + myCenter.x
        }
        func convertedViewYFromFormulaY(fy: Float) -> CGFloat {
            return CGFloat(-fy) * pointNum + myCenter.y
        }
        func getDrawingPointForHorizontalPosition(px: CGFloat) -> CGPoint {
            let fx = convertedFormulaXFromViewX(px)
            if let fy = y?.findYForX(fx) {
                if fy > max {
                    max = fy
                }
                if fy < min {
                    min = fy
                }
                let py = convertedViewYFromFormulaY(fy)
                return CGPointMake(px, py)
            }
            return myCenter
        }
        
        var p = getDrawingPointForHorizontalPosition(0.0)
        path.moveToPoint(p)
        for var px: CGFloat = 0.0; px <= bounds.size.width; px += (1.0/contentScaleFactor) {
            p = getDrawingPointForHorizontalPosition(px)
            path.addLineToPoint(p)
        }
        maxAndMin = "MinY is: \(min)\nMaxY is: \(max)"
        UIColor.blueColor().set()
        path.lineWidth = 1.0
        path.stroke()
        y?.clearM()
    }
    
}
