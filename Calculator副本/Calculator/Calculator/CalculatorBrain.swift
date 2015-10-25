//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by exialym on 15/8/23.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import Foundation
class CaluculatorBrain {
    private enum Op: CustomStringConvertible{//这是一个协议，实现这个协议，这个协议里有一个description属性
        case Operand(Double, Int)
        case OperationFor1(String, Int, Double -> Double)
        case OperationFor2(String, Int, (Double, Double) -> Double)
        case Constant(String, Int, Double)
        case Variable(String, Int)
        var description: String {
            switch self {
            case .Operand(let operand, _):
                return "\(operand)"
            case .OperationFor1(let operation, _, _):
                return "\(operation)"
            case .OperationFor2(let operation, _, _):
                return "\(operation)"
            case .Constant(let constant, _, _):
                return "\(constant)"
            case .Variable(let variable, _):
                return "\(variable)"
            }
        }
    }
    func reset(){
        opStack = []
        VariableValues.removeAll()
    }
    
    func undo() -> Double? {
        if !opStack.isEmpty {
            opStack.removeLast()
            return evluate()
        }
        return 0
    }
    
    private var opStack = [Op]()//初始化数组
    
    private var knowOps = [String:Op]()//初始化字典
    
    private var VariableValues = [String:Double]()
    
    var isVariableSet = false
    
    init(){
        func learnOp(op: Op) {
            knowOps[op.description] = op
        }
        learnOp(Op.OperationFor2("✕", 3, *))
        learnOp(Op.OperationFor2("÷", 3){$1/$0})
        learnOp(Op.OperationFor2("+", 2, +))
        learnOp(Op.OperationFor2("-", 2){$1-$0})
        learnOp(Op.OperationFor1("√", 1, sqrt))
        learnOp(Op.OperationFor1("Sin", 1, sin))
        learnOp(Op.OperationFor1("Cos", 1, cos))
        learnOp(Op.Constant("π", 0, M_PI))
    }
    var historyDisplayString:String {
        return (display() as NSArray).componentsJoinedByString(",") + "="
    }
    var program: AnyObject{
        get{
//            var returnValue = [String]()
//            for op in opStack {
//                returnValue.append(op.description)
//            }
//            return returnValue
            return opStack.map { $0.description }//这行代替了上面所有行
        }
        set{
            if let opSymbols = newValue as? [String]{//判断返回给我的是不是String类型的数组
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let operation = knowOps[opSymbol] {
                        newOpStack.append(operation)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand, 0))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    private func display(ops:[Op]) -> (result: String?, currentPrecedence: Int, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainOps = ops
            let op = remainOps.removeLast()
            switch op {
            case .Operand(let operand, let pre):
                return (operand > 0 ? "\(operand)" : "(\(operand))", pre, remainOps)
            case .OperationFor1(let op1, let pre, _):
                let recur = display(remainOps)
                var resultString = recur.result ?? "?"
                let resultPre = recur.currentPrecedence
                
                resultString = op1 + (resultPre > 0 ? "(\(resultString))" : resultString)
                
                return (resultString, pre, recur.remainingOps)
            case .OperationFor2(let op2, let pre, _):
                let recur1 = display(remainOps)
                var resultString1 = recur1.result ?? "?"
                let pre1 = recur1.currentPrecedence
                
                let recur2 = display(recur1.remainingOps)
                var resultString2 = recur2.result ?? "?"
                let pre2 = recur2.currentPrecedence
                
                if pre1 != 0 && pre1 != 1{
                    resultString1 = "(" + resultString1 + ")"
                }
                if pre > pre2 && pre2 != 0{
                    resultString2 = "(" + resultString2 + ")"
                }
                
                let resultString = resultString2 + op2 + resultString1
                
                return (resultString, pre, recur2.remainingOps)
            case .Constant(let cons, let pre, _):
                return ("\(cons)", pre, remainOps)
            case .Variable(let variable, let pre):
                return ("\(variable)", pre, remainOps)
            }
        }
        return (nil, -1, ops)
    }
    //在函数的参数表中，变量前是默认隐含一个let的，你可以通过强制改为Var来是他变为一个变量，但并不推荐这么做
    private func evluate(ops: [Op]) -> (result: Double?, remain: [Op]) {
        if !ops.isEmpty {
            var remainOps = ops
            let op = remainOps.removeLast()
            switch op {
            case .Operand(let operand, _):
                return (operand, remainOps)
            case .OperationFor1(_, _, let operation):
                let recurEvluate = evluate(remainOps)
                if let recurOperand = recurEvluate.result {
                    return (operation(recurOperand),recurEvluate.remain)
                }
            case .OperationFor2(_, _, let operation):
                let recurEvluate = evluate(remainOps)
                if let recurOperand = recurEvluate.result {
                    let recurEvluateAgain = evluate(recurEvluate.remain)
                    if let recurOperandAgain = recurEvluateAgain.result {
                        //print("\(recurOperand);\(recurOperandAgain)")
                        return (operation(recurOperand, recurOperandAgain), recurEvluateAgain.remain)
                    }
                }
            case .Constant(_, _, let constant):
                return (constant,remainOps)
            case .Variable(let variableName, _):
                if let variableValue = VariableValues[variableName] {
                    return (variableValue, remainOps)
                }
            }
        }
        return (nil, ops)
    }
    
    func display() -> [String] {
        var history = [String]()
        var (result, _, remain) = display(opStack)
        if result != nil {
            history.append(result!)
        }
        while !remain.isEmpty {
            (result, _, remain) = display(remain)
            if result != nil {
                history.insert(result!, atIndex: 0)
            }
        }
        return history
    }
    
    func evluate() -> Double? {
        let (result, remainder) = evluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        display(opStack)
        return result
    }
    
    func pushOperand(operand:Double) ->Double? {
        opStack.append(Op.Operand(operand, 0))
        return evluate()
    }
    
    func performOperation(symbol: String) ->Double? {
        if let operation = knowOps[symbol]{
            opStack.append(operation)//这里如果不用if的话直接append需要解包字典返回的是一个Optional
        }
        return evluate()
    }
    func setValue(symbol: String, value: Double?) -> Double? {
        VariableValues.updateValue(value!, forKey: symbol)
        return evluate()
    }
    func pushOperand(symbol: String) {// -> Double? {
        opStack.append(Op.Variable(symbol, 0))
    }
}
