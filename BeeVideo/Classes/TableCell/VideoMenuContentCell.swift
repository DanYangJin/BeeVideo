//
//  VideoMenuContentCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/8/26.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VideoMenuContentCell: UITableViewCell {

    var titleLbl:UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        titleLbl = UILabel()
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont.systemFont(ofSize: 10)
        titleLbl.textColor = UIColor.white
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.bottom.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        if selected {
            titleLbl.textColor = UIColor.textBlueColor()
        }else{
            titleLbl.textColor = UIColor.white
        }
        // Configure the view for the selected state
    }

}
