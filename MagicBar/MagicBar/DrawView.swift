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
    let columnNum = 24//列数
    let rowNum = 24//行数
    var blockWidth:CGFloat = 0
    var blockHeight:CGFloat = 0
    var blockArray = [[BlockView?]]()
    var dataArray1 = [[Int]]()
    var dataArray2 = [[Int]]()
    var dataArray3 = [[Int]]()
    var dataArray4 = [[Int]]()
    var dataArray5 = [[Int]]()
    var nowImageNum:Int = 1
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    private func drawBlocks(){
        blockArray = [[BlockView?]](count: columnNum, repeatedValue: [BlockView?](count: rowNum, repeatedValue: nil))
        dataArray1 = [[Int]](count: columnNum, repeatedValue: [Int](count: rowNum, repeatedValue: 0))
        dataArray2 = [[Int]](count: columnNum, repeatedValue: [Int](count: rowNum, repeatedValue: 0))
        dataArray3 = [[Int]](count: columnNum, repeatedValue: [Int](count: rowNum, repeatedValue: 0))
        dataArray4 = [[Int]](count: columnNum, repeatedValue: [Int](count: rowNum, repeatedValue: 0))
        dataArray5 = [[Int]](count: columnNum, repeatedValue: [Int](count: rowNum, repeatedValue: 0))
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blueColor().CGColor
        blockWidth = self.bounds.width/CGFloat(columnNum)
        blockHeight = self.bounds.height/CGFloat(rowNum)
        for i in (0..<columnNum){
            for j in (0..<rowNum) {
                let blockFlame = CGRect(x: CGFloat(i)*blockWidth, y: CGFloat(j)*blockHeight, width: blockWidth, height: blockHeight)
                let blockView = BlockView(frame: blockFlame)
                blockView.layer.borderWidth = 0//0.5
                blockView.layer.borderColor = UIColor.whiteColor().CGColor
                blockView.ischoosed = 0
                self.addSubview(blockView)
                blockArray[i][j] = blockView
            }
        }
        
    }
    func setWord(wordArray:[[Bool]]) {
        for (rowIndex,rowArray) in wordArray.enumerate(){
            for (columnIndex,item) in rowArray.enumerate(){
                blockArray[columnIndex][rowIndex]!.ischoosed = item ? 1 : 0
            }
        }
        redraw()
    }
    func redraw() {
        for row in blockArray {
            for item in row {
                if item?.ischoosed == 0 {
                    item?.backgroundColor = UIColor.whiteColor()
                } else if item?.ischoosed == 1{
                    item?.backgroundColor = UIColor.blueColor()
                }
            }
        }
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
        drawBlocks()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let column = Int((touches.first?.locationInView(self).x)!/blockWidth)
        let row = Int((touches.first?.locationInView(self).y)!/blockHeight)
        print("x:\(column);y:\(row)")
        if (column<columnNum)&&(row<rowNum){
            blockArray[column][row]!.backgroundColor = UIColor.blueColor()
            blockArray[column][row]!.ischoosed = 1
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let column = Int((touches.first?.locationInView(self).x)!/blockWidth)
        let row = Int((touches.first?.locationInView(self).y)!/blockHeight)
        print("x:\(column);y:\(row)")
        if (column<columnNum)&&(row<rowNum)&&(column>=0)&&(row>=0){
            blockArray[column][row]!.backgroundColor = UIColor.blueColor()
            blockArray[column][row]!.ischoosed = 1
        }
    }
    func saveToDataArray(changeTo:Int){
        let dataArray = blockArray.map({ (row:[BlockView?]) -> [Int] in
                return row.map({ (block:BlockView?) -> Int in
                    return (block?.ischoosed)!
                })
            })
        var nowArray = [[Int]]()
        switch nowImageNum{
        case 1:
            dataArray1 = dataArray
        case 2:
            dataArray2 = dataArray
        case 3:
            dataArray3 = dataArray
        case 4:
            dataArray4 = dataArray
        case 5:
            dataArray5 = dataArray
        default:
            break
        }
        nowImageNum = changeTo
        switch changeTo {
        case 1:
            nowArray = dataArray1
        case 2:
            nowArray = dataArray2
        case 3:
            nowArray = dataArray3
        case 4:
            nowArray = dataArray4
        case 5:
            nowArray = dataArray5
        default:
            break
        }
        for i in (0..<columnNum){
            for j in (0..<rowNum) {
                blockArray[i][j]!.ischoosed = nowArray[i][j]
            }
        }
        redraw()
    }

}
