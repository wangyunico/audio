//
//  RecordListPageViewCell.swift
//  WYAudio
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 wangyu. All rights reserved.
//

import  UIKit
import SnapKit

private var kPlayButtonisPlaying:Void?

class RecordListPageViewCell: UITableViewCell {
    
    var didSetupConstraints = false
    // 点击的回调
    var model:RecordListModel!{
        didSet{
            self.titelLabel.text = model.title
            self.button.isPlaying = model.isPlaying
            self.titelLabel.sizeToFit()
            self.button.sizeToFit()
            // 增加KVO观察
            //            self.setNeedsLayout()
            //            self.layoutIfNeeded()
            model.addObserver(self, forKeyPath: "isPlaying", options: [.New,.Old], context: nil)
        }
    }
    
    var startPlayButtonTap:((cell: RecordListPageViewCell) -> ())?
    var titelLabel:UILabel!{
        didSet{
            self.titelLabel.font = UIFont.systemFontOfSize(14)
            self.titelLabel.textColor = UIColor(rgbValue: 0x666666)
            self.titelLabel.textAlignment = .Left
            self.titelLabel.lineBreakMode = .ByTruncatingTail
            // self.contentView.addSubview(self.titelLabel)
        }
    }
    
    var button:UIButton!{
        didSet{
            self.button.backgroundColor = UIColor(rgbValue: 0xd73c31)
            self.button.titleLabel?.font = UIFont.systemFontOfSize(14)
            self.button.setTitleColor(UIColor(rgbValue: 0xffffff), forState: .Normal)
            self.button.addTarget(self , action: "buttonIsTapped:", forControlEvents: .TouchUpInside)
            self.button.isPlaying = false 
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        
    }
    
    func setupViews(){
        self.button = UIButton(frame: CGRectZero)
        self.titelLabel = UILabel(frame: CGRectZero)
        self.contentView.addSubview(self.button)
        self.contentView.addSubview(self.titelLabel);
    }
    override func updateConstraints() {
        if !didSetupConstraints {
            self.titelLabel.snp_makeConstraints{ (make) -> Void in
                make.centerY.equalTo(self.contentView.snp_centerY)
                make.left.equalTo(self.contentView.snp_left).offset(10)
            }
            self.button.snp_makeConstraints {(make) -> Void in
                
                make.centerY.equalTo(self.contentView.snp_centerY)
                make.right.equalTo(self.contentView.snp_right).offset(-10)
            }
        }
        didSetupConstraints = true
        super.updateConstraints()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(context, 0, CGRectGetHeight(rect))
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect))
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor(rgbValue: 0xeeeeee).CGColor)
        CGContextStrokePath(context)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.model.removeObserver(self, forKeyPath: "isPlaying")
        self.startPlayButtonTap = nil
    }
    
    func buttonIsTapped(btn: UIButton){
        // 已经点击了
        self.startPlayButtonTap?(cell: self)
    }
    
    
    // MARK - 采用KVO 观察变化
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "isPlaying" {
            if let change = change where context == nil {
                let isPlaying = change[NSKeyValueChangeNewKey] as! Bool
                let wasPlaying = change[NSKeyValueChangeOldKey] as! Bool
                if isPlaying != wasPlaying {
                    // 根据当前的isPaling 做判断
                    dispatch_async(dispatch_get_main_queue()) { [weak self] in
                        if let strongSelf = self {
                            strongSelf.button.isPlaying = isPlaying
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    
}


extension UIButton {
    
    public var  isPlaying:Bool?{
        get{
            return objc_getAssociatedObject(self, &kPlayButtonisPlaying) as? Bool
        }
        set{
            objc_setAssociatedObject(self, &kPlayButtonisPlaying , newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue == true {
                self.setTitle("正在播放", forState: .Normal)
                
            }else{
                self.setTitle("点播", forState: .Normal)
            }
        }
    }
}

