//
//  RecordListDataSource.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import UIKit
import Foundation



class RecordListDataSource: NSObject, UITableViewDataSource {
    
    var cellIdentifier:String!
    
    lazy var dataSource:[RecordListModel] = {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let filePath = "\(paths[0])/audios"
        var audioModels = [RecordListModel]()
        let  audios:[String]? = NSFileManager.defaultManager().subpathsAtPath(filePath)
        audioModels = audios!.map({ (path) -> RecordListModel in
            let model = RecordListModel()
            model.path = "\(filePath)/\(path)"
            model.title = path
            return model 
        })
        
        return audioModels
        
        
    }()
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! RecordListPageViewCell
        cell.model = dataSource[indexPath.row]
        // 做统一的回调进行处理
        cell.startPlayButtonTap = {[weak self] cell in
            if  let indexPath = tableView.indexPathForCell(cell){
                if  let model = self?.dataSource[indexPath.row] {
                    RecordListPlayerManager.defaultManager.addPlayerModel(model)
                }
            }
        }
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }
}
