//
//  ViewController.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import UIKit
import WYNavigation

private var kPlayButtonisPlaying:Void?

class ViewController: UIViewController,WYAudioButtonDelegate {
    
    @IBOutlet weak var playBotton: UIButton!
    @IBOutlet weak var recordButton: WYAudioButton!
    var record:WYRecordManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.playBotton.hidden = true
        self.recordButton.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK - WYAudioButtonDeleate
    
    func recordStart(record:WYRecordManager) -> Void {
        self.playBotton.hidden = true
    }
    func recordCanceled(record:WYRecordManager) -> Void{
        self.playBotton.hidden = true
    }
    func recordFinished(record:WYRecordManager) -> Void {
        self.playBotton.hidden = false
        self.record = record
    }
    
    // MARK - target-action
    
    @IBAction func playButtonTapped(button:UIButton){
        if let record = self.record {
            record.startPlaying()
        }
    }
    
    // MARK - prvate function
    /**
    停止播放音乐
    */
    func stopPlayer(){
        if let record = self.record {
            record.stopPlaying()
        }
        self.record = nil
    }
    
}

extension UIButton {
    
    public var  isPlaying:Bool?{
        get{
            return objc_getAssociatedObject(self, &kPlayButtonisPlaying) as? Bool
        }
        set{
            objc_setAssociatedObject(self, &kPlayButtonisPlaying , newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

