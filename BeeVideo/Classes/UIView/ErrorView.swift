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
        
        
        
        
        errorInfoLable = UILabel()
        errorInfoLable.font = UIFont.systemFont(ofSize: 14)
        errorInfoLable.textAlignment = .center
        errorInfoLable.textColor = UIColor.white
        self.addSubview(errorInfoLable)
        errorInfoLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(30)
        }
        
        errorImg = UIImageView()
        errorImg.contentMode = .scaleAspectFit
        errorImg.image = UIImage(named: "error_icon")
        self.addSubview(errorImg)
        errorImg.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(errorInfoLable.snp.top)
            make.left.right.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
