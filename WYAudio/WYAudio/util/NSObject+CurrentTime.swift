//
//  NSObject+CurrentTime.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import Foundation




func geCurrentTime() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmss"
    let dataTime = formatter.stringFromDate(NSDate())
    return dataTime
}
