//
//  ViewController.swift
//  Breakout
//
//  Created by 🦁️ on 16/2/18.
//  Copyright © 2016年 exialym. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate{

    
    
    @IBOutlet weak var GameView: UIView!
    let ballBehavior = BallBehavior()
    var ball = UIView()
    var blocks = [String:UIView]()
    var paddle = UIView()
    let gap = 5
    var blocksPerLine = 10
    var lineNumber = 5
    var isLaunched = false
    var pushBehavior = UIPushBehavior()
    
    lazy var animator : UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.GameView)
        animator.delegate = self
        return animator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prefersStatusBarHidden()
        animator.addBehavior(ballBehavior)
        ballBehavior.collision.collisionDelegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initBlocks()
        initPaddleAndBall()
        initBoundaries()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func initBlocks() {
        let width = GameView.bounds.width - CGFloat(gap * (blocksPerLine + 1))
        let perWidth = width / CGFloat(blocksPerLine)
        let perHeight = perWidth * 0.2
        for i in (1...lineNumber) {
            for j in (1...blocksPerLine) {
                let flame = CGRect(x: CGFloat(j*gap)+CGFloat(j-1)*perWidth, y: CGFloat(i*gap)+CGFloat(i-1)*perHeight, width: perWidth, height: perHeight)
                blocks["block\(i)\(j)"] = UIView(frame: flame)
                blocks["block\(i)\(j)"]!.backgroundColor = UIColor.blueColor()
                GameView.addSubview(blocks["block\(i)\(j)"]!)
                ballBehavior.addBarrier("block\(i)\(j)", path: UIBezierPath(rect: flame))
                ballBehavior.myBehavior.addItem(blocks["block\(i)\(j)"]!)
            }
            
        }
    }
    
    
    func initPaddleAndBall() {
        let paddleWidth = GameView.bounds.width * 0.2
        let paddleHeight = paddleWidth * 0.2
        let paddleX = (GameView.bounds.width-paddleWidth)/2
        let paddleY = GameView.bounds.maxY-(self.tabBarController?.tabBar.bounds.height)!-paddleHeight*1.5
        let paddleFlame = CGRect(x: paddleX, y: paddleY, width: paddleWidth, height: paddleHeight)
        paddle = UIView(frame: paddleFlame)
        paddle.backgroundColor = UIColor.blackColor()
        GameView.addSubview(paddle)
        ballBehavior.myBehavior.addItem(paddle)
        ballBehavior.collision.addBoundaryWithIdentifier("paddle", forPath: UIBezierPath(ovalInRect: paddleFlame))
        
        let ballWidth = paddleWidth*0.2
        let ballFlame = CGRect(x: (GameView.bounds.width-ballWidth)/2, y: paddleY-ballWidth, width: ballWidth, height: ballWidth)
        ball = UIView(frame: ballFlame)
        ball.backgroundColor = UIColor.redColor()
        GameView.addSubview(ball)
        ballBehavior.collision.addItem(ball)
        //ballBehavior.gravity.addItem(ball)
        ballBehavior.myBehavior.addItem(ball)
        
        pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.active = false
        ballBehavior.addChildBehavior(pushBehavior)
    }
    
    func movePaddleFunc(x:CGFloat) {
        paddle.center.x = x
        ballBehavior.collision.removeBoundaryWithIdentifier("paddle")
        ballBehavior.collision.addBoundaryWithIdentifier("paddle", forPath: UIBezierPath(ovalInRect: paddle.frame))
        animator.updateItemUsingCurrentState(paddle)
        if !isLaunched {
            ball.center.x = x
            animator.updateItemUsingCurrentState(ball)
        }
    }
    
    func initBoundaries() {
        ballBehavior.collision.addBoundaryWithIdentifier("top", fromPoint: CGPoint(x: GameView.bounds.minX, y: GameView.bounds.minY), toPoint: CGPoint(x: GameView.bounds.maxX, y: GameView.bounds.minY))
        ballBehavior.collision.addBoundaryWithIdentifier("left", fromPoint: CGPoint(x: GameView.bounds.minX, y: GameView.bounds.minY), toPoint: CGPoint(x: GameView.bounds.minX, y: GameView.bounds.maxY))
        ballBehavior.collision.addBoundaryWithIdentifier("right", fromPoint: CGPoint(x: GameView.bounds.maxX, y: GameView.bounds.minY), toPoint: CGPoint(x: GameView.bounds.maxX, y: GameView.bounds.maxY))
    }
    
    func launchBall() {
        let random = Double(arc4random_uniform(101))
        let randomAngle = random/100
        
        pushBehavior.setAngle(CGFloat(M_PI*randomAngle), magnitude: 1)
        pushBehavior.active = true
        isLaunched = true
    }
    
    @IBAction func movePaddle(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            movePaddleFunc(sender.locationInView(GameView).x)
        case .Changed:
            movePaddleFunc(sender.locationInView(GameView).x)
        default: break
        }
    }
    @IBAction func launch(sender: UITapGestureRecognizer) {
        launchBall()
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
//        print(behavior)
//        print(item)
//        print(identifier)
        //print(p)
        if let id = identifier as? String {
            if id.hasPrefix("block") {
                ballBehavior.collision.removeBoundaryWithIdentifier(id)
                blocks[id]?.removeFromSuperview()
            } else if id.hasPrefix("paddle") && isLaunched {
//                pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous)
//                pushBehavior.setAngle(CGFloat(M_PI_2), magnitude: 100)
            }
        }
        
    }

}

