//
//  RecordListModel.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import Foundation



// 相当于一个播放的model，用来执行双向绑定
class RecordListModel: NSObject {
    
    var path:String!
    var title:String!
    dynamic var isPlaying:Bool = false
    
}
