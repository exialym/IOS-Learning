//
//  wordToArray.swift
//  MagicBar
//
//  Created by 🦁️ on 16/4/10.
//  Copyright © 2016年 exialym. All rights reserved.
//

import Foundation
class WordToArray {
    var arr = [[Bool]]()
    let all_16_32 = 16//24
    let all_2_4 = 2//3
    let all_32_128 = 32//72
    
    func drawString(_ strAll:String) ->[[Bool]] {
        let str = (strAll as NSString).substring(to: 1)
        var data = [UInt8]()
        var code = [Int]()
        var byteCount = 0
        var lCount = 0
        arr = [[Bool]](repeating: [Bool](repeating: false, count: all_16_32), count: all_16_32)
        if str <= "~" {
            return arr
        }
        code = getByteCode(str)
        data = read(code[0], posCode: code[1])
        byteCount = 0
        for line in(0..<all_16_32) {
            lCount = 0;
            for _ in (0..<all_2_4) {
                for j in(0..<8) {
                    let move:UInt8 = 8-UInt8(j)
                    if j==0 {
                       print(" ",terminator:"")
                        arr[line][lCount] = false
                        continue
                    }
                    if (((data[byteCount] >> move) & 0x1) == 1) {
                        arr[line][lCount] = true
                        print("*",terminator:"")
                    } else {
                        print(" ",terminator:"")
                        arr[line][lCount] = false
                    }
                    lCount+=1
                }
                byteCount+=1
                }
                print("\n")
        }
        return arr
    }
   
    fileprivate func read(_ areaCode:Int, posCode:Int) -> [UInt8]{
        var data = [UInt8](repeating: 0, count: all_32_128)
        let area:Int = areaCode - 0xa0;
        let pos:Int = posCode - 0xa0;
        let url = Bundle.main.url(forResource: "hzk16", withExtension: nil)
        let dataInput = try? Data(contentsOf: url!)
        //print(dataInput)
        let offset:Int = all_32_128 * ((area - 1) * 94 + pos - 1);
        (dataInput as NSData?)?.getBytes(&data, range: NSRange(location: offset, length: all_32_128))
        //print(data)
//      in.skip(offset);
//        data = new byte[all_32_128];
//        in.read(data, 0, all_32_128);
//        in.close();
        return data;
    
    }
    fileprivate func getByteCode(_ str:String)->[Int] {
        var byteCode = [Int](repeating: 0, count: 2)
        var data = [UInt8](repeating: 0, count: 2)
        let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        let test  = str.data(using: String.Encoding(rawValue: enc), allowLossyConversion: false)
        //print(test)
        (test as NSData?)?.getBytes(&data[0], range: NSRange(location: 0, length: 1))
        (test as NSData?)?.getBytes(&data[1], range: NSRange(location: 1, length: 1))
        //print(data)
        //var d = NSData(bytes: data, length: 2)
        //print(d)
        byteCode[0] = data[0] < 0 ? 256 + Int(data[0]) : Int(data[0])
        byteCode[1] = data[1] < 0 ? 256 + Int(data[1]) : Int(data[1])
        //print(byteCode)
        return byteCode
    }
}
