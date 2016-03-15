//
//  ViewController.swift
//  CoreDataTest
//
//  Created by 🦁️ on 15/12/26.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var authorText: UITextField!
    @IBOutlet weak var resultText: UITextView!
    @IBAction func insert(sender: UIButton) {
        let request = NSFetchRequest(entityName: "Book")
        if nameText.text != "" && authorText.text != "" {
            let predicate = NSPredicate(format: "%K == %@","name", nameText.text!)
            request.predicate = predicate
            var result:[NSManagedObject] = []
            do{
                result = try appDelegate.managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
            } catch {}
            if result.count == 0{
                //向指定实体中插入托管对象
                let object:Book = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: appDelegate.managedObjectContext) as! Book
                object.name = nameText.text
                object.author = authorText.text
                appDelegate.saveContext()
            }
        }
        
    }
    @IBAction func query(sender: UIButton) {
        //首先，规定获取数据的实体
        let request = NSFetchRequest(entityName: "Book")
        if nameText.text != "" && authorText.text == "" {
            //配置查询条件，如果有需要还可以配置结果排序
            let predicate = NSPredicate(format: "%K == %@", "name", nameText.text!)
            request.predicate = predicate
        } else if nameText.text == "" && authorText.text != "" {
            let predicate = NSPredicate(format: "%K == %@", "author", authorText.text!)
            request.predicate = predicate
        } else if nameText.text != "" && authorText.text != "" {
            let predicate = NSPredicate(format: "%K == %@ && %K == %@", "name", nameText.text!, "author", authorText.text!)
            request.predicate = predicate
        }

        var result:[NSManagedObject] = []
        do{
            //进行查询，结果是一个托管对象数组
            result = try appDelegate.managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
        } catch {}
        resultText.text = ""
        for item in result {
            //用键值对的方式获取各个值
            resultText.text! += "书名：\(item.valueForKey("name") as! String)  作者：\(item.valueForKey("author") as! String)\n"
        }
        
    }
    
    @IBAction func update(sender: UIButton) {
        let request = NSFetchRequest(entityName: "Book")
        if nameText.text != "" && authorText.text != "" {
            let predicate = NSPredicate(format: "%K == %@","name", nameText.text!)
            request.predicate = predicate
            var result:[NSManagedObject] = []
            do{
                result = try appDelegate.managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
            } catch {}
            if result.count != 0{
                resultText.text = ""
                for item in result {
                    //获取到想要的对象，改想改的值
                    item.setValue(authorText.text, forKey: "author")
                    resultText.text! += "书名：\(item.valueForKey("name") as! String)  作者：\(item.valueForKey("author") as! String)\n"
                }
            }
        }
        appDelegate.saveContext()
    }
    
    @IBAction func Delete(sender: UIButton) {
        let request = NSFetchRequest(entityName: "Book")
        if nameText.text != "" && authorText.text != "" {
            let predicate = NSPredicate(format: "%K == %@","name", nameText.text!)
            request.predicate = predicate
            var result:[NSManagedObject] = []
            do{
                result = try appDelegate.managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
            } catch {}
            if result.count != 0{
                for item in result {
                    appDelegate.managedObjectContext.deleteObject(item)
                }
            }
        }
        appDelegate.saveContext()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

