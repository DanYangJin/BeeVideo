//
//  VideoMenuCategoryCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/8/26.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class VideoMenuCategoryCell: UITableViewCell {

    var icon:UIImageView!
    var titleLbl:UILabel!
    var subTitleLbl:UILabel!
    
    var data:LeftViewTableData!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?,data:LeftViewTableData) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        self.data = data
        
        icon = UIImageView()
        icon.image = UIImage(named: data.unSelectPic)
        self.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.75)
            make.width.equalTo(icon.snp.height)
            make.left.equalTo(self).offset(3)
        }
        
        titleLbl = UILabel()
        titleLbl.textAlignment = .left
        titleLbl.font = UIFont.systemFont(ofSize: 10)
        titleLbl.textColor = UIColor.white
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(3)
            make.centerY.equalTo(self)
        }
        
        subTitleLbl = UILabel()
        subTitleLbl.textAlignment = .left
        subTitleLbl.font = UIFont.systemFont(ofSize: 10)
        subTitleLbl.textColor = UIColor.white
        self.addSubview(subTitleLbl)
        subTitleLbl.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.width.equalTo(self).dividedBy(3)
            make.centerY.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        guard data != nil else{
            return
        }
        if selected {
            icon.image = UIImage(named: data.selectedPic)
            titleLbl.textColor = UIColor.textBlueColor()
            subTitleLbl.textColor = UIColor.textBlueColor()
        }else{
            icon.image = UIImage(named: data.unSelectPic)
            titleLbl.textColor = UIColor.white
            subTitleLbl.textColor = UIColor.white
        }
        
    }

}
