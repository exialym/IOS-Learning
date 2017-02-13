//
//  MCMachineCodeViewController.swift
//  MCMachineCodeDemo
//
//  Created by 马超 on 16/5/25.
//  Copyright © 2016年 qq 714080794. All rights reserved.
//

import UIKit
import AVFoundation

open class MCMachineCodeViewController: UIViewController,MCPreviewViewDelegate,AVCaptureMetadataOutputObjectsDelegate {
    
    
    open var didGetMachineCode: ((_ code: String) -> Void)?
    //自己添加
    open var defaultDevice : AVCaptureDevice = .defaultDevice(withMediaType: AVMediaTypeVideo);
    
    fileprivate var previewView: MCPreviewView!
    fileprivate var cameraManager: MCCameraManager!
    fileprivate var isGetCode = false
    fileprivate var lineType: LineType = LineType.grid
    fileprivate var moveType: MoveType = MoveType.default
    fileprivate var statusBarStyle: UIStatusBarStyle!
    
    init(lineType: LineType , moveType: MoveType) {
     
        super.init(nibName: nil, bundle: nil)
        
        self.lineType = lineType
        self.moveType = moveType
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setupNavWithIsHideNav(true)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        setupNavWithIsHideNav(false)
        
        self.cameraManager.stopSession()
        self.previewView.overlayView.stopMoving()
    }

    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        self.statusBarStyle = UIApplication.shared.statusBarStyle
        
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
                                            attribute: NSLayoutAttribute.left,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.left,
                                            multiplier: 1.0,
                                            constant: 0.0)
        let contraint2 = NSLayoutConstraint(item: previewView,
                                            attribute: NSLayoutAttribute.right,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.right,
                                            multiplier: 1.0,
                                            constant: 0.0)
        let contraint3 = NSLayoutConstraint(item: previewView,
                                            attribute: NSLayoutAttribute.top,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.top,
                                            multiplier: 1.0,
                                            constant: 0.0)
        let contraint4 = NSLayoutConstraint(item: previewView,
                                            attribute: NSLayoutAttribute.bottom,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.bottom,
                                            multiplier: 1.0,
                                            constant: 0.0)
        self.view.addConstraints([contraint1,contraint2,contraint3,contraint4])
    }
    
    func setupBackView() {
        
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "back"), for: UIControlState())
        backButton.addTarget(self, action: #selector(MCMachineCodeViewController.backAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(backButton)
        
        let contraint1 = NSLayoutConstraint(item: backButton,
                                            attribute: NSLayoutAttribute.left,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.left,
                                            multiplier: 1.0,
                                            constant: 10.0)
        let contraint2 = NSLayoutConstraint(item: backButton,
                                            attribute: NSLayoutAttribute.top,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.top,
                                            multiplier: 1.0,
                                            constant: 20.0)
        let contraint3 = NSLayoutConstraint(item: backButton,
                                            attribute: NSLayoutAttribute.width,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 50.0)
        let contraint4 = NSLayoutConstraint(item: backButton,
                                            attribute: NSLayoutAttribute.height,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 50.0)
        self.view.addConstraints([contraint1,contraint2,contraint3,contraint4])
        //添加另外两个button
        let btnLight = UIButton();
        btnLight.translatesAutoresizingMaskIntoConstraints = false;
        btnLight.backgroundColor = UIColor.clear;
        btnLight.setTitle("开启闪光灯", for: UIControlState());
        btnLight.titleLabel?.font = UIFont.systemFont(ofSize: 11.0);
        btnLight.setTitleColor(UIColor.white, for: UIControlState());
        btnLight.addTarget(self, action: #selector(MCMachineCodeViewController.turnOnLight), for: .touchUpInside);
        self.view.addSubview(btnLight);
        
        let contraint5 = NSLayoutConstraint(item: btnLight, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 3.0, constant: 60.0);
        
        let contraint6 = NSLayoutConstraint(item: btnLight,
                                            attribute: NSLayoutAttribute.top,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.top,
                                            multiplier: 1.0,
                                            constant: 500.0)
        let contraint7 = NSLayoutConstraint(item: btnLight,
                                            attribute: NSLayoutAttribute.width,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 100)
        let contraint8 = NSLayoutConstraint(item: btnLight,
                                            attribute: NSLayoutAttribute.height,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 50.0)
        self.view.addConstraints([contraint5,contraint6,contraint7,contraint8])
        
        let btnCode = UIButton();
        btnCode.translatesAutoresizingMaskIntoConstraints = false;
        btnCode.backgroundColor = UIColor.clear;
        btnCode.setTitle("输入编码", for: UIControlState());
        btnCode.titleLabel?.font = UIFont.systemFont(ofSize: 11.0);
        btnCode.setTitleColor(UIColor.white, for: UIControlState());
        btnCode.addTarget(self, action: #selector(MCMachineCodeViewController.pushToPutinVC), for: .touchUpInside);
        self.view.addSubview(btnCode);
        
        let contraint9 = NSLayoutConstraint(item: btnCode, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 3.0, constant: 120.0);
        
        let contraint10 = NSLayoutConstraint(item: btnCode,
                                            attribute: NSLayoutAttribute.top,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.view,
                                            attribute: NSLayoutAttribute.top,
                                            multiplier: 1.0,
                                            constant: 500.0)
        let contraint11 = NSLayoutConstraint(item: btnCode,
                                            attribute: NSLayoutAttribute.width,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 100)
        let contraint12 = NSLayoutConstraint(item: btnCode,
                                            attribute: NSLayoutAttribute.height,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: nil,
                                            attribute: NSLayoutAttribute.notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 50.0)
        self.view.addConstraints([contraint9,contraint10,contraint11,contraint12])
    }
    
    func backAction() {
        
        if let _ = self.navigationController {
            
            self.navigationController?.popViewController(animated: false)
        }
        else {
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //开启闪光灯
    func turnOnLight() ->Void {
        print("开启灯光成功");
        do {
            try defaultDevice.lockForConfiguration()
            
            let current = defaultDevice.torchMode
            defaultDevice.torchMode = AVCaptureTorchMode.on == current ? .off : .on;
            
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
    
    func didDectectionCode(_ code: String) {

        if self.isGetCode {
            
            return
        }
        
        self.isGetCode = true
        
        self.cameraManager.stopSession()
        
        backAction()
        
        if let _ = self.didGetMachineCode {
            
            self.didGetMachineCode!(code)
        }
        // play down sound
        playSound()

    }

    func playSound() {
        
        let path = Bundle.main.path(forResource: "qrcode_found", ofType: "wav")
        
        if let path = path {
            
            var soundID: SystemSoundID = 0
            let soundURL = URL(fileURLWithPath: path)
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            
            AudioServicesPlayAlertSound(soundID)
        }
    
   
    }
    
    func setupNavWithIsHideNav(_ hideNav: Bool) {
        
        if let nav = self.navigationController {
            
            nav.navigationBar.isHidden = hideNav

            UIApplication.shared.setStatusBarStyle(hideNav == true ? UIStatusBarStyle.lightContent : self.statusBarStyle, animated: false)
        }
    }
    
    
    deinit
    {
        self.cameraManager.stopSession()
    }
}
