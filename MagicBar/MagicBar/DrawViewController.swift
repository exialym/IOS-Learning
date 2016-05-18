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
    var centralManager:CBCentralManager?
    var writeCharacterisitic:CBCharacteristic?
    @IBOutlet weak var textMsg: UITextField!
    @IBAction func back(sender: UIButton) {
        centralManager?.cancelPeripheralConnection(connectedDevice!)
    }
    @IBAction func perview(sender: UIButton) {
        drawView.setWord(wordConvert.drawString(textMsg.text ?? ""))
    }
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBAction func turnGrid(sender: UIButton) {
        if drawView.isGrid {
            drawView.isGrid = false
            sender.setTitle("Grid:Off", forState: UIControlState.Normal)
        } else {
            drawView.isGrid = true
            sender.setTitle("Grid:On", forState: UIControlState.Normal)
        }
    }
    @IBAction func greenButton(sender: UIButton) {
        drawView.setColors(0b00000010)
    }
    @IBAction func pinkButton(sender: UIButton) {
        drawView.setColors(0b00010000)
    }
    @IBAction func whiteButton(sender: UIButton) {
        drawView.setColors(0b00100000)
    }
    @IBAction func cyanButton(sender: UIButton) {
        drawView.setColors(0b01000000)
    }
    @IBAction func blueButton(sender: UIButton) {
        drawView.setColors(0b00000001)
    }
    @IBAction func redButton(sender: UIButton) {
        drawView.setColors(0b00000100)
    }
    @IBAction func yellowButton(sender: UIButton) {
        drawView.setColors(0b00001000)
    }
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
    
    
    @IBAction func sendData(sender: UIButton) {
        let dataValue = drawView.sendData()
        for data in dataValue {
            self.connectedDevice?.writeValue(data, forCharacteristic: writeCharacterisitic!, type: CBCharacteristicWriteType.WithResponse)
        }
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
