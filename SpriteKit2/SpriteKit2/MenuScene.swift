//
//  MenuScene.swift
//  SpriteKit2
//
//  Created by exialym on 15/10/29.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit
import SpriteKit
class MenuScene: SKScene {
    override func didMoveToView(view: SKView) {
        let label = SKLabelNode(text: "Welcome to My Amazing Game")
        label.fontSize = 50
        label.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        self.addChild(label)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let game = GameScene(size: self.size)
        let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.3)
        self.view?.presentScene(game, transition: transition)
    }
}
