//
//  NameViewController.swift
//  IOSDocuments
//
//  Created by 🦁️ on 15/11/17.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    var masterViewController: MasterViewController?
    
    @IBAction func createNewFile(sender: AnyObject) {
        masterViewController?.createDocument(nameText.text!)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelFile(sender: AnyObject) {
        
    }
    
    @IBOutlet weak var nameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
