//
//  ViewController.swift
//  Trax
//
//  Created by exialym on 15/8/29.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate{

    
    @IBOutlet var mapView: MKMapView! {
        didSet {
            mapView.mapType = MKMapType.Standard
            mapView.delegate = self//设置自己为代理
        }
    }
        
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var pointName = ""
    
    var savePoints: [String:[String]] {
        get{
            let returnValue = defaults.objectForKey("point") as? [String:[String]] ?? ["":[]]
            print("\(returnValue)")
            return returnValue
            
        }
        set{
            defaults.setObject(newValue, forKey: "point")
            print("\(newValue)")
        }
    }
    
    func change(newPoint: myGPS) -> [String] {
        var tempArray = [String]()
        tempArray.append((newPoint.coordinate.latitude).description)
        tempArray.append((newPoint.coordinate.longitude).description)
        tempArray.append(newPoint.title!)
        tempArray.append(newPoint.subtitle!)
        tempArray.append(newPoint.path)
        return tempArray
    }
    
    
    
    @IBAction func addGPSPoint(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let coordinate = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
            pointName = NSDate.timeIntervalSinceReferenceDate().description
            let newPoint = EditablePoint(coorX: coordinate.latitude, coorY: coordinate.longitude, initTitle: "Title", initSubtitle: "Subtitle", url: nil, initName: pointName)
            newPoint.name = pointName
            mapView.addAnnotation(newPoint)
            savePoints.updateValue(change(newPoint), forKey: pointName)
        }
    }
    
    
    var myGPSs: [MKAnnotation] = [myGPS(coorX: 39.9170529046423, coorY: 116.397189269045, initTitle: "故宫博物院", initSubtitle: "Center Of China",url: NSURL(string: "http://farm1.staticflickr.com/315/20118461406_da4008efa0_c.jpg"),initName: "Fixed")
            ]
    
    
    //定制Annotation的弹出框样式
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        //先看看是否有可以复用的View
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("wayPoint")
        if view == nil {
            //如果没有则新建一个，注意ID是要一样的
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "wayPoint")
            view!.canShowCallout = true
        } else {
            //如果有可以复用的，则直接使用
            view!.annotation = annotation
        }
        
        view!.draggable = annotation is EditablePoint
        
        //定制左右View
        view!.leftCalloutAccessoryView = nil
        view!.rightCalloutAccessoryView = nil
        if let gps = annotation as? myGPS {
            if gps.smallImageURL != nil {
                view!.leftCalloutAccessoryView = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 59, height: 59)))
            }
            if annotation is EditablePoint {
                view!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            }
        }
        return view
    }
    
    //左View是一个图片，不需要在annotation设置时就载入图片，在某一个被选中时加载即可
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let gps = view.annotation as? myGPS {
            if gps.smallImageURL != nil {
                view.leftCalloutAccessoryView = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 59, height: 59)))
            }
            if let littleImageButton = view.leftCalloutAccessoryView as? UIButton {
                //if littleImageButton.imageView != nil {
                    if let url = gps.smallImageURL {
                        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                            if let imageData = NSData(contentsOfURL: url) {
                                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                    //异步加载时一定要检查是否返回的是之前请求的资源
                                    let a = (view.annotation as! myGPS).smallImageURL
                                    if url == a {
                                        if let image = UIImage(data: imageData) {
                                            littleImageButton.setImage(image, forState: .Normal)
                                        }
                                    }
                                }
                            }
                        }
                    }
                //}这里应该判断UIButton的背景真的变了才可以加载，要不浪费流量，但还不知道怎么做
            }
        }
    }
    
    
    
    //这里是弹出框点击事件，执行了一个Segue
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control as? UIButton)?.buttonType == UIButtonType.DetailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: true)
            performSegueWithIdentifier("editView", sender: view)
        } else if let _ = view.annotation as? myGPS {
            performSegueWithIdentifier("showBigImage", sender: view)
        }
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBigImage" {
            if let gps = (sender as? MKPinAnnotationView)?.annotation as? myGPS {
                if let ivc = segue.destinationViewController.contentViewController as? PointImageViewController {
                        ivc.GPSPoint = gps
                }
            }
        } else if segue.identifier == "editView" {
            if let gps = (sender as? MKPinAnnotationView)?.annotation as? EditablePoint {
                if let evc = segue.destinationViewController.contentViewController as? EditViewController {
                    if let ppc = evc.popoverPresentationController {
                        //获得坐标并转换
                        let coordinatePoint = mapView.convertCoordinate(gps.coordinate, toPointToView: mapView)
                        //设置popover的弹出源
                        ppc.sourceRect = (sender as! MKAnnotationView).popoverSourceRectForCoordiantePoint(coordinatePoint)
                        //获取pop出来的View的最小大小
                        let miniSize = evc.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                        //设置其大小合适
                        evc.preferredContentSize = CGSize(width: 320, height: miniSize.height)
                        //将本类设置为代理，来实现更多的控制
                        ppc.delegate = self
                    }
                    evc.pointEditable = gps
                }
            }
        }
    }
    
    //popoverPresentationController代理方法
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.OverFullScreen
    }
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navcon = UINavigationController(rootViewController: controller.presentedViewController)
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        visualEffectView.frame = navcon.view.bounds
        navcon.view.insertSubview(visualEffectView, atIndex: 0)
        return navcon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savePoints.removeValueForKey("")
        let fileManager = NSFileManager()
        let url = (fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first)! as! NSURL
        for (key , pointArray) in savePoints {
            if pointArray.count == 5 {
                if let x = NSNumberFormatter().numberFromString(pointArray[0])?.doubleValue {
                    if let y = NSNumberFormatter().numberFromString(pointArray[1])?.doubleValue {
                        if pointArray[4] == "" {
                            let new = EditablePoint(coorX: x, coorY: y, initTitle: pointArray[2], initSubtitle: pointArray[3], url: nil, initName: key)
                            myGPSs.append(new)
                        } else {
                            let allURL = url.URLByAppendingPathComponent(pointArray[4])
                            let new = EditablePoint(coorX: x, coorY: y, initTitle: pointArray[2], initSubtitle: pointArray[3], url: allURL, initName: key)
                            myGPSs.append(new)
                        }
                    }
                }
            }
        }
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        center.addObserverForName(GPXURL.Notification, object: appDelegate, queue: queue) { notification in
            if let url = notification.userInfo?[GPXURL.Key] as? NSURL {  //在这个字典里的值都是AnyObject
                print("\(url)")
            }
        }
        mapView.addAnnotations(myGPSs)
        mapView.showAnnotations(myGPSs, animated: true)
    }
    
}

extension UIViewController {
    var contentViewController: UIViewController{
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController!
        } else {
            return self
        }
    }
}

extension MKAnnotationView{
    func popoverSourceRectForCoordiantePoint(coordinate: CGPoint) -> CGRect{
        var center = coordinate
        center.x -= frame.width / 2 - centerOffset.x - calloutOffset.x
        center.y -= frame.height / 2 - centerOffset.y - calloutOffset.y
        return CGRect(origin: center, size: frame.size)
    }
}


