//
//  DrawViewController.swift
//  MagicBar
//
//  Created by 🦁️ on 16/4/4.
//  Copyright © 2016年 exialym. All rights reserved.
//

import UIKit
import CoreBluetooth
class DrawViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var drawView: DrawView!
    var wordConvert:WordToArray = WordToArray()
    var data:String?
    var connectedDevice:CBPeripheral?
    var writeCharacterisitic:CBCharacteristic?
    @IBOutlet weak var textMsg: UITextField!
    @IBAction func perview(sender: UIButton) {
        drawView.setWord(wordConvert.drawString(textMsg.text ?? ""))
    }
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBAction func changeToImage1(sender: UIButton) {
        drawView.saveToDataArray(1)
        setButtonBorder(sender)
    }
    
    @IBAction func changeToImage2(sender: UIButton) {
        drawView.saveToDataArray(2)
        setButtonBorder(sender)
    }
    
    @IBAction func changeToImage3(sender: UIButton) {
        drawView.saveToDataArray(3)
        setButtonBorder(sender)
    }
    
    @IBAction func changeToImage4(sender: UIButton) {
        drawView.saveToDataArray(4)
        setButtonBorder(sender)
    }
    
    @IBAction func changeToImage5(sender: UIButton) {
        drawView.saveToDataArray(5)
        setButtonBorder(sender)
    }
    
    @IBAction func sendData(sender: UIButton) {
        let dataValue: NSData = textMsg.text!.dataUsingEncoding(NSUTF8StringEncoding)!
        print(writeCharacterisitic)
        print(drawView.blockArray.map({ (row:[BlockView?]) -> [Int] in
            return row.map({ (block:BlockView?) -> Int in
                return (block?.ischoosed)!
            })
        }))
        self.connectedDevice?.writeValue(dataValue, forCharacteristic: writeCharacterisitic!, type: CBCharacteristicWriteType.WithResponse)
    }
    @IBAction func clean(sender: UIButton) {
        for row in drawView.blockArray {
            for item in row {
                item?.ischoosed = 0
            }
        }
        drawView.redraw()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textMsg.delegate = self
        textMsg.text = data
        print("qqqqqqqqq\(data)")
        setButtonBorder(button1)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DrawViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DrawViewController.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    func setButtonBorder(thisButton:UIButton){
        button1.layer.borderWidth = 0
        button2.layer.borderWidth = 0
        button3.layer.borderWidth = 0
        button4.layer.borderWidth = 0
        button5.layer.borderWidth = 0
        thisButton.layer.borderWidth = 1
        thisButton.layer.cornerRadius = 5.0
        thisButton.layer.borderColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.00).CGColor
    }

    func keyboardWillAppear(notification: NSNotification) {
        let keyBoardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        let keBoardHeight = keyBoardFrame?.CGRectValue.height
        self.view.bounds.origin.y = keBoardHeight!
    }
    func keyboardWillDisappear(notification: NSNotification) {
        self.view.bounds.origin.y = 0
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        drawView.setWord(wordConvert.drawString(textMsg.text ?? ""))
        textField.resignFirstResponder()
        self.view.bounds.origin.y = 0
        return true
    }
}
