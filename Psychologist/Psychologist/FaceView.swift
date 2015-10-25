//
//  FaceView.swift
//  Happiness
//
//  Created by exialym on 15/8/18.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

protocol FaceDataSource : class{
    func smilinessForFaceView(sender:FaceView) -> Double?//1、将自己为参数传入Controller请求一个数据，Controller会实现这个方法
}

@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }//使用Property observer，当有人重心设置了线宽就调用函数重绘
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    var  faceCenter: CGPoint {
        //return center不能直接写center在这里center是这个UIView的父节点的中心坐标
        return convertPoint(center, fromView: superview)//将处于superview坐标系中的center转化到我现在的UIView的坐标系中
    }
    var faceRadius: CGFloat {
        return min(bounds.size.height, bounds.size.width)/2*scale
    }
    
    weak var dataSource: FaceDataSource?
    //2、设置一个公有变量为协议的类型，Controller将把自己设置成这个dataSource，这就造成了一个问题：dataSource指向Controller，而在视图层次上我们还有一个由Controller指向FaceView的指针
    //这样就两个类就互相指向了对方，这时系统的自动引用计数就没用了，这样它们在内存中永远不会被释放，这是不可以的。加上weak关键字就意味着这个指针指向的东西不能一直留在内存中，这样两个就都可以被释放了
    //不过这就又有一个问题了，weak只能修饰class（当然也只有class是在内存里的）不能修饰结构体和枚举，这样在协议的定义阶段加上只能由类实现就对了
    
    func scale(gesture: UIPinchGestureRecognizer){//缩放手势的实现函数
        if gesture.state == .Changed { //获得手势的状态来做相应的改变
            scale *= gesture.scale //获得手势的各种属性和方法
            gesture.scale = 1
        }
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeseparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3//定义常量建议这样定义
    }
    
    private enum Eye {case Left,Right}
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath{
        let eyeRadius = faceRadius/Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius/Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius/Scaling.FaceRadiusToEyeseparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation/2
        case .Right: eyeCenter.x += eyeHorizontalSeparation/2
        }
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    private func bezierPathForSmile(fractionOfSmile: Double) ->UIBezierPath {
        let mouthWidth = faceRadius/Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius/Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius/Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfSmile,1),-1)) * mouthHeight
        let start = CGPoint(x: faceCenter.x - mouthWidth/2, y:faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth/3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth/3, y: cp1.y)
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)//注意CGFloat类型转换
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0 //3、使用代理传回来的数据，??的作用是当其左侧的表达式返回nil时使用右边的值
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }


}
