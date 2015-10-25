//
//  EditViewController.swift
//  Trax
//
//  Created by exialym on 15/8/31.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit
import MobileCoreServices
import MapKit

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate{

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    
    @IBOutlet weak var imageViewContenter: UIView! {
        didSet{
            imageViewContenter.addSubview(imageView)
        }
    }
    
    var mainView: ViewController?
    
    @IBAction func deletePoint(sender: UIButton) {
        if let navCon = presentingViewController as? UINavigationController {
            if let mainView = navCon.topViewController as? ViewController {
                mainView.savePoints.removeValueForKey(pointEditable!.name)
                mainView.mapView.removeAnnotation(pointEditable!)
            }
        }
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func takePic() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            //picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            picker.allowsEditing = true
            //picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    
    //UIImagePickerController的代理方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        imageView.image = image
        makeRoomForImage()
        savePointImage()
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //储存照片的方法
    func savePointImage() {
        if let image = imageView.image {
            if let imageData = UIImageJPEGRepresentation(image, 0) {
                //获取fileManager
                let fileManager = NSFileManager()
                //得到根目录URL
                if let docsDir = (fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first)! as? NSURL {
                    //通过唯一的时间来得到唯一的文件名
                    let uniqueFileName = NSDate.timeIntervalSinceReferenceDate()
                    //在根URL后添加文件相对路径
                    let url = docsDir.URLByAppendingPathComponent("\(uniqueFileName).jpg")
                    //写数据到这个URL，atomically的意思是原子性：写入文件后，将原文件替换，再删除原文件，这样保证文件系统里的文件都是完整的
                    if imageData.writeToURL(url, atomically: true) {
                        pointEditable?.smallImageURL = url
                        pointEditable?.bigImageURL = url
                        pointEditable?.path = "\(uniqueFileName).jpg"
                        mainView!.savePoints.updateValue(mainView!.change(pointEditable!), forKey: pointEditable!.name)
                    }
                }
            }
        }
    }
    
    
    @IBAction func done(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var ntfObserver: NSObjectProtocol?
    var itfObserver: NSObjectProtocol?
    
    var pointEditable: EditablePoint? {
        didSet{
            updateUI()
        }
    }

    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        infoTextField.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        ntfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: nameTextField, queue: queue) { (NSNotification) -> Void in
            if let point = self.pointEditable {
                point.title = self.nameTextField.text
                self.mainView!.savePoints.updateValue(self.mainView!.change(point), forKey: point.name)
            }
        }
        itfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: infoTextField, queue: queue) { (NSNotification) -> Void in
            if let point = self.pointEditable {
                point.subtitle = self.infoTextField.text
                self.mainView!.savePoints.updateValue(self.mainView!.change(point), forKey: point.name)
            }
        }
        mainView = (presentingViewController as? UINavigationController)?.topViewController as? ViewController
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let ob = ntfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(ob)
        }
        if let ob = itfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(ob)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
    
    
    func updateUI() {
        nameTextField?.text = pointEditable?.title
        infoTextField?.text = pointEditable?.subtitle
        updateImage() 
    }
}


extension EditViewController {
    func updateImage() {
        if let url = pointEditable?.bigImageURL {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)){ [weak self] in
                if let imageData = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if url == self?.pointEditable?.bigImageURL {
                            if let image = UIImage(data: imageData) {
                                self?.imageView.image = image
                                self?.makeRoomForImage()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if imageView.image?.aspectRatio > 0 {
            if let width = imageView.superview?.frame.size.width {
                let height = width / imageView.image!.aspectRatio
                extraHeight = height - imageView.frame.height
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -imageView.frame.height
            imageView.frame = CGRectZero
        }
        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}































