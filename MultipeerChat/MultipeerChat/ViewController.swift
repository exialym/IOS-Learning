//
//  ViewController.swift
//  MultipeerChat
//
//  Created by 🦁️ on 15/11/18.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate{

    @IBOutlet weak var chatView: UITextView!
    @IBOutlet weak var messageField: UITextField!
    @IBAction func sendChat(sender: AnyObject) {
        let msg = self.messageField.text?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        _ = try? self.session.sendData(msg!, toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable)
        self.updateChat(self.messageField.text!, fromPeer: self.peerID)
        self.messageField.text = ""
    }
    @IBAction func showBrowser(sender: AnyObject) {
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    let serviceType = "LCOC-Chat"
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID : MCPeerID!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        //创建浏览器视图控制器，它有一个独一无二的服务名
        self.browser = MCBrowserViewController(serviceType: serviceType, session: self.session)
        self.browser.delegate = self
        self.assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: self.session)
        self.assistant.start()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardWillAppear(notification: NSNotification) {
        let keyBoardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        let keBoardHeight = keyBoardFrame?.CGRectValue.height
        self.view.frame.origin.y -= keBoardHeight!
    }
    func keyboardWillDisappear(notification: NSNotification) {
        let keyBoardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        let keBoardHeight = keyBoardFrame?.CGRectValue.height
        self.view.frame.origin.y += keBoardHeight!
    }

    func updateChat(text: String, fromPeer peerID: MCPeerID) {
        var name: String
        switch peerID {
        case self.peerID:
            name = "me"
        default:
            name = peerID.displayName
        }
        let message = "\(name):\(text)\n"
        self.chatView.text = self.chatView.text + message
    }
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let msg = NSString(data: data, encoding: NSUTF8StringEncoding) {
                self.updateChat(msg as String, fromPeer: peerID)
            }
        }
        
    }
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
    }
}

