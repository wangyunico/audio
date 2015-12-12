//
//  WYRecordManager.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import AVFoundation
import Foundation 
import QuartzCore



protocol WYRecorderDelegate:class{
    func recoderManager( recorderManger:WYRecordManager, degree: Int )
    
}

// 放在document 目录下用于防治录音的
private let fileDocument = "audios"

class WYRecordManager: NSObject,AVAudioRecorderDelegate {
    
    private var reco:AVAudioRecorder?
    
    var recorder:AVAudioRecorder!{
        if let tmpRecoder = self.reco {
            return tmpRecoder;
        }else{
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let filePath = "\(paths[0])/\(fileDocument)"
            if !(NSFileManager.defaultManager().fileExistsAtPath(filePath)) {
                try! NSFileManager.defaultManager().createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil)
            }
            let url = NSURL(string:"\(filePath)/\(geCurrentTime()))")!
            self.recorderUrl = url
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try! session.setActive(true, withOptions: [])
            self.reco = try! AVAudioRecorder(URL: url, settings: [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatAppleIMA4), AVSampleRateKey:44100, AVNumberOfChannelsKey:1,AVLinearPCMBitDepthKey:8, AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue])
            self.reco!.delegate = self
            self.reco!.meteringEnabled = true
            self.reco!.prepareToRecord()
            return self.reco
        }
        
    }
    
    
    var player: AVAudioPlayer?
    weak var delegate: WYRecorderDelegate?
    
    var recorderUrl:NSURL?
    private var displayLink:CADisplayLink?
    
    // for a sington
    static let defaultManager = WYRecordManager()
    
    private override init() {
        super.init()
    }
    
    // MARK: - pulbic methods
    func startRecoding()->(){
        self.stopPlaying()
        self.recorder.record()
        // CAdispalylink 刷新一下
        self.displayLink = CADisplayLink(target: self, selector: Selector("soundsDegree"))
        self.displayLink!.frameInterval = 1
        self.displayLink! .addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func stopRecoding()->(){
        self.recorder.stop()
        self.reco = nil;
    }
    
    func startPlaying()->(){
        if let player = self.player {
            if player.playing {
                return
            }
        }
        self.player = try! AVAudioPlayer(contentsOfURL: self.recorderUrl!)
        self.player!.play()
    }
    
    func stopPlaying()->(){
        guard let player = self.player else{
            return
        }
        if player.playing {
            player.stop()
        }
    }
    // MARK: private methods 
    
    private func soundsDegree(){
        self.recorder.updateMeters()
        let result = pow(10.0, 0.05 * self.recorder.peakPowerForChannel(0))*10
        var degree:Int = 0
        if result > 0 && result <= 2{
            degree = 1
        }else if result > 2 && result < 3 {
            degree = 2
        }else if result > 3 && result < 5 {
            degree = 3
        }else if result > 5 && result < 10 {
            degree = 4
        }else if result > 10  {
            degree = 5
        }
        self.delegate?.recoderManager(self, degree: degree)
    }
    // MARK: -- delegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        // TODO
    }
    
}
