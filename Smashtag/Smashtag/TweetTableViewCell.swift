//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by exialym on 15/8/26.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet = tweetData(initName: "lym", initText: "lalalalala", initImage: UIImage(named: "1")!) {
        didSet{
            updateUI()
        }
    }

    @IBOutlet weak var tweetImage: UIImageView!
    
    
    @IBOutlet weak var tweetName: UILabel!
    

    @IBOutlet weak var tweetText: UILabel!
    
    func updateUI(){
        tweetName?.text = tweet.userName
        tweetText?.text = tweet.userText
        tweetImage?.image = tweet.userImage
    }
}
