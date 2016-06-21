//
//  MCMachineCodeViewController.swift
//  MCMachineCodeDemo
//
//  Created by 马超 on 16/5/25.
//  Copyright © 2016年 qq 714080794. All rights reserved.
//

import UIKit
import AVFoundation

public class MCMachineCodeViewController: UIViewController,MCPreviewViewDelegate,AVCaptureMetadataOutputObjectsDelegate {
    
    
    public var didGetMachineCode: ((code: String) -> Void)?
    //自己添加
    public var defaultDevice : AVCaptureDevice = .defaultDeviceWithMediaType(AVMediaTypeVideo);
    
    private var previewView: MCPreviewView!
    private var cameraManager: MCCameraManager!
    private var isGetCode = false
    private var lineType: LineType = LineType.Grid
    private var moveType: MoveType = MoveType.Default
    private var statusBarStyle: UIStatusBarStyle!
    
    init(lineType: LineType , moveType: MoveType) {
     
        super.init(nibName: nil, bundle: nil)
        
        self.lineType = lineType
        self.moveType = moveType
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setupNavWithIsHideNav(true)
    }

    override public func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        setupNavWithIsHideNav(false)
        
        self.cameraManager.stopSession()
        self.previewView.overlayView.stopMoving()
    }

    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.statusBarStyle = UIApplication.sharedApplication().statusBarStyle
        
        setupPreviewView()
        setupBackView()

        self.cameraManager = MCCameraManager()
        if self.cameraManager.setupSession().0{
            
            self.previewView.session = self.cameraManager.captureSession
            self.cameraManager.codeDelegate = self.previewView
            self.cameraManager.startSession()
        }
        else {
            
            print(self.cameraManager.setupSession().1?.localizedDescription)
        }
        
        let pan = UIPanGestureRecognizer()
        self.view.addGestureRecognizer(pan)
    }
    
    
    //MARK: - setup views
    // set up previewView
    func setupPreviewView() {
        
        previewView = MCPreviewView(lineType: self.lineType, moveType: self.moveType)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.delegate = self
        self.view.addSubview(previewView)
        
        let contraint1 = NSLayoutConstraint(item: previewView,
                                            attribute: NSLayoutAttribute.Left,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.Left,
                                            multiplier: 1.0,
                                            constant: 0.0)
        let contraint2 = NSLayoutConstraint(item: previewView,
                                            attribute: NSLayoutAttribute.Right,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.Right,
                                            multiplier: 1.0,
                                            constant: 0.0)
        let contraint3 = NSLayoutConstraint(item: previewView,
                                            attribute: NSLayoutAttribute.Top,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.Top,
                                            multiplier: 1.0,
                                            constant: 0.0)
        let contraint4 = NSLayoutConstraint(item: previewView,
                                            attribute: NSLayoutAttribute.Bottom,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.Bottom,
                                            multiplier: 1.0,
                                            constant: 0.0)
        self.view.addConstraints([contraint1,contraint2,contraint3,contraint4])
    }
    
    func setupBackView() {
        
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: #selector(MCMachineCodeViewController.backAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        let contraint1 = NSLayoutConstraint(item: backButton,
                                            attribute: NSLayoutAttribute.Left,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.Left,
                                            multiplier: 1.0,
                                            constant: 10.0)
        let contraint2 = NSLayoutConstraint(item: backButton,
                                            attribute: NSLayoutAttribute.Top,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.Top,
                                            multiplier: 1.0,
                                            constant: 20.0)
        let contraint3 = NSLayoutConstraint(item: backButton,
                                            attribute: NSLayoutAttribute.Width,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.NotAnAttribute,
                                            multiplier: 1.0,
                                            constant: 50.0)
        let contraint4 = NSLayoutConstraint(item: backButton,
                                            attribute: NSLayoutAttribute.Height,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.NotAnAttribute,
                                            multiplier: 1.0,
                                            constant: 50.0)
        self.view.addConstraints([contraint1,contraint2,contraint3,contraint4])
        //添加另外两个button
        let btnLight = UIButton();
        btnLight.translatesAutoresizingMaskIntoConstraints = false;
        btnLight.backgroundColor = UIColor.clearColor();
        btnLight.setTitle("开启闪光灯", forState: .Normal);
        btnLight.titleLabel?.font = UIFont.systemFontOfSize(11.0);
        btnLight.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        btnLight.addTarget(self, action: #selector(MCMachineCodeViewController.turnOnLight), forControlEvents: .TouchUpInside);
        self.view.addSubview(btnLight);
        
        let contraint5 = NSLayoutConstraint(item: btnLight, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 3.0, constant: 60.0);
        
        let contraint6 = NSLayoutConstraint(item: btnLight,
                                            attribute: NSLayoutAttribute.Top,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.Top,
                                            multiplier: 1.0,
                                            constant: 500.0)
        let contraint7 = NSLayoutConstraint(item: btnLight,
                                            attribute: NSLayoutAttribute.Width,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.NotAnAttribute,
                                            multiplier: 1.0,
                                            constant: 100)
        let contraint8 = NSLayoutConstraint(item: btnLight,
                                            attribute: NSLayoutAttribute.Height,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.NotAnAttribute,
                                            multiplier: 1.0,
                                            constant: 50.0)
        self.view.addConstraints([contraint5,contraint6,contraint7,contraint8])
        
        let btnCode = UIButton();
        btnCode.translatesAutoresizingMaskIntoConstraints = false;
        btnCode.backgroundColor = UIColor.clearColor();
        btnCode.setTitle("输入编码", forState: .Normal);
        btnCode.titleLabel?.font = UIFont.systemFontOfSize(11.0);
        btnCode.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        btnCode.addTarget(self, action: #selector(MCMachineCodeViewController.pushToPutinVC), forControlEvents: .TouchUpInside);
        self.view.addSubview(btnCode);
        
        let contraint9 = NSLayoutConstraint(item: btnCode, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 3.0, constant: 120.0);
        
        let contraint10 = NSLayoutConstraint(item: btnCode,
                                            attribute: NSLayoutAttribute.Top,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.Top,
                                            multiplier: 1.0,
                                            constant: 500.0)
        let contraint11 = NSLayoutConstraint(item: btnCode,
                                            attribute: NSLayoutAttribute.Width,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.NotAnAttribute,
                                            multiplier: 1.0,
                                            constant: 100)
        let contraint12 = NSLayoutConstraint(item: btnCode,
                                            attribute: NSLayoutAttribute.Height,
                                            relatedBy: NSLayoutRelation.Equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.NotAnAttribute,
                                            multiplier: 1.0,
                                            constant: 50.0)
        self.view.addConstraints([contraint9,contraint10,contraint11,contraint12])
    }
    
    func backAction() {
        
        if let _ = self.navigationController {
            
            self.navigationController?.popViewControllerAnimated(false)
        }
        else {
            
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    //开启闪光灯
    func turnOnLight() ->Void {
        print("开启灯光成功");
        do {
            try defaultDevice.lockForConfiguration()
            
            let current = defaultDevice.torchMode
            defaultDevice.torchMode = AVCaptureTorchMode.On == current ? .Off : .On;
            
            defaultDevice.unlockForConfiguration()
        }
        catch _ { }
    }
    
    //跳转到手动输入编码页面
    func pushToPutinVC() ->Void {
        print("跳转成功");
        let vc = InputCodeViewController()
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    func didDectectionCode(code: String) {

        if self.isGetCode {
            
            return
        }
        
        self.isGetCode = true
        
        self.cameraManager.stopSession()
        
        backAction()
        
        if let _ = self.didGetMachineCode {
            
            self.didGetMachineCode!(code: code)
        }
        // play down sound
        playSound()

    }

    func playSound() {
        
        let path = NSBundle.mainBundle().pathForResource("qrcode_found", ofType: "wav")
        
        if let path = path {
            
            var soundID: SystemSoundID = 0
            let soundURL = NSURL(fileURLWithPath: path)
            AudioServicesCreateSystemSoundID(soundURL, &soundID)
            
            AudioServicesPlayAlertSound(soundID)
        }
    
   
    }
    
    func setupNavWithIsHideNav(hideNav: Bool) {
        
        if let nav = self.navigationController {
            
            nav.navigationBar.hidden = hideNav

            UIApplication.sharedApplication().setStatusBarStyle(hideNav == true ? UIStatusBarStyle.LightContent : self.statusBarStyle, animated: false)
        }
    }
    
    
    deinit
    {
        self.cameraManager.stopSession()
    }
}
