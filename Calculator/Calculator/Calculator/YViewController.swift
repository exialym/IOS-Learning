//
//  YViewController.swift
//  Calculator
//
//  Created by exialym on 15/10/2.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class YViewController: UIViewController {

    @IBOutlet weak var textView: UITextView! {
        didSet{
            textView.text = text
        }
    }
    var text: String = "" {
        didSet{
            textView?.text = text
        }
    }
}
