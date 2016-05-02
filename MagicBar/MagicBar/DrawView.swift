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
    let picNum = 5//画面数
    var isGrid = false {
        didSet{
            redraw()
        }
    }
    var blockWidth:CGFloat = 0
    var blockHeight:CGFloat = 0
    var blockArray = [[BlockView?]]()
    
    var dataArray = [[[Int]]]()
    var colorArray = [String]()
    
    var nowImageNum:Int = 1
    var nowImageColor:UIColor? = UIColor.blueColor()
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    private func drawBlocks(){
        blockArray = [[BlockView?]](count: columnNum, repeatedValue: [BlockView?](count: rowNum, repeatedValue: nil))
        dataArray = [[[Int]]](count: picNum, repeatedValue: [[Int]](count: columnNum, repeatedValue: [Int](count: rowNum, repeatedValue: 0)))
        colorArray = [String](count:picNum, repeatedValue:"blue")
        self.layer.borderWidth = 0//1
        self.layer.borderColor = UIColor.blueColor().CGColor
        blockWidth = self.bounds.width/CGFloat(columnNum)
        blockHeight = self.bounds.height/CGFloat(rowNum)
        for i in (0..<columnNum){
            for j in (0..<rowNum) {
                let blockFlame = CGRect(x: CGFloat(i)*blockWidth, y: CGFloat(j)*blockHeight, width: blockWidth, height: blockHeight)
                let blockView = BlockView(frame: blockFlame)
                blockView.layer.borderWidth = isGrid ? 1 : 0
                blockView.layer.borderColor = UIColor.whiteColor().CGColor
                blockView.layer.cornerRadius = blockWidth/2
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
                item!.layer.borderWidth = isGrid ? 1 : 0
                if item?.ischoosed == 0 {
                    item?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                } else if item?.ischoosed == 1{
                    item?.backgroundColor = nowImageColor
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
        //print("x:\(column);y:\(row)")
        if (column<columnNum)&&(row<rowNum){
            blockArray[column][row]!.backgroundColor = nowImageColor
            blockArray[column][row]!.ischoosed = 1
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let column = Int((touches.first?.locationInView(self).x)!/blockWidth)
        let row = Int((touches.first?.locationInView(self).y)!/blockHeight)
        //print("x:\(column);y:\(row)")
        if (column<columnNum)&&(row<rowNum)&&(column>=0)&&(row>=0){
            blockArray[column][row]!.backgroundColor = nowImageColor
            blockArray[column][row]!.ischoosed = 1
        }
    }
    func saveToDataArray(changeTo:Int){
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
    func setColors(nowImageColorString:String) {
        colorArray[nowImageNum-1] = nowImageColorString
        getColors()
        redraw()
    }
    func getColors(){
        //print(colorArray)
        switch colorArray[nowImageNum-1] {
        case "blue":
            nowImageColor = UIColor.blueColor()
        case "green":
            nowImageColor = UIColor.greenColor()
        case "red":
            nowImageColor = UIColor.redColor()
        case "yellow":
            nowImageColor = UIColor.yellowColor()
        default:
            nowImageColor = UIColor.blackColor()
        }
    }
}
