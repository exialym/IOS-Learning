//
//  StartViewController.swift
//  Fellow Me
//
//  Created by 🦁️ on 16/2/16.
//  Copyright © 2016年 exialym. All rights reserved.
//

import UIKit

class StartViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var maxNumber:Int = 1
    var speed : Float = 1.0
    let userDefult = NSUserDefaults.standardUserDefaults()
    var score = [Int]()
    
    @IBAction func speed(sender: UISlider) {
        speed = sender.value
        number.text = "最长序列数：\(maxNumber)；速度：\(speed)"
    }
    @IBOutlet weak var number: UILabel!
    @IBAction func changeNumber(sender: UISlider) {
        maxNumber = Int(sender.value)
        number.text = "最长序列数：\(maxNumber)；速度：\(speed)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        number.text = "最长序列数：\(maxNumber)；速度：\(speed)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "beginGame":
            if let dvc = segue.destinationViewController as? ViewController {
                dvc.winningNumber = maxNumber
                dvc.highlightSquareTime = speed
            }
        default:break
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        score = userDefult.objectForKey("score") as? [Int] ?? []
        return score.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        score = userDefult.objectForKey("score") as? [Int] ?? []
        let cell = tableView.dequeueReusableCellWithIdentifier("score", forIndexPath: indexPath) as! TableViewCell
        cell.rank.text = "第\(indexPath.row + 1)名"
        cell.number.text = "\(score[indexPath.row])"
        return cell
    }

}
