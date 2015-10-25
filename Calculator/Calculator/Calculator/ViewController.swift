//
//  ViewController.swift
//  Calculator
//
//  Created by exialym on 15/8/14.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var sign: UIButton!
    @IBOutlet weak var graphingButton: UIBarButtonItem!
    
    var firstType: Bool = true
    var isNegative: Bool = false
    var isDotTyped: Bool = false
    
    var brain = CaluculatorBrain()
    
    func setSignButtonToPositive(){
        sign.setTitle("+", forState: UIControlState.Normal)
        sign.setTitleColor(UIColor(red: 0, green: 0, blue: 255, alpha: 1), forState: UIControlState.Normal)
        sign.backgroundColor = UIColor.whiteColor()
    }

    
    
    
    @IBAction func negativeOrPositive(sender: UIButton) {
        isNegative = !isNegative
        if isNegative {
            sender.setTitle("-", forState: UIControlState.Normal)
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            sender.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
            display.text = "-" + display.text!
        } else {
            sender.setTitle("+", forState: UIControlState.Normal)
            sender.setTitleColor(UIColor(red: 0, green: 0, blue: 255, alpha: 1), forState: UIControlState.Normal)
            sender.backgroundColor = UIColor.whiteColor()
        }
    }
    
    
    @IBAction func backSpace(sender: UIButton) {
        let num = (display.text! as NSString).length
        if num == 1 {
            display.text = "0"
            firstType = true
            isNegative = false
            isDotTyped = false
            setSignButtonToPositive()
            if let result = brain.undo() {
                displayValue = result
            }
            history.text = brain.historyDisplayString
        } else {
            display.text = (display.text! as NSString).substringToIndex(num-1)
        }
    }
    @IBAction func clear() {
        display.text = "0"
        history.text = "History"
        firstType = true
        isNegative = false
        isDotTyped = false
        setSignButtonToPositive()
        brain.reset()
    }
    
    
    @IBAction func appendDot(sender: AnyObject) {
        if !isDotTyped {
            if firstType {
                firstType = false
                display.text = "0."
            } else {
                display.text! += "."
            }
        }
        isDotTyped = true
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if firstType {
            display.text = digit
            firstType = false
        }else{
            display.text = display.text!+digit
        }
    }
    
    //var operandStack = Array<Double>()

    @IBAction func enter() {
        firstType = true
        isDotTyped = false
        if let inputValue = displayValue {
            if let result = brain.pushOperand(inputValue){
                displayValue = result
            }
        }
        else{
            displayValue = 0
        }
        //operandStack.append(displayValue)
        history.text = brain.historyDisplayString
        setSignButtonToPositive()
    }
    
    
    @IBAction func appendVariable(sender: UIButton) {
        brain.pushOperand("M")
        firstType = true
        history.text = brain.historyDisplayString
    }
    
    @IBAction func setVariable(sender: UIButton) {
        brain.isVariableSet = true
        firstType = true
        if let result = brain.setValue("M", value: displayValue) {
            displayValue = result
        }else{
            displayValue = 0
        }
    }
    
    
    var displayValue: Double? {
        get {
//            if display.text == "π" {
//                return M_PI
//            }
            if let result = NSNumberFormatter().numberFromString(display.text!) {
                return result.doubleValue
            } else {
                return nil
            }
            
//这不是一个好的判断是否有多个小数点的办法
//            let arraySplited = display.text?.componentsSeparatedByString(".")
//            if arraySplited?.count<=2 {
//                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
//            } else {
//                display.text = "0"
//                return 0
//                //这里应该有报错信息
//            }
        }
        set {
            display.text="\(newValue!)"
            firstType = true
            isDotTyped = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if !firstType{
            enter()
        }
        if let operation=sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }else{
                displayValue = 0
            }
        }
        history.text = brain.historyDisplayString
        setSignButtonToPositive()
//        switch operation{
//        case "✕" : performOperation(multiply)//这是最笨的方法
//        case "÷" : performOperation({(op1:Double,op2:Double)->Double in return op2/op1})//closure
//        case "+" : performOperation({(op1,op2) in return op1+op2}) //函数声明中有两个参数的类型，所以可以省略
//                 //performOperation({(op1,op2) in op1+op2})       //因为函数声明中有声明返回值类型，可以省略return关键字
//                 //performOperation({$0+$1})                     //你也可以不给变量命名，swift自动命名为$0,$1,$2...
//                 //performOperation() {$0+$1}          //如果你的函数是像这样有一个函数作为参数，且这个参数位于最后一个，那么可以将这个函数移到括号外面，其他参数还在括号里
//                 //performOperation {$0+$1}                  //如果只有这一个参数，那么括号也不需要了
//        case "-" : performOperation {$1-$0}
//        case "⌥" : performOperation {sqrt($0)}
//        default: break
//        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        graphingButton.title = "Graphing"
        var dastination = segue.destinationViewController as? UIViewController
        if let navController = dastination as? UINavigationController {//这里可以获得现在View所在的navController
            dastination = navController.visibleViewController//这个方法可以获得UINavigationController中最顶层的View即可视的View
        }
        if let graCon = dastination as? GraphingViewController {
            if let id = segue.identifier {
                switch id {
                    case "Graphing":
                        graCon.brain = brain
//                        if let fum = brain.display().last {
//                            graCon.graphingTitle.title = ("y = " + fum as NSString).stringByReplacingOccurrencesOfString("M", withString: "x")
//                            graCon.remebered.setObject(brain.program, forKey: "expression")
//                        }
                default: break
                }
            }
        }
        
    }
//    func performOperation(operation:(Double,Double) ->Double){
//        if operandStack.count >= 2 {
//            displayValue=operation(operandStack.removeLast(),operandStack.removeLast())
//            enter()
//        }
//    }
//    private func performOperation(operation: Double ->Double){
//        if operandStack.count >= 1 {
//            displayValue=operation(operandStack.removeLast())
//            enter()
//        }
//    }
//    func multiply(op1:Double,op2:Double)->Double{
//        return op1*op2
//    }
}

