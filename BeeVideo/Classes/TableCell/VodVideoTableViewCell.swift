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
    case iconMode
    case titleMode
}

class VodVideoTableViewCell: UITableViewCell {
    
    var titleLbl : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFont(ofSize: 14)
        titleLbl.textColor = UIColor.white
        self.contentView.addSubview(titleLbl)
        
        titleLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(contentView.snp.right).dividedBy(4)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
