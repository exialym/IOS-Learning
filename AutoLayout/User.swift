//
//  User.swift
//  AutoLayout
//
//  Created by exialym on 15/8/21.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import Foundation
class User
{
    let name: String
    let company: String
    let login: String
    let password: String
    var lastlogin: NSDate?
    
    init(iname: String, icompany: String, ilogin: String, ipassword: String, ilastlogin: NSDate?){
        name = iname
        company = icompany
        login = ilogin
        password = ipassword
        lastlogin = ilastlogin
    }
    
    static func login(login: String, passwd: String) -> User?{
        if let user = database[login] {
            if user.password == passwd {
                return user
            }
        }
        return nil
    }
    
    static let database: Dictionary<String, User> = {
        var theDatabase = Dictionary<String, User>()
        for user in [
            User(iname: "lym", icompany: "🍎", ilogin: "exialym", ipassword: "1", ilastlogin: nil),
            User(iname: "lyq", icompany: "🐰", ilogin: "rabbit", ipassword: "2", ilastlogin: nil),
            User(iname: "🐶", icompany: "🐶", ilogin: "", ipassword: "3", ilastlogin: nil)
            ] {
                theDatabase[user.login] = user
        }
        return theDatabase
    }()
}