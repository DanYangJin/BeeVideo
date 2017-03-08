//
//  CycleTableCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/7.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import MarqueeLabel

/**
    首页轮播海报tablecell
 */

class CycleTableCell: UITableViewCell {

    fileprivate var lineView : UIView!
    var marqueeLabel : MarqueeLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        marqueeLabel = MarqueeLabel()
        marqueeLabel.type = .continuous
        marqueeLabel.textAlignment = .left
        marqueeLabel.textColor = UIColor.colorWithHexString("a0a0a9")
        marqueeLabel.speed = .rate(40)
        marqueeLabel.lineBreakMode = .byClipping
        marqueeLabel.trailingBuffer = 20.0
        marqueeLabel.labelize = true
        marqueeLabel.animationDelay = 0.0
        marqueeLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(marqueeLabel)
        marqueeLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.left.equalTo(self.contentView.snp.right).multipliedBy(0.1)
            make.right.equalTo(self.contentView).multipliedBy(0.9)
        }
        
        lineView = UIView()
        lineView.isHidden = true
        lineView.backgroundColor = UIColor.textBlueColor()
        self.contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(marqueeLabel)
            make.left.equalTo(self.contentView)
            make.width.equalTo(1)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMarqueeStart(isScroll: Bool){
        marqueeLabel.labelize = !isScroll
        if isScroll {
            lineView.isHidden = false
            marqueeLabel.textColor = UIColor.textBlueColor()
        }else {
            lineView.isHidden = true
            marqueeLabel.textColor = UIColor.colorWithHexString("a0a0a9")
        }
    }
    
    
}
