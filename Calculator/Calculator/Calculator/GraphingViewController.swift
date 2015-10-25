//
//  GraphingViewController.swift
//  Calculator
//
//  Created by exialym on 15/9/27.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit

class GraphingViewController: UIViewController , GraphingData, UIPopoverPresentationControllerDelegate{

    
    @IBOutlet weak var graphingTitle: UINavigationItem!
    
    @IBAction func replace(sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 2
        if sender.state == .Ended{
            graphingView.delta = CGPoint(x: sender.locationInView(graphingView).x - graphingView.bounds.midX, y: sender.locationInView(graphingView).y - graphingView.bounds.midY)
        }
    }
    @IBAction func move(sender: UIPanGestureRecognizer) {
        if sender.state == .Ended {
            graphingView.delta.x += sender.translationInView(graphingView).x
            graphingView.delta.y += sender.translationInView(graphingView).y
        }
    }
    @IBAction func scale(sender: UIPinchGestureRecognizer) {
        if sender.state == .Ended {
            //print("\(graphingView.scale):\(sender.scale)")
            graphingView.scale *= sender.scale
            sender.scale = 1
        }
    }
    @IBOutlet weak var graphingView: GraphingView! {
        didSet{
            graphingView.y = self
        }
    }
    var brain :CaluculatorBrain?
    let remebered = NSUserDefaults.standardUserDefaults()
    var isFirstOpen = true
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = brain?.display().last {
            remebered.setObject(brain?.program, forKey: "expression")
        }
        brain?.program = remebered.objectForKey("expression") ?? []
        if let fum = brain?.display().last {
            graphingTitle.title = ("y = " + fum as NSString).stringByReplacingOccurrencesOfString("M", withString: "x")
        }
        // Do any additional setup after loading the view.
    }
    func findYForX(x: Float) -> Float? {
        if let br = brain {
            br.setValue("M", value: Double(x))
            let doubleResult = br.evluate() ?? 0
            if doubleResult.isNaN {
                return nil
            }
            return Float(doubleResult)
        }
        return nil
    }
    func clearM() {
        brain?.VariableValues.removeAll()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            switch id {
            case "showY":
                if let yvc = segue.destinationViewController as? YViewController {
                    if let ppc = yvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    yvc.text = graphingView.maxAndMin
                }
            default:break
            }
        }
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

}
