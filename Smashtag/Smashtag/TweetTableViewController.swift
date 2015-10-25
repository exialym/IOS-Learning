//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by exialym on 15/8/25.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit

struct tweetData {
    
    var userName = "lym"
    var userText = "alalalala"
    var userImage = UIImage(named: "1")
    
    init(initName: String, initText: String, initImage: UIImage){
        userName = initName
        userText = initText
        userImage = initImage
    }
}

class TweetTableViewController: UITableViewController, UITextFieldDelegate{
    
    var searchText: String? = "1" {
        didSet{
            searchTextField?.text = searchText
            tableView.reloadData()
            refresh()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    var originalTweet = [tweetData(initName: "lym", initText: "lalalalala", initImage: UIImage(named: "1")!),
                            tweetData(initName: "lyq", initText: "hahhaha", initImage: UIImage(named: "2")!),
                            tweetData(initName: "exia", initText: "sassasasaasdgafdsgadfgsadgasdfsadgsdafasdgasddsfsadgfsafgdsafasdgfdhgdsfhfgjgfhkjhfjsgf", initImage: UIImage(named: "1")!),
                            tweetData(initName: "l", initText: "fdehesfdg", initImage: UIImage(named: "2")!)]
    var tweets = [
        [tweetData(initName: "lym", initText: "lalalalala", initImage: UIImage(named: "1")!),
            tweetData(initName: "lyq", initText: "hahhaha", initImage: UIImage(named: "1")!),
            tweetData(initName: "exia", initText: "sassasasa", initImage: UIImage(named: "1")!),
            tweetData(initName: "l", initText: "fdehesfdg", initImage: UIImage(named: "1")!
            )]
    ]
    
    func refresh(){
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        if searchText != nil {
            let num = NSNumberFormatter().numberFromString(searchText!)?.intValue
            tweets.removeAll(keepCapacity: true)
            tableView.reloadData()
            for _ in 1...num! {
                tweets.append(originalTweet)
            }
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }

    @IBAction func refreshTable(sender: UIRefreshControl) {
        searchText = searchTextField?.text
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Tweet", forIndexPath: indexPath) as! TweetTableViewCell

        // Configure the cell...
        let tweet = tweets[indexPath.section][indexPath.row]
        cell.tweet = tweet
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
