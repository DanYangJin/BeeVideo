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
        titleLbl.textAlignment = .center
        titleLbl.textColor = UIColor.white
        titleLbl.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-5)
        }
        
        subTitleLbl = UILabel()
        subTitleLbl.textColor = UIColor.white
        subTitleLbl.textAlignment = .center
        subTitleLbl.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(subTitleLbl)
        subTitleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom)
            make.centerX.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
