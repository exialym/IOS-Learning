//
//  drawView.swift
//  MagicBar
//
//  Created by 🦁️ on 16/4/5.
//  Copyright © 2016年 exialym. All rights reserved.
// 

import UIKit
@IBDesignable
class DrawView: UIView {
    let columnNum = 16//列数24
    let rowNum = 16//行数24
    let picNum = 4//画面数
    let defaultBackgroundColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.00).cgColor
    let borderColor = UIColor.white.cgColor
    var isGrid = false {
        didSet{
            redraw()
        }
    }
    var blockWidth:CGFloat = 0
    var blockHeight:CGFloat = 0
    var blockArray = [[BlockView?]]()
    
    var dataArray = [[[Int]]]()
    var colorArray = [UInt8]()
    
    var nowImageNum:Int = 1
    var nowImageColor:UIColor? = UIColor.blue
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    fileprivate func drawBlocks(){
        blockArray = [[BlockView?]](repeating: [BlockView?](repeating: nil, count: rowNum), count: columnNum)
        dataArray = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: rowNum), count: columnNum), count: picNum)
        colorArray = [UInt8](repeating: 0b00000001, count: picNum)
        self.layer.borderWidth = 0//1
        self.layer.borderColor = UIColor.blue.cgColor
        blockWidth = self.bounds.width/CGFloat(columnNum)
        blockHeight = self.bounds.height/CGFloat(rowNum)
        for i in (0..<columnNum){
            for j in (0..<rowNum) {
                let blockFlame = CGRect(x: CGFloat(i)*blockWidth, y: CGFloat(j)*blockHeight, width: blockWidth, height: blockHeight)
                let blockView = BlockView(frame: blockFlame)
                blockView.layer.borderWidth = 1
                blockView.layer.borderColor = isGrid ? borderColor : defaultBackgroundColor
                blockView.layer.cornerRadius = blockWidth/2
                blockView.ischoosed = 0
                self.addSubview(blockView)
                blockArray[i][j] = blockView
            }
        }
        
    }
    func setWord(_ wordArray:[[Bool]]) {
        for (rowIndex,rowArray) in wordArray.enumerated(){
            for (columnIndex,item) in rowArray.enumerated(){
                blockArray[columnIndex][rowIndex]!.ischoosed = item ? 1 : 0
            }
        }
        redraw()
    }
    func redraw() {
        for row in blockArray {
            for item in row {
                item!.layer.borderColor = isGrid ? borderColor : defaultBackgroundColor
                if item?.ischoosed == 0 {
                    item?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                } else if item?.ischoosed == 1{
                    item?.backgroundColor = nowImageColor
                }
            }
        }
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawBlocks()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let column = Int((touches.first?.location(in: self).x)!/blockWidth)
        let row = Int((touches.first?.location(in: self).y)!/blockHeight)
        //print("x:\(column);y:\(row)")
        if (column<columnNum)&&(row<rowNum){
            blockArray[column][row]!.backgroundColor = nowImageColor
            blockArray[column][row]!.ischoosed = 1
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let column = Int((touches.first?.location(in: self).x)!/blockWidth)
        let row = Int((touches.first?.location(in: self).y)!/blockHeight)
        //print("x:\(column);y:\(row)")
        if (column<columnNum)&&(row<rowNum)&&(column>=0)&&(row>=0){
            blockArray[column][row]!.backgroundColor = nowImageColor
            blockArray[column][row]!.ischoosed = 1
        }
    }
    func saveToDataArray(_ changeTo:Int){
        let tempDataArray = blockArray.map({ (row:[BlockView?]) -> [Int] in
                return row.map({ (block:BlockView?) -> Int in
                    return (block?.ischoosed)!
                })
            })
        var nowArray = [[Int]]()
        dataArray[nowImageNum-1] = tempDataArray
        nowImageNum = changeTo
        nowArray = dataArray[nowImageNum-1]
        for i in (0..<columnNum){
            for j in (0..<rowNum) {
                blockArray[i][j]!.ischoosed = nowArray[i][j]
            }
        }
        getColors()
        redraw()
    }
    func setColors(_ nowImageColorString:UInt8){
        colorArray[nowImageNum-1] = nowImageColorString
        getColors()
        redraw()
    }
    func getColors(){
        //print(colorArray)
        switch colorArray[nowImageNum-1] {
        case 0b00000001:
            nowImageColor = UIColor.blue
        case 0b00000010:
            nowImageColor = UIColor.green
        case 0b00000100:
            nowImageColor = UIColor.red
        case 0b00001000:
            nowImageColor = UIColor.yellow
        case 0b00010000:
            nowImageColor = UIColor.magenta
        case 0b00100000:
            nowImageColor = UIColor.white
        case 0b01000000:
            nowImageColor = UIColor.cyan
        default:
            nowImageColor = UIColor.blue
        }
    }
    func sendData() -> [Data]{
        saveToDataArray(nowImageNum)
        var dataValue = [Data]()
        var tempData = [[UInt8]](repeating: [UInt8](), count: picNum)
        for (index, image) in dataArray.enumerated() {
            tempData[index].append(colorArray[index])
            for row in image {
                var tempchar:UInt8 = 0b00000000
                for i in (0..<8) {
                    tempchar = tempchar >> 1
                    tempchar += (row[i] == 1 ? 0 : 0b10000000)
                }
                tempData[index].append(tempchar)
                tempchar = 0b00000000
                for i in (8..<16) {
                    tempchar = tempchar >> 1
                    tempchar += (row[i] == 1 ? 0 : 0b10000000)
                }
                tempData[index].append(tempchar)
//                tempchar = 0b00000000
//                for i in (16..<24) {
//                    tempchar = tempchar << 1
//                    tempchar += (row[i] == 1 ? 0 : 1)
//                }
//                tempData[index].append(tempchar)
            }
        }
        for i in (0..<tempData.count) {
            dataValue.append(Data(bytes: UnsafePointer<UInt8>(tempData[i]), count: 33))//73
        }
        print(dataValue)
        return dataValue
    }
}
