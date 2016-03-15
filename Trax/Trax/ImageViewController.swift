//
//  ImageViewController.swift
//  Cassini
//
//  Created by exialym on 15/8/24.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController ,UIScrollViewDelegate{
    
    
    //Action Sheets,Alert
    var alert = UIAlertController(title: "What Do You Want To Do?", message: "choose An Option", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    var popAlert = UIAlertController(title: "Password Required", message: "Please Enter Your PassWord", preferredStyle: UIAlertControllerStyle.Alert)
    
    var imageURL: NSURL? {
        didSet{
            image = nil
            //如果当前页面不处于屏幕上则不会获取图片
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage(){
        if let url = imageURL {
            spinner?.startAnimating()
            //self.image = UIImage(named: "1")
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                            //self.image = UIImage(named: "1")
                            //动画相关
                            UIView.animateWithDuration(3.0,//执行时间
                                delay: 2.0,//等待时间
                                options: UIViewAnimationOptions.CurveEaseInOut,//动画效果选择
                                animations: { () -> Void in//设置你的动画
                                    //在执行这句话时这个属性立即变为0，你所看到的动画只是表象
                                    self.imageView.alpha = 0.0
                                    self.imageView.transform.tx = 20.0
                                    //self.imageView.frame.height
                                },
                                completion: { (Bool) -> Void in//动画执行完后，或被其他动画打断后执行，布尔值会告诉你是否完成这次动画
                                    if Bool {
                                        self.imageView.alpha = 1.0
                                        UIView.transitionWithView(self.imageView,
                                            duration: 2,
                                            options: UIViewAnimationOptions.TransitionFlipFromLeft,
                                            animations: { () -> Void in
                                                self.image = UIImage(data: imageData!)
                                            },
                                            completion: { (Bool) -> Void in
                                                
                                        })
                                    }
                            })
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var itemBitton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 5.0
        }
    }
    
    @IBAction func actionSheets(sender: UIBarButtonItem) {
        presentViewController(alert, animated: true, completion: nil)//最后一个参数是一个函数，在View弹出后调用
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    //直接从代码创建一个UIImageView
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size//这句话执行时scrollView可能还没有初始化完毕
            spinner?.stopAnimating()        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        
        alert.modalPresentationStyle = .Popover//配置alert在ipad中的样式，否则在ipad中无法显示
        let ppc = alert.popoverPresentationController
        ppc?.barButtonItem = itemBitton
        //往里添加选项
        alert.addAction(UIAlertAction(title: "buy", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
            self.presentViewController(self.popAlert, animated: true, completion: nil)//最后一个参数是一个函数，在View弹出后调用
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            //要做的操作
        })
        
        popAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            let tf = self.popAlert.textFields?.first//self.popAlert.textFields?如果有的话返回的是一个AnyObject数组
            if tf != nil {
                print("\(tf?.text)")
            }
        })
        popAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            //要做的操作
        })
        popAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Your Password"
        }
        
        //要注意必须在target初始化完成后再调用这个方法，或者你可以使用lazy关键字解决
        let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "fire:", userInfo: nil, repeats: true)
        timer.tolerance = 0.2
        
    }
    
    //Timer
    var num = true
    func fire(timer: NSTimer){
        if num {
            itemBitton?.title = "Rabbit"
        } else {
            itemBitton?.title = "Lion"
        }
        num = !num
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
        //image = UIImage(named: "1")
    }
}
