//
//  VodVideoTableViewCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/3.
//  Copyright © 2016年 skyworth. All rights reserved.
//

/**
 点播列表页分类tableviewcell
 */

enum VodTableCellMode {
    case IconMode
    case TitleMode
}

class VodVideoTableViewCell: UITableViewCell {
    
    var titleLbl : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFontOfSize(14)
        titleLbl.textColor = UIColor.whiteColor()
        self.contentView.addSubview(titleLbl)
        
        titleLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(contentView.snp_right).dividedBy(4)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
