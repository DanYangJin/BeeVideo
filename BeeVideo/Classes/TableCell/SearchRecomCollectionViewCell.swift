//
//  SearchRecomCollectionViewCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class SearchRecomCollectionViewCell: UICollectionViewCell {
    
    fileprivate var bgImg : UIView!
    var titleLable : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgImg = UIImageView(image: UIImage(named: "normal_bg"))
        //bgImg.contentMode = .Redraw
        //bgImg.image = UIImage(named: "normal_bg")?.resizableImageWithCapInsets(UIEdgeInsets(top: 13,left: 10,bottom: 13,right: 10), resizingMode: .Stretch)
        self.addSubview(bgImg)
        bgImg.snp.makeConstraints{ (make) in
            make.left.right.equalTo(self)
            make.top.bottom.equalTo(self)
        }
        
        titleLable = UILabel()
        titleLable.font = UIFont.systemFont(ofSize: 12)
        titleLable.numberOfLines = 2
        titleLable.textAlignment = .left
        titleLable.textColor = UIColor.colorWithHexString(ColorUtil.search_recom_item_normal)
        self.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self)
            make.centerY.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
