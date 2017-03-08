//
//  KeynoardCollectionViewCell.swift
//  BeeVideo
//
//  Created by JinZhang on 16/6/12.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit

class KeyboardCollectionViewCell: UICollectionViewCell {
    
    var titleLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView = UIImageView(image: UIImage(named: "normal_bg"))//?.resizableImageWithCapInsets(UIEdgeInsets(top: 12,left: 12,bottom: 58,right: 58), resizingMode: .Stretch))
        backgroundView?.contentMode = .scaleToFill
        backgroundView?.isHidden = true
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
