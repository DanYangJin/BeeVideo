//
//  RestVideoCollectionCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/1.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class RestVideoCollectionCell: UICollectionViewCell {
    
    private var backgroundImg : UIImageView!
    var icon : UIImageView!
    var titleLbl : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .ScaleToFill
        backgroundImg.image = UIImage(named: "v2_laucher_block_blue_bg")
        self.contentView.addSubview(backgroundImg)
        backgroundImg.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        icon = UIImageView()
        icon.contentMode = .ScaleAspectFit
        self.contentView.addSubview(icon)
        icon.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        titleLbl = UILabel()
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.textAlignment = .Center
        self.contentView.addSubview(titleLbl)
        titleLbl.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
