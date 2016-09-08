//
//  T9KeyCollectionViewCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/8/15.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class T9KeyCollectionViewCell: UICollectionViewCell {
    
    var titleLbl:UILabel!
    var subTitleLbl:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLbl = UILabel()
        titleLbl.textAlignment = .Center
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.font = UIFont.systemFontOfSize(12)
        self.addSubview(titleLbl)
        titleLbl.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-5)
        }
        
        subTitleLbl = UILabel()
        subTitleLbl.textColor = UIColor.whiteColor()
        subTitleLbl.textAlignment = .Center
        subTitleLbl.font = UIFont.systemFontOfSize(10)
        self.addSubview(subTitleLbl)
        subTitleLbl.snp_makeConstraints { (make) in
            make.top.equalTo(titleLbl.snp_bottom)
            make.centerX.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
