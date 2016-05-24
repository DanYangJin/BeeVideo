//
//  VideoItemCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class VideoItemCell: UICollectionViewCell {

    var itemView : ItemView!
     //var image : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        itemView = ItemView()
        itemView.frame = self.contentView.frame
        self.contentView.addSubview(itemView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

