//
//  SampleDocument.swift
//  IOSDocuments
//
//  Created by 🦁️ on 15/11/16.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class SampleDocument: UIDocument {
    var text = ""
    //读取文件内容
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
        self.text = ""
        if let data = contents as? NSData {
            if data.length > 0 {
                if let theText = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    self.text = theText as String
                }
            }
        }
    }
    //保存文件内容
    override func contentsForType(typeName: String) throws -> AnyObject {
        return self.text.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
