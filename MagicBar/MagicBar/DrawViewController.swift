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
    @IBAction func back(_ sender: UIButton) {
        centralManager?.cancelPeripheralConnection(connectedDevice!)
    }
    @IBAction func perview(_ sender: UIButton) {
        drawView.setWord(wordConvert.drawString(textMsg.text ?? ""))
    }
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBAction func turnGrid(_ sender: UIButton) {
        if drawView.isGrid {
            drawView.isGrid = false
            sender.setTitle("Grid:Off", for: UIControlState())
        } else {
            drawView.isGrid = true
            sender.setTitle("Grid:On", for: UIControlState())
        }
    }
    @IBAction func greenButton(_ sender: UIButton) {
        drawView.setColors(0b00000010)
    }
    @IBAction func pinkButton(_ sender: UIButton) {
        drawView.setColors(0b00010000)
    }
    @IBAction func whiteButton(_ sender: UIButton) {
        drawView.setColors(0b00100000)
    }
    @IBAction func cyanButton(_ sender: UIButton) {
        drawView.setColors(0b01000000)
    }
    @IBAction func blueButton(_ sender: UIButton) {
        drawView.setColors(0b00000001)
    }
    @IBAction func redButton(_ sender: UIButton) {
        drawView.setColors(0b00000100)
    }
    @IBAction func yellowButton(_ sender: UIButton) {
        drawView.setColors(0b00001000)
    }
    @IBAction func changeToImage1(_ sender: UIButton) {
        drawView.saveToDataArray(1)
        setButtonBorder(sender)
    }
    
    @IBAction func changeToImage2(_ sender: UIButton) {
        drawView.saveToDataArray(2)
        setButtonBorder(sender)
    }
    
    @IBAction func changeToImage3(_ sender: UIButton) {
        drawView.saveToDataArray(3)
        setButtonBorder(sender)
    }
    
    @IBAction func changeToImage4(_ sender: UIButton) {
        drawView.saveToDataArray(4)
        setButtonBorder(sender)
    }
    
    
    @IBAction func sendData(_ sender: UIButton) {
        let dataValue = drawView.sendData()
        for data in dataValue {
            self.connectedDevice?.writeValue(data as Data, for: writeCharacterisitic!, type: CBCharacteristicWriteType.withResponse)
        }
    }
    @IBAction func clean(_ sender: UIButton) {
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
        NotificationCenter.default.addObserver(self, selector: #selector(DrawViewController.keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DrawViewController.keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func setButtonBorder(_ thisButton:UIButton){
        button1.layer.borderWidth = 0
        button2.layer.borderWidth = 0
        button3.layer.borderWidth = 0
        button4.layer.borderWidth = 0
        thisButton.layer.borderWidth = 1
        thisButton.layer.cornerRadius = 5.0
        thisButton.layer.borderColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.00).cgColor
    }

    func keyboardWillAppear(_ notification: Notification) {
        let keyBoardFrame = (notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]
        let keBoardHeight = (keyBoardFrame as AnyObject).cgRectValue.height
        self.view.bounds.origin.y = keBoardHeight
    }
    func keyboardWillDisappear(_ notification: Notification) {
        self.view.bounds.origin.y = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        drawView.setWord(wordConvert.drawString(textMsg.text ?? ""))
        textField.resignFirstResponder()
        self.view.bounds.origin.y = 0
        return true
    }
}
