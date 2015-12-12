//
//  WYAudioButton.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation



enum WYAudioButtonState :Int {
    case Normal
    case RecordDidBegin
    case RecordDidCancel
    case Recording
    case RecordDidFinished
}

protocol  WYAudioButtonDelegate:class{
    func recordStart(record:WYRecordManager) -> Void
    func recordCanceled(record:WYRecordManager) -> Void
    func recordFinished(record:WYRecordManager) -> Void
}

class WYAudioButton: UIButton {
    
    // 因为用enum,与KVO无缘分了
    var recordState:WYAudioButtonState = .Normal {
        didSet{
            switch recordState {
            case .RecordDidBegin:
                self.setTitle("开始录音", forState: .Normal)
                self.delegate?.recordStart(self.recordManager)
            case .RecordDidCancel:
                self.setTitle("录音被取消", forState: .Normal)
                self.delegate?.recordCanceled(self.recordManager)
            case .Recording:
                self.setTitle("正在录音", forState: .Normal)
            case .RecordDidFinished:
                self.setTitle("录音完成", forState: .Normal)
                self.delegate?.recordFinished(self.recordManager)
            default:
                break
                
            }
        }
    }
    
    lazy var recordManager:WYRecordManager = {
        return WYRecordManager.defaultManager
    }()
    
    weak var  delegate:WYAudioButtonDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    // private mark 
    
    func setupView(){
        self.addTarget(self, action: "recordButtonDidTouchDown:", forControlEvents: .TouchDown)
        self.addTarget(self, action: "recordButtonDidTouchUpInside:", forControlEvents: .TouchUpInside)
        self.addTarget(self, action: "recordButtonDidTouchDragExit:", forControlEvents: .TouchDragExit)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK - target-action Pair
    
    func recordButtonDidTouchDown(button:UIButton){
        self.recordState = .RecordDidBegin
        self.recordManager.startRecoding()
        self.recordState = .Recording
    }
    
    func recordButtonDidTouchUpInside(button: UIButton){
        let currentTime = self.recordManager.recorder.currentTime
        guard currentTime > 2 else{
            self.recordState = .RecordDidCancel
            // 表明说话比较短暂
            dispatch_async(dispatch_get_global_queue(0, 0)){ [weak self] in
                if let strongSelf = self {
                    strongSelf.recordManager.stopRecoding()
                    strongSelf.recordManager.clearCache()
                }
            }
            return
        }
        self.recordState = .RecordDidFinished
        // 表示录音成功了
        dispatch_async(dispatch_get_global_queue(0, 0)){[weak self] in
            if let strongSelf = self {
                strongSelf.recordManager.stopRecoding()
            }
        }
    }
    func recordButtonDidTouchDragExit(button: UIButton){
        self.recordState = .RecordDidCancel
        dispatch_async(dispatch_get_global_queue(0, 0)){[weak self] in
            if let strongSelf = self {
                strongSelf.recordManager.stopRecoding()
                strongSelf.recordManager.clearCache()
            }
        }
    }
    
}
