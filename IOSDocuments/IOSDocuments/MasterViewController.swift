//
//  MasterViewController.swift
//  IOSDocuments
//
//  Created by 🦁️ on 15/11/12.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UIPopoverPresentationControllerDelegate{

    func createDocument(name: String) {
        
        let fileName = "\(name).sampleDocument"
        
        let url = self.URLforDocuments().URLByAppendingPathComponent(fileName)
        
        let documentToCreate = SampleDocument(fileURL:url)
        documentToCreate.saveToURL(documentToCreate.fileURL, forSaveOperation: UIDocumentSaveOperation.ForCreating) { (success) -> Void in
            if success {
                self.performSegueWithIdentifier("showDetail", sender: documentToCreate)
                self.updateFileList()
            }
        }
    }
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var documentURLs : [NSURL] = []
    let fileManager = NSFileManager()
    func URLforDocuments() -> NSURL {
        let url1 = (fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first)!
        //DocumentationDirectory获得到的文件夹我们是没有读写权限的
        //let url2 = (fileManager.URLsForDirectory(.DocumentationDirectory, inDomains: .UserDomainMask).first)!
        //print(url1)
        //print(url2)
        return url1
    }
    func updateFileList() {
        if let urls = try? fileManager.contentsOfDirectoryAtURL(self.URLforDocuments(), includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions()) as [NSURL] {
            documentURLs = urls
        }
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        self.updateFileList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var dastination = segue.destinationViewController
        if let navController = dastination as? UINavigationController {//这里可以获得现在View所在的navController
            dastination = navController.visibleViewController!//这个方法可以获得UINavigationController中最顶层的View即可视的View
        }
        if segue.identifier == "showDetail" {
            if let detailViewcon = dastination as? DetailViewController {
                let document = sender as? SampleDocument
                detailViewcon.detailItem = document
                detailViewcon.myMasterViewController = self
            }
        } else if segue.identifier == "Name your file" {
            if let nameViewCon = segue.destinationViewController as? NameViewController{
                if let ppc = nameViewCon.popoverPresentationController {
                    ppc.delegate = self
                    nameViewCon.preferredContentSize = CGSize(width: 320, height: 100)
                }
                nameViewCon.masterViewController = self
            }
        }
    }
    //使popover的ViewController在iPhone下不会满屏
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentURLs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FileCell", forIndexPath: indexPath)

        let url = documentURLs[indexPath.row]
        cell.textLabel?.text = url.lastPathComponent
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = documentURLs[indexPath.row]
        let documentToOpen = SampleDocument(fileURL: url)
        documentToOpen.openWithCompletionHandler { (success) -> Void in
            if success {
                self.performSegueWithIdentifier("showDetail", sender: documentToOpen)
            }
        }
    }

}

