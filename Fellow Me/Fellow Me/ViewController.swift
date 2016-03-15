

//
//  ViewController.swift
//  Fellow Me
//
//  Created by 🦁️ on 16/2/13.
//  Copyright © 2016年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var block1: UIButton!
    @IBOutlet weak var block2: UIButton!
    @IBOutlet weak var block3: UIButton!
    @IBOutlet weak var block4: UIButton!
    
    enum ButtonColor : Int {
        case Green = 1
        case Blue = 2
        case Red = 3
        case Yellow = 4
    }
    enum WhoseTurn {
        case Human
        case Computer
    }
    
    var winningNumber : Int!
    var currentPlayer : WhoseTurn = .Computer
    var inputs = [ButtonColor]()
    var indexOfNextButtonToTouch = 0
    var highlightSquareTime : Float = 1.0
    let userDefult = NSUserDefaults.standardUserDefaults()
    
    @IBAction func buttonTouched(sender: UIButton) {
        let buttonTag = sender.tag
        if let colorTouched = ButtonColor(rawValue: buttonTag) {
            if currentPlayer == .Computer {
                return
            }
            if colorTouched == inputs[indexOfNextButtonToTouch] {
                indexOfNextButtonToTouch++
                if indexOfNextButtonToTouch == inputs.count {
                    if advanceGame() == false {
                        playerWins()
                    }
                    indexOfNextButtonToTouch = 0
                } else {
                    
                }
            } else {
                playerLoses()
                indexOfNextButtonToTouch = 0
            }
        }
    }
    
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        startNewGame()
//    }

    
    func playerWins(){
        
        record(true)
        let winner : UIAlertController = UIAlertController(title: "You Win", message: "Congratulations!You made it \(inputs.count)", preferredStyle: .Alert)
//        winner.modalPresentationStyle = .FullScreen
        var action = UIAlertAction(title: "again", style: UIAlertActionStyle.Default) { (a) -> Void in
            self.startNewGame()
        }
        winner.addAction(action)
        action = UIAlertAction(title: "change number", style: UIAlertActionStyle.Default) { (a) -> Void in
            self.startNewGame()
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("1") as! StartViewController
            self.presentViewController(storyboard, animated: true, completion: nil)
            //print(self.presentingViewController)
        }
        winner.addAction(action)
        presentViewController(winner, animated: true, completion: nil)
//        var winner : UIAlertView = UIAlertView(title: "You Win", message: "Congratulations!", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Awsome")
//        winner.show()
    }
    
    func playerLoses(){
        
        record(false)
        let winner : UIAlertController = UIAlertController(title: "You Lose", message: "Try Again!You made it \(inputs.count-1)", preferredStyle: .Alert)
       // winner.modalPresentationStyle = .FormSheet
        var action = UIAlertAction(title: "again", style: UIAlertActionStyle.Default) { (a) -> Void in
            self.startNewGame()
        }
        winner.addAction(action)
        action = UIAlertAction(title: "change number", style: UIAlertActionStyle.Default) { (a) -> Void in
            self.startNewGame()
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("1") as! StartViewController
            self.presentViewController(storyboard, animated: true, completion: nil)
            //print(self.presentingViewController)
        }
        winner.addAction(action)
        presentViewController(winner, animated: true, completion: nil)

    }
    
    private func record(isWin:Bool) {
        var buttonTouched = inputs.count
        if !isWin {
            buttonTouched -= 1
        }
        if buttonTouched != 0 {
            var highestNumbers = userDefult.objectForKey("score") as? [Int] ?? []
            var had = false
            for item in highestNumbers {
                if buttonTouched == item {
                    had = true
                }
            }
            if !had {
                highestNumbers += [buttonTouched]
                highestNumbers = highestNumbers.sort(){ $0 > $1 }
                if highestNumbers.count > 10 {
                    highestNumbers.removeLast()
                }
                print(highestNumbers)
                userDefult.setObject(highestNumbers, forKey: "score")
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        self.prefersStatusBarHidden()
        //self.setNeedsStatusBarAppearanceUpdate()
        let superView = block1.superview
       
        var aspect: NSLayoutConstraint?
        aspect = NSLayoutConstraint(item: block1, attribute: .Width, relatedBy: .Equal, toItem: superView, attribute: .Width, multiplier: 0.5, constant: 0)
        view.addConstraint(aspect!)
        aspect = NSLayoutConstraint(item: block1, attribute: .Height, relatedBy: .Equal, toItem: superView, attribute: .Height, multiplier: 0.5, constant: 0)
        view.addConstraint(aspect!)
        aspect = NSLayoutConstraint(item: block2, attribute: .Width, relatedBy: .Equal, toItem: superView, attribute: .Width, multiplier: 0.5, constant: 0)
        view.addConstraint(aspect!)
        aspect = NSLayoutConstraint(item: block2, attribute: .Height, relatedBy: .Equal, toItem: superView, attribute: .Height, multiplier: 0.5, constant: 0)
        view.addConstraint(aspect!)
        aspect = NSLayoutConstraint(item: block3, attribute: .Width, relatedBy: .Equal, toItem: superView, attribute: .Width, multiplier: 0.5, constant: 0)
        view.addConstraint(aspect!)
        aspect = NSLayoutConstraint(item: block3, attribute: .Height, relatedBy: .Equal, toItem: superView, attribute: .Height, multiplier: 0.5, constant: 0)
        view.addConstraint(aspect!)
        aspect = NSLayoutConstraint(item: block4, attribute: .Width, relatedBy: .Equal, toItem: superView, attribute: .Width, multiplier: 0.5, constant: 0)
        view.addConstraint(aspect!)
        aspect = NSLayoutConstraint(item: block4, attribute: .Height, relatedBy: .Equal, toItem: superView, attribute: .Height, multiplier: 0.5, constant: 0)
        view.addConstraint(aspect!)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startNewGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func randomButton() -> ButtonColor {
        let v : Int = Int(arc4random_uniform(UInt32(4))) + 1
        let result = ButtonColor(rawValue: v)
        return result!
    }
    
    func startNewGame(){
        inputs = [ButtonColor]()
        advanceGame()
    }
    func advanceGame() -> Bool {
        var result = true
        if inputs.count == winningNumber {
            result = false
        } else {
            inputs += [randomButton()]
            playSequence(0, highlightTime: highlightSquareTime)
        }
        return result
        
    }

    func playSequence(index: Int, highlightTime: Float) {
        currentPlayer = .Computer
        //print(inputs)
        if index == inputs.count {
            currentPlayer = .Human
            return
        }
        let button : UIButton = buttonByColor(inputs[index])
        let originalColor : UIColor? = button.backgroundColor
        let highlightColor : UIColor = UIColor.whiteColor()
        UIView.animateWithDuration(Double(highlightSquareTime)/Double(2), delay: 0.0, options: [.BeginFromCurrentState,.AllowUserInteraction,.CurveLinear], animations: { () -> Void in
            button.backgroundColor = highlightColor
            }) { (isFinished) -> Void in
                UIView.animateWithDuration(Double(self.highlightSquareTime)/Double(2), delay: 0.0, options: [.BeginFromCurrentState,.AllowUserInteraction,.CurveLinear], animations: { () -> Void in
                    button.backgroundColor = originalColor
                    }, completion: { (isFinished) -> Void in
                        let newIndex : Int = index + 1
                        self.playSequence(newIndex, highlightTime: self.highlightSquareTime)
                })
        }
    }
    
    func buttonByColor(color: ButtonColor) -> UIButton {
        switch color {
        case .Green:
            return block1
        case .Blue:
            return block2
        case .Red:
            return block3
        case .Yellow:
            return block4
        }
    }
    
    
    
}

