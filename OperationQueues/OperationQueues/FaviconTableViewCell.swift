//
//  FaviconTableViewCell.swift
//  OperationQueues
//
//  Created by exialym on 15/10/22.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class FaviconTableViewCell: UITableViewCell {
    var operationQueue : NSOperationQueue?
    
    @IBOutlet weak var urltext: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    var url: NSURL?{
        didSet {
            let request = NSURLRequest(URL: self.url!)
            self.urltext.text = self.url?.host
            //这个方法现在好像不被推荐了
            NSURLConnection.sendAsynchronousRequest(request, queue: self.operationQueue!) { (response: NSURLResponse?, data:NSData?, error:NSError?) in
                //let image = UIImage(named: "1")
                let image = UIImage(data: data!)
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if let imageview = self.favImage {
                        imageview.image = image
                        self.setNeedsDisplay()
                    }
                })
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
