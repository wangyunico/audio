//
//  NSObject+CurrentTime.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import Foundation
import UIKit



func geCurrentTime() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmss"
    let dataTime = formatter.stringFromDate(NSDate())
    return dataTime
}


extension UIColor {
    public convenience init(rgbValue:UInt){
        
        self.init(red:CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green:CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue:CGFloat(rgbValue & 0x0000FF) / 255.0, alpha:1)
    }
}