//
//  GameViewController.swift
//  SpriteKit2
//
//  Created by exialym on 15/10/27.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit
import SpriteKit
class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = MenuScene(size: self.view.bounds.size)//MyScene(fileNamed: "MyScene")
        let skView = self.view as! SKView
        scene.scaleMode = .AspectFill
        scene.backgroundColor = UIColor.blackColor()
        skView.presentScene(scene)
    }

    
}
