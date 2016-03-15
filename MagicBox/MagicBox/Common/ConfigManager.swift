//
//  ConfigManager.swift
//  MagicBox
//
//  Created by 🦁️ on 15/12/27.
//  Copyright © 2015年 exialym. All rights reserved.
//

import Foundation
public class ConfigManager{
    //生成ConfigManager的单例形式
    public class var sharedInstance: ConfigManager {
        struct singleManager {
            static var instance: ConfigManager?
            static var token: dispatch_once_t = 0
        }
        //实现GCD调用，保证多线程环境下的安全操作
        dispatch_once(&singleManager.token) { () -> Void in
            singleManager.instance = ConfigManager()
        }
        return singleManager.instance!
    }
    var settingURL:NSURL{
        let fileManager = NSFileManager()
        //得到根目录URL
        let docsDir = (fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first)
        //在根URL后添加文件相对路径
        let url = docsDir!.URLByAppendingPathComponent("Setting.plist")
        return url
    }
    init(){
        initBoxAppsDB()
        initMyBoxAppsDB()
    }
    var boxAppsDB:[BoxAppModel] = []
    var myAppsDB:[BoxAppModel] = []
    func initBoxAppsDB() {
        boxAppsDB.removeAll(keepCapacity: false)
        let settingPath = settingURL.path
        if settingPath != nil {
            let dictResult = NSMutableDictionary(contentsOfFile: settingPath!)
            let apps: NSArray? = dictResult?.objectForKey("Apps")?.objectForKey("CurrentList") as? NSArray
            if apps != nil {
                for app in apps! {
                    boxAppsDB.append(BoxAppModel(dict: app as! NSDictionary))
                }
            }
        }
    }
    func initMyBoxAppsDB() {
        myAppsDB = boxAppsDB
    }
    func getBoxAppAmount() -> Int {
        return boxAppsDB.count
    }
    func getBoxAppByIndex(index: Int) -> BoxAppModel? {
        return boxAppsDB[index]
    }
    func getMyBoxAppAmount() -> Int {
        return myAppsDB.count
    }
    func getMyBoxAppByIndex(index: Int) -> BoxAppModel? {
        return myAppsDB[index]
    }
    func refreshConfigurePlist() -> Bool {
        let configPath = settingURL.path
        if configPath == nil {
            print("Setting.plist找不到")
            return false
        }
        let dic = NSMutableDictionary(contentsOfFile: configPath!)
        NSLog("配置文件是：%@", dic!)
        return true
    }
    public func parserJsonData(path: String){// -> String {
        let path = NSBundle.mainBundle().pathForResource("Configure", ofType: "geojson")
        let contents = try? NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        if contents != nil {
            let jsonData: NSData = (contents?.dataUsingEncoding(NSUTF8StringEncoding))!
            let resultDict:NSDictionary? = jsonData.objectFromJSONData() as? NSDictionary
            let ret: Bool = resultDict!.writeToFile(settingURL.path!, atomically: true)
            if ret {
                NSLog("JSON数据写入成功：\(settingURL)")
            } else {
                NSLog("JSON数据写入失败")
            }
            
        }
        
    }
}
