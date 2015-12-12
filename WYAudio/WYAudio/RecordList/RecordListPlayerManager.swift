//
//  RecordListPlayerManager.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


class RecordListPlayerManager: NSObject, AVAudioPlayerDelegate {
    
    var audioQueue = [RecordListModel]() // 相当于一个播放队列
    // 当前的player
    var currentplayer: AVAudioPlayer?
    
    static let defaultManager = RecordListPlayerManager()
    
    private override init(){
        super.init()
        
    }
    
    /**
     向播放音频
     
     - parameter mode: model
     
     - returns: 返回是否增加成功
     */
    func addPlayerModel(mode:RecordListModel) -> Bool{
        if self.audioQueue.count == 0 {
            self.audioQueue.append(mode)
            self.startplayer()
            return true
        }else{
            return false // 表示添加失败
        }
    }
    
    func removePlayerModel(mode:RecordListModel) -> Bool{
        if self.audioQueue.count > 0 {
            if self.audioQueue.contains(mode){
                self.stopPlayer()
                self.audioQueue.removeAll()
                return true
            }else {
                return false
            }
        }else {
            return false
        }
    }
    
    // function Player Relavent 
    
    func startplayer(){
        guard self.audioQueue.count > 0 else {
            return
        }
        //播放
        if self.currentplayer != nil {
            if self.currentplayer!.playing {
                return
            }
        }
        let model = self.audioQueue[0]
        self.currentplayer = try! AVAudioPlayer(contentsOfURL: NSURL(string: model.path)!)
        self.currentplayer?.delegate = self
        self.currentplayer?.play()
        model.isPlaying = true
    }
    
    // 没有暂停状态，
    func stopPlayer(){
        if let currentPlayer = self.currentplayer {
            currentPlayer.stop()
            currentPlayer.delegate = nil
            if let model = self.audioQueue.first {
                model.isPlaying = false
            }
        }
        self.currentplayer = nil
    }
    // MARK - delegate 
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.stopPlayer()
        // 清除队列
        self.audioQueue.removeAll()
        
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        player.play()
    }
}
