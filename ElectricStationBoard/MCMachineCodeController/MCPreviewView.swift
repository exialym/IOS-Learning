//
//  MCPreviewView.swift
//  MCMachineCodeDemo
//
//  Created by 马超 on 16/5/25.
//  Copyright © 2016年 qq 714080794. All rights reserved.
//

import UIKit
import AVFoundation

protocol MCPreviewViewDelegate : NSObjectProtocol {
    
    func didDectectionCode(_ code: String)

    
}

open class MCPreviewView: UIView,MCCodeDetectionDelegate {
    
    var codeLayers: NSMutableDictionary!
    weak var delegate: MCPreviewViewDelegate?

    
    fileprivate var lineType: LineType = LineType.grid
    fileprivate var moveType: MoveType = MoveType.default
    
    var session: AVCaptureSession {
        
        set {
            self.previewLayer.session = newValue
        }
        get {
            return self.previewLayer.session
        }
    }
    
    var overlayView: MCOverlayView!
    
    init(lineType: LineType , moveType: MoveType) {
        
        super.init(frame: CGRect.zero)
        
        self.lineType = lineType
        self.moveType = moveType
        
        configurePreviewLayer()
        setupOverlayView()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        configurePreviewLayer()
        setupOverlayView()
       
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        configurePreviewLayer()
        setupOverlayView()
    }
    
    // override return layer
    override open class var layerClass : AnyClass {
        
        return AVCaptureVideoPreviewLayer.self
    }
    
    // private layer
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer  {
        
        get {
            
            return self.layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    //MARK: - private method
    
    func setupOverlayView() {
        
        self.overlayView = MCOverlayView(lineType: self.lineType, moveType: self.moveType, lineColor: UIColor(red: 0/255.0, green: 153/255.0, blue: 204/255.0, alpha: 1.0))
        self.overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.overlayView)
        
        let contraint1 = NSLayoutConstraint(item: self.overlayView,
                                            attribute: NSLayoutAttribute.left,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self,
                                            attribute: NSLayoutAttribute.left,
                                            multiplier: 1.0,
                                            constant: 0.0)
        let contraint2 = NSLayoutConstraint(item: self.overlayView,
                                            attribute: NSLayoutAttribute.right,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self,
                                            attribute: NSLayoutAttribute.right,
                                            multiplier: 1.0,
                                            constant: 0.0)
        let contraint3 = NSLayoutConstraint(item: self.overlayView,
                                            attribute: NSLayoutAttribute.top,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self,
                                            attribute: NSLayoutAttribute.top,
                                            multiplier: 1.0,
                                            constant: 0.0)
        let contraint4 = NSLayoutConstraint(item: self.overlayView,
                                            attribute: NSLayoutAttribute.bottom,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self,
                                            attribute: NSLayoutAttribute.bottom,
                                            multiplier: 1.0,
                                            constant: 0.0)
        self.addConstraints([contraint1,contraint2,contraint3,contraint4])
        
    }
    func configurePreviewLayer() {
        
        self.codeLayers = NSMutableDictionary()
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    }
    
    // Code Detection Delegate
    func didDetectCodes(_ codes: [AnyObject]) {
        
        let trandformedCodes = transformedCodesFromCodes(codes)
        
//        let lostCodes = NSMutableArray()
        
        for code in trandformedCodes {

            if let code = (code as? AVMetadataMachineReadableCodeObject) {
                
                let path = bezierPathForCorners(code.corners as [AnyObject])
                if self.overlayView.scanRect.contains(CGPoint(x: path.bounds.origin.x + path.bounds.size.width / 2, y: path.bounds.origin.y - path.bounds.size.height / 2)) == false {
                
                    break
                }
                let stringValue = code.stringValue
               
                if self.delegate != nil {
                    
                    self.delegate!.didDectectionCode(stringValue!)
                }
                
                break
                
//                lostCodes.removeObject(stringValue)
//    
//                var layers = self.codeLayers[stringValue] as? [CAShapeLayer]
//    
//                if layers == nil {
//    
//                    layers = [makeBoundsLayer(),makeCornersLayer()]
//                    self.codeLayers[stringValue] = layers!
//                    self.previewLayer.addSublayer(layers![0])
//                    self.previewLayer.addSublayer(layers![1])
//                }
//    
//                let boundsLayer: CAShapeLayer = layers![0]
//                boundsLayer.path = bezierPathForBounds(code.bounds).CGPath
//    
//                let cornersLayer: CAShapeLayer = layers![1]
//                cornersLayer.path = bezierPathForCorners(code.corners).CGPath
//    
//                print(stringValue)
//    
//                for stringV in lostCodes {
//                    
//                    for layer in self.codeLayers[stringV as! String] as! [CALayer] {
//                        
//                        layer.removeFromSuperlayer()
//                    }
//                    
//                    self.codeLayers.removeObjectForKey(stringV)
//                }

            }
        }
        
    }
    
    // Device coordinates  ->   View coordinates
    func transformedCodesFromCodes(_ codes: [AnyObject]) -> [AnyObject] {
        
        var transformedCodes: [AnyObject] = Array()
        
        for code in codes as! [AVMetadataObject] {
            
            let transformedCode = self.previewLayer.transformedMetadataObject(for: code)
            transformedCodes.append(transformedCode!)
        }
        
        return transformedCodes
    }
    
    func bezierPathForBounds(_ bounds: CGRect) -> UIBezierPath {
        
        return UIBezierPath(rect: bounds)
    }
    
    func bezierPathForCorners(_ corners: [AnyObject]) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        for i in 0  ..< corners.count  {
            
            let point = pointForCorner(corners[i] as! NSDictionary)
            if i == 0 {
                
                path.move(to: point)
            }
            else {
                
                path.addLine(to: point)
            }
        }
        
        path.close()
        return path
    }
    
    func pointForCorner(_ corner: NSDictionary) -> CGPoint {
        
        var point = CGPoint.zero
        
        do {
            point =  CGPoint(x: corner["X"] as! CGFloat, y: corner["Y"] as! CGFloat)
        }

        return point
    }
    
    func makeBoundsLayer() -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(red: 0.95, green: 0.75, blue: 0.06, alpha: 1.0).cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 4
        return shapeLayer
    }
    
    func makeCornersLayer() -> CAShapeLayer {
        
        let conersLayer = CAShapeLayer()
        conersLayer.strokeColor = UIColor(red: 0.172, green: 0.671, blue: 0.428, alpha: 1.0).cgColor
        conersLayer.fillColor = UIColor(red: 0.190, green: 0.753, blue: 0.489, alpha: 1.0).cgColor
        conersLayer.lineWidth = 2
        return conersLayer
    }
}
