//
//  VodVideoTableIconCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/3.
//  Copyright © 2016年 skyworth. All rights reserved.
//

class VodVideoTableIconCell: UITableViewCell {
    var icon : UIImageView!
    var titleLbl : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        self.contentView.addSubview(icon)
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFont(ofSize: 14)
        titleLbl.textColor = UIColor.white
        self.contentView.addSubview(titleLbl)
        
        icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView.snp.right).dividedBy(4)
            make.width.height.equalTo(18)
        }
        
        titleLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(icon)
            make.left.equalTo(icon.snp.right).offset(3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
