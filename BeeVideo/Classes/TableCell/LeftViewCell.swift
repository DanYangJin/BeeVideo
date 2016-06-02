//
//  LeftViewCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/30.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class LeftViewCell: UITableViewCell {

    var icon : UIImageView!
    var titleLbl : UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        icon = UIImageView()
        icon.contentMode = .ScaleAspectFit
        self.contentView.addSubview(icon)
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFontOfSize(14)
        titleLbl.textColor = UIColor.whiteColor()
        self.contentView.addSubview(titleLbl)
        
        icon.snp_makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView.snp_right).dividedBy(4)
            make.width.height.equalTo(18)
        }
        
        titleLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(icon)
            make.left.equalTo(icon.snp_right).offset(3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillRect(context, rect)
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.05, rect.size.width, 0.05))
        
        
        
    }
    
}
