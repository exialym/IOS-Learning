//
//  BoxAppModel.swift
//  
//
//  Created by 🦁️ on 15/12/27.
//
//

import Foundation
import CoreData


class BoxAppModel: NSManagedObject {

    var name: String!
    var boxDescription: String!
    var type: Int!
    var certNum: String!
    var isHot: Bool!
    var isNew: Bool!
    var isHeart: Bool!
    var position: Int!
    var item: String!
    var link: String!
    //var image: String!
    init(dict: NSDictionary) {
        name = dict.objectForKey("Name") as! String
        boxDescription = dict.objectForKey("Description") as! String
        type = dict.objectForKey("Type") as! Int
        certNum = dict.objectForKey("CertNum") as! String
        isHot = dict.objectForKey("IsHot") as! Bool
        isNew = dict.objectForKey("IsNew") as! Bool
        isHeart = dict.objectForKey("IsHeart") as! Bool
        position = dict.objectForKey("Position") as! Int
        item = dict.objectForKey("AppItem") as! String
        link = dict.objectForKey("Link") as! String
        
    }

}
