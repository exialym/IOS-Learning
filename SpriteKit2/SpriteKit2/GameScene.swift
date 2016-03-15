//
//  GameScene.swift
//  SpriteKit2
//
//  Created by exialym on 15/10/27.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit
import SpriteKit
class GameScene: SKScene {
    let blurEffectNode = SKEffectNode()
    let planeNode = SKSpriteNode(imageNamed: "Spaceship")
    let imageNode = SKSpriteNode(imageNamed: "BlockSquareBlue")
    let textLabel = SKLabelNode(text: "Aloha")
    var lightNode = SKShapeNode()
    var isTouched = false
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFill
        
        //SKSpriteNode节点
        planeNode.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        planeNode.name = "plane"
        self.addChild(planeNode)
        imageNode.position = CGPoint(x: size.width-100, y: size.height-100)
        self.addChild(imageNode)
        
        
        //SKLabelNode节点
        textLabel.fontName = "Zapfino"
        textLabel.fontSize = 30
        textLabel.fontColor = UIColor.blueColor()
        textLabel.position = CGPoint(x: size.width / 2.0, y: 530)
        //self.addChild(textLabel)
        
        //SKShapNode节点
        let path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: 50, height: 50))
        lightNode = SKShapeNode(path: path.CGPath)
        lightNode.position = CGPointMake(100, 500)
        lightNode.lineWidth = 4.0
        lightNode.lineCap = CGLineCap.Round
        lightNode.strokeColor = UIColor.greenColor()
        lightNode.fillColor = UIColor.yellowColor()
        lightNode.glowWidth = 10.0
        self.addChild(lightNode)
        
        //使用SKAction添加动作
        let moveAction = SKAction.moveBy(CGVector(dx: 0, dy: 50), duration: 1.0)
        let reversedMovAction = moveAction.reversedAction()
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI), duration: 2.0)
        let reversedrotateAction = rotateAction.reversedAction()
        let scaleAction = SKAction.scaleTo(2.0, duration: 0.5)
        let reversedscaleAction = scaleAction.reversedAction()
        //group里的Action同时开始
        _ = SKAction.group([moveAction,reversedMovAction,rotateAction,reversedrotateAction,scaleAction,reversedscaleAction])
        //sequence里的Action顺序执行
        let actionSequence = SKAction.sequence([moveAction,reversedMovAction,rotateAction,reversedrotateAction,scaleAction,reversedscaleAction])
        //对某个节点应用动作
        textLabel.runAction(actionSequence)
        
        //对节点添加特效
        let blurFiler = CIFilter(name: "CIGaussianBlur")
        blurFiler?.setDefaults()
        blurFiler?.setValue(5.0, forKey: "inputRadius")
        blurEffectNode.filter = blurFiler
        blurEffectNode.shouldEnableEffects = false
        self.addChild(blurEffectNode)
        //与其他节点不同的是，这里需要将要应用特效的节点加到SKEffectNode节点中
        blurEffectNode.addChild(textLabel)
        
        //为节点添加物理特效
        //为添加边界实体用SKPhysicsBody(edgeLoopFromRect:)方法创建的实体不受重力影响
        let wallsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = wallsBody
        //self.view?.showsPhysics = true//这样可以打开物理调试模式
        
        //场景照明
        let light = SKLightNode()
        light.enabled = true
        light.lightColor = UIColor.yellowColor()
        light.categoryBitMask = 0xFFFFFFFF//场景照明通过掩码来设置哪些元素会被照亮
        light.position = lightNode.position
        self.addChild(light)
        planeNode.lightingBitMask = 0x1//0xFFFFFFFF与0x1与得到了true则这个节点会被照亮
        
        //自定义着色器
        let noiseTexture = SKTexture(noiseWithSmoothness: 0.5, size: CGSize(width: 265, height: 256), grayscale: true)
        let textureUniform = SKUniform(name: "noiseTexture", texture: noiseTexture)
        let thresholdUniform = SKUniform(name: "threshold", float: 0.5)
        let shader = SKShader(fileNamed: "CustomShader")
        shader.addUniform(textureUniform)
        shader.addUniform(thresholdUniform)
        imageNode.shader = shader
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        blurEffectNode.shouldEnableEffects = true//打开模糊特效
        
        //设置物理实体形状，不一定和原来节点形状相同，可能的情况下越简单越好，便于系统计算碰撞效果
        let textbody = SKPhysicsBody(rectangleOfSize: textLabel.frame.size)
        textLabel.physicsBody = textbody
        //设置质量kg单位
        textbody.mass = 1.0
        let planebody = SKPhysicsBody(rectangleOfSize: planeNode.frame.size)
        planeNode.physicsBody = planebody
        planebody.mass = 2.0
//        let lightBody = SKPhysicsBody(rectangleOfSize: lightNode.frame.size)
//        lightNode.physicsBody = lightBody
//        lightBody.mass = 2.0
        
        //创建一个对象接合，接合有很多种SKPhysicsJointSpring是其中一种
        let pinJoint = SKPhysicsJointSpring.jointWithBodyA(textbody, bodyB: planebody, anchorA: CGPointMake(textLabel.position.x-100, textLabel.position.y+100), anchorB: planeNode.position)
        self.physicsWorld.addJoint(pinJoint)
        
        let location:CGPoint! = touches.first?.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if node.name == "plane" {
            isTouched = true
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isTouched {
            let location:CGPoint! = touches.first?.locationInNode(self)
            planeNode.position = CGPointMake(location.x, location.y)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouched = false
    }
}
