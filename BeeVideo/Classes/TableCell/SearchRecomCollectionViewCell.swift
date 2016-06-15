//
//  SearchRecomCollectionViewCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class SearchRecomCollectionViewCell: UICollectionViewCell {
    
    private var bgImg : UIImageView!
    var titleLable : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgImg = UIImageView()
        bgImg.contentMode = .ScaleToFill
        bgImg.image = UIImage(named: "normal_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 30,left: 30,bottom: 30,right: 30), resizingMode: .Tile)
        self.addSubview(bgImg)
        bgImg.snp_makeConstraints{ (make) in
            make.left.right.equalTo(self)
            make.top.bottom.equalTo(self)
        }
        
        titleLable = UILabel()
        titleLable.font = UIFont.systemFontOfSize(12)
        titleLable.textAlignment = .Left
        titleLable.textColor = UIColor.colorWithHexString(ColorUtil.search_recom_item_normal)
        self.addSubview(titleLable)
        titleLable.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
