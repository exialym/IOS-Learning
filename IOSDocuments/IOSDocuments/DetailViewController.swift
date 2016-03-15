//
//  DetailViewController.swift
//  IOSDocuments
//
//  Created by 🦁️ on 15/11/12.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    var myMasterViewController: MasterViewController?
    @IBOutlet weak var textView: UITextView!

    
    @IBAction func deleteArtical(sender: UIBarButtonItem) {
        if let document: SampleDocument = self.detailItem {
            _ = try? NSFileManager.defaultManager().removeItemAtURL(document.fileURL)
            myMasterViewController?.updateFileList()
        }
    }
    
    
    var detailItem: SampleDocument? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let document: SampleDocument = self.detailItem {
            self.textView?.text = document.text
            self.title = String(document.fileURL).componentsSeparatedByString("/").last?.componentsSeparatedByString(".").first
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        //self.navigationItem.hidesBackButton = true
    }

    func textViewDidChange(textView: UITextView) {
        if let document: SampleDocument = self.detailItem {
            document.text = self.textView.text
            //在文件发生变化时，及时保存，.Done意味着A change has been made to the document.
            document.updateChangeCount(UIDocumentChangeKind.Done)
        }
    }


}

