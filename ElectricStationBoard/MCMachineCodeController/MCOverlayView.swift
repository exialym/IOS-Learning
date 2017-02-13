//
//  MCOverlayView.swift
//  MCMachineCodeDemo
//
//  Created by 马超 on 16/5/25.
//  Copyright © 2016年 qq 714080794. All rights reserved.
//

import UIKit

enum LineType {
    case none      // none
    case `default`   // line color transition
    case lineScan  // line
    case grid      // grid style
}


enum MoveType {
    case none      // none
    case `default`   // up to down
    case upAndDown  // up and down
}

var w: CGFloat {
    get {
        let max = screenw < screenh ? screenw : screenh
        let margin: CGFloat = 60
        return max - margin * 2
    }
}
let h: CGFloat = w
let screenw: CGFloat = UIScreen.main.bounds.size.width
let screenh: CGFloat = UIScreen.main.bounds.size.height
let moveSpeed: CGFloat = 1.0

open class MCOverlayView: UIView {
    
    var scanRect: CGRect {
        get {
            return CGRect(x: (screenw - w) / 2, y: (screenw - h) / 2, width: w, height: h)
        }
    }
    
    fileprivate var lineType: LineType = LineType.default
    fileprivate var moveType: MoveType = MoveType.default
    fileprivate var lineColor: UIColor = UIColor.green
    fileprivate var tempY: CGFloat = 0
    fileprivate var lineView: UIView?
    fileprivate var displayLink: CADisplayLink?
    fileprivate var moveToEdge: Bool = false
    
