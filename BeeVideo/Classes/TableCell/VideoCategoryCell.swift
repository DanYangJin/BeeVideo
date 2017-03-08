//
//  TableCellTest.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/17.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class VideoCategoryCell: ZXOptionBarCell {
    
    let itemView : ItemView = {
        return ItemView()
    }()
    
    override init(style: ZXOptionBarCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(itemView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        itemView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }

    
}
