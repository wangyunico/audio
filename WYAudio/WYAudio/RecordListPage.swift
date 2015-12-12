//
//  RecordListPage.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import  UIKit
import  SnapKit

class RecordListPage: UIViewController,UITableViewDelegate {
    
    var dataSource:RecordListDataSource!
    var tableView: UITableView!
    var cellIdentifier = "cellIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = RecordListDataSource()
        self.dataSource.cellIdentifier = cellIdentifier
        
        self.tableView = UITableView(frame: CGRectZero)
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(10, 0, 0, 0))
        }
        self.tableView.separatorStyle = .None
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.registerClass(RecordListPageViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.tableView.rowHeight = 50
        self.tableView.reloadData()
    }
    
    
    
    // MARK -- UITableViewDelegate 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        // 处理是停止当前
        let model = self.dataSource.dataSource[indexPath.row]
        RecordListPlayerManager.defaultManager.removePlayerModel(model)
        
    }
    
}