    //MARK: - init
    init(lineType: LineType , moveType: MoveType, lineColor: UIColor) {
        
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        
        self.lineType = lineType
        self.moveType = moveType
        self.lineColor = lineColor
        
        setupLineView()
        startMoving()
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public method
    /**
     start to scanning
     */
    func startMoving() {
        
        switch self.lineType {
        case .default:
            if self.displayLink == nil {
                
                self.displayLink = CADisplayLink(target: self, selector: #selector(MCOverlayView.beginLineAnimation))
                self.displayLink!.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
            }
        case .lineScan:
            
            beginLineAnimation()
            
        case .grid:
            
            beginGridAnimation()
            
        default:
            break
        }
    }
    
    func stopMoving() {
        
        if self.displayLink != nil {
            
            self.displayLink?.invalidate()
            self.displayLink = nil
        }
    }
    
    /**
      begin the line animation
     */
    func beginLineAnimation() {
        
        switch self.lineType {
        case .default:
            
            var frame = self.lineView!.frame
            self.moveToEdge ? (frame.origin.y -= moveSpeed) : (frame.origin.y += moveSpeed)
            self.lineView!.frame = frame
            
            // scan line shadow
            self.lineView?.layer.shadowColor = self.lineView?.backgroundColor?.cgColor
            self.lineView?.layer.shadowOpacity = 1
            self.lineView?.layer.shadowOffset = CGSize(width: 0, height: -3)
            
            switch self.moveType {
            case .default:
                
                // reset lineView frame
                if self.lineView!.frame.origin.y - self.tempY >= h {
                    
                    resetLineViewFrameBack()
                }
             
            case .upAndDown:
                
                if self.lineView!.frame.origin.y - self.tempY >= h {
                    
                    self.moveToEdge = !self.moveToEdge
                }
                else if self.lineView!.frame.origin.y == self.tempY {
                    
                    self.moveToEdge = !self.moveToEdge
                }
            default:
                break
            }
         
        case .lineScan:
            
            lineViewMovedWithLineType(self.lineType)
            
        case .grid:
            
            break
            
        default:
            break
        }
    }
    
    func lineViewMovedWithLineType(_ lineType: LineType) {
        
        UIView.animate(withDuration: 2.0, animations: {
            
            var frame = self.lineView!.frame
            frame.origin.y += h - 2
            self.lineView!.frame = frame
            
            }, completion: { (finished) in
                
                if self.moveType == .default {
                    
                    self.resetLineViewFrameBack()
                    self.lineViewMovedWithLineType(lineType)
                }
                else {
                    
                    UIView.animate(withDuration: 2.0, delay: 0, options: UIViewAnimationOptions(), animations: { 
                        
                            self.resetLineViewFrameBack()
                        
                        }, completion: { (finished) in
                            
                             self.lineViewMovedWithLineType(lineType)
                    })
                }
        }) 
    }
    /**
     begin the grid animation
     */
    func beginGridAnimation() {
        
        let imageView = self.lineView?.subviews.first as? UIImageView
        if let imageView = imageView {
            
            UIView.animate(withDuration: 1.5, delay: 0.1, options: UIViewAnimationOptions(), animations: {
                
                imageView.transform = imageView.transform.translatedBy(x: 0, y: h)
                
                }, completion: { (finished) in
                    
                    imageView.frame = CGRect(x: 0, y: -h, width: self.lineView!.frame.size.width, height: self.lineView!.frame.size.height)
                    self.startMoving()
            })
     
        }
    }
    
    /**
     reset lineView frame back
     */
    func resetLineViewFrameBack() {
        
        var frame = self.lineView!.frame
        frame.origin.y = tempY
        self.lineView!.frame = frame
    }
    //MARK: - setup view
    func setupLineView() {
        
        if self.moveType == .none { return }
        
        self.lineView = UIView(frame: CGRect(x: (screenw - w) * 0.5, y: screenh / 3.5, width: w, height: 2))
        self.addSubview(self.lineView!)
        
        if self.lineType == .default {
            
            self.lineView!.backgroundColor = self.lineColor
            self.tempY = self.lineView!.frame.origin.y
        }
        
        if self.lineType == .lineScan {
            
            self.lineView?.backgroundColor = UIColor.clear
            self.tempY = self.lineView!.frame.origin.y
            
            let imageView = UIImageView(image: UIImage(named: "line@2x"))
            imageView.frame = CGRect(x: 0, y: 0, width: self.lineView!.frame.size.width, height: self.lineView!.frame.size.height)
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            self.lineView!.addSubview(imageView)
        }
        
        if self.lineType == .grid {
            
            self.lineView!.clipsToBounds = true
            
            // reset height
            var frame = self.lineView!.frame
            frame.size.height = h
            self.lineView!.frame = frame
            
            let imageView = UIImageView(image: UIImage(named: "scan_net@2x"))
            imageView.frame = CGRect(x: 0, y: -h, width: self.lineView!.frame.size.width, height: self.lineView!.frame.size.height)
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            self.lineView!.addSubview(imageView)
        }
        
        
        
    }
    
    //MARK: - override drawRect method
    override open func draw(_ rect: CGRect) {
       
        let originx: CGFloat = (rect.size.width - w ) / 2
        let originy: CGFloat = rect.size.height / 3.5
        let maggin: CGFloat = 15
        
        let cornerColor: UIColor = UIColor(red: 0/255.0, green: 153/255.0, blue: 204/255.0, alpha: 1.0)
        let frameColor: UIColor = UIColor.white
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.setFillColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 0.5);
        ctx?.fill(rect);
        
        // framePath
        let framePath: UIBezierPath = UIBezierPath(rect: CGRect(x: originx, y: originy, width: w, height: h))
        ctx?.addPath(framePath.cgPath)
        ctx?.setStrokeColor(frameColor.cgColor)
        ctx?.setLineWidth(0.6)
        ctx?.strokePath()
        
        // set scan rect
        ctx?.clear(CGRect(x: originx, y: originy, width: w, height: h))
        
        
        
        // left top corner
        let leftTopPath = UIBezierPath()
        leftTopPath.move(to: CGPoint(x: originx, y: originy + maggin))
        leftTopPath.addLine(to: CGPoint(x: originx, y: originy))
        leftTopPath.addLine(to: CGPoint(x: originx + maggin, y: originy))
        ctx?.addPath(leftTopPath.cgPath)
        ctx?.setStrokeColor(cornerColor.cgColor)
        ctx?.setLineWidth(1.6)
        ctx?.strokePath()
        
        // right top corner
        let rightTopPath = UIBezierPath()
        rightTopPath.move(to: CGPoint(x: originx + w - maggin, y: originy))
        rightTopPath.addLine(to: CGPoint(x: originx + w, y: originy))
        rightTopPath.addLine(to: CGPoint(x: originx + w, y: originy + maggin))
        ctx?.addPath(rightTopPath.cgPath)
        ctx?.setStrokeColor(cornerColor.cgColor)
        ctx?.setLineWidth(1.6)
        ctx?.strokePath()
        
        // left bottom corner
        let leftBottomPath = UIBezierPath()
        leftBottomPath.move(to: CGPoint(x: originx, y: originy + h - maggin))
        leftBottomPath.addLine(to: CGPoint(x: originx , y: originy + h))
        leftBottomPath.addLine(to: CGPoint(x: originx + maggin, y: originy + h))
        ctx?.addPath(leftBottomPath.cgPath)
        ctx?.setStrokeColor(cornerColor.cgColor)
        ctx?.setLineWidth(1.6)
        ctx?.strokePath()
        
        // right bottom corner
        let rightBottomPath = UIBezierPath()
        rightBottomPath.move(to: CGPoint(x: originx + w , y: originy + h - maggin))
        rightBottomPath.addLine(to: CGPoint(x: originx + w, y: originy + h))
        rightBottomPath.addLine(to: CGPoint(x: originx + w - maggin, y: originy + h))
        ctx?.addPath(rightBottomPath.cgPath)
        ctx?.setStrokeColor(cornerColor.cgColor)
        ctx?.setLineWidth(1.6)
        ctx?.strokePath()
        
        // draw title
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let attr = [NSParagraphStyleAttributeName: paragraphStyle ,
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12.0) ,
                    NSForegroundColorAttributeName: UIColor.white]
        let title = "将二维码/条码放入框内, 即可自动扫描"
            
        let size = (title as NSString).size(attributes: attr)
        
        let r = CGRect(x: 0, y: originy + h + 15, width: rect.size.width, height: size.height)
        (title as NSString).draw(in: r, withAttributes: attr)
        
        

    }
}
