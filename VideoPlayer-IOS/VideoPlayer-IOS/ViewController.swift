//
//  ViewController.swift
//  VideoPlayer-IOS
//
//  Created by 🦁️ on 15/11/3.
//  Copyright © 2015年 exialym. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //播放音频
//        let audioURL = NSBundle.mainBundle().URLForResource("a", withExtension: "wav")
//        let audioPlayer = try? AVAudioPlayer(contentsOfURL: audioURL!)
//        audioPlayer!.play()
//        audioPlayer?.volume = 0.5
//        audioPlayer?.numberOfLoops = -1//0:一次，1:两次
//        audioPlayer?.currentTime = 0
        
        //语音合成
        let synthesizer = AVSpeechSynthesizer()
        //要读出的字符串
        let utteranceString = "I am lion"
        let utterance = AVSpeechUtterance(string: utteranceString)
        utterance.rate = 0.175
        synthesizer.speakUtterance(utterance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "videoSegue" {
            let videoURL = NSBundle.mainBundle().URLForResource("TestVideo", withExtension: "m4v")
            let videoView = segue.destinationViewController as! AVPlayerViewController
            videoView.player = AVPlayer(URL: videoURL!)
        }
    }

}

