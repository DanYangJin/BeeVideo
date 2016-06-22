//
//  ErrorView.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/15.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    var errorImg:UIImageView!
    var errorInfoLable:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        errorImg = UIImageView()
        errorImg.contentMode = .ScaleAspectFit
        errorImg.image = UIImage(named: "error_icon")
        self.addSubview(errorImg)
        errorImg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        errorInfoLable = UILabel()
        errorInfoLable.font = UIFont.systemFontOfSize(14)
        errorInfoLable.textAlignment = .Center
        errorInfoLable.textColor = UIColor.whiteColor()
        self.addSubview(errorInfoLable)
        errorInfoLable.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
