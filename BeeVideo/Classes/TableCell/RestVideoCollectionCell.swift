//
//  RestVideoCollectionCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/1.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class RestVideoCollectionCell: UICollectionViewCell {
    
    fileprivate var backgroundImg : UIImageView!
    var icon : UIImageView!
    var titleLbl : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundImg = UIImageView()
        backgroundImg.contentMode = .scaleToFill
        backgroundImg.image = UIImage(named: "v2_laucher_block_blue_bg")
        self.contentView.addSubview(backgroundImg)
        backgroundImg.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        self.contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.right.equalTo(self)
        }
        
        titleLbl = UILabel()
        titleLbl.textColor = UIColor.white
        titleLbl.textAlignment = .center
        self.contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
