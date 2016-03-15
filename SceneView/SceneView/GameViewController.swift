//
//  GameViewController.swift
//  SceneView
//
//  Created by exialym on 15/10/30.
//  Copyright (c) 2015年 exialym. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
        
        // animate the 3d object
        ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        scnView.addGestureRecognizer(tapGesture)
        
        
        
        //我自己的场景
        let myScenes = myScene()
        
        //创建视角，可以说是整个场景的入口，没有视角没法观察一个3D场景
        let myCamera = SCNCamera()
        myCamera.xFov = 45
        myCamera.yFov = 45
        let myCameraNode = SCNNode()
        myCameraNode.camera = myCamera
        myCameraNode.position = SCNVector3(0, 0, 20)
        //向场景添加节点与SpriteKit有些不一样
        myScenes.rootNode.addChildNode(myCameraNode)
        
        //创建胶囊
        let capsule = SCNCapsule(capRadius: 2.5, height: 10)
        //SCNCapsule是SCNGeomery的一个子类，通过这个类可以创建更多的形状
        let capsuleNode = SCNNode(geometry: capsule)
        capsuleNode.position = SCNVector3(-15, -2.8, 0)//节点的默认位置是0，0，0
        capsuleNode.name = "myCapsule"
        myScenes.rootNode.addChildNode(capsuleNode)
        
        //添加环境光源
        let ambientLight = SCNLight()
        //光源的类型，这里是环境光源
        ambientLight.type = SCNLightTypeAmbient
        ambientLight.color = UIColor(white: 0.25, alpha: 1.0)
        let myAmbientLightNode = SCNNode()
        myAmbientLightNode.light = ambientLight
        myScenes.rootNode.addChildNode(myAmbientLightNode)
        
        //添加泛光源1
        let omniLight = SCNLight()
        omniLight.type = SCNLightTypeOmni
        omniLight.color = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        let omniLightNode = SCNNode()
        omniLightNode.light = omniLight
        omniLightNode.position = SCNVector3(-10, 8, 5)
        myScenes.rootNode.addChildNode(omniLightNode)
        //添加泛光源2
        let omniLight1 = SCNLight()
        omniLight1.type = SCNLightTypeOmni
        omniLight1.color = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        let omniLightNode1 = SCNNode()
        omniLightNode1.light = omniLight1
        omniLightNode1.position = SCNVector3(10, 8, -5)
        myScenes.rootNode.addChildNode(omniLightNode1)
        
        //向胶囊节点添加动画
        let moveUpDownAnimation = CABasicAnimation(keyPath: "position")//这里的这个keyPath很重要，不是随便写一个就好的
        moveUpDownAnimation.byValue = NSValue(SCNVector3: SCNVector3(30, 0, 0))//移动的坐标
        moveUpDownAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)//移动速度的曲线
        moveUpDownAnimation.autoreverses = true//是否自动返回
        moveUpDownAnimation.repeatCount = Float.infinity//重复次数
        moveUpDownAnimation.duration = 10.0//持续时间
        capsuleNode.addAnimation(moveUpDownAnimation, forKey: "updown")//这里的这个keyPath貌似随便写就可以
        
        //胶囊节点的子节点，一个文本
        let text = SCNText(string: "BaLaLaLa", extrusionDepth: 1)
        text.font = UIFont.systemFontOfSize(2)
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(-5, 6, 0)
        capsuleNode.addChildNode(textNode)
        
        //在一个节点上添加多个动画结果会复合，即便是继承自父节点的动画也同样一起复合
        let rotate = CABasicAnimation(keyPath: "eulerAngles")
        rotate.byValue = NSValue(SCNVector3: SCNVector3(Float(0), Float(M_PI * 2), Float(0)))
        rotate.repeatCount = Float.infinity
        rotate.duration = 5.0
        textNode.addAnimation(rotate, forKey: "rotation")
        
        //使用材料
        let redMetallicMateril = SCNMaterial()
        //contents设置为颜色
        redMetallicMateril.diffuse.contents = UIColor.blueColor()
        redMetallicMateril.specular.contents = UIColor.whiteColor()
        redMetallicMateril.shininess = 1.0
        //一个物体的材料是不唯一的，故传进去一个数组
        capsule.materials = [redMetallicMateril]
        
        let noiseTexture = SKTexture(noiseWithSmoothness: 0.25, size: CGSize(width: 512, height: 512), grayscale: true)
        let noiseMaterial = SCNMaterial()
        //contents设置为SpriteKit纹理
        noiseMaterial.diffuse.contents = noiseTexture
        text.materials = [noiseMaterial]
        
        //法线贴图
        let noiseNormalMapTexture = noiseTexture.textureByGeneratingNormalMapWithSmoothness(1, contrast: 1.0)
        redMetallicMateril.normal.contents = noiseNormalMapTexture
        
        //命中检测
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        let longTapRecoginizer = UILongPressGestureRecognizer(target: self, action: "longTapped:")
        scnView.addGestureRecognizer(tapRecognizer)
        scnView.addGestureRecognizer(longTapRecoginizer)
        scnView.userInteractionEnabled = true
        
        //添加约束
        let pointer = SCNPyramid(width: 0.5, height: 0.9, length: 4.0)
        let pointerNode = SCNNode(geometry: pointer)
        pointerNode.position = SCNVector3(0,0,5)
        myScenes.rootNode.addChildNode(pointerNode)
        //添加指向胶囊节点这个约束
        let lookAtConstraint = SCNLookAtConstraint(target: capsuleNode)
        //使其只围绕一个轴转动
        lookAtConstraint.gimbalLockEnabled = true
        pointerNode.constraints = [lookAtConstraint]
        
        //加载一个已经建好的3D模型或场景，会是一个COLLADA文件，后缀名为.dae
        let critterURL = NSBundle.mainBundle().URLForResource("Critter", withExtension: "dae")
        print(critterURL)
        let critterData = SCNSceneSource(URL: critterURL!, options: nil)
        let critterNode = critterData?.entryWithIdentifier("Critter", withClass: SCNNode.self)
        if (critterNode != nil) {
            critterNode!.position = SCNVector3(0, 0, -10)
            critterNode?.name = "Critter"
            myScenes.rootNode.addChildNode(critterNode!)
        }
        
        //像节点添加物理特性
        var critterPhysicsShape: SCNPhysicsShape?
        if let geometry = critterNode?.geometry {
            critterPhysicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
        }
        let critterPhysicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: critterPhysicsShape)
        critterPhysicsBody.mass = 1
        critterNode?.physicsBody = critterPhysicsBody
        
        //添加一个地板
        let floor = SCNFloor()
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(0, -10, 0)
        myScenes.rootNode.addChildNode(floorNode)
        let floorPhysicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: SCNPhysicsShape(geometry: floor, options: nil))
        floorNode.physicsBody = floorPhysicsBody
        
        // set the scene to the view
        scnView.scene = myScenes//将SCNView的场景设置为我的场景
    }
    
    func longTapped(longTap: UIGestureRecognizer){
        if longTap.state == UIGestureRecognizerState.Ended {
            let scnView = self.view as! SCNView
            let hits = scnView.hitTest(longTap.locationInView(longTap.view), options: nil)
            for hit in hits {
                if hit.node.name == "myCapsule" {
                    scnView.scene = scene
                }
                if hit.node.name == "Critter" {
                    hit.node.position = SCNVector3(0,10,0)
                }
            }
        }
    }
    
    func tapped(tapRecognize: UIGestureRecognizer){
        if tapRecognize.state == UIGestureRecognizerState.Ended {
            let scnView = self.view as! SCNView
            //检测点击到哪个，返回被点到的物体，这里返回的数组里包含了你点击的点顺着屏幕法线穿过的所有的物体
            let hits = scnView.hitTest(tapRecognize.locationInView(tapRecognize.view), options: nil) as [SCNHitTestResult]
            for hit in hits {
                if let theMaterial = hit.node.geometry?.materials[0] {
                    let hightLightAnimation = CABasicAnimation(keyPath: "contents")
                    hightLightAnimation.fromValue = UIColor.blackColor()
                    hightLightAnimation.toValue = UIColor.yellowColor()
                    hightLightAnimation.autoreverses = true
                    hightLightAnimation.repeatCount = 2
                    hightLightAnimation.duration = 1
                    theMaterial.emission.addAnimation(hightLightAnimation, forKey: "heightLight")
                }
            }
        }
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
